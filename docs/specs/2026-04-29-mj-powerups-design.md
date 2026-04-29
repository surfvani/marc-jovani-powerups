# Design Spec — `marc-jovani-powerups`

**Date:** 2026-04-29
**Author:** Marc Jovani (with Claude)
**Status:** Approved — ready for implementation

---

## 1. Purpose

Build a personal collection of Marc Jovani's prompts, converted into Claude Code **skills**, distributable across multiple servers via a single GitHub repository. Designed to grow over time from a prompt library into broader workflows and ways-of-working.

The first batch converts three "Destile Information" prompts into skills.

## 2. Goals

- Each prompt becomes one skill, distributable and version-controlled.
- The repo can be cloned to any server and its skills made available to Claude Code with minimal effort.
- A single `DOCUMENTATION.md` provides enough context for any future AI session (cold-start) to continue the work without re-deriving decisions.
- Structure is forward-compatible: when this collection is later wrapped into a Claude Code plugin, no files need to move.

## 3. Non-goals (this iteration)

- No CHANGELOG, no README, no separate EVOLUTION doc — only `DOCUMENTATION.md`.
- No conversion of prompts beyond YAML frontmatter. Bodies are 100% verbatim.
- No plugin manifest (`plugin.json`) yet. We stay on standalone skills (Option A from the conversation).
- No copies of the original `.txt` files inside the repo. The SKILL.md body IS the canonical source going forward.

## 4. Repository

- **Local path:** `/home/ubuntu/marc-jovani-powerups/`
- **GitHub:** `github.com/surfvani/marc-jovani-powerups`
- **Visibility:** Private (default — can be flipped to public later)

## 5. File Structure

```
marc-jovani-powerups/
├── DOCUMENTATION.md
├── install.sh                ← one-time setup on a new server (clones + symlinks)
├── update.sh                 ← from this server: git add/commit/push
├── pull.sh                   ← from any other server: git pull (refresh skills)
├── docs/
│   └── specs/
│       └── 2026-04-29-mj-powerups-design.md   ← this file (workflow artifact)
└── skills/
    ├── distill-general-conversations/
    │   └── SKILL.md
    ├── distill-educational-generic/
    │   └── SKILL.md
    └── distill-educational-audio-composition/
        └── SKILL.md
```

The `docs/specs/` directory holds workflow artifacts (design specs, plans). It is not part of the user-facing project structure but is committed for traceability.

## 6. Skill Format

Every `SKILL.md` follows this exact template:

```markdown
---
name: <slug>
description: <when Claude should auto-trigger this skill — 1-2 sentences>
---

<EXACT verbatim body of the original .txt prompt — zero modifications>
```

### Frontmatter rules

- `name`: must match the parent folder name (lowercase, hyphens, URL-safe)
- `description`: drafted by Claude based on reading the prompt; **approved by Marc before writing the file**

### Body rule

**100% verbatim port.** No rewriting, no summarization, no cleanup, no tightening, no fixing typos, no translating. The body of the SKILL.md equals the body of the source `.txt` file, byte-for-byte (modulo trailing newline normalization).

## 7. Source-to-Skill Mapping

| Source file | Skill slug | Skill folder |
|---|---|---|
| `Destile Information (General — Conversations & Instructional).txt` | `distill-general-conversations` | `skills/distill-general-conversations/` |
| `Destile Information (Includes Context & Examples).txt` | `distill-educational-generic` | `skills/distill-educational-generic/` |
| `Destile Information FOR AUDIO & COMPOSITION CONTENT (Includes Context & Examples).txt` | `distill-educational-audio-composition` | `skills/distill-educational-audio-composition/` |

All three source files live at `/home/ubuntu/anthropic_text_processor/prompts/`.

## 8. DOCUMENTATION.md — Required Structure

`DOCUMENTATION.md` must follow Marc's standard documentation template. The first section is locked per Marc's convention:

1. **⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE** (locked first section)
   - Tree of the repo
   - Description of each file/folder
   - How Claude Code loads skills (`~/.claude/skills/<name>/SKILL.md`)
   - Difference between a skill and a plugin
   - The verbatim-port rule
2. **Project purpose** — what this collection is and the evolution path (skills → workflows → plugin)
3. **How to install on a new server** — git clone + `./install.sh`, with a brief explanation of what the script does (symlinks)
4. **CEO update workflow** — the symlink mechanic + the three scripts (`install.sh`, `update.sh`, `pull.sh`) and the table from section 9 of the spec
5. **Skill catalog** — one subsection per skill: source file, trigger description, when to use, last updated date
6. **Adding a new skill (Cold-Agent Procedure)** — written so a brand-new Claude session, reading only DOCUMENTATION.md, can add a new skill end-to-end with one approval beat from Marc. MUST include:
   - The 7-step procedure (slug → folder → SKILL.md template → frontmatter rules → verbatim-port rule → `./install.sh` → `./update.sh`)
   - A complete worked example showing actual file contents
   - Slug naming rules (lowercase, hyphens, descriptive, prefix-grouped where it makes sense)
   - The verbatim-port rule in **bold** (impossible to miss)
   - The "draft description, ask Marc to approve, THEN write the file" rule
   - Handling for source prompts that aren't `.txt` files (e.g., Marc pastes prompt body directly into chat)
