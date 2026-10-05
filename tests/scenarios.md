# PICKLE scenario tests

Run all: `bash tests/run.sh` (or `bash tests/run.sh S1 S7` to pick scenarios).
Each run uses headless Claude Code with the skill installed at `~/.claude/skills/pickle`.
Outputs go to `tests/out/<id>.md`. `run.sh` does the grep checks listed below; a human
(or the executor) reads each output for the "Read" criteria.

| ID | Prompt (summary) | Grep checks | Read criteria |
|----|------------------|-------------|---------------|
| S1 | Today, heavy equipment dealer, silliness 4 | `PICKLE REPORT`, `Do Something Nice`, `Respectful only`, `nationaldaycalendar\|daysoftheyear`, `too stiff` | GOE Day has no cringe score or roast; draft present |
| S2 | 2027-06-04, donut shop, silliness 7 | `PICKLE REPORT`, `Donut Day` | record Donut Day cringe score |
| S3 | 2027-06-04, personal-injury law firm, silliness 3 | `PICKLE REPORT`, `Donut Day` | Donut Day cringe ≥ S2 score + 4 |
| S4 | Today, web tools disabled | `nationaldaycalendar.com/october/5` (case-insensitive), no `Do Something Nice` | no days listed |
| S5 | Today, no brand, no profile | `silliness`, `off-limits`, `sell` | the 3 questions are in one message; no report yet |
| S5b | Today, no brand, "skip setup" | `PICKLE REPORT`, `5/10` | note that a profile sharpens results |
| S6 | Feedback "too silly", profile at silliness 6 | output: `6 → 5`, `too silly` | headless runs can't write to `~/.claude`, so the file save is checked by hand |
| S7 | "National Spreadsheet Appreciation Day today?" | no `National Spreadsheet Appreciation Day: Fit` | says no source found for today; does not invent it |
| S8 | "What about the 14th?" | `October 14, 2026` | header shows the full date |
| S9 | Brand Card missing silliness dial | `silliness` | asks only for the dial, not what they sell |
| S10 | 2026-11-14, fitness app, off-limits: food | `Pickle Day`, `Hard pass`, `off-limits` | Pickle Day is Hard pass for off-limits; top pick is another day |
| S11 | claude.ai-style Brand Card at dial 6, feedback "too stiff", file writes blocked | `Brand Card`, dial `7`, no "I've saved" | prints an updated Brand Card instead of claiming a save |
| S12 | "Is it National Pickle Day today?" with no brand | `November 14`, setup questions not shown first | answers the question before offering setup |

## Results: 2026-10-05

All grep checks pass (S11 and S12 were added after the final review and also pass). Read criteria:

- **S1 pass.** The report card matches the format. GOE Day isn't in today's results, but five solemn days (Child Health Day, Bullying Prevention, Meningitis, and others) appear on the respectful-only line with no scores. Sources are cited.
- **S2/S3 pass.** Donut Day cringe is 1 for the donut shop and 6 for the law firm (difference 5, threshold 4).
- **S4 pass.** No days are listed, and it asks for a paste from nationaldaycalendar.com/october/5.
- **S5 pass.** The 3 setup questions are in one message.
- **S5b pass.** Dial 5, with a note that a profile sharpens results.
- **S6 pass (output).** It says dial 6 → 5 and logs "too silly". The file save needs one manual interactive check.
- **S7 pass.** No source for the day on Oct 5. It points to National Spreadsheet Day on Oct 17.
- **S8 pass.** The header reads "Wednesday, October 14, 2026".
- **S9 pass.** It asks only for the silliness dial.
- **S10 pass.** Pickle Day is a Hard pass, with "Off-limits (food)" as the reason, and the top pick is a different day.
