# Style Rules

These rules apply to every file the agent generates for the lab.

## No em dashes

Never emit the em dash character in any generated prose file (`manual_steps.md`, `report.tex`, plan files). Use commas or separate sentences instead. Check with `grep -r "—"` before finishing.

## Beginner direct English

Analysis paragraphs, conclusions, and theory answers use simple direct beginner engineering-student English. Short sentences. Plain words. No fancy academic style. Methods, captions, checklists, and code stay plain and direct as well.

## Boilerplate is append-only

Never change or delete a TODO or comment line already present in boilerplate code cells or files. Add new code lines below them. Replace placeholder values (`None`, `pass`, empty returns) only where the boilerplate asks. Keep variable names and behavior exactly as the assignment defines.
