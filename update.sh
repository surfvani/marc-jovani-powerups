#!/usr/bin/env bash
# update.sh — stage, commit, and push changes to origin.
# Usage: ./update.sh "commit message"
#   If no message is given, uses "Update skills" with a timestamp.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

MSG="${1:-Update skills ($(date -u +%Y-%m-%d_%H:%M:%SZ))}"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "ERROR: $REPO_DIR is not a git repository." >&2
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "$MSG"
  echo "Committed: $MSG"
fi

if git remote get-url origin > /dev/null 2>&1; then
  git push origin HEAD
  echo "Pushed to origin."
else
  echo "WARNING: no 'origin' remote configured — skipping push."
fi
