---
name: hook-creator
description: |
  Extract 20 captivating hook-style book/course/module/episode titles from any
  long-form work (manuscript, transcript, chapter, course module, book draft) by
  running the Schwartz-style 6-pass extraction discipline (Idea × Avatar × Pattern).
  Use this skill whenever Marc provides a body of long-form content and asks for
  hook ideas, title candidates, marketing angles, "what should I call this", "name
  this episode", or anything in the Tim-Ferriss-found-the-4-Hour-Workweek-inside-
  his-book / James-Clear-found-Atomic-Habits-inside-his-research family. Default
  avatar: Cinematic Composing student (loaded automatically from references/).
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Hook Creator — Schwartz-Style Editorial-Mimic (v0 alpha)

## What this skill does

Given a long-form input (manuscript, transcript, chapter, module — typically 5K-200K words) and an avatar definition, produces **20 ranked hook-style titles** engineered along three axes:

- **IDEA** — the captivating sub-idea hidden inside the broader work (the Atomic-Habits-inside-the-habits-book move)
- **AVATAR** — matched to the avatar's verbatim language, awareness level, and Mass Desire (Schwartz)
- **PATTERN** — coined-noun, number+unit+noun, anti-X, how-to-without-Y, etc., from the named-pattern catalog

This is **alpha v0**. The discipline is the 6-pass procedure documented in `references/03-hidden-hook-extraction-research.md` Section H. Quality scales with avatar-doc quality.

## When to invoke

Invoke when Marc:
- Provides a path to a manuscript, transcript, course module, book chapter, or long article and asks for hooks/titles/angles/marketing/"what should I call this"
- Says "find the hook in this", "name this", "what's the captivating idea", "give me title candidates"
- Is mid-launch and needs viral angles for a piece of long-form content

Do NOT invoke for:
- Short briefs <1,500 words → ask Marc to either expand or run a quick brainstorm without this skill
- Pure short-form video opener hooks → that's the `viral-you` skill's job (different beast)
- Generic copywriting that isn't tied to a specific long-form work

## Inputs the skill needs

Before running, confirm with Marc (or extract from the message):

1. **Content path** — path to the long-form file (`.md`, `.txt`, `.pdf` extracted, etc.)
2. **Avatar path** — defaults to `references/avatar-cinematic-composing.md`. Marc can override (e.g. for non-Cinematic-Composing brands)
3. **Output count** — defaults to 20. Marc can ask for 10 / 30 / 50.
4. **Brand-safety polarization cap** — defaults to ≤3/5 (educator brand). Marc can lift to 5/5 for spicier launches.

If the content file is missing or unreadable, STOP and ask Marc.

## The 6-pass procedure

Execute all 6 passes in a single Claude Code conversation. The model reads files via the Read tool (no API prompt-caching needed — the 1M context window holds everything).

### Pass 0 — Load context

1. Read the **content file** in full.
2. Read the **avatar doc** (`references/avatar-cinematic-composing.md` unless overridden).
3. Read the cognitive backbone & pattern taxonomy from `references/02-frameworks-and-cognitive-science-research.md` Sections B (book-title patterns), C (headline patterns), D (avatar engineering), E (cognitive science), G (idea×avatar×pattern matrix).
4. Read the 15-signal detection rubric and 6 prompt templates from `references/03-hidden-hook-extraction-research.md` Sections G and H.

If the clawfu MCP server is connected (look for `clawfu_*` tools), optionally query it for the Schwartz Awareness, Hormozi MAGIC, Cialdini, Heath SUCCESs, and Ogilvy framework cards as additional grounding. Skip silently if the MCP isn't available.

### Pass 1 — Inventory (8 categories, 10+ items each)

Read the manuscript twice mentally as Eugene Schwartz read manuscripts at 3 a.m. Then produce a structured inventory in **exactly 8 categories**, each with at least 10 items quoted or paraphrased from the content with a chapter/section reference:

