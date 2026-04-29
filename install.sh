#!/usr/bin/env bash
# install.sh — symlink every skill in skills/ into ~/.claude/skills/.
# Idempotent: re-running is safe.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DEST="$HOME/.claude/skills"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "ERROR: $SKILLS_SRC does not exist." >&2
  exit 1
fi

mkdir -p "$SKILLS_DEST"

shopt -s nullglob
for skill_path in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_path")"
  target="$SKILLS_DEST/$skill_name"

  if [[ -L "$target" ]]; then
    current="$(readlink "$target")"
    if [[ "$current" == "${skill_path%/}" ]]; then
      echo "OK     $skill_name (symlink already correct)"
      continue
    else
      echo "FIX    $skill_name (symlink points to $current — repointing)"
      rm "$target"
      ln -s "${skill_path%/}" "$target"
      continue
    fi
  fi

  if [[ -e "$target" ]]; then
    echo "ERROR: $target exists and is NOT a symlink. Refusing to overwrite." >&2
    exit 1
  fi

  ln -s "${skill_path%/}" "$target"
  echo "LINK   $skill_name -> $skill_path"
done

echo "Done. Skills installed at $SKILLS_DEST."
