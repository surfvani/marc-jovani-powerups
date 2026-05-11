# marc-jovani-powerups — Documentation

## ⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE

**📌 NOTE: This section must NOT be changed unless actual file structure modifications occur. Do NOT omit when updating documentation. Update ONLY if real changes are made to the codebase structure.**

### Repository tree

```
marc-jovani-powerups/
├── DOCUMENTATION.md            ← this file (the single user-facing doc)
├── install.sh                  ← one-time setup on a new server: symlinks skill folders into ~/.claude/skills/, symlinks skill-bundled executables into ~/.local/bin/, creates per-skill venvs at ~/.config/<skill>/venv/ when requirements.txt is present
├── update.sh                   ← from primary dev server: git add -A + commit + push
├── pull.sh                     ← from any other server: git pull --ff-only, then auto-runs install.sh so new skills / bundled tools / venvs wire up immediately
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
    ├── sowhatstheplan/SKILL.md
    ├── hook-creator/                       ← Schwartz-style 6-pass hook extractor (alpha v0)
    │   ├── SKILL.md
    │   ├── .gitignore                      ← excludes runs/
    │   ├── references/
    │   │   ├── 01-existing-solutions-research.md
    │   │   ├── 02-frameworks-and-cognitive-science-research.md
    │   │   ├── 03-hidden-hook-extraction-research.md
    │   │   └── avatar-cinematic-composing.md   ← symlink to live avatar (per-server)
    │   └── runs/                            ← gitignored: per-run outputs land here
    ├── scroll-stop-prompter/                ← 3D website asset prompt generator
    │   ├── SKILL.md
    │   └── assets/prompt-page-template.html   ← gorgeous tabbed copy-prompt page
    ├── scroll-stop-builder/                 ← scroll-driven 3D website builder (ffmpeg + canvas)
    │   ├── SKILL.md
    │   ├── assets/                          ← (empty placeholder)
    │   ├── references/sections-guide.md     ← per-section implementation details
    │   └── scripts/                         ← (empty placeholder)
    └── cc-google-ads/                       ← Cinematic Composing Google Ads operator (skill + bundled CLIs)
        ├── SKILL.md
        ├── cc-gads                          ← Python CLI executable for writes (symlinked into ~/.local/bin/ by install.sh)
        ├── cc-gads-ensure-adc               ← Python preflight executable; auto-heals ADC from app_cc/.env (stdlib-only, symlinked into ~/.local/bin/)
        └── requirements.txt                 ← google-ads + click; install.sh creates venv at ~/.config/cc-google-ads/venv/
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
| Receive updates | `./pull.sh` (auto-runs `install.sh`) | each remote server |

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
- **Purpose:** Marc's planning-agent workflow. Triggered when starting a new build/feature/app/refactor. Discusses concept with Marc, generates deep-research prompts, captures the Active State (live spend, deployed systems, anything bleeding per day of inaction), then produces a build plan document containing all downstream instructions (TODO list spec, 🔬 research checkpoints, Cross-Session Continuity Protocol, Session Log, Documentation Protocol with `DOCUMENTATION.md` maintenance, Deep Research 10x Multiplier Rule, Active State Protocol). Designed so the next agent can execute with just `"read this doc, start"` — no execution-phase or doc-phase skill needed.
- **Last updated:** 2026-05-07 (Active State Protocol added: mandatory "what's running in production today, and what's broken or untracked about it?" question in the discussion phase + required Active State section in plan output, so urgency outranks dependency-shape sequencing)

### `research-prompt-instructions`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-resss.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/research-prompt-instructions/SKILL.md`
- **Purpose:** Loads the instruction set for writing a high-quality deep-research prompt (paradigm-shifting framing, no-abandoned-tech filter, parallel-prompt splitting, mandatory contextualization checklist, post-result validation questions). Invoked by user during a `plan-build` session when it's time to draft research prompts. Replaces the former `resss` TextExpander snippet — `plan-build` references this skill explicitly (see edit applied to `-plania.txt` line 63).
- **Last updated:** 2026-04-29 (created)

### `hook-creator`

