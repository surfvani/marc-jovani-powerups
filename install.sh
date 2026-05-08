#!/usr/bin/env bash
# install.sh — wire every skill in skills/ into Claude Code, plus any
# skill-bundled tools and per-skill venvs. Idempotent: safe to re-run.
#
# What it does, per skill:
#   1. Symlinks the skill folder into ~/.claude/skills/<skill-name>/.
#   2. Looks for "skill-bundled tools" — executable files at the skill root
#      whose extension is NOT in {md,txt,json,yaml,yml} (and not dotfiles) —
#      and symlinks each into ~/.local/bin/<basename>.
#   3. If skills/<name>/requirements.txt exists AND
#      ~/.config/<skill-name>/venv/ does NOT, creates a venv there and
#      pip-installs the requirements (one-time, per-server).
#
# Re-running on a server that's already set up: skill symlinks reconciled,
# tool symlinks reconciled, venvs left alone (delete the venv to force a
# rebuild). All output is human-friendly with OK / LINK / FIX prefixes.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DEST="$HOME/.claude/skills"
BIN_DEST="$HOME/.local/bin"
CONFIG_BASE="$HOME/.config"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "ERROR: $SKILLS_SRC does not exist." >&2
  exit 1
fi

mkdir -p "$SKILLS_DEST" "$BIN_DEST"

# ────────── helper: should this file be treated as a skill-bundled tool? ──────────
is_bundled_tool() {
  local f="$1"
  local base
  base="$(basename "$f")"
  # Skip dotfiles
  [[ "$base" == .* ]] && return 1
  # Skip known doc/config extensions
  case "$base" in
    *.md|*.txt|*.json|*.yaml|*.yml) return 1 ;;
  esac
  # Must be a regular, executable file
  [[ -f "$f" && -x "$f" ]]
}

# ────────── helper: link a skill-bundled tool into ~/.local/bin/ ──────────
link_bundled_tool() {
  local src="$1"
  local skill_name="$2"
  local base
  base="$(basename "$src")"
  local target="$BIN_DEST/$base"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$src" ]]; then
      echo "  OK     $skill_name/$base -> $BIN_DEST (symlink already correct)"
      return 0
    fi
    echo "  FIX    $skill_name/$base -> $BIN_DEST (was $current, repointing)"
    rm "$target"
    ln -s "$src" "$target"
    return 0
  fi

  if [[ -e "$target" ]]; then
    echo "  ERROR: $target exists and is NOT a symlink. Refusing to overwrite." >&2
    exit 1
  fi

  ln -s "$src" "$target"
  echo "  LINK   $skill_name/$base -> $BIN_DEST"
}

# ────────── helper: ensure per-skill venv ──────────
ensure_skill_venv() {
  local skill_path="$1"
  local skill_name="$2"
  local req="$skill_path/requirements.txt"

  [[ -f "$req" ]] || return 0  # no requirements.txt = no venv needed

  local venv_dir="$CONFIG_BASE/$skill_name/venv"
  if [[ -d "$venv_dir" ]]; then
    echo "  OK     $skill_name venv already exists at $venv_dir (delete to force rebuild)"
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "  WARN   $skill_name needs a venv but python3 is not on PATH — skipping" >&2
    return 0
  fi

  echo "  VENV   $skill_name → $venv_dir (this can take a minute)"
  mkdir -p "$(dirname "$venv_dir")"
  python3 -m venv "$venv_dir"
  "$venv_dir/bin/pip" install --quiet --upgrade pip
  "$venv_dir/bin/pip" install --quiet -r "$req"
  echo "  DONE   $skill_name venv ready"
}

# ────────── main loop ──────────
shopt -s nullglob
for skill_path in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_path")"
  skill_path_clean="${skill_path%/}"
  target="$SKILLS_DEST/$skill_name"

  echo "→ $skill_name"

  # 1. Symlink the skill folder into ~/.claude/skills/
  if [[ -L "$target" ]]; then
    current="$(readlink "$target")"
    if [[ "$current" == "$skill_path_clean" ]]; then
      echo "  OK     skill folder (symlink already correct)"
    else
      echo "  FIX    skill folder (was $current, repointing)"
      rm "$target"
      ln -s "$skill_path_clean" "$target"
    fi
  elif [[ -e "$target" ]]; then
    echo "  ERROR: $target exists and is NOT a symlink. Refusing to overwrite." >&2
    exit 1
  else
    ln -s "$skill_path_clean" "$target"
    echo "  LINK   skill folder -> $SKILLS_DEST"
  fi

  # 2. Symlink any skill-bundled tools into ~/.local/bin/
  for f in "$skill_path"*; do
    if is_bundled_tool "$f"; then
      link_bundled_tool "$f" "$skill_name"
    fi
  done

  # 3. Ensure per-skill venv if requirements.txt is present
  ensure_skill_venv "$skill_path_clean" "$skill_name"
done

echo
echo "Done."
echo "  Skills:        $SKILLS_DEST"
echo "  Bundled tools: $BIN_DEST"
echo "  Skill venvs:   $CONFIG_BASE/<skill-name>/venv (when requirements.txt present)"
