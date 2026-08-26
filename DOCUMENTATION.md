# marc-jovani-powerups — Documentation

> **⚠️ SCOPE — read before adding ANYTHING here.** This file documents the powerups repo's own system ONLY: skills, install/update/pull, managed config. **Content about systems merely STORED in this repo does not go here.** The CLAUDEMANAGER/board machinery (`server-specific/`) is documented in the persona itself — that project deliberately has no DOCUMENTATION.md (`NORTH_STAR/BOARDS/CLAUDEMANAGER-BUILD_PLAN.md` §7.2). Unsure where something goes → global CLAUDE.md § Documentation Routing.

## ⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE

**📌 NOTE: This section must NOT be changed unless actual file structure modifications occur. Do NOT omit when updating documentation. Update ONLY if real changes are made to the codebase structure.**

### Repository tree

```
marc-jovani-powerups/
├── DOCUMENTATION.md            ← this file (the single user-facing doc)
├── install.sh                  ← setup on any server: symlinks skills into ~/.claude/skills/, skill-bundled executables into ~/.local/bin/, per-skill venvs at ~/.config/<skill>/venv/, PLUS the managed config surface below (global CLAUDE.md, portable personas, statusline, persona-picker hook). Repo wins: a real file in the way is moved to ~/.claude/_powerups_backups/ and replaced by a symlink. settings.json is the one exception — MERGED, not symlinked (repo wins on shared keys, machine keeps its own plugins/model/theme; see merge_settings)
├── update.sh                   ← from primary dev server: git add -A + commit + push
├── pull.sh                     ← from any other server: git pull --ff-only, then auto-runs install.sh so new skills / bundled tools / venvs / config wire up immediately
├── global/
│   └── CLAUDE.md               ← → ~/.claude/CLAUDE.md — global rules, loaded in EVERY session regardless of persona (or none)
├── personas/                   ← → ~/.claude/personas/ — ONLY the portable personas; server-specific ones are never touched
│   ├── CLAUDEDEV.md            ← the development persona
│   └── CLAUDEREG.md            ← the "no special preferences" default persona
├── config/                     ← → ~/.claude/ — Claude Code configuration; these three travel together
│   ├── settings.json           ← MERGED into ~/.claude/settings.json, not symlinked (declares the SessionStart hook + statusline below, both via "$HOME/..." so one file works on Linux and macOS)
│   ├── statusline-command.sh   ← → ~/.claude/statusline-command.sh
│   └── hooks/persona-picker.sh ← → ~/.claude/hooks/persona-picker.sh — dynamic: lists whatever .md files exist in ~/.claude/personas/, so each server shows its own menu
├── server-specific/            ← versioned but NEVER deployed by install.sh — files that belong to THIS server only, symlinked by hand. Here purely so they survive a disk loss. ⚠️ NOT documented here: the manager project deliberately has no DOCUMENTATION.md — the persona itself is the documentation (see NORTH_STAR/BOARDS/CLAUDEMANAGER-BUILD_PLAN.md §7.2)
│   ├── CLAUDEMANAGER.md        ← → ~/.claude/personas/CLAUDEMANAGER.md
│   ├── claudemanager           ← → ~/.local/bin/claudemanager
│   ├── mgr-opencheck           ← → ~/.local/bin/mgr-opencheck
│   ├── mgr                     ← → ~/.local/bin/mgr
│   ├── manager-close/          ← → ~/.claude/skills/manager-close — a skill, but deliberately NOT in skills/: install.sh would ship it to every server, and it only means anything on this one
│   └── manager-checkout/       ← → ~/.claude/skills/manager-checkout — the day-checkout ritual skill (same deliberately-not-in-skills/ rule as manager-close)
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
    ├── whatdocs/SKILL.md                   ← research-first protocol before any fix (read all relevant files, propose generic non-duplicate solution)
    ├── defcode/SKILL.md                    ← live-prod execution discipline (backup-before-edit, no ninja injection, route matching, restart pm2, safe test script)
    ├── simplll/SKILL.md                    ← plain-English decision-ready explainer (verbatim Marc prompt; auto-fired at the end of /whatdocs)
    ├── samepage-brainstorming/SKILL.md     ← mandatory alignment gate between /whatdocs and /defcode (3-5 turn clarification + brainstorming, explicit GO required)
    ├── grammar-polish/SKILL.md             ← two-pass manuscript editor (grammar/spelling first, clarity second) preserving the author's casual voice
    ├── claudeclarity/SKILL.md              ← reader-first writing discipline (subject discipline, capability framing, cruft detection, one-screen budget) — brought under version control 2026-07-31; it had been a local-only skill since April
    ├── handoff-continuia/SKILL.md          ← end-of-session boundary skill — targeted-read of /plan-build doc, writes strict-template Session Log entry + prints copy-pasteable handoff prompt in chat for next agent (companion to sowhatstheplan which handles start-of-session)
    ├── team-discussion/                     ← the multi-agent rulebook (OWNER/VERIFIER, severity gate, loop-breakers, END-STATE). Carries the Fable→Opus relay for /plan-build work
    │   ├── SKILL.md
    │   └── references/
    │       ├── LEDGER-template.md           ← the shared source of truth (decisions · claims · evidence tags · research queue)
    │       └── DESK-template.md             ← the ≤15-line file the user actually reads
    ├── how-marc-works-w-claude-code/SKILL.md ← Marc's builder profile (identity, workflow, pain points, architectural principles, technical context, CC-Sampler case study) — background context skill (user-invocable: false), auto-loaded during plan-build/brainstorming/architecture decisions
    ├── subagentic-workflow/                ← improved variant of /superpowers:subagent-driven-development — same-subagent /whatdocs+/defcode flow with user-approval gate, always Opus 4.7, single-source-of-truth (no duplicates of /whatdocs or /defcode content)
    │   ├── SKILL.md
    │   ├── implementer-prompt.md           ← dispatch template for the implementer subagent (handoff-continuia structure + Phase A research / Phase B approval gate / Phase C execute via SendMessage)
    │   ├── spec-reviewer-prompt.md         ← dispatch template for spec compliance reviewer (verifies execution matches APPROVED PROPOSAL)
    │   └── code-quality-reviewer-prompt.md ← dispatch template for code quality reviewer (/defcode discipline checks: backups, no ninja, no duplicates, route matching, safe test)
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
    ├── cc-launch-pace/                      ← launch-vs-launch comparison at the SAME day-range (skill + bundled CLI)
    │   ├── SKILL.md
    │   ├── cc-launch-pace                   ← executable, symlinked into ~/.local/bin/ by install.sh
    │   └── overrides.json                   ← per-launch corrections the CLI reads
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

### Porting a prompt, and editing it afterwards

When a skill starts life as one of Marc's prompts, **port the body as-is on the first pass** — don't rewrite, summarize, or "improve" a prompt you haven't seen work yet. Claude authors the YAML frontmatter (`name` and `description`); the body is Marc's.

**After that first pass, the skill is a living document.** Skills evolve — typo sweeps, tool-name corrections, new rules Marc adds in chat, fixes for failures seen in the field. Edit them freely. `SKILL.md` is the canonical version of every skill in this repo; most source `.txt` files live on the VPS and are no longer kept in sync (noted per-skill in the catalog where it applies).

The one thing to preserve is **Marc's voice** — his phrasing, his emphasis, his vocabulary. Change what's wrong or stale; don't smooth out how he writes.

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

To receive future updates: `cd ~/marc-jovani-powerups && ./pull.sh` (or set up a cron — see CEO Update Workflow below).

### What the repo manages, and what it never touches

`install.sh` is idempotent — safe to re-run any time. Everything it ships is
**symlinked**, so a `./pull.sh` updates it on every server automatically.

**The repo WINS on its own surface.** If a real file is sitting at a target path,
it is moved to `~/.claude/_powerups_backups/<name>.bak_pre_powerups_YYYY-MM-DD`
and replaced by the symlink. (Backups go to that one folder and never next to the
original — a skill backup left inside `~/.claude/skills/` would be picked up by
Claude Code as a real, duplicate skill.)

| Path | Managed? |
|---|---|
| `~/.claude/skills/<name>` for every skill in `skills/` | ✅ replaced |
| `~/.claude/CLAUDE.md` | ✅ replaced |
| `~/.claude/personas/CLAUDEDEV.md`, `CLAUDEREG.md` | ✅ replaced |
| `~/.claude/settings.json` | ⚖️ **merged, not symlinked** — see below |
| `~/.claude/statusline-command.sh` | ✅ replaced |
| `~/.claude/hooks/persona-picker.sh` | ✅ replaced |
| `~/.local/bin/<skill-bundled tool>` | ✅ replaced |
| **Server-specific personas** — `CLAUDEGADS`, `CLAUDEEMAILS`, `CLAUDEANALYSIS`, `CLAUDEMARC`, `CLAUDEPLAN`, `CLAUDEMJYT`, `CLAUDECLARITY`, `CLAUDEEXPENSES`, `CLAUDELAUNCH`, `CLAUDEHEALTH`, `CLAUDE` | ❌ never read, moved, or deleted |
| Any other hook, `settings.local.json`, anything else under `~/.claude/` | ❌ untouched |

Only the two general-purpose personas travel. Everything else in
`~/.claude/personas/` is specific to the server it lives on and stays there.

#### `settings.json` is the one exception: merged, never symlinked

Every other managed path is a symlink. `settings.json` cannot be, because it mixes
two kinds of content:

- **Shared setup** — the SessionStart persona-picker hook, the statusline, `env`,
  `permissions`, and the assorted behaviour flags. Should be identical everywhere.
- **Machine-specific state** — `enabledPlugins` and `extraKnownMarketplaces` mirror
  which marketplaces are *physically installed* on that machine, and
  `model` / `theme` / `effortLevel` / `alwaysThinkingEnabled` / `voice` /
  `agentPushNotifEnabled` are per-machine preferences.

Symlinking would hand one machine's plugin list to every other machine. That is not
cosmetic: the same plugin ships from different marketplaces (`superpowers` exists as
both `superpowers@superpowers-marketplace` and `superpowers@claude-plugins-official`),
and naming a marketplace the machine doesn't have **silently disables the plugin**.

So `install.sh` merges instead:

- the repo wins on every shared key,
- the machine keeps every key in `MACHINE_LOCAL_KEYS` (defined at the top of
  `install.sh`),
- any extra key a machine added on its own is left alone,
- the pre-merge file is backed up to `_powerups_backups/` and the merge is
  idempotent — a second run reports `OK settings.json (shared keys already up to date)`.

A machine that was previously *symlinked* is migrated automatically: the symlink's
content is its live settings, so it is written out as a real file first, then merged.
Nothing is lost. A brand-new machine with no `settings.json` gets the repo's file
wholesale as a seed.

**Consequence for the workflow:** `/config` changes no longer write through to
`config/settings.json`. To change something for *every* machine, edit
`config/settings.json` in the repo and `./update.sh`. To change one machine only,
use `/config` as usual.

**Portability:** `config/settings.json` references the hook and statusline as
`bash "$HOME/.claude/..."`, not a hardcoded path, so the same file works on Linux and
macOS. This is safe because Claude Code runs both hook and `statusLine` commands
through a shell — the hooks docs state the command string is passed to `sh -c` and
that "the shell tokenizes the string, expands variables", and the statusline docs'
own example uses a `~/.claude/...` path. Verified on macOS: `sh -c 'bash "$HOME/..."'`
resolves and both scripts run.

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

### `cc-launch-pace`

- **Source:** fresh-authored 2026-08-08 (not a verbatim port). Designed during the Fluid Flutes launch session, from Marc's own framing: *"How many days in? How much so far? So what's that per day? Now compare against every other launch AT THE SAME DATE RANGE — comparing the first 3 days against a full launch is no good, because launches valley in the middle."*
- **Trigger description:** see frontmatter `description:` field in `skills/cc-launch-pace/SKILL.md`.
- **Purpose:** Answers "is this launch actually good, and is it worth extending?" by normalising every launch to **cumulative revenue at day N** and ranking them against each other at the *same* day-N. Reports `Rev @dN`, `$/day`, `Sends` and `$/send`, splits NEW vs RELAUNCH, and flags a NEW launch topping its class as an extension / post-launch-workhorse candidate. Exists as a CLI rather than persona prose because hand-derived launch SQL has produced wrong numbers twice — most notably Fluid Flutes reported at $2,997 when the funnel had made $5,510 (a product-name filter hid a $1,568 upsell and a $396 bump).
- **Bundled tools:** `cc-launch-pace` (Python CLI, `psycopg2` + stdlib only — no `requirements.txt`, no venv needed; `psycopg2` is already present system-wide on the CC servers). Flags: `--focus <funnel-slug>`, `--day N`, `--months`, `--min-rev`, `--all`. Reads Postgres `purchases` / `funnels` / `builder_checkouts` / `email_campaigns` and the Launch Hub SQLite at `/home/ubuntu/LAUNCH_HUB/App/data/launch_hub.db`. **Read-only — it never writes.**
- **Correctness properties worth preserving if this is ever edited:** (1) revenue is scoped by `funnel_id` / `builder_checkout_id`, never by product name or `product_id`, so bumps and upsells are counted; (2) NEW/RELAUNCH is read from the Launch Hub's two tables (`launches` = NEW, `old_launches` = RELAUNCH) and anything unmapped prints `?` rather than being guessed — classify permanently by adding `"<funnel_id>": "NEW"|"RELAUNCH"` to `overrides.json` beside `SKILL.md`; (3) revenue is split into **runs** separated by 7+ quiet days, because a funnel resells on every relaunch and often carries a stray sale months before its real launch — both corrupt "day 1"; (4) runs starting within 2 days of the lookback edge are dropped, or the window boundary masquerades as a launch date (this bug once reported Fast String Motors at $37 for day-4 instead of its real $10,884).
- **Per-machine setup:** none. Works anywhere the CC Postgres and the Launch Hub SQLite are reachable — i.e. the prod server. On a machine without them the CLI errors out; it does not fall back or estimate.
- **Last updated:** 2026-08-08 (created — second skill to use the "Skill-bundled tools" category after `cc-google-ads`).

### `distill-general-conversations`

- **Source file:** `Destile Information (General — Conversations & Instructional).txt`
- **Trigger description:** see frontmatter `description:` field in `skills/distill-general-conversations/SKILL.md` (this is the canonical source — Claude reads it to decide when to auto-trigger)
- **Last updated:** 2026-04-29 (created)

### `distill-educational-generic`

- **Source file:** `Destile Information (Includes Context & Examples).txt`
- **Trigger description:** see frontmatter `description:` field in `skills/distill-educational-generic/SKILL.md`
- **Last updated:** 2026-07-16 v1.1 (23-typo sweep under the pass rule: "distilation distilation"→distillation, destile(d)/distiled→distill(ed) throughout, ASSES/assesment→ASSESS/assessment, parnet→parent, fabricatet→fabricated, overwelms→overwhelms, too litle→too little, "Is de"→"Is the", becuase→because, insde→inside, doucment→document, "any any"→any, "carefull careful"→careful, somethign→something, less→fewer elements, "created document I've created" dedup ×3, encapsulates→encapsulate, "edit doc to and add"→"to add" ×3, "Below is"→"Below are", punctuation fixes. Voice untouched. Backported from the general skill (Marc-approved): a Pre-flight Questions section (save location with 3 suggested candidates, ENGLISH/SPANISH ask, structure approval before filling) + the name-registry consultation rule with the standing Marc Jovani variant entry; the hardcoded "write in ENGLISH" line became default-with-override. Source .txt not on this Mac — SKILL.md canonical from v1.1.) Prior: 2026-04-29 (created)

### `distill-educational-audio-composition`

- **Source file:** `Destile Information FOR AUDIO & COMPOSITION CONTENT (Includes Context & Examples).txt`
- **Trigger description:** see frontmatter `description:` field in `skills/distill-educational-audio-composition/SKILL.md`
- **Last updated:** 2026-07-16 v1.1 (26-typo sweep — same shared family as distill-educational-generic (destiled, ASSES, parnet, fabricatet, becuase, doucment, etc.) plus its own: "Do not mention the name IF the teacher"→"name OF the teacher", "ie."→"i.e.". Voice untouched. Same Marc-approved backport applied as the generic sibling (Pre-flight Questions + name registry + default-language line); SKILL.md canonical from v1.1.) Prior: 2026-04-29 (created)

### `doc-new-project`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-docnew.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/doc-new-project/SKILL.md`
- **Purpose:** Marc's instructions for creating a new `DOCUMENTATION.md` from scratch for a new project, app, or build. Produces a comprehensive Markdown doc starting with the locked `⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE` first section, with detailed file structure (paying special attention to modularized clusters so future AIs don't get confused by old monolithic files), and enough context for a future AI session to ask informed follow-up questions.
- **Last updated:** 2026-07-16 v1.2 (7-typo sweep under the pass rule: LOOSING→LOSING, give→gives, Some times→Sometimes, inter relates→interrelates, DON NOT→DO NOT, CUCIAL→CRUCIAL, OMITED/SKIPED/MODIFYIED→OMITTED/SKIPPED/MODIFIED. Voice untouched. ⚖️ REJECTED by Marc (recorded so future passes don't re-propose): adding a non-software adaptive line — the doc pair stays code-shaped; plan-build's own Documentation Protocol already covers the non-software case when it matters.) Prior: 2026-05-24 v1.1 (1) fixed line-40 ambiguity that implied a prior doc to inherit from — now explicitly says "run `tree -L 3` filtered for noise, use what you find"; (2) added SIZE TARGET — ASK FIRST block with default anchor of ~500-700 lines and reasoning prompt combining codebase scope + this-session work scope + hard-won-knowledge density, then explicit ask-user step before writing — solves the Opus 4.7 problem of producing 100KB docs; (3) added ANTI-VERBOSITY RULES block (tables/bullets over prose, no cross-section duplication, "complete means COVERAGE not WORD COUNT"); (4) added NEXT STEPS conditional rule (include only if no separate build plan / handoff owns the roadmap); (5) added HARD-WON KNOWLEDGE forever rule so it's baked in at creation. Prior: 2026-04-29 (created)

### `doc-update-project`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-doccode.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/doc-update-project/SKILL.md`
- **Purpose:** Marc's instructions for updating an existing `DOCUMENTATION.md` after a coding session, implementation, bugfix, or upgrade. Preserves all critical info (carefully-discovered solutions, roadblocks overcome), adds new learnings, removes only fully-obsolete content, targets ~1% shorter while remaining comprehensive. The 1% target is a deliberate forcing function — most updates can't hit it exactly, but the attempt triggers a real tightening pass that wouldn't otherwise happen.
- **Last updated:** 2026-07-16 v1.2 (16-typo sweep under the pass rule — headline fossil: the opening line "good low let's move" → "good, now let's move". Also: we'vde→we've, each things→each thing, LOOSING→LOSING, give→gives, useful is→useful it is, overcomed→overcome, it's best→its best, DON NOT→DO NOT, CUCIAL/OMITED/SKIPED/MODIFYIED→CRUCIAL/OMITTED/SKIPPED/MODIFIED, targetted→targeted ×3, fluf→fluff, tocken→token, approariate→appropriate, inticate/mi→indicate/me. PLUS a description-body consistency fix: the frontmatter still promised "a clear next-steps plan" but v1.1 made Next Steps conditional (only when no build plan / handoff owns the roadmap) — description now matches the body. ⚖️ REJECTED by Marc (same rationale as doc-new-project — no non-software adaptive line; plan-build's Documentation Protocol owns that case).) Prior: 2026-05-24 v1.1 (1) FIXED the dangerous "read from memory, don't reload" instruction — was causing silent data loss when long-session memory was summarized/stale; now mandates FRESH READ FROM DISK before any update; (2) preserved the 1% shorter forcing function but added explicit "falling short is fine — the point is the optimization pass" so the agent doesn't strip valuable content trying to hit the literal number; (3) cut the mandatory NEXT STEPS / "clear plan for next steps" blocks — made conditional: include only if no build plan / handoff owns the roadmap (this doc captures what the system IS, not what's planned); (4) added ANTI-VERBOSITY RULES block matching doc-new-project; (5) promoted "never remove hard-won knowledge or solved-problem entries" to an explicit TODO item in the template (was buried in body text). Prior: 2026-04-29 (created)

