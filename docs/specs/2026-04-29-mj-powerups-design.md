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

- No `install.sh` automation. Symlinks are manual for now.
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
3. **How to install on a new server** — git clone + symlink steps, including `~/.claude/skills/` target
4. **Skill catalog** — one subsection per skill: source file, trigger description, when to use, last updated date
5. **Adding a new skill** — step-by-step procedure so future-Marc (or future-Claude) can extend cleanly
6. **Decisions & rationale** — verbatim-port rule, naming convention, single-doc choice, private repo default, etc.
7. **Where we left off / next steps** — running narrative for cold-start continuation

The doc is written in Markdown, comprehensive but not so schematic that context is lost. It must give a future AI enough context to start working and ask informed follow-up questions.

## 9. Distribution / Install Procedure (manual, for now)

On each server where these skills should be available:

```bash
git clone git@github.com:surfvani/marc-jovani-powerups.git ~/marc-jovani-powerups
cd ~/marc-jovani-powerups
ln -s "$PWD/skills/distill-general-conversations" ~/.claude/skills/distill-general-conversations
ln -s "$PWD/skills/distill-educational-generic" ~/.claude/skills/distill-educational-generic
ln -s "$PWD/skills/distill-educational-audio-composition" ~/.claude/skills/distill-educational-audio-composition
```

Symlinks (rather than copies) so a `git pull` updates all servers automatically.

## 10. Implementation Sequence

1. Create `/home/ubuntu/marc-jovani-powerups/` and `git init` (DONE as of this spec).
2. Write this spec to `docs/specs/2026-04-29-mj-powerups-design.md` and commit (in progress).
3. Read each of the 3 source `.txt` files in full.
4. Draft a `description` field for each skill — present all 3 to Marc for approval in a single message.
5. After approval, write the 3 `SKILL.md` files (frontmatter + verbatim body).
6. Write `DOCUMENTATION.md` per section 8.
7. Commit everything.
8. Create private GitHub repo `surfvani/marc-jovani-powerups`, push.
9. Symlink the 3 skills into `~/.claude/skills/` on this server.
10. Verify Claude Code picks up the skills (restart session if needed).

## 11. Risks / Open Questions

- **Description quality.** The auto-trigger behavior depends on the `description` field. If descriptions are too vague, Claude won't load the skill when it should. If too specific, Claude won't load it when context shifts. Mitigation: Marc approves each description before writing.
- **Verbatim port may include outdated boilerplate.** Some prompts may start with "You are an expert assistant…" which is redundant inside a skill. Per Marc's explicit instruction, this stays as-is. Acceptable risk.
- **Slug stability.** Once published and used, renaming a skill folder breaks any saved references. The three slugs in section 7 are final.
- **Future plugin wrap.** When this becomes a plugin, slugs gain a namespace prefix (`/marc-jovani-powerups:distill-general-conversations`). Document this in `DOCUMENTATION.md` so it isn't a surprise later.

## 12. Approval

Marc approved this design verbally during the brainstorm session on 2026-04-29 ("PROCEED").