- **Source:** Google Drive folder "Hook Creator (Schwartz 6-pass)" (downloaded 2026-05-04, alpha v0)
- **Trigger description:** see frontmatter `description:` field in `skills/hook-creator/SKILL.md`
- **Purpose:** Extracts 20 captivating hook-style book/course/module/episode titles from any long-form work (manuscript, transcript, chapter, course module, book draft) by running the Schwartz-style 6-pass extraction discipline (Idea × Avatar × Pattern). The "Tim Ferriss found '4-Hour Workweek' inside his book" / "James Clear found 'Atomic Habits' inside his research" family. Default avatar: Cinematic Composing student (loaded automatically from `references/avatar-cinematic-composing.md` — symlinked to the live avatar per-server).
- **Reusable assets:** `references/01-existing-solutions-research.md`, `02-frameworks-and-cognitive-science-research.md`, `03-hidden-hook-extraction-research.md` — readable on their own as standalone references for hook theory.
- **Last updated:** 2026-05-04 (added)

### `scroll-stop-prompter`

- **Source:** Google Drive folder "3D Website Asset Generator" (downloaded 2026-05-04)
- **Trigger description:** see frontmatter `description:` field in `skills/scroll-stop-prompter/SKILL.md`
- **Purpose:** For a given product/object, generates 3 linked AI prompts — (A) clean assembled product shot on white, (B) exploded/deconstructed view, (C) video transition between the two. Delivers them via a styled HTML page (`prompt-page-template.html`) with tabs, one-click copy buttons, and confetti. Image- and video-model-agnostic (Higgsfield, Midjourney, Runway, Kling, Pika, etc.).
- **Reusable assets:** `assets/prompt-page-template.html` — the tabbed/copy/confetti HTML template can be reused on its own for any 3-prompt set, not just deconstruction. See "Using just a piece" below.
- **Last updated:** 2026-05-04 (added)

### `scroll-stop-builder`

- **Source:** Google Drive folder "scroll-stop-builder-skill" (downloaded 2026-05-04)
- **Trigger description:** see frontmatter `description:` field in `skills/scroll-stop-builder/SKILL.md`
- **Purpose:** Takes a video file (e.g., a product deconstruction animation) and builds a production-quality website where the video plays forward/backward as the user scrolls — Apple-style. Uses ffmpeg to extract 60–150 JPEG frames, draws them to a canvas based on scroll position, and assembles a full site (starscape, loader, transforming navbar, hero, sticky-canvas scroll animation, snap-stop annotation cards, count-up specs, glass-morphism feature cards, optional testimonials, optional Three.js card scanner, footer). Customized via a mandatory interview (brand, logo, accent color, content source).
- **Prerequisite:** `ffmpeg` installed on the machine running the skill (`sudo apt install ffmpeg` / `brew install ffmpeg`).
- **Reusable assets:** `references/sections-guide.md` — implementation details for each website section, readable on its own as a reference for similar builds.
- **Last updated:** 2026-05-04 (added)

### `sowhatstheplan`

- **Source:** fresh-authored 2026-05-07 (not a verbatim port of an existing prompt). Designed during a brainstorm session on the 6_MONTH_CC_AUTOMATED build plan.
- **Trigger description:** see frontmatter `description:` field in `skills/sowhatstheplan/SKILL.md`
- **Purpose:** Marc's "where are we / what's next" briefer for any existing build-plan project. Generic across any folder containing the BUILD_PLAN family pattern (`*BUILD_PLAN*.md` + optional `*RUN_OPERATIONS*.md` + optional `*STATUS*.md`). Loads docs in fastest order, computes done/in-progress/next from the milestone tracker + Session Log, outputs a tight Marc-Jovani-style executive briefing (📍 / ✅ / 🟡 / 🔴 / 💡 / OPTIONS A-B-C) without big lists, then stops and waits for Marc's pick. Lets Marc pick up cold on a project he hasn't touched in months. Read-only — does not modify any doc.
- **Last updated:** 2026-05-07 (added)

### `cc-google-ads`

