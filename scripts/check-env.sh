#!/usr/bin/env bash
# check-env.sh: check course-independent base tools, optionally install them.
# Usage: check-env.sh [--check-only] [--fix]
# Default mode is --check-only (safe, changes nothing).
set -u

MODE="check"
for arg in "$@"; do
  case "$arg" in
    --fix) MODE="fix" ;;
    --check-only) MODE="check" ;;
    -h|--help)
      echo "Usage: check-env.sh [--check-only] [--fix]"
      exit 0 ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

MISSING=0
report() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "OK $1"
  else
    echo "MISSING $1"
    MISSING=1
  fi
}

report node
report python3
report pip3
report git
if command -v latexmk >/dev/null 2>&1; then
  echo "OK latexmk"
elif command -v pdflatex >/dev/null 2>&1; then
  echo "OK pdflatex"
else
  echo "MISSING latexmk-or-pdflatex"
  MISSING=1
fi

if [ "$MODE" = "check" ]; then
  if [ "$MISSING" -ne 0 ]; then
    echo "Run with --fix to auto-install, or install the MISSING tools by hand."
  fi
  exit "$MISSING"
fi

# --fix mode: install only what is missing.
OS="$(uname -s)"
have() { command -v "$1" >/dev/null 2>&1; }

install_mac() {
  if ! have brew; then
    echo "Homebrew not found. Install it first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
    return 1
  fi
  ! have node && brew install node
  ! have python3 && brew install python
  ! have git && brew install git
  { have latexmk || have pdflatex; } || brew install --cask mactex-no-gui
}

install_deb() {
  sudo apt-get update
  ! have node && sudo apt-get install -y nodejs npm
  ! have python3 && sudo apt-get install -y python3 python3-pip
  ! have git && sudo apt-get install -y git
  { have latexmk || have pdflatex; } || sudo apt-get install -y texlive-latex-recommended latexmk
}

case "$OS" in
  Darwin) install_mac ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      install_deb
    else
      echo "No apt-get on this Linux. Install by hand: node, python3, python3-pip, git, texlive-latex-recommended, latexmk." >&2
      exit 1
    fi ;;
  *) echo "Unsupported OS ($OS). Install by hand: node 18+, python3, pip, git, and a LaTeX distribution with latexmk or pdflatex." >&2; exit 1 ;;
esac

# Re-check after provisioning.
exec "$0" --check-only