### `plan-build`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-plania.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/plan-build/SKILL.md`
- **Purpose:** Marc's planning-agent workflow. Triggered when starting a new build/feature/app/refactor — or, since the 2026-07-16 genericization, any non-coding initiative (campaign, course, launch, content system). Process: (1) user describes project, (2) load `/brainstorming` for collaborative back-and-forth with deep research detours interleaved during brainstorming whenever community knowledge would change the answer, (3) after brainstorming concludes, assess what additional deep researches are needed for the execution phase and create prompts, (4) plan the document structure, print the section list in chat, pass the mandatory self-evaluation gate (over-engineering / density / recency-bias check) before anything is written, then build the doc placeholder-by-placeholder. Captures the Active State (live spend, deployed systems, anything bleeding per day of inaction). Build plan contains all downstream instructions (TODO list spec, 🔬 research checkpoints, Cross-Session Continuity Protocol, Session Log, Documentation Protocol with `DOCUMENTATION.md` maintenance, Deep Research 10x Multiplier Rule, Active State Protocol). Designed so the next agent can execute with just `"read this doc, start"` — no execution-phase or doc-phase skill needed.
- **Last updated:** 2026-08-25 v1.6 (**STEP 0 — THE DISCOVERY GATE**, inserted ahead of STEP 1. `/whatdocs` is now MANDATORY at the start of every plan-build, and nothing — no brainstorming, no clarifying question, no writing — happens before it closes. Paid for the same day: a planning agent opened an INVESTORS build plan on a transcript and a digest alone, having read neither the board, nor the persona, nor the parent plan; it misread Marc's own journal note as strategic doctrine, asked a downstream tactical question as if it gated the plan, and later proposed reviving a small app nobody had mentioned. Marc: *"if you do not know these things, you should get contextualized before you even ask these questions, because it is embarrassing."* **`/whatdocs` text is NOT copied into this skill** — one file on disk, one source of truth. STEP 0 instead classifies the project **BUILD / STRATEGIC / MIXED** and then rules, section by section, which of `/whatdocs`'s 14 sections apply: §1–5 keep (§3, the no-lazy-questions rule, named the most load-bearing); §6 conditional — code file-types for BUILD, a **business reading list** for STRATEGIC (parent direction doc · every build plan touched · the board and its constants · the persona · source transcripts · the inbox); §7 environment checks only for a BUILD or a MIXED build wired to a larger live environment; §9's ten solution tests conditional (code-shaped); §10 adapted to *coherent with what is already decided and already running*; **§11 recontextualized and promoted** — the no-duplicates rule now runs two checks, ① the estate (is this already a plan, a ghost row, a parked decision?) and ② **the world** (has someone already solved this — wins AND failures?), and check ② is exactly what the 🔬 research checkpoints exist for; §12 kept but **the discovery TODO list is TEMPORARY** — deleted at the gate and replaced by the build-plan list, never coexisting; **§13 REPLACED** — no `=== PROPOSED SOLUTION ===` block, since its fields demand a code answer and are what dragged the 25 Aug session into a codebase; substitute *"explain in simple terms what it is that we are trying to build"*; §14 ending sequence kept. Mirrored in `whatdocs/SKILL.md` so either entry point behaves identically.) Prior: 2026-07-31 v1.5 (STEP 6.5 SELF-EVALUATION — MANDATORY GATE, inserted between "print the list of topics/sections in chat" and "create the document with structure + placeholders". The planning agent must ultrathink three questions before writing anything: is the structure I designed too dense / over-engineered, does it feel too complex, and does the last part of the conversation carry too much weight while the first part got thinned out (recency bias). If any is true, redo the structure list. States the goal explicitly — retain ALL discussed info in a readable, token-efficient plan with no bloat. Authored by Marc, applied directly to `SKILL.md` (source `-plania.txt` on the VPS still untouched — SKILL.md remains canonical per the 2026-07-16 note). Scope check: this changes the planning agent's process, NOT the build plan's guaranteed structural conventions, so `/handoff-continuia`'s Step 2 reading list and `/sowhatstheplan`'s scan stay valid — no companion-skill edits needed. Version numbering starts with this entry; the prior dated updates back-count as v1.0 created → v1.4 GREENFIELD.) Prior: 2026-07-16 v1.4 (GREENFIELD conditionality — Marc's field feedback: the mandatory "anything bleeding?" question fired on every plan-build, including brand-new projects where it reads as nonsense. Root cause: the May 7 incident fix was broadcast unconditionally in crisis mode and never revisited. Fix: the early question is now CONDITIONAL — the agent assesses from context whether the project touches anything already running; asks once if yes/unclear; on greenfield does NOT ask and records "Greenfield — nothing live. N/A." as the Active State. New GREENFIELD RULE line added to the Active State Protocol section. sowhatstheplan / handoff-continuia / subagentic-workflow deliberately unchanged — they are silent readers/slots, not questions to Marc. Same source-sync note applies: -plania.txt on VPS untouched.) Prior: 2026-07-16 v1.3 (genericization + consistency pass, designed with Fable 5: (1) widened beyond coding — description now covers campaign/course/launch/content-system/any business initiative; research-detour triggers add platform choice, pricing model, launch mechanics, curriculum structure, vendor selection; 10x Multiplier gets a new non-coding example — before implementing something already implemented elsewhere (e.g., AI education programs in schools), research the successful AND the failed implementations, failures teach what NOT to do (from Marc's real research for Jesús); Deep Research Protocol TRIGGER list extended to match; Documentation Protocol gets an adaptive line for non-software projects (Asset/Resource Inventory, Workflow Map, Tools & Access replace sections 1-3). (2) Consistency fixes: inherited "Update Section 11" → "Update the Session Log section" (original project's numbering was leaking into every future plan); stale "resss snippet" reminder → /research-prompt-instructions (line 79 already pointed there); EDITDOC/editdoc/EditDoc → the Edit tool (real Claude Code tool name, 3 sites); /how-marc-works → exact slug /how-marc-works-w-claude-code. (3) 19-typo sweep incl. the REDACT false friend (Spanish redactar ≠ English redact/censor → WRITE), UNDERSTNADING, IA AGANE, ANNALYSIS, everythign, docuemntation, configurat/specks, debuging, exectuing, temporal sateilte, resuilt, Remding, tockens, moveing, COMUNICATE, userr, SUMARIZE, unclosed paren. ⚠️ SOURCE-SYNC NOTE: source `-plania.txt` lives on the VPS and was NOT touched — SKILL.md is canonical for this skill from this version onward, or apply the same edits to the source next time on the VPS.) Prior: 2026-06-22 v1.2 (embedded `/brainstorming` as Step 2 of the process — brainstorming and deep research are now interleaved, not sequential; Active State question folded into brainstorming phase as mandatory early question; post-brainstorming research separated as distinct step for execution-phase concerns). Prior: 2026-05-07 v1.1 (Active State Protocol added). Prior: 2026-04-29 v1.0 (created — verbatim port of `-plania.txt`)

