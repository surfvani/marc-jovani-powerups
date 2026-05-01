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
    ├── distill-educational-audio-composition/SKILL.md
    ├── doc-new-project/SKILL.md
    ├── doc-update-project/SKILL.md
    ├── plan-build/SKILL.md
    ├── research-prompt-instructions/SKILL.md
    └── hook-creator/                       ← Schwartz-style 6-pass hook extractor (alpha v0)
        ├── SKILL.md
        ├── .gitignore                      ← excludes runs/
        ├── references/
        │   ├── 01-existing-solutions-research.md
        │   ├── 02-frameworks-and-cognitive-science-research.md
        │   ├── 03-hidden-hook-extraction-research.md
        │   └── avatar-cinematic-composing.md   ← symlink to live avatar (per-server)
        └── runs/                            ← gitignored: per-run outputs land here
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

### `doc-new-project`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-docnew.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/doc-new-project/SKILL.md`
- **Purpose:** Marc's instructions for creating a new `DOCUMENTATION.md` from scratch for a new project, app, or build. Produces a comprehensive Markdown doc starting with the locked `⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE` first section, with detailed file structure (paying special attention to modularized clusters so future AIs don't get confused by old monolithic files), and enough context for a future AI session to ask informed follow-up questions.
- **Last updated:** 2026-04-29 (created)

### `doc-update-project`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-doccode.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/doc-update-project/SKILL.md`
- **Purpose:** Marc's instructions for updating an existing `DOCUMENTATION.md` after a coding session, implementation, bugfix, or upgrade. Preserves all critical info (carefully-discovered solutions, roadblocks overcome), adds new learnings, removes only fully-obsolete content, targets ~1% shorter while remaining comprehensive. Includes a clear next-steps plan so a fresh AI session can resume cold without context loss.
- **Last updated:** 2026-04-29 (created)

### `plan-build`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-plania.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/plan-build/SKILL.md`
- **Purpose:** Marc's planning-agent workflow. Triggered when starting a new build/feature/app/refactor. Discusses concept with Marc, generates deep-research prompts, then produces a build plan document containing all downstream instructions (TODO list spec, 🔬 research checkpoints, Cross-Session Continuity Protocol, Session Log, Documentation Protocol with `DOCUMENTATION.md` maintenance, Deep Research 10x Multiplier Rule). Designed so the next agent can execute with just `"read this doc, start"` — no execution-phase or doc-phase skill needed.
- **Last updated:** 2026-04-29 (created)

### `research-prompt-instructions`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-resss.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/research-prompt-instructions/SKILL.md`
- **Purpose:** Loads the instruction set for writing a high-quality deep-research prompt (paradigm-shifting framing, no-abandoned-tech filter, parallel-prompt splitting, mandatory contextualization checklist, post-result validation questions). Invoked by user during a `plan-build` session when it's time to draft research prompts. Replaces the former `resss` TextExpander snippet — `plan-build` references this skill explicitly (see edit applied to `-plania.txt` line 63).
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

### The 8-step procedure

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

   To preserve bytes exactly, write the file via Bash + `cat` rather than the Write tool:
   ```bash
   {
     echo "---"
     echo "name: <slug>"
     echo "description: <approved description>"
     echo "---"
     echo ""
     cat "<path to source .txt>"
   } > /home/ubuntu/marc-jovani-powerups/skills/<slug>/SKILL.md
   ```
   Then verify byte-equivalence:
   ```bash
   tail -n +6 skills/<slug>/SKILL.md > /tmp/skill-body.txt
   diff /tmp/skill-body.txt "<path to source .txt>"
   ```
   The diff must be empty.
6. **Run `./install.sh`** — auto-creates the symlink (idempotent).
7. **Add a Skill-catalog entry** to this `DOCUMENTATION.md` under "Skill catalog": new `### \`<slug>\`` subsection with source file path, trigger description (or "see frontmatter"), one-line Purpose, last updated date. **Do not skip — the catalog is the cold-agent's index.**
8. **Run `./update.sh "added <slug> skill"`** — commits and pushes (includes the catalog edit).

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

# Step 5: Write SKILL.md (use cat to preserve bytes)
{
  echo "---"
  echo "name: my-new-skill"
  echo "description: Use when ... <approved text>"
  echo "---"
  echo ""
  cat "/path/to/My New Prompt.txt"
} > /home/ubuntu/marc-jovani-powerups/skills/my-new-skill/SKILL.md

# Step 5b: Verify verbatim
tail -n +6 /home/ubuntu/marc-jovani-powerups/skills/my-new-skill/SKILL.md > /tmp/skill-body.txt
diff /tmp/skill-body.txt "/path/to/My New Prompt.txt"
# (must print nothing)

# Step 6: Install (creates the symlink)
cd /home/ubuntu/marc-jovani-powerups
./install.sh

# Step 7: Edit DOCUMENTATION.md — add a "### `my-new-skill`" entry under "Skill catalog"

# Step 8: Publish (commits both SKILL.md AND the catalog edit, pushes)
./update.sh "added my-new-skill skill"
```

### Handling source prompts that are NOT in `.txt` files

If Marc pastes the prompt body directly into chat (no file), the procedure is identical except step 5 uses the pasted text as the verbatim body. Save the original pasted text to a temp file first, then use `cat` on it as in the worked example. Do not "clean it up" before writing the SKILL.md. For step 7, write `pasted in chat <YYYY-MM-DD>` in place of the source file path.

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

**As of 2026-04-29 (later — workflow skills added):**
- Two workflow skills added: `plan-build` (verbatim port of `-plania.txt`) and `research-prompt-instructions` (verbatim port of `-resss.txt`). Together they encode Marc's full build-philosophy: planning agent creates a build plan document that contains all downstream executor + documenter instructions; `research-prompt-instructions` is invoked when the planner needs to draft deep-research prompts for satellite agents.
- Source edit applied to `/home/ubuntu/anthropic_text_processor/prompts/-plania.txt` line 63: replaced the "resss snippet" reference with the `research-prompt-instructions` skill reference. Per the verbatim-port rule, the source was edited first, then ported.
- **Note:** `doc-new-project` and `doc-update-project` skills exist on disk and are now reflected in the repo tree, but do NOT yet have catalog entries in this file. Add when Marc gets to them.

**Next, when Marc resumes:**
- Add catalog entries for `doc-new-project` and `doc-update-project`.
- Add more skills from his existing prompt library.
- When the collection is stable, evaluate wrapping it as a plugin (`plugin.json` + `marketplace.json`) for `/plugin install`-style distribution to other servers.
