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
# Beyond skills, it also makes these repo-managed (symlinked, so every
# ./pull.sh updates them automatically):
#   - global/CLAUDE.md            → ~/.claude/CLAUDE.md   (loads in EVERY session)
#   - personas/*.md               → ~/.claude/personas/   (portable personas only)
#   - config/settings.json        → ~/.claude/settings.json  (MERGED, not symlinked:
#                                   repo wins on shared keys, the machine keeps its
#                                   own plugins/model/theme — see merge_settings).
#                                   Its `env` block carries the switches the skills
#                                   depend on — CLAUDE_CODE_ENABLE_TODO_TOOLS keeps
#                                   the TaskCreate/TaskGet/TaskList/TaskUpdate tools
#                                   available on models that drop them by default.
#                                   verify_env_keys re-reads the installed file and
#                                   reports per key, so a skipped merge is loud.
#   - config/statusline-command.sh→ ~/.claude/statusline-command.sh
#   - config/hooks/persona-picker.sh → ~/.claude/hooks/persona-picker.sh
#
# The repo WINS on everything it ships: a real file in the way is backed up as
# <name>.bak_pre_powerups_YYYY-MM-DD and replaced by the symlink. Anything the
# repo does NOT ship — server-specific personas, other hooks, settings.local.json
# — is never read, moved, or deleted.
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
BACKUP_DIR="$HOME/.claude/_powerups_backups"

# Keys in settings.json that describe THIS MACHINE rather than the shared setup.
# On a machine that already has settings.json, its own values for these win and
# are never overwritten; the repo only supplies them as defaults on a brand-new
# machine. Everything NOT listed here is shared, and the repo wins on it.
#
# Why these are machine-local:
#   enabledPlugins / extraKnownMarketplaces — mirror which marketplaces are
#     physically installed on the machine. The same plugin can come from
#     different marketplaces (superpowers ships from both claude-plugins-official
#     and obra/superpowers-marketplace), and naming a marketplace the machine
#     doesn't have silently disables the plugin.
#   model / theme / effortLevel / alwaysThinkingEnabled / voice /
#     agentPushNotifEnabled — personal preferences that legitimately differ
#     between a desktop and a headless server.
MACHINE_LOCAL_KEYS='["enabledPlugins","extraKnownMarketplaces","model","theme","effortLevel","alwaysThinkingEnabled","voice","agentPushNotifEnabled"]'

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
  link_managed "$src" "$BIN_DEST/$base" "$skill_name/$base -> $BIN_DEST"
}

# ────────── helper: install a repo-managed file as a symlink ──────────
# The repo WINS. If a real file is sitting at the target, it is backed up first
# as <name>.bak_pre_powerups_YYYY-MM-DD and then replaced by the symlink.
# Because it's a symlink, every future ./pull.sh updates it automatically.
link_managed() {
  local src="$1"
  local target="$2"
  local label="$3"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$src" ]]; then
      echo "  OK      $label (symlink already correct)"
      return 0
    fi
    echo "  FIX     $label (was $current, repointing)"
    rm "$target"
    ln -s "$src" "$target"
    return 0
  fi

  if [[ -e "$target" ]]; then
    # Backups go to ONE dedicated folder, never next to the original. A skill
    # backup left inside ~/.claude/skills/ would be picked up as a real skill;
    # this keeps every backup out of anything Claude Code scans.
    mkdir -p "$BACKUP_DIR"
    local base
    base="$(basename "$target")"
    local backup="$BACKUP_DIR/$base.bak_pre_powerups_$(date +%Y-%m-%d)"
    local n=1
    while [[ -e "$backup" ]]; do
      backup="$BACKUP_DIR/$base.bak_pre_powerups_$(date +%Y-%m-%d)-$n"
      n=$((n + 1))
    done
    mv "$target" "$backup"
    ln -s "$src" "$target"
    echo "  REPLACE $label (backup: _powerups_backups/$(basename "$backup"))"
    return 0
  fi

  ln -s "$src" "$target"
  echo "  LINK    $label"
}