### `research-prompt-instructions`

- **Source file:** `/home/ubuntu/anthropic_text_processor/prompts/-resss.txt`
- **Trigger description:** see frontmatter `description:` field in `skills/research-prompt-instructions/SKILL.md`
- **Purpose:** Loads the instruction set for writing a high-quality deep-research prompt (paradigm-shifting framing, no-abandoned-tech filter, parallel-prompt splitting, mandatory contextualization checklist, post-result validation questions). Invoked by user during a `plan-build` session when it's time to draft research prompts. Replaces the former `resss` TextExpander snippet — `plan-build` references this skill explicitly (see edit applied to `-plania.txt` line 63).
- **Last updated:** 2026-07-16 v1.3 (21-typo sweep under the pass's new typo rule — avandoned ×2→abandoned, transforer→transformer, urselves→ourselves, SEEMENGLY AUTORITATIVE→SEEMINGLY AUTHORITATIVE, THIS QUESTIONS→THESE QUESTIONS, planing-to-doing→planning-to-do, happens/we-building→happen/us-building, alread→already, mut→must, repositores→repositories, enviroment/Environemnt→environment/Environment, importnat→important, begining→beginning, new projects→new project, conditions→condition, has-to-give→have-to-give, Thnk→Think, some times→sometimes, necssary→necessary, seaking→seeking, Erros→Errors, project→project's characteristics. Voice deliberately preserved: "timebending", "DO NOT GET WEIGHTED WITH", the DDSP/RAVE and JUCE examples. No structural changes. Opening line genericized — "codebase (or materials) of the project" — to match plan-build's new non-coding scope. ⚖️ REJECTED by Marc, recorded so future passes don't re-propose it: forcing the research prompt to demand a "recommendation + confidence" output shape. Rationale: the satellite researcher lacks full project context; a forced recommendation frame makes the master agent over-trust conclusions the researcher had to infer. Evidence-gathering is the researcher's job; recommending stays with the master agent who holds the context. SKILL.md remains canonical (source -resss.txt on VPS untouched, per v1.2 note).) Prior: 2026-07-13 v1.2 (generalized additions backported from the Spanish adaptation built for Jesús & Tere, originally from a research prompt Marc wrote for a Jesús project: "you don't know what you don't know" framing in the Why paragraph; complete-understanding-of-the-project precondition; "highest probability of success" bullet; new LEARN FROM THOSE WHO ALREADY DID IT block — precedents battery (what similar projects exist, who/why/how, success rate + results, reception, controversy + how they fixed it, pros/cons found) plus collateral-topics line; "Do we need a second research?" added to the post-research validation questions; "Tested" bullet strengthened to "Validated and tested — successfully applied in the real world". ⚠️ SOURCE-SYNC NOTE: edited `skills/research-prompt-instructions/SKILL.md` directly — the source `-resss.txt` lives on the VPS (`/home/ubuntu/anthropic_text_processor/prompts/`) and was not available on this Mac; either apply the same edits to the source next time on the VPS, or treat SKILL.md as canonical for this skill from v1.2 onward.) Prior: 2026-05-23 v1.1 (added Weights/Disregards Principle to the post-research MANDATORY block: when reading Deep Research results, take only info that matters, dismiss seemingly-authoritative information that may not be 100% real/factual, and discard anything unrelated to the session's goal — and updated the closing self-check line to "ask these questions to yourself & apply the weights/disregards principles". Source `-resss.txt` edited first per the verbatim-port rule, then ported.). Prior: 2026-04-29 (created)

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
- **Last updated:** 2026-07-16 (two Marc-approved one-liners: (1) post-briefing cadence line — when Marc picks an option that touches an existing codebase, the agent is told the cadence is /whatdocs → simplll + samepage-brainstorming gate → explicit GO → /defcode, no jumping straight to edits; (2) LOCKED output format header fixed "acting/bleeding" → "active/bleeding" (typo confirmed by Marc). Zero other typos — cleanest skill of the Fable 5 pass.) Prior: 2026-05-07 (added)

