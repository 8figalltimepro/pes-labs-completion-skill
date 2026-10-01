# Workflow Reference

## Input intake

The lab folder is the working directory. Inside it, `./lab-input/` is the only place the agent reads assignment inputs from. If the folder is missing, create it. If the assignment brief, boilerplate code, or data files are missing from it, stop and reply with the exact file names needed, then wait. Instruction text given directly in the user prompt counts the same as files. Never guess at missing requirements.

## Planning

Read every input file end to end before writing anything. The `<Lab-Info>-plan.md` file is written beside the lab folder, never inside `lab-input/`. It must contain: each code edit stated as the exact target plus the exact new behavior, each dependency to install with version pinning where the lab fixes one, which real program outputs feed the report, the screenshot list with exact file names (only if the assignment deliverables include figures), and every `\includegraphics` tag that will reference them (only if a PDF report is a deliverable). Approval HALT: after writing the plan, stop and wait for the user's explicit approval. Change no lab files until it arrives. Each round of user feedback means an updated plan plus another halt.

## Implementation

Resolve the toolchain before touching code. Inspect boilerplate imports, Makefiles, build files, manifests, or README setup notes. Install only what is missing for this lab and record exact versions in the plan. If the lab is not Python-based, use its native toolchain and skip Python steps without error. Run `scripts/check-env.sh` from the installed skill directory on first use per machine, adding `--fix` to auto-install missing base tools.

Fill boilerplate by appending below existing TODO and comment lines only. Before the first edit, copy each original boilerplate file to `<name>.orig` as the TODO baseline. Replace placeholder values (`None`, `pass`, empty returns) where the boilerplate asks. Keep every original comment line. Never rename symbols, restyle output, or add unrequested parameters, loops, or helpers. Run the full program top to bottom until it passes with zero errors. Copy real printed outputs into a temp note for the report. Never invent or round-trip numbers through memory: copy them. If a network download fails, retry with network on and keep the given loader code unchanged; if it still fails, stop and report the error instead of faking results.

## Screenshot handoff

`manual_steps.md` lives in the lab folder. It strictly instructs the user and never the agent: every user-side step in order, such as screenshots, tracker updates (for example JIRA tickets), form fills, and file uploads, each with exact actions and how to confirm. Screenshot entries appear only if the assignment deliverables include figures; every such entry names the exact cell or command to run, what to include in the shot, what to crop out, the format (PNG), and the exact save name under `screenshots/`. It ends with a done-confirm line: the user replies when everything is ready, and the final build waits for that reply.

The user often ignores the save names and dumps whatever their capture tool produced into
`screenshots/`. That is fine, the naming is the agent's job in the sorting step below. Tell
the user in `manual_steps.md` that the names do not matter but the order does.

## Screenshot sorting

Do this as the first thing after the user says the screenshots are in, and before anything
touches `report.tex` or the PDF. The names in `manual_steps.md` are the contract, the
uploaded file names are not. There is no script for this, the agent judges each batch.

1. List the folder with sizes and times (`ls -l`, plus file names, since a Mac capture tool
   puts the capture time in the name, `Screenshot 2026-10-01 at 1.51.44 PM.png`).
2. Build the expected name list, in order, by reading the shot entries out of
   `manual_steps.md`.
3. Sort the uploaded files oldest capture time first. The shot list told the user to shoot
   in that order, so times and list positions line up. Use the time in the file name when
   it is there, it is the true capture time. Fall back to the file mtime.
4. Rename each uploaded file onto its expected name, exactly character for character.
5. Check the pictures when the order is not certain. Reading the images is allowed, taking
   them is not. Each shot entry says what should be in the frame (a title, an SRN, a header
   line), so a doubtful slot can be confirmed by eye. Fix any mix up and re-check.

Cases that need a decision, not a script:

- A png the agent put in `screenshots/` itself, for example a plot taken out of the
  notebook. Leave it named, do not let it eat an expected name.
- The user retook one shot after the rest. Its time is late, so it sorts into the wrong
  slot. Find it by eye and swap it back, or ask the user which one it was.
- The shots arrived in a zip or a copy that kept old timestamps. Sort by the times in the
  file names instead, or ask.
- Count mismatch, or a file that is not a PNG, or two files that look identical. Stop and
  ask the user. Never guess a mapping silently.
- Every expected name is already in place. Nothing to do, move on.

Report the mapping that was applied in the final message, one line per rename, so the user
can spot a wrong slot at a glance.

## Report build

`report.tex` lives in the lab folder and is written only if the assignment needs a PDF report. Image tags, used only when screenshots are part of the deliverables, must match the screenshot names character for character. The screenshot HALT applies only when screenshots are deliverables: after writing the tex file, stop and wait for the user's screenshots-ready reply. After confirmation: run the sorting step, check every tagged name exists in `screenshots/`, compile from the lab folder with `latexmk -pdf report.tex` (fallback: `pdflatex report.tex` twice), and name the output `<Lab>_Report.pdf`. Never write over the assignment brief file. Open the PDF and confirm the title page, all figures, the results table matching program output, and all answers, with no missing-image boxes.
