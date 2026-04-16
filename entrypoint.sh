#!/bin/bash
set -euo pipefail

# entrypoint.sh - Runs inside the Docker container to compile LaTeX.
# Usage: entrypoint.sh <main.tex> [additional latexmk args...]

MAIN_TEX="${1:-}"

if [ -z "$MAIN_TEX" ]; then
    echo "texdock: no .tex file specified, auto-detecting..." >&2
    MAIN_TEX=$(find /texdock/input -maxdepth 1 -name '*.tex' -print -quit 2>/dev/null || true)
    if [ -z "$MAIN_TEX" ]; then
        echo "texdock error: no .tex file found in /texdock/input" >&2
        exit 1
    fi
fi

echo "texdock: compiling ${MAIN_TEX} ..."

EXIT_CODE=0
latexmk \
    -pdf \
    -interaction=nonstopmode \
    -file-line-error \
    -output-directory="/texdock/output" \
    "$MAIN_TEX" || EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "texdock: compilation succeeded"
else
    echo "texdock: compilation failed with exit code ${EXIT_CODE}" >&2
fi

exit $EXIT_CODE
