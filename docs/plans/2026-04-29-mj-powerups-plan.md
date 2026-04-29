# marc-jovani-powerups Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `marc-jovani-powerups` skill collection: three Claude Code skills (verbatim ports of Marc's "Destile Information" prompts), three Bash helper scripts (`install.sh`, `update.sh`, `pull.sh`), and a single `DOCUMENTATION.md` that allows future cold Claude sessions to add new skills with one approval beat.

**Architecture:** Standalone skills repo at `/home/ubuntu/marc-jovani-powerups/`. Each skill lives in `skills/<slug>/SKILL.md` with YAML frontmatter (`name`, `description`) and a verbatim body copied byte-for-byte from the source `.txt` prompt. Distribution to other servers is via `git pull` and a one-time `install.sh` that creates symlinks from `~/.claude/skills/<slug>` into the repo. Single source of truth: the repo file. Edits to either path edit the same file (symlink).

**Tech Stack:** Bash 5+, Git, Markdown, YAML frontmatter. No build, no language runtime.

---

## File Structure

After this plan is executed, the repo will contain:

```
/home/ubuntu/marc-jovani-powerups/
├── DOCUMENTATION.md
├── install.sh                                      (chmod +x)
├── update.sh                                       (chmod +x)
├── pull.sh                                         (chmod +x)
├── docs/
│   ├── specs/2026-04-29-mj-powerups-design.md      (already committed)
│   └── plans/2026-04-29-mj-powerups-plan.md        (this file)
└── skills/
    ├── distill-general-conversations/SKILL.md
    ├── distill-educational-generic/SKILL.md
    └── distill-educational-audio-composition/SKILL.md
```

Source prompts (read-only references — NOT modified):
- `/home/ubuntu/anthropic_text_processor/prompts/Destile Information (General — Conversations & Instructional).txt`
- `/home/ubuntu/anthropic_text_processor/prompts/Destile Information (Includes Context & Examples).txt`
- `/home/ubuntu/anthropic_text_processor/prompts/Destile Information FOR AUDIO & COMPOSITION CONTENT (Includes Context & Examples).txt`

---

## Task 1: Read all 3 source prompts and draft descriptions

**Files:**
- Read: `/home/ubuntu/anthropic_text_processor/prompts/Destile Information (General — Conversations & Instructional).txt`
- Read: `/home/ubuntu/anthropic_text_processor/prompts/Destile Information (Includes Context & Examples).txt`
- Read: `/home/ubuntu/anthropic_text_processor/prompts/Destile Information FOR AUDIO & COMPOSITION CONTENT (Includes Context & Examples).txt`

- [ ] **Step 1: Read all three source `.txt` files in full**

Use the Read tool on each path. Hold the contents in context — they will be pasted verbatim into SKILL.md files in later tasks.

- [ ] **Step 2: Draft a 1–2 sentence `description` for each skill**

For each skill, the description must answer: *"When should Claude auto-trigger this skill?"* Reference the prompt's actual purpose (what kind of input it takes, what it produces). Keep each description under ~250 characters. Do not promise outcomes the prompt doesn't deliver.

- [ ] **Step 3: Present all three drafted descriptions to Marc in ONE message**

Format:

```
SKILL: distill-general-conversations
DESCRIPTION: <draft>

SKILL: distill-educational-generic
DESCRIPTION: <draft>

SKILL: distill-educational-audio-composition
DESCRIPTION: <draft>

Approve, or tell me what to change.
```

Wait for Marc's response. If he requests edits, revise and re-present. Only proceed to Task 2 after explicit approval.

- [ ] **Step 4: Persist the approved descriptions to a handoff file**

Subsequent tasks (2, 3, 4) may run in fresh subagents that don't share context. Write the approved descriptions to `/tmp/mj-powerups-descriptions.json` so later tasks can read them:

```bash
cat > /tmp/mj-powerups-descriptions.json <<'JSON'
{
  "distill-general-conversations": "<approved description 1>",
  "distill-educational-generic": "<approved description 2>",
  "distill-educational-audio-composition": "<approved description 3>"
}
JSON
```

Replace `<approved description N>` with the actual approved strings (escape internal double-quotes with `\"`). Verify by `cat /tmp/mj-powerups-descriptions.json | python3 -m json.tool` — must parse cleanly.

---

## Task 2: Create `skills/distill-general-conversations/SKILL.md`

**Files:**
- Create: `/home/ubuntu/marc-jovani-powerups/skills/distill-general-conversations/SKILL.md`