### `cc-google-ads`

- **Source:** fresh-authored 2026-05-08 (not a verbatim port — Marc's first powerup that bundles a CLI binary alongside `SKILL.md`). Designed during the Google Ads integration build (Phase 4 of `/home/ubuntu/app_cc/docs/specs/2026-05-07-google-ads-integration-build-plan.md`).
- **Trigger description:** see frontmatter `description:` field in `skills/cc-google-ads/SKILL.md`.
- **Purpose:** Operator skill for Cinematic Composing's Google Ads account. Two-layer split per BPD §1.4 Finding C: **reads** via the official `googleads/google-ads-mcp` MCP server (installed per-machine via `pipx`, NOT vendored into this repo); **writes** via the Marc-authored `cc-gads` Python CLI (~600 LOC, lives next to SKILL.md, symlinked into `~/.local/bin/` by `install.sh`). The skill enforces the CEP protocol — Confirm (dry-run) → Execute (with `--confirm` after Marc types "yes") → Postcheck (re-query via read MCP). Hard policy ceilings live INSIDE the CLI (max bid $15, max budget delta 25%, regex blocklist `_PROD_|_LIVE_|^Brand_`), so even if Claude forgets a rule the binary refuses the operation.
- **Bundled tools:** (1) `cc-gads` (Python CLI for writes, requires `google-ads` + `click` from `requirements.txt` — `install.sh` creates a venv at `~/.config/cc-google-ads/venv/` automatically). Subcommands: `list-campaigns`, `list-ad-groups`, `set-budget`, `set-bid`, `pause-campaign`, `enable-campaign`, `add-negative-keyword`, `set-tracking-template` (single via `--campaign-id`/`--ad-group-id` or bulk via `--from-tsv`, with `--clear` flag for proto3-optional clear-via-update-mask), `set-account-tracking-template` (customer-level — highest blast radius), `env-check`. Every mutation is dry-run by default; `--confirm` required to apply. Audit log at `~/.config/cc-google-ads/audit.log`. (2) `cc-gads-ensure-adc` (Python preflight, stdlib-only — no venv needed). Idempotent ADC auto-healer: checks the current ADC's refresh token for the `adwords` scope, and if missing/broken, rebuilds ADC from `app_cc/.env`'s `GOOGLE_OAUTH_{CLIENT_ID,CLIENT_SECRET,REFRESH_TOKEN}` triple (Phase-1 sync's already-valid refresh token). Exits 0 on success or no-op, exits 1 only on unrecoverable error (missing `.env`, missing keys, or rebuild still fails). Logged to the same `audit.log` as `cc-gads` with `"op": "ensure-adc"`.
- **Per-machine setup:** credentials in `~/.config/cc-google-ads/env` (chmod 600, sourced from `.bashrc`); user-scope read MCP wired via `claude mcp add --scope user google-ads-read /home/ubuntu/.local/bin/google-ads-mcp` (writes to `~/.claude.json`, one-time, requires Claude Code restart for tools to appear). **ADC setup is NO LONGER a manual `gcloud auth application-default login` step** — that approach was deprecated 2026-05-11 after Google's reauth policy + custom-client `--no-browser` rejection made every gcloud-driven flow unreliable. Instead, ADC auto-heals from `app_cc/.env` on first invocation via `cc-gads-ensure-adc` (mandatory preflight in SKILL.md). The only requirement is that `app_cc/.env` exists on the machine with valid `GOOGLE_OAUTH_*` keys — true on both dev and prod by definition (Phase-1 sync depends on it).
- **Last updated:** 2026-05-11 (cascade-rule cleanup session: discovered via HYROS docs research + Google's "Serving URL Expansion Rules" that tracking templates REPLACE not append across hierarchy levels — the 253 campaign-level + 261 ad-group-level templates on CC were silently overriding the rich account-level `app_cc` template, dropping 12 of 14 tracking params at click time. Fix: cleared 512 of 514 lower-level templates via new `--clear` flag on `set-tracking-template` and new `set-account-tracking-template` subcommand to append HYROS-canonical `gc_id={campaignid}&h_ad_id={creative}` to the account-level template. 2 known exceptions left (paused VIDEO campaign `Claude Book Vid VIEWS` + its ad group — Google v24 API rejects mutations). Added "Tracking-template cascade rule" section to SKILL.md as burned-in lesson + audit-at-any-time GAQL queries. Added bulk-operation resilience to `set-tracking-template` (per-target failures no longer halt the batch). New canonical CC tracking template documented in `app_cc/DOCUMENTATION_TRACKING_CONVERSIONS_&_NOTIFICATIONS.md` §4.5.9. Discovery details: empty-string is NOT a valid clear value for `tracking_url_template` (Google returns `Too short`); proto3-optional fields clear via update_mask listing the field WITHOUT setting a value on the update message. Prior: 2026-05-11 earlier (added `set-tracking-template` subcommand to `cc-gads` — single-target via `--campaign-id`/`--ad-group-id` and bulk via `--from-tsv`, follows the same dry-run/`--confirm`/audit-log pattern as `set-budget`/`set-bid`; verified field mutability via SDK proto inspection before coding; tested end-to-end on one paused campaign + one ad group with post-check via read MCP. Added "When `cc-gads` is missing a command Marc needs" protocol section to SKILL.md so future gaps in the CLI's write surface become a ~1-minute autonomous add rather than a CEO-level discussion — documents the proven process: verify field via SDK proto → copy the structurally similar command → test on one paused target → post-check via read MCP → run bulk dry-run. Prior: 2026-05-11 (added `cc-gads-ensure-adc` preflight auto-healer + mandatory Preflight section in SKILL.md; ADC manual setup deprecated); 2026-05-08 (added — first skill to introduce the "Skill-bundled tools" powerup category; see Powerup taxonomy below).

### `whatdocs`

- **Source file:** `/home/ubuntu/img/whatdocs.md`
- **Trigger description:** see frontmatter `description:` field in `skills/whatdocs/SKILL.md`
- **Purpose:** Marc's research-first protocol — invoked when Marc asks for a fix, update, refactor, or new implementation and the right move is to fully understand the system BEFORE touching code (not apply anything yet). Forces a TODO-first response: confirm what's actually being asked, request app structure if missing (or run targeted TREE commands on specific directories — never the whole app), list every document needed for a perfect fix (database/models, routes/forms, templates, JS, HTML, content examples), read each file ENTIRELY (skipping files or parts of files is FORBIDDEN), reassess after the first pass and read more if needed, then propose the best solution (or multiple options) that is generic, clean, scalable, long-term, coherent with the existing architecture, and crucially NOT a duplicate of a system that already exists. Pairs with `defcode` — `whatdocs` handles the pre-implementation context-gathering, `defcode` handles the in-implementation execution discipline. Since v1.1, ends with the mandatory simplll → samepage-brainstorming gate.
- **Last updated:** 2026-08-25 v1.3 (**second entry point declared: `/plan-build` STEP 0.** This skill now runs at the head of every build plan, not only before a code fix, so two things were added. (1) **The discovery TODO list is TEMPORARY under plan-build** — deleted at the alignment gate and replaced by the build-plan TODO list; two lists never coexist, because a leftover discovery list competes with the plan's own for the agent's attention. (2) A closing **"RUNNING INSIDE /plan-build — two substitutions"** block: step 2a's `=== PROPOSED SOLUTION ===` block is REPLACED by *"explain in simple terms what it is that we are trying to build"* (its fields demand a code answer and will drag a strategic project into a codebase — exactly how the 25 Aug INVESTORS session ended up proposing to revive a small CRM nobody had mentioned), 2b and 2c unchanged; and after the GO the flow continues into plan-build's steps, not `/defcode`. `plan-build/SKILL.md` STEP 0 stays authoritative on which of this skill's 14 sections apply — the section-by-section ruling lives there, deliberately not duplicated here.) Prior: 2026-07-16 v1.2 (⚠️ DELIVERY RULE added after a same-day field failure on the VPS: an agent ran the new ending but interleaved the PROPOSAL block and simplll explanation with tool calls — the user saw neither, only the gate question; its post-hoc "they didn't render" explanation was contradicted by mid-turn text having rendered fine minutes earlier in the same session. v1.2 restructures the ending: invoke simplll + samepage-brainstorming FIRST as tool calls, THEN deliver ONE final tool-free message containing PROPOSAL block + simplll explanation + gate opening in that order; mid-turn text explicitly does NOT count as delivering.) Prior: 2026-07-16 v1.1 (MANDATORY ENDING SEQUENCE added, replacing the old "wait for user approval" closing paragraph: (1) deliver the PROPOSED SOLUTION block, (2) auto-invoke `simplll` — the plain-English explanation must be delivered in the same message, loading the skill alone doesn't count, (3) auto-invoke `samepage-brainstorming` — announce the gate, expose shakiest assumptions, ask the first question, then stop. /defcode is LOCKED until the gate closes with an explicit GO; same-agent continuity into /defcode preserved. Incident-driven rationale: sessions run ~2h, human energy degrades, and the fresh-eyes discussion that saves an outcome must be structural, not optional. Designed with Fable 5.) Prior: 2026-05-15 (added)

### `defcode`

- **Source file:** `/home/ubuntu/img/defcode.md`
- **Trigger description:** see frontmatter `description:` field in `skills/defcode/SKILL.md`
- **Purpose:** Marc's live-production execution discipline — invoked when about to apply a fix, update, or new implementation to a live production app with real users and live payments. Enforces: a final context check before any file is touched, no modifying files Claude hasn't seen, per-file backup with descriptive suffix before edits, no "ninja" sed/awk/echo injection (Edit/MultiEdit only), route/endpoint matching across JS↔API (no `/resource/api/...` vs `/api/...` mismatches), auto-create-and-execute any migration scripts (don't make user run them), focus strictly on the task at hand (no scope creep), then after the work is done restart pm2 and write a SAFE test script (dry-run, no live emails or mass sends) that validates the fix actually works — not just that files changed. Pairs with `whatdocs` (the pre-implementation companion). Since v1.1, the CONTINUITY section requires the samepage-brainstorming gate to have closed with an explicit GO before execution.
- **Last updated:** 2026-07-16 v1.1 (gate guard added to CONTINUITY FROM /whatdocs — "approved" now means the samepage-brainstorming gate closed with an explicit GO; if the gate never ran, STOP and run it before touching any file; spec explicitly = the PROPOSED SOLUTION as amended by the gate conversation. Defense-in-depth mirror of whatdocs' ending lock, same pattern as defcode's existing duplicate re-check. Also: Rule 3 now notes MultiEdit was dropped in newer Claude Code versions — repeated Edit calls are equivalent (verified absent from the Fable 5 session toolset). Designed with Fable 5.) Prior: 2026-05-15 (added)

### `simplll`

- **Source:** pasted in chat 2026-07-16 (Marc's TextExpander clarity prompt — verbatim port, byte-verified via the cat + diff procedure)
- **Trigger description:** see frontmatter `description:` field in `skills/simplll/SKILL.md`
- **Purpose:** Plain-English, decision-ready explainer. Explains the What / How / Why CEO/Founder/Visionary-style — short lists, no dense engineer paragraphs, complete information — so Marc (juggling 3+ workstreams) can decide fast. Callable standalone on anything (a proposal, a system, a bug, a plan) AND auto-fired at the end of /whatdocs immediately after the PROPOSED SOLUTION block: loading the skill is not the job, the delivered explanation is.
- **Last updated:** 2026-08-23 v1.1 (**THE MOST IMPORTANT RULE** appended to the body, authored by Marc in chat and added verbatim — three rules: (1) stop reporting problems, give solutions; (2) we're here to get shit done, not to show how much you caught — don't over-explain, it's exhausting; (3) short phrases, keyword style, not long paragraphs. Placed at the END of the body deliberately: it is the last thing the agent reads before producing output, which is where a style rule bites hardest. Marc's typo "exausting" preserved under the verbatim rule — SKILL.md is canonical for this skill, there is no source .txt to sync.) Prior: 2026-07-16 (created — first new skill of the Fable 5 improvement pass)

### `samepage-brainstorming`

- **Source:** fresh-authored 2026-07-16 (not a verbatim port). Designed with Fable 5 during the skill improvement pass. Conversation engine deliberately reused from superpowers:brainstorming (one question per message, multiple-choice preferred, 2-3 approaches with recommendation, incremental validation, YAGNI, HARD-GATE pattern, "too simple to need this" anti-pattern) while dropping its artifact pipeline (no project-context exploration step, no design-doc/spec writing, no spec review gates, no visual-companion browser server, no writing-plans terminal state).
- **Trigger description:** see frontmatter `description:` field in `skills/samepage-brainstorming/SKILL.md`
- **Purpose:** The mandatory alignment gate between /whatdocs and /defcode — «we are not going to move forward until there's crystal clear evidence that you and I are on the same page». Agent announces the gate, exposes its 2-3 shakiest assumptions, then runs a 3-5-exchange clarification + brainstorming conversation (tracked silently, no turn-count bureaucracy): one decision-question per message, recommendations before options, "what just changed" stated after every answer, YAGNI allowed to shrink the proposal. Closes only on explicit user GO — an early GO gets exactly one pushback, then obedience; an explicit "skip the gate" is obeyed after a one-sentence risk statement. Visual forks get an artifact via artifact-design (Marc is a visual thinker); falls back to local HTML / mermaid sketch when the Artifact tool is unavailable. Never produces a spec document or code. Also standalone for any pre-execution alignment moment (subagentic-workflow Phase B approvals, plan reviews). Incident-driven rationale: sessions run ~2h, human energy degrades, and the fresh-eyes discussion that saves an outcome must be structural, not lucky.
- **Last updated:** 2026-07-16 (created)

### `how-marc-works-w-claude-code`

- **Source file:** `/Users/marcjovani/Downloads/how-marc-works-w-claude-code.md`
- **Trigger description:** Background context skill (`user-invocable: false`) — Claude loads it automatically during planning, brainstorming, or architecture decisions. Not invokable as a `/` command.
- **Purpose:** Marc's builder profile for architecture decisions. Covers: identity (vibe coder, not traditional programmer), the gold-standard web dev workflow (SSH → Claude Code → instant feedback), pain points that kill momentum (slow feedback loops, cross-platform friction, opaque toolchains, manual repetitive work), non-negotiable architectural principles (tight loop, text-native AI-first structure, automation over manual process, own the infrastructure, build for expansion / ship the minimum, team transferability), full technical context (stacks, servers, existing platform), and the CC-Sampler case study showing how the right infrastructure made C++ vibe-codeable (JUCE Docs MCP, clangd LSP, Pamplejuce CI/CD, CMake+Ninja+sccache 2-5s builds, naming-convention pipelines). Gives planning/executing agents the context to design for how Marc actually works instead of assuming a traditional developer workflow.
- **Last updated:** 2026-07-16 (frontmatter `name:` field said "how-marc-works" while the folder/slug is "how-marc-works-w-claude-code" — aligned to the slug per repo convention; every other skill's name field matches its folder. Zero spelling typos in 203 lines — "actionate" (line 33) flagged to Marc and deliberately KEPT as voice. No other changes.) Prior: 2026-06-22 (added)

### `handoff-continuia`

- **Source:** fresh-authored 2026-05-24 (not a verbatim port of an existing prompt). Designed end-of-session during the CC-Sampler legato build (Session 05/06), after the agent that closed Session 06 produced two known handoff failure modes: (1) forgot to mark completed phases ✅ in the milestone tracker, (2) conflated the §16 Session Log entry with the handoff prompt (deleted the doc entry when asked to "print handoff in chat").
- **Trigger description:** see frontmatter `description:` field in `skills/handoff-continuia/SKILL.md`
- **Purpose:** End-of-session boundary skill for any project set up with `/plan-build`. Designed as the closing-out companion to `/sowhatstheplan` (which handles start-of-session). Replaces Marc's manual ~20 min / ~200k-token end-of-session workflow with a targeted-reading version (~10 min / ~60-80k tokens) by relying ONLY on `/plan-build`'s guaranteed structural conventions (Active State section, Session Log section with structured entries, Cross-Session Continuity Protocol, Milestone Tracker, 🚨 / 🔬 / 🟢 markers) — no project-specific assumptions. Workflow: (1) detects LEAN vs DEEP mode based on what the session did + recommends one; (2) targeted-reads the plan doc's Status banner + Active State + Milestone Tracker + Cross-Session Continuity Protocol + latest Session Log entry + all 🚨/🔬 marker rows; (3) gathers session memory via `git status` / `git log` / the task list; (4) proposes 3 scoping options (relaxed / realistic / pushing it) for the next session with a recommendation and WAITS for Marc's pick; (5) writes a strict-template Session Log entry into the plan doc; (6) marks completed milestones in the tracker; (7) invokes `/doc-update-project` if `DOCUMENTATION.md` exists; (8) commits as one batched doc-updates commit; (9) prints a self-contained, strict-template handoff prompt in chat (NEVER buried in the plan doc — that's a `/plan-build` hard rule). Strict templates for both artifacts (Session Log entry + handoff prompt) prevent agent latitude that would reproduce Marc's known failure modes. Includes built-in `/research-prompt-instructions` reminder for any next-session 🔬 checkpoint, and `/frontend-design` reminder for any UI work. Coherence rule: when `/plan-build` adds/changes/removes a guaranteed structural convention, update this skill's Step 2 reading list to match — stay within `/plan-build`'s guaranteed vocabulary, never reference project-specific section numbers or naming.
- **Last updated:** 2026-07-16 v1.4 (typo + template-junk sweep under the pass's typo rule. Notable: THREE keyboard-mash placeholder strings ("asdlfjads", "asdlfjhalsdfh", "lajsdfhkasdjfh") were sitting inside the Step 4 scoping-options template — the block agents copy verbatim — replaced with real [one line] placeholders, the third now carrying the ~180k-budget callout it hinted at. Also fixed: nex→next, choosen→chosen, instrucions→instructions, trully→truly, many time→many times, Most of the times→Most of the time, comercial→commercial ×2, hunddreds→hundreds ×2, Some times→Sometimes, localy→locally, poing→point, aproval→approval ×2. Handoff-prompt gate-cadence line applied after Marc's approval — the template now tells the next agent that /whatdocs ends with the simplll + samepage-brainstorming gate and /defcode comes only after the explicit GO. No other structural changes.) Prior: 2026-06-24 (v1.3 — DEEP mode now default recommendation; LEAN/DEEP criteria rewritten for clarity; scoping options use plain-English pros/cons instead of risk levels; Session Log entries kept briefer — details go to DOCUMENTATION.md; handoff prompt template streamlined — removed boilerplate sections (HARD RULES, TODO LIST, FIRST COMMAND), added PERSONA line + skill workflow instructions (/whatdocs → /defcode → /handoff-continuia); added Step 9.6 clipboard copy for local Mac; removed rationale section). Prior: 2026-06-10 (added Step 9.5 plain-English sanity check). Prior: 2026-05-24 (added)

### `subagentic-workflow`

- **Source:** fresh-authored 2026-05-25 (not a verbatim port). Designed as an improved variant of `/superpowers:subagent-driven-development` that bakes Marc's `/whatdocs` + `/defcode` cadence into every subagent dispatch. Builds on `/handoff-continuia`'s strict-template prompt structure, applied here to controller→subagent dispatches instead of session→session handoffs.
- **Trigger description:** see frontmatter `description:` field in `skills/subagentic-workflow/SKILL.md`
- **Purpose:** Same-session subagent execution of a multi-task plan with Marc's full discipline baked in. For each task: dispatch ONE named subagent that performs BOTH `/whatdocs` research (Phase A — produces structured PROPOSED SOLUTION block, no code touched) and `/defcode` execution (Phase C — backup, edit, integrate, restart, SAFE test, produces structured EXECUTION REPORT). Between A and C: Phase B is a MANDATORY user-approval gate where Marc approves the proposal before any code lands. Same subagent across both phases via SendMessage — never dispatch a second subagent for the execute phase (the research mental model would be lost). Always Opus 4.7 (cheap-model-for-mechanical-tasks logic from the original is REJECTED — live prod code where the failure modes cheaper models miss cost money). After execution: two-stage review — spec compliance reviewer (verifies execution matches the APPROVED PROPOSAL) then code quality reviewer (verifies /defcode discipline: backups present, no ninja injection, no duplicate-named files, routes match, SAFE test, no assumptions). 4 files: SKILL.md + 3 prompt templates (implementer / spec-reviewer / code-quality-reviewer). Single-source-of-truth — the prompt templates POINT to /whatdocs and /defcode SKILL.md sections rather than duplicating content, so a change to the source skills propagates automatically. Pairs with `/plan-build` (which produces the plan being executed) and `/handoff-continuia` (which wraps each session boundary).
- **Last updated:** 2026-07-16 v1.2 (Phase B upgraded per Marc's "include it": the controller now runs the full clarity + alignment gate with Marc — relay the proposal verbatim, deliver the simplll explanation, open samepage-brainstorming (assumptions + first question), close only on explicit GO; if the gate amends the proposal, the delta bullets ride the "Approved by Marc" SendMessage and the amended proposal is the spec. The old "'Looks fine' counts as approval" rule replaced by the gate's early-GO handling. Subagent never participates in the gate. Closes the OPEN item from v1.1.) Prior: 2026-07-16 v1.1 (two real-bad fixes, designed with Fable 5. (1) MODEL PIN REMOVED: every `model: "opus-4-7"` dispatch param and Opus-4.7 reference across SKILL.md + all 3 templates replaced with the omit-model-param inherit pattern, per the Jun 2026 subagent-model-inheritance learnings — a pin silently DOWNGRADES subagents the day the session runs a newer model, the opposite of the never-downgrade intent; principle unchanged, now future-proof with zero model names baked in. (2) GATE COLLISION FIX: whatdocs v1.2 / defcode v1.1 introduced the simplll + samepage-brainstorming ending gate, which a literal-following implementer subagent would try to run INSIDE the subagent — stalling on an alignment conversation that belongs to Marc. implementer-prompt.md now carries two explicit exceptions: skip whatdocs' MANDATORY ENDING SEQUENCE (the gate IS Phase B, run controller↔Marc), and the controller's "Approved by Marc" message counts as the explicit GO satisfying defcode's CONTINUITY gate-guard. No typos found. OPEN for Marc to decide later: upgrade Phase B itself to run simplll + samepage-brainstorming between controller and Marc instead of plain relay-and-approve.) Prior: 2026-05-25 (added)

### `grammar-polish`

- **Source:** pasted in chat 2026-06-08
- **Trigger description:** see frontmatter `description:` field in `skills/grammar-polish/SKILL.md`
- **Purpose:** Two-pass manuscript editing skill. Pass 1 fixes only grammar, spelling, duplicate words, and broken markdown — surgical, minimal edits preserving the author's casual/conversational voice. Non-grammar issues (clarity, ambiguity, awkward phrasing) are listed as suggestions only, not applied. Pass 2 (clarity) runs only if the author approves — tightens nested clauses, mixed verb forms, dangling phrases, buried subjects, and unnecessary words while preserving the author's register. Rules: propose each change with explanation before applying, rewrite the minimum, never add ideas the author didn't write, don't make it "proper" — make it clear.
- **Last updated:** 2026-07-16 (one-character fix: the Pass-1 "Do you want me to do a pass on Clarity?" script block opened a quote that never closed — ironic for a skill whose job includes fixing mismatched formatting. Zero typos otherwise; cleanest skill of the Fable 5 pass alongside sowhatstheplan.) Prior: 2026-06-08 (added)

---

### `claudeclarity`

- **Source:** created locally 2026-04-27; brought under version control 2026-07-31
- **Trigger description:** see frontmatter `description:` field in `skills/claudeclarity/SKILL.md`
- **Purpose:** Reader-first writing discipline for anything a cold reader has to understand — event/offer/product/audience definitions, hand-off briefs, and copy that downstream agents derive ads/hooks/titles from. Seven moves applied in order: subject discipline (is the doc about the subject, or drifting onto the speaker's credentials?), reader-first composition, capability framing over concept framing (verbs the reader will *do*, not nouns they'll *learn*), concept-name translation in the same sentence, verbatim preservation of the user's own words, cruft detection (metadata blocks, status banners, "how to update" sections), and a one-screen budget (~50 lines) as a forcing function. Closes with an acceptance test that must be all-yes before showing the user.
- **Note:** this skill lived only in `~/.claude/skills/` for three months — it was never in the repo, so it wasn't backed up and wouldn't survive a fresh install. Moved in on 2026-07-31.
- **Last updated:** 2026-07-31 (version-controlled)

### `team-discussion`

- **Source:** fresh-authored 2026-08-21 (not a verbatim port). Designed and battle-tested inside a live three-way session (Marc + two agents) on the robot-friend project, where an unbounded agent-to-agent protocol produced ~18 messages of monotonically decaying value — the last eight being agents correcting each other's summaries and then designing bookkeeping infrastructure for their own dysfunction. Every rule in the skill is a fix for a failure actually observed in that session; the Failure Log inside `SKILL.md` records which rule pays for which failure.
- **Trigger description:** see frontmatter `description:` field in `skills/team-discussion/SKILL.md`.
- **Purpose:** Turns "user + 2 AI agents" into a disciplined team rather than a debate club. One rule generates the rest: **state lives in files, conversation is only for disagreements that would change the user's decision.** OWNER holds the pen (sole writer of `LEDGER.md` + `DESK.md`; every user-facing rendering cites row IDs and carries evidence tags inline, so compression drift has nowhere to hide). VERIFIER holds the red pen (unlimited reading, bounded speaking, 🔴-only, no competing artifacts). A severity gate (🔴 blocking / 🟡 file-edit-only / ⚪ banned) plus seven loop-breakers bound each exchange; a separate **END-STATE** rule bounds the *discussion* — necessary because ten individually well-terminated exchanges still produced a spiral, i.e. bounds do not compose upward for free. Marc's two amendments are rules 6 and 7: **check before you contest** (no arguing from memory about anything a web search or a satellite deep research can settle — a research flag is a trigger, not a label) and the **pre-send intent note** (the user is briefed in ≤3 plain-language lines before any agent-to-agent message, so they gate traffic instead of reading wreckage).
- **Bundled tools:** none. Category 1, pure Markdown — `SKILL.md` plus `references/LEDGER-template.md` and `references/DESK-template.md`, symlinked whole.
- **Per-machine setup:** none. Load the skill in two or more sessions pointed at the same problem. Roles resolve deterministically — first agent the user addresses becomes OWNER and claims it in `DESK.md` line 1; any agent finding OWNER already claimed becomes VERIFIER — so forgetting to assign roles is harmless, and the user's plain-language assignment always overrides the default.
- **Last updated:** 2026-08-25 v1.3 (**THE RELAY — the lead now changes hands once, and the named pairing is reversed.** Marc's order after a live INVESTORS plan-build session: **Fable is OWNER for Leg 1** (the mandatory `/whatdocs` discovery pass, the brainstorming conversation, the alignment gate) and **Opus is OWNER for Leg 2** (continues the `/plan-build` process from wherever Leg 1 left off — skipping no steps — and owns it until the end; the steps live in `plan-build/SKILL.md`, deliberately not restated in the relay). The handover fires at one named boundary — **the moment the user approves the design** — not at a token count and not at anyone's convenience: Fable writes a final ledger pass, updates the desk, and hands the pen in one message. **Opus's first act on taking the pen is deciding whether more questions are needed** — it reads `LEDGER.md` + `DESK.md` and asks the user before writing anything if the brainstorm left a hole. The message budget does NOT reset at the handover — one discussion, one counter, only the user re-arms it. Also added: the VERIFIER reads in parallel *during discovery* — the one stretch where its unlimited-reading budget pays double, since a contextualized VERIFIER can catch a misread in the ledger before it hardens into the plan's frame. Supersedes v1.1's Opus-is-OWNER default for this pairing.) Prior: 2026-08-21 v1.2 (**gloss rule** added to the user-facing contract, from live use: a row ID may never be cited naked — every `L7`/`E3`/`C1` reference carries a short plain-language gloss on first appearance in a message. Row IDs are the agents' index, not the user's memory; Marc's own words: *"always give me a mini reminder of what you're talking about... I'm not a robot with this type of memory to remember simbol to coencept connection."* This closes a real hole: the protocol already REQUIRED renderings to cite row IDs, which without this rule actively made renderings less readable.) Prior: 2026-08-21 v1.1 (added the **named pairing** default to the bootstrap section, per Marc's standing rule: when Opus and Fable are both in the room, Opus is OWNER and Fable is VERIFIER unless he says otherwise. The deterministic first-addressed rule still governs every other pairing, and the user's plain-language assignment overrides both.) Prior: 2026-08-21 (created)

---

## Powerup taxonomy

This repo distributes three categories of powerup, each with different distribution mechanics. The `cc-google-ads` skill (added 2026-05-08) was the first to introduce categories #2 and #3.

### 1. Skills (Markdown, propagate via symlink)

Operator playbooks Claude reads at session start. Pure Markdown, no runtime dependencies. Distributed automatically by `install.sh` / `pull.sh`: each `skills/<slug>/` folder is symlinked into `~/.claude/skills/<slug>/` on every server.

Examples: `distill-general-conversations`, `plan-build`, `sowhatstheplan`, `cc-google-ads`.

This is the dominant category — all 20 skills in this repo include a `SKILL.md`. Most live entirely as Markdown (the verbatim-port ones plus `sowhatstheplan`); a few include reference sub-folders (`hook-creator/references/`, `scroll-stop-builder/references/`).

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

   <BODY OF THE SOURCE PROMPT>
   ```
   **On this first pass, port the body as-is** — no rewriting, no "small fixes", no cleanup. You haven't seen the prompt work yet. Once it's in, the skill is editable like any other file in this repo.

   To copy the body cleanly, write the file via Bash + `cat` rather than the Write tool:
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
   Then confirm the body copied cleanly:
   ```bash
   tail -n +6 skills/<slug>/SKILL.md > /tmp/skill-body.txt
   diff /tmp/skill-body.txt "<path to source .txt>"
   ```
   Expect an empty diff on the initial port — it catches a truncated or mangled copy. Later edits will make this diff non-empty, which is normal and expected.
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

- **Port as-is, then evolve.** Marc's prompts work for him as-is, so the first pass copies the body rather than "improving" a prompt nobody has watched run yet. After that, skills are living documents — edit them as they evolve. Preserve Marc's voice, not the original bytes. (The old byte-for-byte "verbatim-port rule" was retired 2026-08-25: it had hardened into a rule that made routine, correct edits — typo sweeps, dead tool names — read as violations, and agents kept flagging them at Marc.)
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

**As of 2026-05-15 (whatdocs + defcode added — Marc's two-phase fix protocol):**
- Two new verbatim-port skills added that together encode Marc's full fix-on-live-app discipline:
  - **`whatdocs`** (source: `/home/ubuntu/img/whatdocs.md`) — pre-implementation context-gathering protocol. Forces a TODO-first response, mandatory file-listing + entire-file reading before proposing any solution, and a final solution-quality check (must be generic, scalable, long-term, coherent with architecture, and NOT a duplicate of an existing system).
  - **`defcode`** (source: `/home/ubuntu/img/defcode.md`) — in-implementation live-prod execution discipline. Forces backup-before-edit, no-ninja-injection (Edit/MultiEdit only), route/endpoint matching, auto-execute migrations, focus on task at hand, restart pm2 + write SAFE test script (dry-run, no live mass-sends) after the fix is applied.
- Catalog entries added; repository tree updated; both skills slugged using Marc's TextExpander-style filename shorthand (matches the `whatdocs.md` / `defcode.md` source filenames).
- Operational note: this session also exposed an `install.sh` foot-gun — running it from a non-canonical clone (e.g. a `/tmp/marc-jovani-powerups` clone created for exploration) repoints every `~/.claude/skills/<slug>` symlink to that clone's location. Recovery is just re-running `install.sh` from the canonical `/home/ubuntu/marc-jovani-powerups`. No code change applied; documenting here so future cold agents know to always operate the install from the canonical clone.

**As of 2026-07-16 (Fable 5 skill improvement pass — clarity + alignment gate):**
- Two new skills: `simplll` (verbatim port of Marc's TextExpander clarity prompt, byte-verified) and `samepage-brainstorming` (fresh-authored alignment gate — reuses superpowers:brainstorming's conversation engine, drops its spec/artifact pipeline).
- `whatdocs` v1.1: MANDATORY ENDING SEQUENCE — PROPOSED SOLUTION → auto-simplll (explanation delivered in the same message) → auto-samepage-brainstorming (first question asked, then stop). /defcode locked until explicit GO.
- Same-day field test on the VPS caught a delivery failure (agent buried the PROPOSAL + simplll explanation mid-turn; user saw only the gate question) → `whatdocs` v1.2 DELIVERY RULE: skills invoked first as tool calls, then ONE final tool-free message carrying all three deliverables. `defcode` v1.1: gate guard in CONTINUITY (explicit GO required; spec = proposal as amended by the gate) + MultiEdit availability note.
- `plan-build` genericized beyond coding (description, research triggers, 10x examples incl. learn-from-prior-implementations — successes AND failures, adaptive Documentation Protocol) + consistency fixes (Section 11 → Session Log section; stale resss → /research-prompt-instructions; EDITDOC → Edit tool; exact how-marc-works slug) + 19-typo sweep incl. the REDACT false friend. Source `-plania.txt` on VPS untouched — SKILL.md canonical from now. NEW PASS RULE from Marc: every skill reviewed from here on gets typos listed + fixed.
- `research-prompt-instructions` v1.3: 21-typo sweep + "codebase (or materials)" genericization; ⚖️ rejected the forced-recommendation output shape (rationale in catalog). `subagentic-workflow` v1.1: model pin removed (omit-param inheritance per Jun 2026 learnings) + gate-collision fix (subagents skip the whatdocs ending gate; controller's "Approved by Marc" = the GO).
- `handoff-continuia` v1.4: typo sweep incl. 3 keyboard-mash placeholders inside the Step 4 scoping template; handoff prompt now teaches the gate cadence (Marc-approved).
- Repo-wide sweeps (Marc-approved): FORVIDEN → FORBIDDEN everywhere (whatdocs incl. its description, defcode ×3, samepage-brainstorming, subagentic implementer prompt, catalog quote); TodoWrite → task tools (TaskCreate/TaskUpdate), with a "(formerly TodoWrite)" breadcrumb kept at the three START-BY-CREATING-A-TODO-LIST instruction sites for older-Claude-Code compatibility. Postcheck grep: zero FORVIDEN remaining; TodoWrite remains only inside the three breadcrumbs.
- `sowhatstheplan`: post-briefing cadence line + "active/bleeding" typo fix in the LOCKED format (both Marc-approved). `plan-build`: Active State question made CONDITIONAL (GREENFIELD RULE) after Marc's field feedback — "anything bleeding?" no longer fires on brand-new projects; the $200/day-class protection stays fully intact for live-adjacent projects.
- `doc-new-project` v1.2 + `doc-update-project` v1.2: typo sweeps (7 + 16, incl. the "good low"→"good, now" fossil) and doc-update's description-body consistency fix (Next Steps conditionality now reflected in the frontmatter).
- Distill trio reviewed: `distill-general-conversations` is a generation ahead — zero typos, zero changes needed. The two educational distills got 23/26-typo sweeps (shared family: destiled, ASSES, parnet, fabricatet…; audio also had "name if the teacher"→"of"). Both already say TASKCREATE + Edit tool — no tool-name work needed. Backport applied (Marc-approved): both educational distills gained the general skill's Pre-flight Questions + name-registry blocks.
- `grammar-polish`: one-character fix (unclosed quote in the Pass-1 script). Otherwise spotless.
- `subagentic-workflow` v1.2: Phase B now runs the full simplll + samepage-brainstorming gate controller↔Marc (closes the v1.1 OPEN item).
- `how-marc-works-w-claude-code`: frontmatter name aligned to the folder slug; zero typos ("actionate" kept as voice). Deliberately NOT reviewed (Marc's call): hook-creator, scroll-stop-prompter, scroll-stop-builder (downloaded alpha bundles), cc-google-ads (operational, battle-hardened, has its own maintenance protocol — don't touch without a live Ads context).
- Fixed on this Mac: `grammar-polish` symlink was missing — re-ran `./install.sh` from the canonical clone.
- Everything stays local until the pass completes (no `./update.sh` yet).

**As of 2026-07-31 (config surface brought into the repo + `plan-build` v1.5):**
- The repo now manages the Claude Code **config surface**, not just skills: `global/CLAUDE.md`, the two portable personas (`CLAUDEDEV` / `CLAUDEREG`), `config/settings.json`, `config/statusline-command.sh`, `config/hooks/persona-picker.sh`. `install.sh` gained replace-with-backup behavior — a real file sitting at a managed path is moved to `~/.claude/_powerups_backups/` and replaced by the symlink. Server-specific personas are never read, moved, or deleted. See "What the repo manages, and what it never touches".
- `claudeclarity` brought under version control after three months living only in `~/.claude/skills/` (it would not have survived a fresh install).
- `plan-build` v1.5: new **STEP 6.5 SELF-EVALUATION — MANDATORY GATE** between printing the section list and creating the skeleton. Three ultrathink questions (over-engineered? too complex? did the late conversation crowd out the early conversation?) — any hit means redo the structure list. Fixes the failure mode where a plan doc comes out bloated and recency-weighted, with the first half of the discussion thinned to sub-bullets. Companion skills (`/handoff-continuia`, `/sowhatstheplan`) deliberately unchanged — the gate changes the planner's process, not the plan's structural conventions those skills read.
- Both commits published to `origin/master` this session.

**As of 2026-08-04 (first cross-machine install — the Mac; config surface made portable):**
- **This was the cross-server propagation test** that the previous session left open, and it failed on first contact. The Mac (`/Users/marcjovani`, powerups last installed 2026-06-11) pulled the 2026-07-31 config surface and `install.sh` would have broken it three ways at once. Caught before running, fixed at the root rather than worked around.
- **Root cause #1 — hardcoded home directory.** `config/settings.json` pointed at `/home/ubuntu/.claude/hooks/persona-picker.sh` and `/home/ubuntu/.claude/statusline-command.sh`. On macOS neither path exists, so the persona picker and the statusline would both have died silently. Fix: both now read `bash "$HOME/.claude/..."`. Safe because Claude Code passes hook commands to `sh -c` and runs `statusLine` through a shell too — the hooks docs say the shell "tokenizes the string, expands variables", and the statusline docs' own example uses a `~/.claude/...` path. Verified empirically on macOS before shipping.
- **Root cause #2 — `settings.json` cannot be a symlink.** It mixes shared setup (hook, statusline, `env`, `permissions`) with machine-specific state. The Mac has `superpowers` + `frontend-design` installed from `claude-plugins-official`; the VPS has them from `superpowers-marketplace` / `claude-code-plugins`. Symlinking would have pointed the Mac at marketplaces it does not have installed — **silently disabling both plugins** — and `extraKnownMarketplaces` would have pulled in a *second* copy of superpowers from obra's marketplace alongside the official one. It would also have wiped the Mac's `model: opus[1m]`, `theme`, `effortLevel`, `voice`, `alwaysThinkingEnabled`. Fix: `install.sh` gained `merge_settings()` — repo wins on shared keys, machine keeps everything in the new `MACHINE_LOCAL_KEYS` list, extra machine keys are left alone, pre-merge file backed up, idempotent on re-run. A previously-symlinked machine migrates automatically (the symlink's content is seeded into the new real file first); a brand-new machine gets the repo file wholesale.
- **Root cause #3 — the statusline script was wrong on both sides, in different places.** The Mac's copy read `.workspace.cwd`, which is not a field Claude Code sends, so it always fell through to `.workspace.project_dir` and displayed the *launch* directory instead of the current one. The repo's copy read `.cwd` (correct) but formatted millions with `bc` at `scale=1`, which truncates — 1,499,999 tokens rendered as `1.4M`. Merged version takes the correct half of each: `.workspace.current_dir // .cwd // empty` (documented-preferred field, documented fallback) and `bc -l`, which rounds. Both halves verified against synthetic payloads built from the documented JSON schema.
- Net effect on the Mac: `claudeclarity` symlinked (it was missing), `plan-build` v1.5 live, `CLAUDE.md` + both personas now repo-managed symlinks (they were stale real files missing the *Default Register* block and the *Deferred follow-ups* rule), settings.json merged with every Mac-specific preference and all four plugins intact.
- ⚠️ **The VPS has not pulled this yet.** On its next `./pull.sh`, `merge_settings()` will convert its symlinked `settings.json` into a real file seeded from that same content — so its plugin set and preferences survive — and only the two `$HOME` paths change. Expected output there: `UNLINK settings.json` followed by `MERGE settings.json`.
- Workflow change worth knowing: `/config` no longer writes through to `config/settings.json` (it isn't a symlink anymore). Repo-wide changes are made by editing `config/settings.json` and running `./update.sh`; single-machine changes go through `/config` as before.

**As of 2026-08-25 (task tools re-enabled by the installer + verbatim-port rule retired):**
- **Root cause found.** Claude Code v2.1.233 turned the todo/task-tracking tools OFF by default on Opus 4.8, Sonnet 5, Fable 5, Mythos 5 and newer. Anthropic's stated reason, verbatim from their tools reference: *"Those models keep track of multi-step work without a written checklist, and the tools' definitions and reminders take up context, so Claude Code leaves them out."* Restored with `CLAUDE_CODE_ENABLE_TODO_TOOLS=1`. Every skill in this repo that says "start by creating a task list" had been calling tools that silently weren't there — including the global `CLAUDE.md` rule that exists to catch skills which forget.
- **Measured, not assumed** (harness `system.init` tool list, `claude-opus-5[1m]`, not model self-report): no flag → no task tools at all; `ENABLE_TODO_TOOLS=1` → `TaskCreate` + `TaskGet` + `TaskList` + `TaskUpdate`; `ENABLE_TODO_TOOLS=1` **plus** `ENABLE_TASKS=0` → `TodoWrite` only, Task family gone. **The two families are mutually exclusive** — no configuration yields both. We standardise on the Task family; `TodoWrite` is the legacy tool Anthropic superseded.
- **The installer now owns this.** `CLAUDE_CODE_ENABLE_TODO_TOOLS=1` added to `config/settings.json`'s `env` block, so `merge_settings()` propagates it to every machine on every `./install.sh` — no new mechanism, the existing merge already deep-merges `env` and `env` is not machine-local. New `verify_env_keys()` re-reads the **installed** `~/.claude/settings.json` and reports per key (`OK` / `FAIL`), because `merge_settings()` returns 0 even when it skips for a missing `jq` — a silent skip would have left the tools dead with the install still reporting success.
- **Skill sweep** (all 38 live `.md` files read in full, 8,368 lines): `global/CLAUDE.md`'s Skill Execution Discipline rewritten off `TodoWrite` onto `TaskCreate`/`TaskUpdate`, plus a fallback line for sessions without the tools. The three `(TaskCreate/TaskUpdate — formerly TodoWrite)` breadcrumbs (`whatdocs`, `defcode`, `handoff-continuia`) removed — kept in July for older-Claude-Code compatibility, they now name a tool the flag deliberately does NOT provide. `plan-build`'s generic "using their todo tool" and `doc-update-project`'s unnamed "START BY CREATING A TODO" now name the tools. Already-correct sites left alone: `subagentic-workflow` + its 3 templates, all three `distill-*`, `manager-checkout`, `manager-close`.
- ⚖️ **Verbatim-port rule RETIRED (Marc's call).** *"This was an agent making it a stupid rule that now overflags things. Yes, originally these skills were exact copies of my prompts. But they evolve. This rule no longer applies."* Replaced with "port as-is on the first pass, then evolve" — preserve Marc's voice, not the original bytes. Removed from all three sites (the rule section, step 5 of the add-a-skill procedure, the Decisions & rationale bullet); the byte-diff step survives only as a truncated-copy check on the initial port.
- **Note for the VPS:** `whatdocs` / `defcode` sources at `/home/ubuntu/img/*.md` were not touched (not on this Mac). `SKILL.md` is canonical for both.

**Future improvement — PER-SERVER SEPARATION (Marc, 12 Aug 2026, not scheduled):**
Today the installer has **no filter**: it ships 100% of `skills/` to every machine, and the only separation is placement — `server-specific/` is invisible to `install.sh` and gets symlinked by hand. Binary, with nothing in between. What Marc wants instead:
1. **One universal folder** that installs on any server, no questions asked.
2. **Per-server folders** that install only where they belong — and the installer does NOT guess: **the agent running the install asks Marc which additional folders belong on THIS server**, then links those.
3. **This documentation carries that instruction**, so a cold agent installing on a new machine knows to ask rather than assume.
Context that motivates it: 5 of the 22 travelling skills assume the surfvani server (`cc-launch-pace` and `cc-google-ads` have hard dependencies; the two doc skills and `how-marc-works-w-claude-code` only mention it in prose — and that last one *should* travel). They are inert elsewhere, not broken, which is why this is an improvement and not a bug. Full capture, with Marc's words and design notes: `NORTH_STAR/BOARDS/PROJECT_HERO/inbox/POWERUPS_IMPROVEMENTS.md` #1.

**Next, when Marc resumes:**
- Run `./pull.sh` on the Ubuntu VPS to complete the propagation test in the other direction, and confirm the `UNLINK` → `MERGE` migration path behaves as designed there.
- Add more skills from Marc's prompt library as they get authored.
- When the collection is stable, evaluate wrapping it as a plugin (`plugin.json` + `marketplace.json`) for `/plugin install`-style distribution to other servers.
- Cross-server propagation test: **done in the VPS → Mac direction on 2026-08-04** (see that session entry — it surfaced three real portability bugs). Still unexercised: the venv creation path on a genuinely cold machine, since the Mac already had the `cc-google-ads` venv from June.
