#!/usr/bin/env bash
# pull.sh — fast-forward this repo from origin to receive skill updates.
# Designed to be cron-able on remote servers.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "ERROR: $REPO_DIR is not a git repository." >&2
  exit 1
fi

if ! git remote get-url origin > /dev/null 2>&1; then
  echo "ERROR: no 'origin' remote configured. Run install.sh on a fresh clone or 'git remote add origin <url>' manually." >&2
  exit 1
fi

git pull --ff-only origin "$(git rev-parse --abbrev-ref HEAD)"
echo "Up to date."

# Auto-run install.sh so any newly added skills / bundled tools / venvs get
# wired up immediately. install.sh is idempotent — safe on every pull.
"$REPO_DIR/install.sh"
