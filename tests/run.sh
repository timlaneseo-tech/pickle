#!/usr/bin/env bash
# Scenario runner for the PICKLE skill. See tests/scenarios.md.
cd "$(dirname "$0")/.."
OUT="$PWD/tests/out"; mkdir -p "$OUT"
# Run claude from an empty dir so it cannot read the spec/plan in this repo.
NEUTRAL=$(mktemp -d)
PROFILE_DIR="$HOME/.claude/pickle"; PROFILE="$PROFILE_DIR/brand-profile.md"
TODAY="Today is Monday, October 5, 2026."
RO=(--allowedTools "WebSearch WebFetch Read Skill" --disallowedTools "Write Edit Bash PowerShell")

prompt() {
  case $1 in
    S1)  echo "$TODAY /pickle What national days are today? Our brand: B2B used heavy equipment dealer selling excavators and loaders to contractors. Silliness dial 4. Off-limits: politics." ;;
    S2)  echo "$TODAY /pickle Give me a Pickle Report for June 4, 2027. Brand: neighborhood donut shop. Silliness dial 7. No off-limits." ;;
    S3)  echo "$TODAY /pickle Give me a Pickle Report for June 4, 2027. Brand: small personal-injury law firm. Silliness dial 3. No off-limits." ;;
    S4)  echo "$TODAY /pickle What national days are today? Brand: specialty coffee roaster. Silliness dial 6." ;;
    S5)  echo "$TODAY /pickle what national days are today?" ;;
    S5b) echo "$TODAY /pickle what national days are today? Skip the setup questions, just give me the report." ;;
    S6)  echo "$TODAY /pickle Feedback on the Pickle Report you gave me earlier today: too silly." ;;
    S7)  echo "$TODAY /pickle Should we post for National Spreadsheet Appreciation Day today? Brand: accounting software for small businesses. Silliness dial 5." ;;
    S8)  echo "$TODAY /pickle What about the 14th? Brand: craft pickle company. Silliness dial 8." ;;
    S9)  printf '%s\n' "$TODAY /pickle what national days are today? Here's my card:" '```' "🥒 Brand Card" "What we sell / who buys: payroll software for restaurants" "Off-limits: alcohol" '```' ;;
    S10) echo "$TODAY /pickle Pickle Report for November 14, 2026. Brand: fitness app. Silliness dial 6. Off-limits: food." ;;
    S11) printf '%s
' "$TODAY /pickle I'm on claude.ai. My card:" '```' "🥒 Brand Card" "- What we sell / who buys: dog treats for pet owners" "- Silliness dial: 6" "- Off-limits: none" '```' "Feedback on the report you gave me earlier today: too stiff." ;;
    S12) echo "$TODAY /pickle Is it National Pickle Day today?" ;;
  esac
}

run() {
  local id=$1; local args=("${RO[@]}")
  case $id in
    S4) args=(--allowedTools "Read Skill" --disallowedTools "WebSearch WebFetch Write Edit Bash PowerShell") ;;
    S6) args=(--allowedTools "Read Skill Edit(~/.claude/pickle/**)" --add-dir "$PROFILE_DIR" --permission-mode acceptEdits) ;;
  esac
  (cd "$NEUTRAL" && claude -p "$(prompt "$id")" "${args[@]}") > "$OUT/$id.md" 2>&1
}

has()   { grep -Eiq -- "$2" "$1" && echo "  ok   /$2/" || { echo "  FAIL missing /$2/"; FAILED=1; }; }
lacks() { grep -Eiq -- "$2" "$1" && { echo "  FAIL found /$2/"; FAILED=1; } || echo "  ok   no /$2/"; }

check() {
  local id=$1 f="$OUT/$1.md"; echo "$id"
  case $id in
    S1)  for p in 'PICKLE REPORT' 'Do Something Nice|Consignment Day|Get Funky' 'Respectful only' 'nationaldaycalendar|daysoftheyear' 'too stiff'; do has "$f" "$p"; done ;;
    S2|S3) has "$f" 'PICKLE REPORT'; has "$f" 'Do(ugh)?nut Day' ;;
    S4)  has "$f" 'nationaldaycalendar.com/october/5'; lacks "$f" 'Do Something Nice' ;;
    S5)  for p in 'Silliness dial, 1–10' 'off-limits' 'sell'; do has "$f" "$p"; done; lacks "$f" 'PICKLE REPORT' ;;
    S5b) has "$f" 'PICKLE REPORT'; has "$f" '5/10' ;;
    S6)  has "$f" "6 (→|->|to) 5"; has "$f" "too silly" ;;  # headless cannot write ~/.claude (protected); file save verified manually
    S7)  lacks "$f" 'National Spreadsheet Appreciation Day: Fit' ;;
    S8)  has "$f" 'October 14, 2026' ;;
    S9)  has "$f" 'silliness' ;;
    S10) has "$f" 'Pickle Day'; has "$f" 'Hard pass'; has "$f" 'off-limits' ;;
    S11) has "$f" 'Brand Card'; has "$f" 'Silliness dial:?[*]*:? ?7'; lacks "$f" "I('ve| have) saved" ;;
    S12) has "$f" 'November 14'; lacks "$f" '^1\. What do you sell' ;;
  esac
}

IDS=("$@"); [ ${#IDS[@]} -eq 0 ] && IDS=(S1 S2 S3 S4 S5 S5b S6 S7 S8 S9 S10 S11 S12)

# S5/S5b need no profile; S6 needs a seeded one. Run S6 last, alone.
[ -f "$PROFILE" ] && mv "$PROFILE" "$PROFILE.bak"
PAR=(); DO_S6=0
for id in "${IDS[@]}"; do [ "$id" = S6 ] && DO_S6=1 || PAR+=("$id"); done
for id in "${PAR[@]}"; do run "$id" & done; wait
if [ $DO_S6 = 1 ]; then
  mkdir -p "$PROFILE_DIR"
  printf '%s\n' "# 🥒 Brand Profile" "- **What we sell / who buys:** used heavy equipment to contractors" "- **Silliness dial:** 6" "- **Off-limits:** politics" "" "## Hits & misses log" "- 2026-10-05 · National Do Something Nice Day · (report given)" > "$PROFILE"
  run S6
fi

FAILED=0
for id in "${IDS[@]}"; do check "$id"; done
[ $DO_S6 = 1 ] && rm -f "$PROFILE"
[ -f "$PROFILE.bak" ] && mv "$PROFILE.bak" "$PROFILE"
[ $FAILED = 0 ] && echo "ALL GREP CHECKS PASSED" || { echo "SOME CHECKS FAILED"; exit 1; }