# ────────── helper: merge settings.json (NOT a symlink) ──────────
# settings.json is the one managed file that cannot be a plain symlink: it mixes
# shared configuration (the persona-picker hook, the statusline, env, permissions)
# with machine-specific state (which plugin marketplaces are installed, model,
# theme). Symlinking it would hand one machine's plugin list to every other
# machine and silently disable plugins that came from a different marketplace.
#
# So: the repo wins on every shared key, the machine keeps every key listed in
# MACHINE_LOCAL_KEYS, and any extra key the machine added on its own is left
# alone. Idempotent — re-running produces no change once converged.
merge_settings() {
  local src="$1"
  local target="$2"

  if ! command -v jq >/dev/null 2>&1; then
    echo "  WARN    settings.json needs jq to merge — skipped (install jq, then re-run)" >&2
    return 0
  fi

  mkdir -p "$(dirname "$target")"

  # Migration from the old regime, where settings.json was symlinked into the
  # repo. The symlink's content IS that machine's live settings, so seed the new
  # real file from it — nothing is lost on the machine that was symlinked.
  if [[ -L "$target" ]]; then
    local resolved
    resolved="$(cat "$target" 2>/dev/null || echo '{}')"
    rm "$target"
    printf '%s\n' "$resolved" > "$target"
    echo "  UNLINK  settings.json (was a symlink into the repo; now a real per-machine file)"
  fi

  # Brand-new machine with no settings at all: take the repo's file wholesale.
  if [[ ! -e "$target" ]]; then
    cp "$src" "$target"
    echo "  SEED    settings.json (new machine — copied repo defaults)"
    return 0
  fi

  if ! jq -e . "$target" >/dev/null 2>&1; then
    echo "  WARN    settings.json is not valid JSON — leaving it untouched" >&2
    return 0
  fi

  local merged
  merged="$(mktemp)"
  if ! jq -s --argjson local "$MACHINE_LOCAL_KEYS" '
        .[0] as $repo
      | .[1] as $mine
      | ($repo | with_entries(select(.key as $k | ($local | index($k)) | not))) as $shared
      | $mine * $shared
      ' "$src" "$target" > "$merged" 2>/dev/null; then
    rm -f "$merged"
    echo "  WARN    settings.json merge failed — leaving it untouched" >&2
    return 0
  fi

  if diff -q <(jq -S . "$target") <(jq -S . "$merged") >/dev/null 2>&1; then
    rm -f "$merged"
    echo "  OK      settings.json (shared keys already up to date)"
    return 0
  fi

  mkdir -p "$BACKUP_DIR"
  local backup="$BACKUP_DIR/settings.json.bak_pre_powerups_$(date +%Y-%m-%d)"
  local n=1
  while [[ -e "$backup" ]]; do
    backup="$BACKUP_DIR/settings.json.bak_pre_powerups_$(date +%Y-%m-%d)-$n"
    n=$((n + 1))
  done
  cp "$target" "$backup"
  mv "$merged" "$target"
  echo "  MERGE   settings.json (shared keys applied; machine-local keys kept)"
  echo "          backup: _powerups_backups/$(basename "$backup")"
}

