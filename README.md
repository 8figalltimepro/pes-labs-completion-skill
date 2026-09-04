# PES Labs Completion Skill

An agent skill that completes engineering lab assignments end to end, for any course or year. The agent reads the assignment from a clean input folder, writes a plan for your approval, implements the code, hands you a checklist for the steps you must do yourself, and, when the assignment calls for it, builds the report PDF from LaTeX after you confirm the screenshots.

## Install

One command, using the open skills package manager (needs Node.js 18 or later):

```bash
npx skills add 8figalltimepro/pes-labs-completion-skill
```

Useful flags:

- `-g` installs for your user account (global) instead of the current project.
- `-a '<agent>'` targets specific agents.
- `--copy` copies files instead of symlinking into agent directories.

## Give this prompt to your agent

Paste this into any coding agent to install the skill plus all base tools:

```
Install the pes-labs-completion-skill from https://github.com/8figalltimepro/pes-labs-completion-skill using `npx skills add 8figalltimepro/pes-labs-completion-skill -g`, then run its scripts/check-env.sh with --fix to install any missing base tools, and confirm the skill is ready to use.
```

## First use per machine

From the installed skill directory, check the base tools:

```bash
bash scripts/check-env.sh
```

Add `--fix` to auto-install anything missing on macOS or Debian/Ubuntu. Subject libraries are never installed here; the agent installs per-lab dependencies at runtime.

## How it works

1. Drop the assignment brief, boilerplate code, and data files into `./lab-input/` in the lab folder.
2. The agent writes `<Lab-Info>-plan.md` and waits for your approval.
3. The agent implements by appending to boilerplate only, then runs everything and records real outputs.
4. The agent writes `manual_steps.md` covering everything you must do yourself: screenshots (only if the assignment deliverables include figures), tracker updates, submissions. The agent never performs user-side steps.
5. If a PDF report is a deliverable, the agent writes `report.tex`, waits for your screenshots-ready reply when screenshots apply, verifies with `scripts/verify-lab.sh`, and builds `<Lab>_Report.pdf`.

## Repo layout

- `SKILL.md` the skill (single-skill package, root layout required by `npx skills add`).
- `scripts/` environment check plus lab verification gate.
- `references/` full workflow, tex, and style rules.
- `assets/` plan and checklist templates (the tex file is always built from scratch per the tex guide).
