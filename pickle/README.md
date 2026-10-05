# 🥒 PICKLE: National Day Hijack Advisor

Every morning, someone in marketing asks: *"Is it National Something Day? Should we post about it?"*

PICKLE answers in seconds. It looks up the national days for today (or any date) and scores each one for **brand fit** and **cringe risk** *for your brand*, so a donut shop on National Donut Day gets "this is your Super Bowl" and a law firm gets "step away from the keyboard." It also writes you a post you can use.

It never makes up national days. If it can't find a source, it says so.

## Install

### Claude app or claude.ai
1. In Claude, go to **Customize → Skills → + → Upload a skill**, and choose `pickle.zip`. (If you don't see Skills, turn on **Code execution** under **Settings → Capabilities** first.)
2. Make sure web search is available in your chat.
3. Start a new chat and type: `/pickle what national days are today?`

### Claude Code
Unzip into your skills folder so you end up with `~/.claude/skills/pickle/SKILL.md`:

```
unzip pickle.zip -d ~/.claude/skills/
```

On Windows (PowerShell):

```
Expand-Archive pickle.zip -DestinationPath $HOME\.claude\skills
```

Then start Claude Code and type `/pickle`.

## Try it

- `/pickle what national days are today?`
- `Should we post for National Pickle Day? We're a fitness app.`
- `/pickle what about the 14th? Write it for Instagram.`

## Teach it your brand 🥒

The first time you use it, PICKLE asks three quick questions: what you sell, your **silliness dial** (1 = a bank, 10 = Wendy's on Twitter), and anything that's off-limits.

After each report it asks: **"Too silly, just right, or too stiff?"** Your answers nudge the dial so it gets closer to your voice over time.

- **Claude Code** saves your profile automatically to `~/.claude/pickle/brand-profile.md`. Approve the file write the first time it asks.
- **claude.ai** can't save files between chats, so PICKLE gives you a **🥒 Brand Card**. Paste it into a Claude **Project's** instructions and run PICKLE inside that Project. It will remember your brand every time. When your dial changes, it gives you an updated card to paste.

## Heads up

- National day sites sometimes disagree. PICKLE shows its sources, so give the top pick a quick click before you post.
- Solemn observances (memorials, health causes, awareness days) are flagged **"Respectful only, don't brand-jack"** and never get jokes.

---

Made by **Tim Lane** 🥒. Full docs and updates: <https://github.com/timlaneseo-tech/pickle>

If PICKLE saves you from a cringe post, tell me about it on LinkedIn.