7. **Decisions & rationale** — verbatim-port rule, naming convention, single-doc choice, private repo default, etc.
8. **Where we left off / next steps** — running narrative for cold-start continuation

The doc is written in Markdown, comprehensive but not so schematic that context is lost. It must give a future AI enough context to start working and ask informed follow-up questions.

## 9. CEO-Frictionless Update Workflow

The whole point of this section: edit a skill in ONE place, have it apply everywhere — without manual copy steps.

### The mechanic: symlinks

`~/.claude/skills/<skill-name>` on each server is a **symlink** into the cloned repo at `~/marc-jovani-powerups/skills/<skill-name>`. Because of the symlink, there is only one file on disk. Editing either path edits the same file. Claude Code reads the live file on next skill load — no copy step ever.

### One-time setup on a new server: `install.sh`

```bash
git clone git@github.com:surfvani/marc-jovani-powerups.git ~/marc-jovani-powerups
cd ~/marc-jovani-powerups
./install.sh
```

`install.sh` iterates `skills/*` and creates a symlink in `~/.claude/skills/` for each. Idempotent (safe to re-run; existing symlinks are left alone, broken ones are repaired).

### To edit and publish (from primary dev server): `update.sh`

```bash
# 1. Edit any SKILL.md (via either the repo path or the ~/.claude/skills/<name>/SKILL.md symlink — same file)
# 2. Stage, commit, push:
cd ~/marc-jovani-powerups
./update.sh "tightened distill-general intro"
```

`update.sh` runs `git add -A`, commits with the supplied message (or a default if none given), and pushes to `origin`.

### To receive updates on another server: `pull.sh`

```bash
cd ~/marc-jovani-powerups
./pull.sh
```

`pull.sh` runs `git pull --ff-only`. Because skills are symlinked, the pull updates the live skills instantly. No restart required.

Optionally cron `pull.sh` on remote servers (e.g., hourly) so they self-sync without intervention.

### Summary table

| Action | Command | Where |
|---|---|---|
| One-time setup | `./install.sh` | any new server |
| Edit + publish | `./update.sh "<msg>"` | primary dev server |
| Receive updates | `./pull.sh` (or cron) | each remote server |

## 10. Implementation Sequence

1. Create `/home/ubuntu/marc-jovani-powerups/` and `git init` — DONE.
2. Write this spec to `docs/specs/2026-04-29-mj-powerups-design.md` and commit — DONE.
3. Read each of the 3 source `.txt` files in full.
4. Draft a `description` field for each skill — present all 3 to Marc for approval in a single message.
5. After approval, write the 3 `SKILL.md` files (frontmatter + verbatim body).
6. Write `install.sh`, `update.sh`, `pull.sh` (Bash, set -euo pipefail, idempotent where applicable, all chmod +x).
7. Write `DOCUMENTATION.md` per section 8 (now including the workflow section from section 9).
8. Commit everything.
9. Create private GitHub repo `surfvani/marc-jovani-powerups`, push.
10. Run `./install.sh` on this server to symlink the 3 skills into `~/.claude/skills/`.
11. Verify Claude Code picks up the skills (restart session if needed).

## 11. Cold-Agent Test (acceptance criteria for DOCUMENTATION.md)

After DOCUMENTATION.md is written, validate it by imagining a cold Claude session that reads only that file. The session must be able to:

- Explain the project's purpose in one sentence
- Locate the three existing skills and their roles
- Add a new skill (provided a source prompt) without asking architectural questions — only one question, the description-approval beat
- Run `./install.sh` and `./update.sh` correctly
- Know NOT to modify the verbatim body of an existing SKILL.md
- Know how to convert a slug to a folder path and where it lives

If any of these fail in a thought experiment, the doc is not done.

## 12. Risks / Open Questions

- **Description quality.** The auto-trigger behavior depends on the `description` field. If descriptions are too vague, Claude won't load the skill when it should. If too specific, Claude won't load it when context shifts. Mitigation: Marc approves each description before writing.
- **Verbatim port may include outdated boilerplate.** Some prompts may start with "You are an expert assistant…" which is redundant inside a skill. Per Marc's explicit instruction, this stays as-is. Acceptable risk.
- **Slug stability.** Once published and used, renaming a skill folder breaks any saved references. The three slugs in section 7 are final.
- **Future plugin wrap.** When this becomes a plugin, slugs gain a namespace prefix (`/marc-jovani-powerups:distill-general-conversations`). Document this in `DOCUMENTATION.md` so it isn't a surprise later.

## 13. Approval

Marc approved this design verbally during the brainstorm session on 2026-04-29 ("PROCEED").