1. **PROMISES** — every transformation, outcome, or end-state the work promises
2. **OBJECTIONS** — every skepticism, doubt, or "yeah but" the avatar would raise
3. **CURIOSITY GAPS** — every question the work opens but does not immediately close
4. **COUNTER-INTUITIVE CLAIMS** — every assertion that violates conventional wisdom in the avatar's world
5. **SPECIFICITIES** — every concrete number, named timeframe, named technique, named person, named piece, named studio
6. **STORIES/ANECDOTES** — every narrative moment, especially off-hand or jaw-dropping anecdotes
7. **MECHANISMS** — every named how-it-works construct, every "the reason this works is X" passage
8. **IDENTITY/STATUS** — every implicit "the kind of composer who does this is..."

Output a markdown table. No commentary.

### Pass 2 — Coining

For each row in the inventory, generate **2–4 candidate hook-style names** following these constraints:

- 2 to 6 words
- Noun phrase, not sentence
- One coined or repurposed term where possible (Atomic Habits, Antifragile, Deep Work, Lean Startup, Purple Cow, Sapiens, Blue Ocean, Linchpin, Hooked, Drive, Grit)
- Must use vocabulary that appears in the avatar's verbatim language (consult avatar doc)
- MAY include one number or specific (4-Hour Workweek, 10,000 Hour Rule, 80/20 Principle)
- MUST avoid: jargon-only academic titles, generic gerund titles ("Composing for Films"), "ultimate guide" patterns, AI-cliché openings ("Unlocking", "Mastering", "The Power of")

Output: `candidate name | source row | pattern matched (from pattern taxonomy)`

### Pass 3 — 15-signal scoring

For each candidate, score **0–5 on each of the 15 signals** from `references/03-hidden-hook-extraction-research.md` Section G:

1. Counter-intuitive
2. High specificity
3. Coined/nameable
4. Avatar-resonant
5. Promise-laden
6. Memorable (Heath SUCCESs — 6-axis sub-score)
7. Anchorable (could hold a 1-hour talk)
8. Defensible (author's authority)
9. Inevitable-sounding
10. Polarizing (CAP at the user-set polarization limit, default 3)
11. Mechanism-implication
12. Category-creating
13. Nut-graf compatibility
14. Talking-to-strangers test
15. 30-year test

For each non-zero score, **give a one-sentence justification quoting either the manuscript or the avatar doc verbatim**. No score without quoted evidence.

**SUCCESs gate**: candidates scoring <18/30 on the 6 SUCCESs sub-axes are eliminated.

Output a scorecard table sorted by weighted score:
```
W = (avatar*0.25 + counter_intuitive*0.15 + coined*0.15 +
     defensible*0.10 + anchorable*0.10 + mechanism*0.10 +
     category*0.05 + inevitable*0.05 + polarizing*0.05) ×
     (1 if SUCCESs >= 18 else 0)
```

### Pass 4 — Adversarial review (top 30 only)

Run three personas in parallel against each of the top 30 candidates:

**A) SKEPTICAL TRADE EDITOR (Adrian Zackheim style):**
- "Would I gasp?" (Ogilvy Q1)
- "Do I wish I'd thought of this?" (Ogilvy Q2)
- "Could this be used in 30 years?" (Ogilvy Q5)
- Score 0–5 overall + one-sentence verdict

**B) AVATAR (the actual avatar from the doc):**
- Would I click this in an email subject line? Y/N
- Would I screenshot this title and send to a peer? Y/N
- Does it use a phrase I would actually say? Quote it.
- Score 0–5

**C) STEVEN PRESSFIELD-STYLE CRAFT SKEPTIC:**
- Is this real, or is it a marketing wrapper around vapor?
- Can the author defensibly hold a 60-minute talk on this without repeating themselves? Y/N
- Score 0–5

**Final candidate score** = `0.4*Avatar + 0.4*Editor + 0.2*Skeptic`

### Pass 5 — Final output (top 20)

Produce final ranked top 20 hooks. For each:

