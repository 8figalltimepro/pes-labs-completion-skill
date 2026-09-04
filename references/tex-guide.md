# Tex Guide

Use clean, standard LaTeX. No custom macros, no extra packages beyond this list.

## Preamble

```latex
\documentclass[11pt,a4paper]{article}
\usepackage{graphicx}
\usepackage{float}
\usepackage{booktabs}
\usepackage{geometry}
\geometry{margin=1in}
\graphicspath{{screenshots/}}
```

Add a package only when the lab content needs it (for example `amsmath` for equations), and note the addition in the plan.

## Figures

One figure environment per screenshot. Full plots and program-output shots use width `0.9\textwidth`; small matrices and compact diagrams use `0.7\textwidth`. Every figure gets a plain direct caption naming what the image shows. Image names must match the `screenshots/` file names character for character, including any letter suffixes for split shots (`06a`, `06b`).

## Tables

Results tables use `booktabs` (`\toprule`, `\midrule`, `\bottomrule`). Numbers come from the real program run, copied exactly at a fixed number of decimal places stated in the plan. The table must match program output row for row.

## Title page

`\maketitle` with title, student name, student ID, course name, and `\today` as the submission date. No placeholders for name or ID; take them from the user or the assignment brief.

## Compile

From the lab folder run `latexmk -pdf report.tex`. If `latexmk` is missing, run `pdflatex report.tex` twice. If neither exists, stop after tex verification and report the missing tool instead of hand making a PDF.
