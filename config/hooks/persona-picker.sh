#!/usr/bin/env bash
# SessionStart hook: dynamically lists personas from ~/.claude/personas/
# and tells Claude to ask the user which one to adopt for this session.

PERSONAS_DIR="$HOME/.claude/personas"

# Headless guard (added 31 Aug 2026, DATA_ENRICHMENT build): the picker is for
# Marc's INTERACTIVE sessions only — it asks a human to type an answer. Skip
# when explicitly told to (PERSONA_PICKER_SKIP=1), or when the parent claude
# process runs in print mode (claude -p / --print), e.g. headless worker loops.
if [ -n "$PERSONA_PICKER_SKIP" ]; then
  exit 0
fi
parent_args=$(ps -o args= -p "$PPID" 2>/dev/null)
case " $parent_args " in
  *" -p "*|*" --print "*) exit 0 ;;
esac

# Bail silently if no personas dir or no .md files (no hook output = no picker)
if [ ! -d "$PERSONAS_DIR" ]; then
  exit 0
fi

# Get all .md basenames (without .md), sorted alphabetically
files=$(ls -1 "$PERSONAS_DIR"/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//' | sort)

if [ -z "$files" ]; then
  exit 0
fi

# Build a markdown bullet list of available personas
list=""
while IFS= read -r name; do
  if [ -n "$name" ]; then
    list="${list}- ${name}"$'\n'
  fi
done <<< "$files"

# Build the additionalContext message Claude will see at session start
context="PERSONA PICKER (mandatory first action this session):

Before doing ANYTHING else — including any tool call, any reply to the user's first message, and any skill invocation other than this — you MUST send the user this chat message verbatim (no preface, no extra text):

---
Which persona should I load for this session? (type the name, or 'none' to skip)

Available personas (from ~/.claude/personas/):
$list---

Then STOP and wait for the user's reply.

When the user replies with a name:
1. Match case-insensitively. Suffix-tolerant: 'emails' matches CLAUDEEMAILS, 'dev' matches CLAUDEDEV, etc. If multiple match, ask the user to disambiguate.
2. Read the matching file from $PERSONAS_DIR/.
3. Adopt the contents of that file as your persona for the rest of the session.
4. Then respond to whatever the user originally asked.

If the user types 'none', 'skip', 'default', or similar, proceed normally without loading any persona file.

Do not skip the picker even if the user's first message looks urgent or trivial. Do not announce the picker before sending the menu; just send it."

# Use jq to safely build the JSON (handles escaping of newlines, quotes, etc.)
jq -n --arg ctx "$context" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'