1. **Hook title** (the candidate)
2. **Source** — chapter/section + 1-sentence quoted passage
3. **Pattern** — which named pattern (from book-title or headline taxonomy)
4. **Avatar quote** — verbatim avatar language this hook activates
5. **Mechanism implied** — what the title promises to teach
6. **Signal scorecard** — 15-row condensed table
7. **Why this works** — 2–3 sentence editorial rationale
8. **Nut graf** — what paragraph 2 of a feature story would say (50 words)
9. **Subtitle suggestion** — 6–14 word descriptive complement (4-Hour-Workweek-style "Escape 9-5, Live Anywhere…")
10. **A/B test recommendation flag** — mark "PICKFU-CANDIDATE" on the top 5

**Diversity check**: ensure no two hooks share the same coined-noun root. If they do, demote the lower-scoring one and pull the next from rank 21+.

Format as markdown. Begin with the ranked table; full per-hook detail follows.

### Pass 6 — Save the run

Write the full output to `~/.claude/skills/hook-creator/runs/<YYYY-MM-DD-HHMM>-<short-slug>/output.md`. Slug = first 4 words of input filename, kebab-cased. Also save the raw inventory (Pass 1) and scorecards (Pass 3, Pass 4) in the same dir as `inventory.md`, `scores.md`, `adversarial.md` for traceability.

Print the path when done so Marc can `cat` it.

## Operational notes

- **Model**: this is an Opus-4.7 / Sonnet-4.6 task. Don't run it on Haiku.
- **Latency**: expect 5-10 minutes end-to-end on real long-form content.
- **First-run quality**: avatar quality is the cap. If outputs feel generic, the avatar doc is too thin — re-author with voice-of-customer mining (Reddit, forums, testimonials, sales calls) before iterating prompts.
- **Polarization cap**: default ≤3/5 for the educator brand. Lift to 5/5 only when Marc explicitly asks for "spicy" or "viral" mode for a non-evergreen launch.
- **Failure modes to watch for**:
  - Pass 2 generates academic-sounding nouns → reseed with a Pass-2 example block of 30 named bestsellers (Atomic Habits, Antifragile, Deep Work, Lean Startup, Sapiens, Purple Cow, Linchpin, Hooked, Drive, Grit, Influence, Mindset, Outliers, Originals, Shoe Dog…)
  - Pass 4's avatar persona uses generic phrases → reload avatar doc verbatim and force quoting
  - Outputs all sound similar → manually run an MMR-style diversity demote in Pass 5
- **Don't fabricate manuscript quotes**. If a signal can't be supported by a verbatim quote, score it 0. Better to have low scores honestly than inflated scores from confabulation.

## After the run

Tell Marc:
- The output file path
- The top 5 (PICKFU-CANDIDATE flagged) for immediate review
- Any avatar-doc gaps you noticed (e.g., "the avatar doc has no language for X — outputs in that lane are weaker")
- Whether anything in the content felt under-developed and might warrant a follow-up "expand the X angle" pass

## Future evolution (not for v0)

- Add `scripts/mmr_diversify.py` (sentence-transformers + sklearn) — only if Pass 5 keeps surfacing same-noun-root duplicates after the in-prompt diversity check
- Add a sister `pickfu-tester` skill — takes the top 5 and constructs PickFu poll specs
- Wire DSPy MIPROv2 prompt-optimization once 30+ runs accumulate in `runs/` with downstream PickFu winner data
- Add a sibling `avatar-builder` skill — voice-of-customer mining (Reddit, Spitfire forums, testimonials, sales calls) → richer avatar doc

## Reference index

- `references/avatar-cinematic-composing.md` — default avatar (symlinked to live source)
- `references/01-existing-solutions-research.md` — landscape map (which tools exist & why we chose this stack)
- `references/02-frameworks-and-cognitive-science-research.md` — pattern taxonomy, avatar engineering, cognitive backbone, idea×avatar×pattern matrix
- `references/03-hidden-hook-extraction-research.md` — the methodology (Procedure 3 / Section H), 15-signal rubric (Section G), 6 prompt templates verbatim
- `runs/<timestamp>-<slug>/` — every run logged for future eval
