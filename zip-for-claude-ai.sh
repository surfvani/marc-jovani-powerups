#!/usr/bin/env bash
# -----------------------------------------------------------
# zip-for-claude-ai.sh
# Packages every skill in skills/ into a ZIP ready for
# Claude.ai upload (Customize > Skills > + > Upload a skill).
#
# ZIP structure:  skill-name/SKILL.md  (folder at root)
# Excludes:       .bak files, .gitignore, __pycache__, .DS_Store
#
# Output:         claude-ai-zips/<skill-name>.zip  (one per skill)
# -----------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
OUT_DIR="$SCRIPT_DIR/claude-ai-zips"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

count=0
for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name="$(basename "$skill_dir")"

  # Create a clean temp copy (no .bak, .gitignore, .DS_Store, __pycache__)
  tmp="$(mktemp -d)"
  rsync -a \
    --exclude='*.bak*' \
    --exclude='.gitignore' \
    --exclude='.DS_Store' \
    --exclude='__pycache__' \
    "$skill_dir" "$tmp/$skill_name/"

  # ZIP it — folder at root level, as Claude.ai expects
  (cd "$tmp" && zip -r "$OUT_DIR/$skill_name.zip" "$skill_name/" -x '*.DS_Store') >/dev/null 2>&1

  rm -rf "$tmp"
  count=$((count + 1))
  echo "  zipped: $skill_name"
done

echo ""
echo "Done — $count ZIPs written to: claude-ai-zips/"
echo ""
echo "Upload each one at: claude.ai > Customize > Skills > + > Upload a skill"
echo "Prerequisite: Settings > Capabilities > enable 'Code execution and file creation'"