- [ ] **Step 1: Create the folder**

Run:
```bash
mkdir -p /home/ubuntu/marc-jovani-powerups/skills/distill-general-conversations
```

- [ ] **Step 2: Read the approved description**

```bash
python3 -c "import json; print(json.load(open('/tmp/mj-powerups-descriptions.json'))['distill-general-conversations'])"
```
Capture the output — that's the description for the frontmatter.

- [ ] **Step 3: Compose the SKILL.md content**

The file content is:
1. Frontmatter:
   ```
   ---
   name: distill-general-conversations
   description: <description from Step 2>
   ---
   ```
2. One blank line.
3. The **EXACT, BYTE-FOR-BYTE verbatim body** of `Destile Information (General — Conversations & Instructional).txt`. No edits, no cleanup, no translation, no typo fixes, no trimming.

- [ ] **Step 4: Write the file using the Write tool**

Use the Write tool with the full content from Step 3.

- [ ] **Step 5: Verify byte-equivalence of the body**

```bash
tail -n +6 "/home/ubuntu/marc-jovani-powerups/skills/distill-general-conversations/SKILL.md" > /tmp/skill-body.txt
diff /tmp/skill-body.txt "/home/ubuntu/anthropic_text_processor/prompts/Destile Information (General — Conversations & Instructional).txt"
```
Expected: empty output (no differences). If there are differences, the body is not verbatim — fix it before continuing.

- [ ] **Step 6: Commit**

```bash
cd /home/ubuntu/marc-jovani-powerups
git add skills/distill-general-conversations/SKILL.md
git commit -m "Add distill-general-conversations skill (verbatim port)"
```

---

## Task 3: Create `skills/distill-educational-generic/SKILL.md`

**Files:**
- Create: `/home/ubuntu/marc-jovani-powerups/skills/distill-educational-generic/SKILL.md`

- [ ] **Step 1: Create the folder**

Run:
```bash
mkdir -p /home/ubuntu/marc-jovani-powerups/skills/distill-educational-generic
```

- [ ] **Step 2: Read the approved description**

```bash
python3 -c "import json; print(json.load(open('/tmp/mj-powerups-descriptions.json'))['distill-educational-generic'])"
```

- [ ] **Step 3: Compose the SKILL.md content**

1. Frontmatter:
   ```
   ---
   name: distill-educational-generic
   description: <description from Step 2>
   ---
   ```
2. Blank line.
3. **EXACT, BYTE-FOR-BYTE verbatim body** of `Destile Information (Includes Context & Examples).txt`.

- [ ] **Step 4: Write the file using the Write tool**

- [ ] **Step 5: Verify byte-equivalence of the body**

```bash
tail -n +6 "/home/ubuntu/marc-jovani-powerups/skills/distill-educational-generic/SKILL.md" > /tmp/skill-body.txt
diff /tmp/skill-body.txt "/home/ubuntu/anthropic_text_processor/prompts/Destile Information (Includes Context & Examples).txt"
```
Expected: empty output.

- [ ] **Step 6: Commit**

```bash
cd /home/ubuntu/marc-jovani-powerups
git add skills/distill-educational-generic/SKILL.md
git commit -m "Add distill-educational-generic skill (verbatim port)"
```

---

## Task 4: Create `skills/distill-educational-audio-composition/SKILL.md`

**Files:**
- Create: `/home/ubuntu/marc-jovani-powerups/skills/distill-educational-audio-composition/SKILL.md`

- [ ] **Step 1: Create the folder**

```bash
mkdir -p /home/ubuntu/marc-jovani-powerups/skills/distill-educational-audio-composition
```

- [ ] **Step 2: Read the approved description**

```bash
python3 -c "import json; print(json.load(open('/tmp/mj-powerups-descriptions.json'))['distill-educational-audio-composition'])"
```

- [ ] **Step 3: Compose the SKILL.md content**

1. Frontmatter:
   ```
   ---
   name: distill-educational-audio-composition
   description: <description from Step 2>
   ---
   ```
2. Blank line.
3. **EXACT, BYTE-FOR-BYTE verbatim body** of `Destile Information FOR AUDIO & COMPOSITION CONTENT (Includes Context & Examples).txt`.

- [ ] **Step 4: Write the file using the Write tool**

- [ ] **Step 5: Verify byte-equivalence of the body**