- **Source:** fresh-authored 2026-05-08 (not a verbatim port — Marc's first powerup that bundles a CLI binary alongside `SKILL.md`). Designed during the Google Ads integration build (Phase 4 of `/home/ubuntu/app_cc/docs/specs/2026-05-07-google-ads-integration-build-plan.md`).
- **Trigger description:** see frontmatter `description:` field in `skills/cc-google-ads/SKILL.md`.
- **Purpose:** Operator skill for Cinematic Composing's Google Ads account. Two-layer split per BPD §1.4 Finding C: **reads** via the official `googleads/google-ads-mcp` MCP server (installed per-machine via `pipx`, NOT vendored into this repo); **writes** via the Marc-authored `cc-gads` Python CLI (~600 LOC, lives next to SKILL.md, symlinked into `~/.local/bin/` by `install.sh`). The skill enforces the CEP protocol — Confirm (dry-run) → Execute (with `--confirm` after Marc types "yes") → Postcheck (re-query via read MCP). Hard policy ceilings live INSIDE the CLI (max bid $15, max budget delta 25%, regex blocklist `_PROD_|_LIVE_|^Brand_`), so even if Claude forgets a rule the binary refuses the operation.
- **Bundled tools:** (1) `cc-gads` (Python CLI for writes, requires `google-ads` + `click` from `requirements.txt` — `install.sh` creates a venv at `~/.config/cc-google-ads/venv/` automatically). Subcommands: `list-campaigns`, `list-ad-groups`, `set-budget`, `set-bid`, `pause-campaign`, `enable-campaign`, `add-negative-keyword`, `set-tracking-template` (single via `--campaign-id`/`--ad-group-id` or bulk via `--from-tsv`, with `--clear` flag for proto3-optional clear-via-update-mask), `set-account-tracking-template` (customer-level — highest blast radius), `env-check`. Every mutation is dry-run by default; `--confirm` required to apply. Audit log at `~/.config/cc-google-ads/audit.log`. (2) `cc-gads-ensure-adc` (Python preflight, stdlib-only — no venv needed). Idempotent ADC auto-healer: checks the current ADC's refresh token for the `adwords` scope, and if missing/broken, rebuilds ADC from `app_cc/.env`'s `GOOGLE_OAUTH_{CLIENT_ID,CLIENT_SECRET,REFRESH_TOKEN}` triple (Phase-1 sync's already-valid refresh token). Exits 0 on success or no-op, exits 1 only on unrecoverable error (missing `.env`, missing keys, or rebuild still fails). Logged to the same `audit.log` as `cc-gads` with `"op": "ensure-adc"`.
- **Per-machine setup:** credentials in `~/.config/cc-google-ads/env` (chmod 600, sourced from `.bashrc`); user-scope read MCP wired via `claude mcp add --scope user google-ads-read /home/ubuntu/.local/bin/google-ads-mcp` (writes to `~/.claude.json`, one-time, requires Claude Code restart for tools to appear). **ADC setup is NO LONGER a manual `gcloud auth application-default login` step** — that approach was deprecated 2026-05-11 after Google's reauth policy + custom-client `--no-browser` rejection made every gcloud-driven flow unreliable. Instead, ADC auto-heals from `app_cc/.env` on first invocation via `cc-gads-ensure-adc` (mandatory preflight in SKILL.md). The only requirement is that `app_cc/.env` exists on the machine with valid `GOOGLE_OAUTH_*` keys — true on both dev and prod by definition (Phase-1 sync depends on it).
- **Last updated:** 2026-05-11 (cascade-rule cleanup session: discovered via HYROS docs research + Google's "Serving URL Expansion Rules" that tracking templates REPLACE not append across hierarchy levels — the 253 campaign-level + 261 ad-group-level templates on CC were silently overriding the rich account-level `app_cc` template, dropping 12 of 14 tracking params at click time. Fix: cleared 512 of 514 lower-level templates via new `--clear` flag on `set-tracking-template` and new `set-account-tracking-template` subcommand to append HYROS-canonical `gc_id={campaignid}&h_ad_id={creative}` to the account-level template. 2 known exceptions left (paused VIDEO campaign `Claude Book Vid VIEWS` + its ad group — Google v24 API rejects mutations). Added "Tracking-template cascade rule" section to SKILL.md as burned-in lesson + audit-at-any-time GAQL queries. Added bulk-operation resilience to `set-tracking-template` (per-target failures no longer halt the batch). New canonical CC tracking template documented in `app_cc/DOCUMENTATION_TRACKING_CONVERSIONS_&_NOTIFICATIONS.md` §4.5.9. Discovery details: empty-string is NOT a valid clear value for `tracking_url_template` (Google returns `Too short`); proto3-optional fields clear via update_mask listing the field WITHOUT setting a value on the update message. Prior: 2026-05-11 earlier (added `set-tracking-template` subcommand to `cc-gads` — single-target via `--campaign-id`/`--ad-group-id` and bulk via `--from-tsv`, follows the same dry-run/`--confirm`/audit-log pattern as `set-budget`/`set-bid`; verified field mutability via SDK proto inspection before coding; tested end-to-end on one paused campaign + one ad group with post-check via read MCP. Added "When `cc-gads` is missing a command Marc needs" protocol section to SKILL.md so future gaps in the CLI's write surface become a ~1-minute autonomous add rather than a CEO-level discussion — documents the proven process: verify field via SDK proto → copy the structurally similar command → test on one paused target → post-check via read MCP → run bulk dry-run. Prior: 2026-05-11 (added `cc-gads-ensure-adc` preflight auto-healer + mandatory Preflight section in SKILL.md; ADC manual setup deprecated); 2026-05-08 (added — first skill to introduce the "Skill-bundled tools" powerup category; see Powerup taxonomy below).

---

## Powerup taxonomy

This repo distributes three categories of powerup, each with different distribution mechanics. The `cc-google-ads` skill (added 2026-05-08) was the first to introduce categories #2 and #3.

### 1. Skills (Markdown, propagate via symlink)

Operator playbooks Claude reads at session start. Pure Markdown, no runtime dependencies. Distributed automatically by `install.sh` / `pull.sh`: each `skills/<slug>/` folder is symlinked into `~/.claude/skills/<slug>/` on every server.

Examples: `distill-general-conversations`, `plan-build`, `sowhatstheplan`, `cc-google-ads`.

This is the dominant category — all 12 skills in this repo include a `SKILL.md`. Most live entirely as Markdown (the verbatim-port ones plus `sowhatstheplan`); a few include reference sub-folders (`hook-creator/references/`, `scroll-stop-builder/references/`).

### 2. Skill-bundled tools (executable scripts, propagate via symlink)

Optional CLI binaries that ship alongside a `SKILL.md`. `install.sh` symlinks each into `~/.local/bin/` on every server, so Claude can invoke them via the `Bash` tool from any working directory. The skill teaches Claude when and how to call the tool; the CLI enforces the hard policy below the LLM layer.

Detection rule used by `install.sh`: any regular, executable file at the skill folder root (no subfolders) whose basename is not a dotfile and whose extension is NOT in `{.md, .txt, .json, .yaml, .yml}`. Such files are symlinked to `~/.local/bin/<basename>`.

Currently: `cc-google-ads/cc-gads` (Python CLI for Google Ads writes). Future bundled tools (any language — bash, python, node, rust binary) follow the same rule.

If the skill has runtime dependencies, list them in `skills/<slug>/requirements.txt` (Python pip format). `install.sh` creates a venv at `~/.config/<slug>/venv/` once per server (idempotent — re-runs skip if the venv already exists; delete the venv to force a rebuild). The bundled tool's auto-route shim re-execs into the venv's `python3` so it Just Works regardless of which `python3` is on `PATH`.

### 3. MCP servers (NOT distributed via powerups)

Per-machine installations (via `pipx`, `npx`, or platform-specific package managers) registered with Claude Code via `claude mcp add --scope user|project|local <name> <command>`. User-scope MCP entries land in `~/.claude.json` (NOT `~/.claude/settings.json` — that file's schema rejects `mcpServers`); project-scope entries land in the project's `.mcp.json`. **Powerups never vendors third-party MCP code** — we wire to upstream releases instead. Vendoring a third-party MCP into this repo would mean tracking upstream commits and shipping security patches; out of scope for a personal skill collection.

When a skill REQUIRES an MCP server (like `cc-google-ads` requires `googleads/google-ads-mcp` for reads), the skill's per-machine setup is documented in its catalog entry above. The `install.sh` script does NOT install MCP servers — it would need credentials and project IDs that vary per-machine. MCPs are installed once, manually, with eyes open.

Currently: `googleads/google-ads-mcp` (official, Apache-2.0, Google-maintained) installed via `pipx` on the dev VPS for `cc-google-ads`. Registered at user scope via `claude mcp add --scope user google-ads-read /home/ubuntu/.local/bin/google-ads-mcp` (entry written to `~/.claude.json`).

### 4. Per-machine installs (documented, not automated)

Some skills require one-time machine setup beyond what `install.sh` can automate (e.g. `gcloud auth application-default login` requires browser consent; `pipx install` of an MCP requires explicit approval; ffmpeg requires `apt install`). These steps are documented in the skill's catalog entry above, not automated by `install.sh`, because they require credentials, network calls, or sudo.

Examples: `cc-google-ads` needs `pipx install googleads/google-ads-mcp` + `gcloud auth application-default login`; `scroll-stop-builder` needs `ffmpeg` installed system-wide.

---

## Using just a piece (modular access)

Sometimes you don't want to invoke a whole skill — you just want a specific template, design token, or reference doc. Because every skill folder is symlinked into `~/.claude/skills/<skill-name>/`, every file inside is reachable from a stable path on every server.

Examples:

```bash
# Grab just the styled tabbed prompt page template (use it for any 3-prompt set)
cp ~/marc-jovani-powerups/skills/scroll-stop-prompter/assets/prompt-page-template.html \
   ./my-page.html

# Read the section-by-section website implementation guide without triggering the build skill
less ~/marc-jovani-powerups/skills/scroll-stop-builder/references/sections-guide.md
```

You can also reference these paths inside a Claude Code session — e.g., "use the design tokens from `~/marc-jovani-powerups/skills/scroll-stop-builder/SKILL.md` (Design System section) for this new project." Claude can read the file directly without auto-triggering the full skill.

If a piece becomes broadly reusable across many projects, lift it into its own focused skill (e.g., a future `voltflow-design-system` skill exposing just the design tokens + glass-morphism components).

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

**As of 2026-05-07 (sowhatstheplan added):**
- New skill `sowhatstheplan` added — Marc's "where are we / what's next" briefer for any existing build-plan project. Generic across any folder containing the BUILD_PLAN family pattern (`*BUILD_PLAN*.md` + optional `*RUN_OPERATIONS*.md` + optional `*STATUS*.md`). Outputs a tight Marc-Jovani-style briefing (📍/✅/🟡/🔴/💡/OPTIONS) and stops. First fresh-authored skill in the collection (not a verbatim port). Designed during the brainstorm session that produced `/home/ubuntu/NORTH_STAR/6_MONTH_COMMITMENT/6_MONTH_CC_AUTOMATED-BUILD_PLAN.md` and its sibling docs.

**As of 2026-05-07 (Active State Protocol — sowhatstheplan + plan-build update):**
- Diagnosis: when given a fresh BUILD_PLAN, `sowhatstheplan` recommended Stream 0 (Lineage) instead of fixing live Google Ads conversion tracking that was bleeding $200/day of unrecoverable data. Root cause: plans naturally encode dependency / size / owner / status — but NOT active state or cost-of-delay-per-day. Sub-bullets labeled "user handles directly" got read as "low priority" by the sequencing logic. Diagnosis spanned 4 levels: brainstorm miss (never asked the live-state question), plan-structure miss (no Active State section), skill-logic miss (no urgency override), output-format miss (no URGENT row).
- Fix: 3-layer change applied today.
  - **Layer 1 (plan):** This Cinematic Composing build plan got an Active State section + 🚨 row promoted to top-level milestone (Stream 2.1a, urgent pre-build).
  - **Layer 2 (skill — `sowhatstheplan`):** Added Active State / URGENT scan with explicit section in output above NEXT, plus heuristic fallback (live + $X/day + untracked → URGENT). Bleeding outranks dependencies.
  - **Layer 3 (skill — `plan-build`):** Source `-plania.txt` updated with mandatory "what's running in production today, and what's broken or untracked about it?" question in the discussion phase + new "Active State Protocol — Live & Bleeding Check" section requiring the Active State table in every plan output. Re-ported verbatim to `skills/plan-build/SKILL.md`; byte-equality verified. Convention is now baked into every future build plan.

**As of 2026-05-08 (cc-google-ads added — first bundled-CLI skill):**
- New skill `cc-google-ads` added — Marc's Google Ads operator playbook (SKILL.md) + `cc-gads` Python CLI (~600 LOC) for writes. First skill to introduce two new powerup categories: **Skill-bundled tools** (CLI binaries that ship next to SKILL.md and get symlinked into `~/.local/bin/` by `install.sh`) and **MCP servers** (per-machine pipx installs that powerups deliberately does NOT vendor, e.g. the official `googleads/google-ads-mcp` for reads).
- `install.sh` extended (backward-compatible — all existing skills still work) to: (a) detect skill-bundled executables and symlink them to `~/.local/bin/`, (b) create per-skill venvs at `~/.config/<skill>/venv/` when `requirements.txt` is present (idempotent — re-runs skip if venv exists).
- Caught up on the catalog: `hook-creator` entry was missing from the Skill catalog despite being in the file structure — added today.
- New "Powerup taxonomy" section formalizes the 4 categories: Skills / Skill-bundled tools / MCP servers / Per-machine installs.
- Source: app_cc Google Ads Integration build, Phase 4 — `/home/ubuntu/app_cc/docs/specs/2026-05-07-google-ads-integration-build-plan.md` §9.

**Next, when Marc resumes:**
- Add more skills from Marc's prompt library as they get authored.
- When the collection is stable, evaluate wrapping it as a plugin (`plugin.json` + `marketplace.json`) for `/plugin install`-style distribution to other servers.
- Cross-server propagation test: after `./update.sh` from this dev VPS, `git pull` on a second machine and run `./install.sh` to verify the new bundled-tool + venv logic works on a fresh setup (the venv creation path hasn't been exercised on a cold server yet).
