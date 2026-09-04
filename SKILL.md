---
name: pes-labs-completion-skill
description: Completes engineering lab assignments end to end from boilerplate code and assignment files. Use when the user mentions a lab, lab assignment, lab experiment, boilerplate code, lab report, manual screenshots, or building a report PDF from LaTeX.
license: MIT
compatibility: Needs Node.js 18 or later for the npx installer, plus Python 3, pip, git, and a LaTeX distribution with latexmk or pdflatex when a PDF report is a deliverable. Assignment-specific libraries and toolchains are installed per lab at runtime.
---

# PES Labs Completion Skill

Complete an engineering lab assignment from boilerplate code to finished report. Works for any course or year. Follow the six phases in order. Obey every HALT: never proceed past one without the user's explicit reply.

## Phase 1. Input intake

Work in the lab folder. Read or create `./lab-input/`. The user drops the assignment brief (PDF or text), boilerplate code, and any data files there. If anything needed is missing, stop and tell the user exactly which files to drop in, then wait. Treat instruction text from the user prompt with equal weight to files. See [the workflow reference](references/workflow.md) for detail.

## Phase 2. Plan and approval HALT

Read every input file fully. Write `<Lab-Info>-plan.md` beside the lab folder using [the plan template](assets/plan-template.md). The plan lists each code edit, each dependency to install, what real output to capture, the screenshot list with exact file names (only if the assignment deliverables include figures), and every tex image tag (only if a PDF report is a deliverable). Then HALT. Change nothing until the user approves. If the user requests changes, update the plan and halt again.

## Phase 3. Implement

First resolve the toolchain: inspect boilerplate imports, Makefiles, build files, or requirements manifests, install only the missing libraries for this lab, and record exact versions in the plan. Check the environment with `scripts/check-env.sh` (add `--fix` to auto-install missing base tools). Before the first edit, copy each original boilerplate file to `<name>.orig` as the TODO baseline. Then fill boilerplate code by appending below existing TODO and comment lines only; replace placeholder values where the boilerplate asks. Never rename symbols, restyle output, or add unrequested parameters. Run the full program end to end until it passes with no errors, and copy the real printed numbers into a temp note. Never invent results. See [the style rules](references/style.md).

## Phase 4. User-side handoff (manual_steps.md)

Write `manual_steps.md` in the lab folder from [the checklist template](assets/manual-steps-template.md): every step the user must do themselves, in order, such as screenshots, tracker or portal updates (for example JIRA tickets), form fills, and file uploads. Include screenshot entries only if the assignment deliverables include figures. The agent MUST NEVER perform user-side steps itself: no screenshots, no portal edits, no submissions.

## Phase 5. Report source and screenshot HALT (when deliverables need them)

If the assignment needs a PDF report, first ask the user for the Student Name and SRN for the title page, then build `report.tex` in the lab folder from scratch following [the tex guide](references/tex-guide.md). The title page MUST show labeled `Student Name:` and `SRN:` lines with the user-supplied values. Image tags, used only when screenshots are part of the deliverables, must match the exact screenshot names from Phase 4. When there are no screenshots, skip the screenshot halt; otherwise HALT until the user confirms `screenshots/` is filled.

## Phase 6. Verify and build

After confirmation (or at once when no user-side steps remain), run `scripts/verify-lab.sh <lab-dir>` and fix every failure. When a PDF report is a deliverable, compile `report.tex` to `<Lab>_Report.pdf` with `latexmk -pdf` (fallback `pdflatex` twice). Never overwrite the assignment brief file. Open the PDF, if any, and confirm the title page, all figures, the results table matching program output, and all answers, with no missing-image boxes.