```bash
tail -n +6 "/home/ubuntu/marc-jovani-powerups/skills/distill-educational-audio-composition/SKILL.md" > /tmp/skill-body.txt
diff /tmp/skill-body.txt "/home/ubuntu/anthropic_text_processor/prompts/Destile Information FOR AUDIO & COMPOSITION CONTENT (Includes Context & Examples).txt"
```
Expected: empty output.

- [ ] **Step 6: Commit**

```bash
cd /home/ubuntu/marc-jovani-powerups
git add skills/distill-educational-audio-composition/SKILL.md
git commit -m "Add distill-educational-audio-composition skill (verbatim port)"
```

---

## Task 5: Write `install.sh`

**Files:**
- Create: `/home/ubuntu/marc-jovani-powerups/install.sh`

`install.sh` symlinks every folder under `skills/` into `~/.claude/skills/`. Idempotent: existing correct symlinks are left alone; broken symlinks are repaired; non-symlink files at target paths cause an error and abort (so we never overwrite real files).

- [ ] **Step 1: Write `install.sh`**

```bash
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
    # Existing symlink: check if it points where we want.
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
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x /home/ubuntu/marc-jovani-powerups/install.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n /home/ubuntu/marc-jovani-powerups/install.sh
```
Expected: no output, exit 0.

- [ ] **Step 4: Run it (this also serves as the integration test)**

```bash
cd /home/ubuntu/marc-jovani-powerups
./install.sh
```
Expected output: three `LINK   ...` lines (one per skill) and `Done. Skills installed at /home/ubuntu/.claude/skills.`

- [ ] **Step 5: Verify symlinks exist and resolve correctly**

```bash
for s in distill-general-conversations distill-educational-generic distill-educational-audio-composition; do
  test -L ~/.claude/skills/$s && readlink ~/.claude/skills/$s
done
```
Expected: three lines, each pointing into `/home/ubuntu/marc-jovani-powerups/skills/<name>`.

- [ ] **Step 6: Re-run install.sh to verify idempotency**

```bash
cd /home/ubuntu/marc-jovani-powerups
./install.sh
```
Expected: three `OK     ...` lines and `Done.` No errors.

- [ ] **Step 7: Commit**

```bash
git add install.sh
git commit -m "Add install.sh: idempotent symlink installer for skills"
```

---

## Task 6: Write `update.sh`

**Files:**
- Create: `/home/ubuntu/marc-jovani-powerups/update.sh`

`update.sh "<message>"` stages all changes, commits with the supplied message (or a sensible default), and pushes to origin. If there's nothing to commit, it skips the commit and still attempts a push (in case there are unpushed local commits from previous runs).

- [ ] **Step 1: Write `update.sh`**

```bash
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
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x /home/ubuntu/marc-jovani-powerups/update.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n /home/ubuntu/marc-jovani-powerups/update.sh
```
Expected: no output, exit 0.

- [ ] **Step 4: Test the "no changes" path**

