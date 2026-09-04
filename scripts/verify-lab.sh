#!/usr/bin/env bash
# verify-lab.sh: gate checks for a finished lab folder.
# Usage: verify-lab.sh <lab-dir>
# Exits 0 when all checks pass, nonzero naming each violation otherwise.
# Screenshot and PDF checks apply only when the lab uses them.
set -u

if [ "$#" -ne 1 ]; then
  echo "Usage: verify-lab.sh <lab-dir>" >&2
  exit 2
fi
LAB="$1"
FAIL=0
bad() { echo "FAIL: $1" >&2; FAIL=1; }

[ -d "$LAB" ] || { echo "FAIL: lab dir not found: $LAB" >&2; exit 2; }

# 1. TODO markers must survive in code (append-only rule).
BACKUP="$(find "$LAB" -maxdepth 2 \( -name '*.orig' -o -name '*.bak' \) -print -quit)"
if [ -n "$BACKUP" ]; then
  A=$(grep -rho 'TODO' "$BACKUP" 2>/dev/null | wc -l)
  B=$(grep -rho 'TODO' "$LAB" --include='*.ipynb' --include='*.py' --include='*.c' --include='*.java' --include='*.sql' 2>/dev/null | wc -l)
  [ "$B" -ge "$A" ] || bad "TODO count dropped vs backup ($B < $A)"
else
  N=$(grep -rl 'TODO' "$LAB" --include='*.ipynb' --include='*.py' --include='*.c' --include='*.java' --include='*.sql' 2>/dev/null | wc -l)
  [ "$N" -gt 0 ] || echo "WARN: no TODO markers found and no .orig backup to compare"
fi

# 2. No residual placeholders in notebook or Python code.
if grep -rn '= None' "$LAB" --include='*.ipynb' --include='*.py' 2>/dev/null | grep -qv 'ssl\._create'; then
  bad "residual '= None' placeholder in code"
fi
if grep -rnE '^[[:space:]]*pass([[:space:]]*(#.*)?)?$' "$LAB" --include='*.py' 2>/dev/null | grep -q .; then
  bad "residual bare 'pass' placeholder in .py files"
fi

# 3. No em dash bytes in generated prose files, when present.
if grep -rl '—' "$LAB"/manual_steps.md "$LAB"/report.tex 2>/dev/null | grep -q .; then
  bad "em dash found in manual_steps.md or report.tex"
fi

TEX="$LAB/report.tex"
if [ -f "$TEX" ]; then
  # 4. Every tex image tag must resolve to screenshots/.
  while IFS= read -r img; do
    [ -f "$LAB/screenshots/$img" ] || bad "missing screenshot: screenshots/$img"
  done < <(grep -oE '\\includegraphics(\[[^]]*\])?\{[^}]+\}' "$TEX" | sed -E 's/.*\{([^}]+)\}/\1/')

  # 5. A compiled report PDF must exist.
  if ! ls "$LAB"/*Report.pdf "$LAB"/report.pdf 2>/dev/null | grep -q .; then
    bad "no compiled report PDF (*Report.pdf or report.pdf)"
  fi
else
  echo "SKIP: no report.tex, skipping screenshot and PDF checks"
fi

if [ "$FAIL" -eq 0 ]; then
  echo "verify-lab: all checks passed for $LAB"
fi
exit "$FAIL"