# ────────── helper: verify the repo's env keys actually landed ──────────
# merge_settings() returns 0 even when it skips (no jq, invalid JSON, failed
# merge), so a machine can finish "successfully" with none of the repo's env
# vars applied. Those vars are load-bearing: CLAUDE_CODE_ENABLE_TODO_TOOLS is
# what keeps TaskCreate / TaskGet / TaskList / TaskUpdate available on Opus 4.8,
# Sonnet 5, Fable 5, Mythos 5 and newer, where Claude Code drops them by
# default. A silent miss means every skill that says "create a task list" calls
# a tool that isn't there. This reads the INSTALLED file back and reports per
# key, so the failure shows up at install time, not mid-session weeks later.
verify_env_keys() {
  local src="$1"
  local target="$2"

  command -v jq >/dev/null 2>&1 || return 0   # merge_settings already warned
  [[ -f "$target" ]] || return 0

  local keys
  keys="$(jq -r '.env // {} | keys[]' "$src" 2>/dev/null)" || return 0
  [[ -n "$keys" ]] || return 0

  local missing=0 key want got
  while IFS= read -r key; do
    [[ -n "$key" ]] || continue
    want="$(jq -r --arg k "$key" '.env[$k]' "$src" 2>/dev/null)"
    got="$(jq -r --arg k "$key" '.env[$k] // "(absent)"' "$target" 2>/dev/null)"
    if [[ "$got" == "$want" ]]; then
      echo "  OK      env $key=$want"
    else
      echo "  FAIL    env $key — expected '$want', found '$got'" >&2
      missing=$((missing + 1))
    fi
  done <<< "$keys"

  if [[ $missing -gt 0 ]]; then
    echo "  WARN    $missing env key(s) did NOT land in $target." >&2
    echo "          Task tools and/or agent teams may be unavailable this session." >&2
    return 0
  fi
  echo "  OK      env keys verified in ~/.claude/settings.json"
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
  link_managed "$skill_path_clean" "$target" "skill folder"

  # 2. Symlink any skill-bundled tools into ~/.local/bin/
  for f in "$skill_path"*; do
    if is_bundled_tool "$f"; then
      link_bundled_tool "$f" "$skill_name"
    fi
  done

  # 3. Ensure per-skill venv if requirements.txt is present
  ensure_skill_venv "$skill_path_clean" "$skill_name"
done

# ────────── global rules: global/CLAUDE.md → ~/.claude/CLAUDE.md ──────────
# Loaded in EVERY session regardless of which persona is picked (or none).
if [[ -f "$REPO_DIR/global/CLAUDE.md" ]]; then
  echo "→ global rules"
  link_managed "$REPO_DIR/global/CLAUDE.md" "$HOME/.claude/CLAUDE.md" "~/.claude/CLAUDE.md"
fi

# ────────── personas: personas/*.md → ~/.claude/personas/ ──────────
# ONLY the personas shipped in this repo (the portable ones) are managed.
# Server-specific personas — CLAUDEGADS, CLAUDEEMAILS, CLAUDEANALYSIS,
# CLAUDEMARC, CLAUDEPLAN, CLAUDEMJYT, CLAUDECLARITY, CLAUDEEXPENSES,
# CLAUDELAUNCH, CLAUDEHEALTH, CLAUDE — are NEVER read, moved, or deleted.
if [[ -d "$REPO_DIR/personas" ]]; then
  for persona_file in "$REPO_DIR"/personas/*.md; do
    [[ -e "$persona_file" ]] || continue
    persona_base="$(basename "$persona_file")"
    echo "→ persona: $persona_base"
    link_managed "$persona_file" "$HOME/.claude/personas/$persona_base" "persona $persona_base"
  done
fi

# ────────── Claude Code config: config/ → ~/.claude/ ──────────
# settings.json carries the SessionStart persona-picker hook and the statusline,
# so all three travel together — shipping one without the others breaks it.
# persona-picker.sh is dynamic: it lists whatever is in ~/.claude/personas/,
# so a machine with only CLAUDEDEV + CLAUDEREG shows exactly those two.
#
# The two scripts are symlinked (identical everywhere). settings.json is MERGED
# instead — see merge_settings() for why it cannot be a symlink. Both scripts are
# referenced from settings.json via "$HOME/..." rather than a hardcoded path, so
# the same settings.json works on Linux and macOS; Claude Code runs hook and
# statusLine commands through a shell, which expands the variable.
if [[ -d "$REPO_DIR/config" ]]; then
  echo "→ Claude Code config"
  if [[ -f "$REPO_DIR/config/settings.json" ]]; then
    merge_settings "$REPO_DIR/config/settings.json" "$HOME/.claude/settings.json"
  fi
  if [[ -f "$REPO_DIR/config/statusline-command.sh" ]]; then
    link_managed "$REPO_DIR/config/statusline-command.sh" "$HOME/.claude/statusline-command.sh" "statusline-command.sh"
  fi
  if [[ -f "$REPO_DIR/config/hooks/persona-picker.sh" ]]; then
    link_managed "$REPO_DIR/config/hooks/persona-picker.sh" "$HOME/.claude/hooks/persona-picker.sh" "hooks/persona-picker.sh"
  fi
  if [[ -f "$REPO_DIR/config/settings.json" ]]; then
    verify_env_keys "$REPO_DIR/config/settings.json" "$HOME/.claude/settings.json"
  fi
fi

echo
echo "Done."
echo "  Skills:        $SKILLS_DEST"
echo "  Bundled tools: $BIN_DEST"
echo "  Skill venvs:   $CONFIG_BASE/<skill-name>/venv (when requirements.txt present)"
echo "  Global rules:  $HOME/.claude/CLAUDE.md"
echo "  Personas:      $HOME/.claude/personas/ (only the ones shipped in this repo)"
echo "  Config:        $HOME/.claude/settings.json + statusline + persona-picker hook"