```bash
cd /home/ubuntu/marc-jovani-powerups
./update.sh "test no-op" 2>&1 | tee /tmp/update-test.log
```
Expected: `No changes to commit.` and `WARNING: no 'origin' remote configured — skipping push.` (origin isn't added until Task 9). Exit code 0.

- [ ] **Step 5: Commit**

```bash
git add update.sh
git commit -m "Add update.sh: one-line commit-and-push helper"
```

---

## Task 7: Write `pull.sh`

**Files:**
- Create: `/home/ubuntu/marc-jovani-powerups/pull.sh`

`pull.sh` runs `git pull --ff-only` on the repo. Used on remote servers to receive updates pushed from the primary dev server.

- [ ] **Step 1: Write `pull.sh`**

```bash
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
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x /home/ubuntu/marc-jovani-powerups/pull.sh
```

- [ ] **Step 3: Syntax check**

```bash
bash -n /home/ubuntu/marc-jovani-powerups/pull.sh
```
Expected: no output, exit 0.

- [ ] **Step 4: Test "no remote" error path**

```bash
cd /home/ubuntu/marc-jovani-powerups
./pull.sh; echo "Exit: $?"
```
Expected: error message about missing `origin` remote, exit code 1. (After Task 9 adds the remote, this script will work for real.)

- [ ] **Step 5: Commit**

```bash
git add pull.sh
git commit -m "Add pull.sh: fast-forward updater for remote servers"
```

---

## Task 8: Write `DOCUMENTATION.md`

**Files:**
- Create: `/home/ubuntu/marc-jovani-powerups/DOCUMENTATION.md`

Per the spec, `DOCUMENTATION.md` is the single user-facing doc. It must let a cold Claude session add a new skill with one approval beat (the description). The first section is locked per Marc's convention.

- [ ] **Step 1: Write the full file**

Use the Write tool to create `/home/ubuntu/marc-jovani-powerups/DOCUMENTATION.md` with the following content:

````markdown
# marc-jovani-powerups — Documentation

## ⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE

**📌 NOTE: This section must NOT be changed unless actual file structure modifications occur. Do NOT omit when updating documentation. Update ONLY if real changes are made to the codebase structure.**

### Repository tree

```
marc-jovani-powerups/
├── DOCUMENTATION.md            ← this file (the single user-facing doc)
├── install.sh                  ← one-time setup on a new server: symlinks skills into ~/.claude/skills/
├── update.sh                   ← from primary dev server: git add -A + commit + push
├── pull.sh                     ← from any other server: git pull --ff-only
├── docs/
│   ├── specs/                  ← design specs (workflow artifacts)
│   └── plans/                  ← implementation plans (workflow artifacts)
└── skills/                     ← every Claude Code skill in this collection
    ├── distill-general-conversations/SKILL.md
    ├── distill-educational-generic/SKILL.md
    └── distill-educational-audio-composition/SKILL.md
```

### How Claude Code loads skills

Claude Code reads personal skills from `~/.claude/skills/<skill-name>/SKILL.md`. In this project, those paths are **symlinks** into `/home/ubuntu/marc-jovani-powerups/skills/<skill-name>/`. There is only one file on disk per skill — the symlink is just a second path pointing to the same file. Editing either path edits the same file. Claude Code picks up changes on next skill load (no restart needed in most cases; a fresh session always works).

### Skill vs Plugin

A **skill** is a single capability: a folder containing one `SKILL.md` (YAML frontmatter + a markdown body that's the prompt itself). A **plugin** is a bundle: a manifest (`plugin.json`) plus skills, slash commands, agents, hooks, and/or MCP server configs. This project currently ships standalone skills (Option A). It is structured so it can be wrapped into a plugin later (Option B) by adding a `.claude-plugin/plugin.json` — no file moves needed.

### The verbatim-port rule (non-negotiable)

When porting a Marc Jovani prompt into a SKILL.md, the body is **100% verbatim**. No rewriting, no summarization, no cleanup, no tightening, no fixing typos, no translating. The body of `SKILL.md` equals the body of the source prompt, byte-for-byte. The only thing Claude authors is the YAML frontmatter (`name` and `description`).

---

## Project purpose

`marc-jovani-powerups` is Marc Jovani's personal collection of prompts converted into Claude Code skills, distributable across multiple servers via a single GitHub repository. Edit a skill in one place; every server `git pull`s and is up to date.

The collection will grow over time from a prompt library into broader workflows and ways-of-working. The current iteration ships three "Distill" skills (verbatim ports of Marc's "Destile Information" prompts).

**Evolution path:** standalone skills (now) → more skills + workflow patterns → eventually wrap as a Claude Code plugin for `/plugin install`-style distribution.

---

## How to install on a new server

```bash
git clone git@github.com:surfvani/marc-jovani-powerups.git ~/marc-jovani-powerups
cd ~/marc-jovani-powerups
./install.sh
```

`install.sh` iterates `skills/*` and creates a symlink in `~/.claude/skills/` for each. It is idempotent — safe to re-run any time. It will refuse to overwrite a non-symlink file at a target path (so it can't clobber an existing local skill of the same name).

To receive future updates: `cd ~/marc-jovani-powerups && ./pull.sh` (or set up a cron — see CEO Update Workflow below).

---

## CEO Update Workflow

The whole point: edit ONE place, have it apply everywhere — without manual copy steps.

### The mechanic

`~/.claude/skills/<skill-name>` on each server is a **symlink** to `~/marc-jovani-powerups/skills/<skill-name>`. One file on disk, two paths. Edit either path → both paths see the change → Claude Code picks it up on next load.

### Daily workflow

| Action | Command | Where |
|---|---|---|
| One-time setup | `./install.sh` | any new server |
| Edit a skill | edit `skills/<name>/SKILL.md` (or `~/.claude/skills/<name>/SKILL.md` — same file) | primary dev server |
| Publish the edit | `./update.sh "your message"` | primary dev server |
| Receive updates | `./pull.sh` | each remote server |

### Optional cron for remote servers

```cron
# every hour at minute 7
7 * * * * cd $HOME/marc-jovani-powerups && ./pull.sh >/dev/null 2>&1
```

This makes remote servers self-sync. Skip if you prefer manual control.

---

## Skill catalog

### `distill-general-conversations`

- **Source file:** `Destile Information (General — Conversations & Instructional).txt`
- **Trigger description:** see frontmatter `description:` field in `skills/distill-general-conversations/SKILL.md` (this is the canonical source — Claude reads it to decide when to auto-trigger)
- **Last updated:** 2026-04-29 (created)

### `distill-educational-generic`

- **Source file:** `Destile Information (Includes Context & Examples).txt`
- **Trigger description:** see frontmatter `description:` field in `skills/distill-educational-generic/SKILL.md`
- **Last updated:** 2026-04-29 (created)

### `distill-educational-audio-composition`

- **Source file:** `Destile Information FOR AUDIO & COMPOSITION CONTENT (Includes Context & Examples).txt`
- **Trigger description:** see frontmatter `description:` field in `skills/distill-educational-audio-composition/SKILL.md`
- **Last updated:** 2026-04-29 (created)

---

## Adding a new skill (Cold-Agent Procedure)

This procedure is written so a brand-new Claude session, reading only this file, can add a new skill end-to-end with **one approval beat from Marc** (the description).

### Inputs you need from Marc

- A source prompt — either a path to a `.txt` file, or pasted prompt text in chat
- (Optional) a hint about the slug; if Marc doesn't supply one, propose one and confirm

### Slug naming rules

- Lowercase, hyphens only, no spaces, no parens, no em-dashes, no accents
- Descriptive (`distill-general-conversations`, not `dgc`)
- Group related skills with a shared prefix when it makes sense (`distill-*`)
- Once published, a slug is stable — renaming breaks references. Pick well.

### The 7-step procedure

1. **Pick the slug.** Propose one to Marc; get a yes/no.
2. **Create the folder:** `mkdir -p skills/<slug>`.
3. **Draft the description.** 1–2 sentences answering "When should Claude auto-trigger this?" Read the source prompt to ground the description in what it actually does.
4. **Present the description to Marc for approval. THIS IS THE ONLY APPROVAL BEAT — wait for "yes" before writing the file.**
5. **Write `skills/<slug>/SKILL.md`** with this exact structure:
   ```markdown
   ---
   name: <slug>
   description: <approved description>
   ---

   <EXACT VERBATIM BODY OF THE SOURCE PROMPT — BYTE FOR BYTE>
   ```
   **The body is 100% verbatim. No edits of any kind. No "small fixes". No translation. No cleanup. No exceptions.** If Marc wants edits, he edits the source separately, not during the port.
6. **Run `./install.sh`** — this auto-creates the symlink for the new skill. (Existing skills are unaffected; idempotent.)
7. **Run `./update.sh "added <slug> skill"`** — commits and pushes.

### Worked example

Marc says: "Here's a new prompt — `/path/to/My New Prompt.txt`. Add it as a skill."

```bash
# Step 1: Propose slug → Marc approves "my-new-skill"

# Step 2: Folder
mkdir -p /home/ubuntu/marc-jovani-powerups/skills/my-new-skill

# Step 3-4: Draft description, get approval
#   Description (drafted by Claude after reading the source):
#     "Use when ... <1-2 sentences>"
#   Marc: "approved"

# Step 5: Write SKILL.md
#   File contents:
#     ---
#     name: my-new-skill
#     description: Use when ... <approved text>
#     ---
#
#     <verbatim body of "/path/to/My New Prompt.txt">

# Step 6: Install (creates the symlink)
cd /home/ubuntu/marc-jovani-powerups
./install.sh

# Step 7: Publish
./update.sh "added my-new-skill skill"
```

### Handling source prompts that are NOT in `.txt` files

If Marc pastes the prompt body directly into chat (no file), the procedure is identical except step 5 uses the pasted text as the verbatim body. Save the original pasted text in your working context exactly as Marc gave it; do not "clean it up" before writing the SKILL.md. If desired, save a copy of the original to `docs/source-prompts/<slug>.txt` for traceability — but this is optional, not required.

### After adding a new skill — update this file

Add a new subsection to the "Skill catalog" with: source file (or "pasted in chat <date>"), trigger description (or "see frontmatter"), when to use, last updated date.

---

## Decisions & rationale

- **Verbatim-port rule.** Marc's prompts work for him as-is. Any "improvement" risks losing nuance Marc put there on purpose. Skills get their voice from Marc; Claude only authors the frontmatter.
- **Single `DOCUMENTATION.md`.** Cleaner than juggling README + CHANGELOG + EVOLUTION. One file, comprehensive, designed for cold-start.
- **Symlinks over copies.** A copy-based workflow requires "deploy" steps and risks drift between repo and live skill. Symlinks make the repo file the single source of truth.
- **Standalone skills, not a plugin (yet).** Option A from the original conversation. Plugin manifest can be added later without moving any files.
- **Private GitHub repo by default.** Safer; flip to public anytime. No reason to publish until the collection is proven.
- **`docs/specs/` and `docs/plans/` are committed.** They are workflow artifacts, not user-facing — but they're tracked for traceability so future agents can read the design history.

---

## Where we left off / next steps

**As of 2026-04-29 (initial build):**
- Three skills created: `distill-general-conversations`, `distill-educational-generic`, `distill-educational-audio-composition`.
- `install.sh`, `update.sh`, `pull.sh` written and tested.
- Repo pushed to `github.com/surfvani/marc-jovani-powerups` (private).
- Symlinks active on this server (`/home/ubuntu`, the primary dev server).

**Next, when Marc resumes:**
- Add more skills from his existing prompt library (he has many; these three were chosen as a starting batch).
- Start sketching what "workflows and ways-of-working" looks like — likely a new top-level concept (e.g., `workflows/`) that may be skills, slash commands, or hooks.
- When the collection is stable, evaluate wrapping it as a plugin (`plugin.json` + `marketplace.json`) for `/plugin install`-style distribution to other servers.
````

- [ ] **Step 2: Verify the file was written**

Read it back and confirm the "Adding a new skill (Cold-Agent Procedure)" section is present with the worked example and the 7-step procedure.

- [ ] **Step 3: Commit**

```bash
cd /home/ubuntu/marc-jovani-powerups
git add DOCUMENTATION.md
git commit -m "Add DOCUMENTATION.md with cold-agent procedure for new skills"
```

---

## Task 9: Create the GitHub repo and push

**Files:** none (network operation)

- [ ] **Step 1: Verify `gh` CLI is available and authenticated**

```bash
gh auth status
```
Expected: shows `surfvani` (or whatever account is logged in) as authenticated. If not authenticated, ask Marc to run `gh auth login` interactively (instruct him to type `! gh auth login` in the prompt).

- [ ] **Step 2: Create the private repo on GitHub**

```bash
cd /home/ubuntu/marc-jovani-powerups
gh repo create surfvani/marc-jovani-powerups --private --source=. --remote=origin --description "Marc Jovani's personal Claude Code skill collection"
```
Expected: repo created, `origin` remote added pointing at `git@github.com:surfvani/marc-jovani-powerups.git` (or HTTPS form).

- [ ] **Step 3: Push the existing branch**

```bash
git push -u origin HEAD
```
Expected: all commits pushed.

- [ ] **Step 4: Verify**

```bash
gh repo view surfvani/marc-jovani-powerups --json visibility,defaultBranchRef
```
Expected: `"visibility":"PRIVATE"`, default branch matches what was pushed.

---

## Task 10: Final verification — Claude Code sees the skills

**Files:** none

- [ ] **Step 1: List installed personal skills**

```bash
ls -la ~/.claude/skills/ | grep distill
```
Expected: three symlinks pointing into `/home/ubuntu/marc-jovani-powerups/skills/...`.

- [ ] **Step 2: Validate frontmatter parses**

```bash
for s in distill-general-conversations distill-educational-generic distill-educational-audio-composition; do
  head -5 ~/.claude/skills/$s/SKILL.md
  echo "---"
done
```
Expected: each shows a valid YAML frontmatter with `name:` matching the slug and a non-empty `description:`.

- [ ] **Step 3: Cold-agent thought experiment (acceptance test from spec section 11)**

Without running anything, confirm by reading `DOCUMENTATION.md`:
- A fresh agent could explain the project's purpose in one sentence ✓
- Locate the three skills and their roles ✓
- Add a new skill given a prompt — only one approval beat (description) ✓
- Run `./install.sh` and `./update.sh` correctly ✓
- Know NOT to modify a verbatim body ✓
- Convert a slug to a folder path ✓

If any answer is "no," fix `DOCUMENTATION.md` before declaring done.

- [ ] **Step 4: Final commit (if anything was tweaked) and push**

```bash
cd /home/ubuntu/marc-jovani-powerups
./update.sh "final tweaks after verification"
```

- [ ] **Step 5: Report to Marc**

Summarize: repo URL, three skills installed, scripts working, where to add new skills (point at the procedure section in DOCUMENTATION.md).
