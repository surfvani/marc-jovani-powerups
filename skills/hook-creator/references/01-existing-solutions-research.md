# Existing Solutions Landscape — Hook Creator (Claude Code Skill)

**BLUF:** The closest existing artifact to your "Hook Creator" vision is **`realkimbarrett/advertising-skills`** (chainable Eugene Schwartz–awareness mapper + headline-matrix + ad-angle-multiplier), which you should fork as the architectural skeleton, then layer Hormozi's MAGIC formula and the SUCCESs/AIDA/PAS pattern decks from **`clawfu/mcp-skills`** and **`wondelai/skills`** on top — none of these alone do book-title concept naming from long-form ingestion, but together they collapse roughly two weeks of from-scratch framework engineering into a 2-day fork. Nothing in the current OSS landscape ships an end-to-end "long manuscript → captivating book-title candidates jointly engineered across IDEA × AVATAR × PATTERN" pipeline; that integration remains your core value-add. Long-document ingestion should ride on Anthropic prompt caching (1-hour TTL, ~90% input-token discount on cached chunks) rather than LangChain map-reduce orchestration.

---

## TL;DR (8 bullets)

- **Paradigm-shift discovery:** `realkimbarrett/advertising-skills` is the only OSS Claude-skills repo that natively encodes Schwartz's 5 awareness levels AND a headline-matrix in chainable SKILL.md form. Your Hook Creator's IDEA × AVATAR × PATTERN tri-axis can be implemented as a chain of 3 already-existing skill primitives + 1 new orchestrator.
- **Fork immediately:** `realkimbarrett/advertising-skills` (schwartz-awareness-mapper + headline-matrix + mechanism-builder) — ~95% match on AVATAR axis.
- **Chain (don't fork):** `clawfu/mcp-skills` MCP server (172 frameworks including Schwartz, Hormozi MAGIC, SUCCESs, StoryBrand) — install as MCP, call from your skill rather than re-encoding.
- **Adopt the execution-mode pattern:** `BrianRWagner/ai-marketing-claude-code-skills` v3.1 ships a `quick | standard | deep` mode flag inside a single SKILL.md. Saves ~3 days of skill ergonomics design.
- **Steal whole-cloth:** `boringmarketer`'s "Direct Response Copy Skill" (single-file gist) — already merges Schwartz/Halbert/Ogilvy/Sugarman pattern decks. MIT-equivalent, pasteable.
- **Dead ends (ignore):** All clickbait/headline ML repos (saurabhmathur96, peterldowns, AlisonSalerno, etc. — abandoned 2018–2022, deep-learning era, irrelevant in LLM era); Markov-chain title libs (`titlegen`, `buzzfeed` npm, last-published 2018); BuzzSumo/CoSchedule/Sharethrough headline analyzers (no public API, GUI-only, ToS-hostile to redistribution); `L2MAC` and book-generators (write *whole books*, not extract titles); `Evolving-Titles` (genetic algorithm, abandoned).
- **Long-document ingestion winner:** Anthropic prompt-caching with 1-hour TTL beats LangChain map-reduce, LlamaIndex tree-summarization, and DSPy refine for a Claude-Code-native skill — it's literally one cache breakpoint, no extra orchestration layer. Reserve KeyBERT/PyTextRank for *deterministic* salient-phrase extraction as a pre-LLM pass.
- **Major gap nobody fills:** Joint optimization across the three axes (IDEA × AVATAR × PATTERN) with diverse-N output (MMR-style) AND the "named title shape" library (Adjective+Noun, Number+Unit+Noun, Anti-X) does not exist anywhere as a single skill. This is the moat for your Hook Creator.

---

## A. Claude Code Skills / Plugins / MCP Servers

| Name | URL | Stars (approx.) | Last activity | License | Verdict | One-line Why |
|------|-----|-----------------|---------------|---------|---------|--------------|
| realkimbarrett/advertising-skills | github.com/realkimbarrett/advertising-skills | low (<100) | 2026 active | not stated (assume MIT-ish, confirm) | **FORK** | The only public skill set with explicit Schwartz awareness-mapper + headline-matrix + chainable design |
| clawfu/mcp-skills (guia-matthieu/clawfu-skills) | github.com/guia-matthieu/clawfu-skills, clawfu.com | active 2026 | active | MIT (declared on site) | **CHAIN as MCP** | 172 named-author frameworks (Schwartz, Hormozi, Cialdini, Dunford) — install via `npx @clawfu/mcp-skills`, query don't duplicate |
| wondelai/skills (Alphasync-LLC/hermes-skills) | github.com/wondelai/skills | mid | 2026 active | MIT | **STUDY-AND-BORROW** | Includes hundred-million-offers (full MAGIC formula in references/naming-offers.md) and storybrand-messaging — copy reference files |
| BrianRWagner/ai-marketing-claude-code-skills | github.com/BrianRWagner/ai-marketing-claude-code-skills | 129 forks 27 | 2026-04 (v3.1) | MIT | **STUDY pattern** | Source the quick/standard/deep execution-mode pattern; positioning-basics + voice-extractor are useful sub-skills |
| coreyhaines31/marketingskills | github.com/coreyhaines31/marketingskills | active | 2026 active | MIT (implied) | **STUDY-AND-BORROW** | "product-marketing-context" foundation skill pattern — every skill reads it first; perfect template for shared brand/avatar context |
| boraoztunc/skills (ogilvy etc.) | github.com/boraoztunc/skills | low | 2026 | MIT | **STUDY** | Single-skill files per copywriter (Ogilvy, etc.) — clean, minimal SKILL.md exemplars |
| boringmarketer Direct Response Copy gist | gist.github.com/boringmarketer/96192770df22ac2a9ff4aed72b4c20f4 | n/a | 2024–2025 | implicit MIT (gist) | **BORROW** | Single-file SKILL.md merging Schwartz/Halbert/Ogilvy/Sugarman/Caples — ~80% of your PATTERN axis |
| viral-content-forge v2.0.0 (Ice-ninja, known) | known to user | known | Dec 2025 | MIT | **IGNORE for book-title use** | Platform-virality only, not concept naming, not avatar-engineered |
| aaaronmiller/create-viral-content (known) | github.com/aaaronmiller/create-viral-content | low | 2025 | n/a | **IGNORE** | Reddit upvote optimization, not title naming |
| anthropics/skills (official) | github.com/anthropics/skills | 37.5k | active | Apache 2.0 + source-available | **REFERENCE only** | Use `skill-creator` skill from this repo to scaffold yours; no marketing skills here |
| obra/superpowers (skills lab) | github.com/obra/superpowers | mid | active | MIT | **IGNORE for use case** | Generic dev skills (TDD, debugging) — orthogonal to copywriting |
| razbakov/skills/viral-threads | github.com/razbakov/skills | low | 2025–26 | MIT | **STUDY** | "One emotional beat per tweet" — anti-pattern detector reusable for book titles |
| The Vibe Marketer Vibe Skills | thevibemarketer.com/skills | n/a | 2026 | $199 paid (10 skills) | **IGNORE** (paid) | Confirms the framework chain pattern is widely viable; don't pay |
| @clawfu/mcp-skills MCP server | npm @clawfu/mcp-skills | active | 2026 | MIT | **CHAIN** | One-line `.mcp.json` install; query at runtime instead of bundling 172 framework files into your skill |

### Per-entry deep dive (non-ignored)

#### `realkimbarrett/advertising-skills` — **FORK BASELINE**
- **File structure:** Multiple sibling skill folders, each with its own SKILL.md, designed to chain (`avatar-extraction → offer-extraction → schwartz-awareness-mapper → mechanism-builder → ad-angle-multiplier → scroll-stopping-creative → conversion-path-builder → objection-crusher → generic-language-killer`).
- **Frameworks named:** Eugene Schwartz awareness levels, mechanism (unique solution justification), angle multiplication, scroll-stopping creative (3-second hook patterns).
- **I/O:** Markdown skill outputs structured by framework label.
- **Avatar handling:** YES — `schwartz-awareness-mapper` is a dedicated skill that returns awareness level + the correct messaging approach for that level. This is rare.
- **Strengths for your use case:** Chainable architecture, explicit Schwartz awareness-mapper, headline-matrix that already does N variations across angles.
- **Lacks for your use case:** (1) no long-form manuscript ingestion, (2) no book-title shapes (Adjective+Noun, Number+Unit+Noun, Anti-X), (3) no MAGIC formula, (4) no diversification (MMR) across N candidates, (5) advertising-flavored not book/course-naming flavored — outputs lean ad-headline not iconic-title.
- **Fork recipe:**
  1. `git clone realkimbarrett/advertising-skills ~/.claude/skills/hook-creator-base`
  2. Keep `schwartz-awareness-mapper`, `headline-matrix`, `ad-angle-multiplier` as sub-skills.
  3. Replace `scroll-stopping-creative` → new `book-title-shaper` (pattern dictionary: AdjNoun, NumUnitNoun, AntiX, How-to-X-Without-Y, Curiosity-Gap, etc.).
  4. Add new `manuscript-ingester` skill (uses Read tool + prompt-caching).
  5. Add new `axis-orchestrator` SKILL.md as the entry point.
- **Math/savings:** ~10–14 days of from-scratch Schwartz encoding + headline-matrix + chaining ergonomics already done. Realistic time-to-MVP collapses from ~3 weeks to ~3 days.

#### `clawfu/mcp-skills` (172 frameworks) — **CHAIN AS MCP**
- **File structure:** Each framework = one markdown file with YAML frontmatter; bundled as MCP server with brand-memory.
- **Frameworks named** (subset relevant to you): Schwartz awareness/sophistication, Hormozi $100M Offers (incl. MAGIC), Cialdini, Dunford positioning, Ogilvy, Hopkins, Caples, Halbert.
- **Install:** `{"mcpServers": {"clawfu": {"command": "npx", "args": ["@clawfu/mcp-skills"]}}}` in `.mcp.json`.
- **Strengths:** No need to rewrite Schwartz or Hormozi yourself — call as MCP tools at runtime.
- **Lacks:** Generic methodology files, not optimized for book-title generation; skills are advisory, not generative-with-MMR.
- **Recipe:** Add `clawfu` MCP block to your project. Inside your `axis-orchestrator` SKILL.md, instruct: *"Before generating, query clawfu MCP for `schwartz-awareness` and `hundred-million-offers` skills; use returned framework as in-context grounding."*

#### `wondelai/skills` (44 framework skills) — **STUDY-AND-BORROW**
- **File structure:** Per-skill folder with SKILL.md + `references/` (e.g., `naming-offers.md`, `pricing-strategy.md`, `bonuses-stacking.md`, `industry-examples.md`).
- **Critical reference file:** `hundred-million-offers/references/naming-offers.md` — contains MAGIC formula breakdown + 20+ name examples + A/B testing offer names. **This is exactly your PATTERN-axis pattern deck for the "book-title naming" sub-task.**
- **Lacks:** Not chained; each skill stands alone; no axis-orchestration.
- **Recipe:** Copy `hundred-million-offers/references/naming-offers.md` into your `hook-creator/references/magic-formula.md` (MIT permits). Cite original.

#### `BrianRWagner/ai-marketing-claude-code-skills` (v3.1) — **PATTERN STEAL**
- **File structure:** 19+ sibling skills, all sharing a `quick | standard | deep` mode flag interpreted inside SKILL.md.
- **Why it matters for you:** Your Hook Creator likely needs (a) "draft 5 quick titles" mode and (b) "audit-and-refine 30 candidates with Schwartz analysis + diverse pattern coverage" mode. This pattern is already field-tested.
- **Recipe:** Add a frontmatter or in-body convention: `Mode: quick (5 titles, 1 framework), standard (15 titles, 3 frameworks, awareness-tagged), deep (30+ titles, all frameworks, MMR-diversified, Schwartz×Sophistication matrix).`

#### `coreyhaines31/marketingskills` — **CONTEXT-FOUNDATION PATTERN**
- **Architecture insight:** A `product-marketing-context` skill is the foundation; every other skill reads it first. Holds positioning, audience, voice.
- **For your use case:** Mirror this with a `creator-context` skill that holds: niche (music composition), brand (Cinematic Composing), avatar profile (composer aspirants, awareness levels), brand-voice samples. Every Hook Creator run loads this first.
- **License:** MIT-style.
- **Saves:** ~1 day of context-passing design.

#### `boringmarketer` Direct Response Copy gist — **PATTERN-DECK BORROW**
- **Single-file SKILL.md** that turns any LLM into a Schwartz/Hopkins/Ogilvy/Halbert/Caples/Sugarman/Collier-trained copywriter.
- **Contains:** awareness-level routing, open-loop hook patterns, gap-creation patterns ("Why Your X Isn't Working (And the 2-Minute Fix)").
- **Recipe:** Copy as `references/direct-response-patterns.md` inside your skill. Note: it is gist-license (no explicit license; treat as inspiration; rewrite with attribution to be safe).

---

## B. OSS Libraries (Python / JS / other)

| Name | URL | Stars | Last release | License | Recency Flag | Verdict |
|------|-----|-------|--------------|---------|--------------|---------|
| KeyBERT | github.com/MaartenGr/KeyBERT | ~3.5k | active 2024–25 | MIT | ✅ current | **USE** for hidden-angle keyphrase extraction |
| sentence-transformers | github.com/UKPLab/sentence-transformers | ~16k | v5.4 active 2025 | Apache 2.0 | ✅ current | **USE** as embedding backend for KeyBERT + MMR |
| BERTopic | github.com/MaartenGr/BERTopic | ~6k | active 2024–25 | MIT | ✅ current | **OPTIONAL** — useful only if you want to cluster a course-corpus into latent themes; overkill for single-manuscript |
| PyTextRank (DerwenAI) | github.com/DerwenAI/pytextrank | ~2k | active 2024 | MIT | ✅ current | **USE** as fast pre-LLM salient-phrase extractor (spaCy pipeline) |
| txtai | github.com/neuml/txtai | ~9k | active 2025 | Apache 2.0 | ✅ current | **OPTIONAL** — only if you want indexed semantic search across many documents |
| spaCy + en_core_web_sm | spacy.io | n/a | active | MIT | ✅ current | **USE** as PyTextRank dependency |
| LangChain map-reduce summarizer | langchain.com | n/a | active | MIT | ✅ current | **IGNORE** — heavyweight orchestrator unnecessary for a Claude-Code-native skill; prompt caching does the same job in fewer LOC |
| LlamaIndex tree-summarization | llamaindex.ai | n/a | active | MIT | ✅ current | **IGNORE** — same reason |
| DSPy | github.com/stanfordnlp/dspy | ~18k | active 2025 | MIT | ✅ current | **IGNORE for v1** — programmatic optimization is a v2/v3 bet; ROI requires evals you don't have yet |
| `titlegen` (Markov chain) | npmjs.com/package/titlegen | n/a | last-pub 2014–2018 | MIT | ⛔ **ABANDONED** | **IGNORE** — pre-LLM Markov chains; useless |
| `buzzfeed` npm | npmjs.com/package/buzzfeed | n/a | 2018 | MIT | ⛔ **ABANDONED** | **IGNORE** |
| `interactive-headline-generator` npm | npmjs.com/package/interactive-headline-generator | n/a | 2017–2020 (no other deps) | MIT | ⛔ **ABANDONED** | **IGNORE** |
| `medium-headline-generator` (poshaughnessy) | github.com/poshaughnessy/medium-headline-generator | low | ~2017 | MIT | ⛔ **ABANDONED** | **IGNORE** |
| `saurabhmathur96/clickbait-detector` | github.com/saurabhmathur96/clickbait-detector | mid | last commit ~2018 (TF1) | MIT | ⛔ **ABANDONED** | **IGNORE** — TensorFlow 1.x deprecated; LLM zero-shot beats it |
| `bhargaviparanjape/clickbait` (Stop Clickbait paper) | github.com/bhargaviparanjape/clickbait | mid | 2016–2017 | research | ⛔ **ABANDONED** | **IGNORE** |
| `alessiovierti/youtube-clickbait-detector` (SVM, 96% F1) | github.com/alessiovierti/youtube-clickbait-detector | low | 2019 | MIT | ⛔ **ABANDONED** | **IGNORE** |
| `dormanh/Evolving-Titles` (GA + NN) | github.com/dormanh/Evolving-Titles | low | 2019 | n/a | ⛔ **ABANDONED** | **IGNORE** |
| L2MAC book-generator | samholt.github.io/L2MAC | mid | 2024 | MIT | ✅ current | **IGNORE for use case** — generates entire books, not titles-from-content |
| LLM-book-generator (fangfufu) | github.com/fangfufu/LLM-book-generator | low | 2024 | GPL-3.0 | ✅ current | **IGNORE** — same |

### Per-library deep dive

#### KeyBERT — **USE for IDEA-axis pre-pass**
- Install: `pip install keybert sentence-transformers`
- Use case: Extract ngram keyphrases (1–4 words) from a 50k-word manuscript that are semantically central. Then apply MMR (`use_mmr=True, diversity=0.7`) to get a *diverse* set of candidate concepts — exactly what you need for "hidden hook extraction" before LLM generation.
- Integration sketch:
  ```python
  from keybert import KeyBERT
  kw = KeyBERT()
  hooks = kw.extract_keywords(manuscript, keyphrase_ngram_range=(1,4),
                              use_mmr=True, diversity=0.7, top_n=30)
  # Feed `hooks` as in-context candidate seeds to Claude
  ```
- Why this beats pure LLM extraction: deterministic, cheap (CPU OK with `all-MiniLM-L6-v2`), repeatable, gives diversity guarantees the LLM doesn't.

#### PyTextRank — **USE for ultra-fast spaCy-native salience**
- Install: `pip install spacy pytextrank && python -m spacy download en_core_web_sm`
- 5-line integration via `nlp.add_pipe("textrank")`. Outputs ranked phrases with `phrase.rank`, `phrase.count`.
- Lighter than KeyBERT (no transformer model required); good for the "first pass over a 100-page manuscript" then KeyBERT for the high-fidelity diversified selection.

#### sentence-transformers (with MMR for output diversification) — **USE for diverse N-titles**
- After Claude generates 50 candidate titles, embed all 50 with `all-MiniLM-L6-v2` and pick top-N via Maximal Marginal Relevance against the source-manuscript embedding. Lambda parameter (~0.5–0.7) trades off relevance vs. diversity. This solves the "10 titles all sound the same" problem natively.
- Reference: KeyBERT documentation explicitly demonstrates the MMR pattern.

#### BERTopic — **OPTIONAL**
- Useful only if you ingest a multi-manuscript corpus (e.g., entire course archive of 50 lessons) and want to surface latent themes across the corpus before titling. Single-book/single-course: skip.

#### LangChain / LlamaIndex / DSPy — **IGNORE for v1**
- Reason: A Claude Code skill already runs inside Claude with native Read/Glob/Bash tools. Adding a Python orchestration framework on top is architectural overkill. Just write SKILL.md instructions that ingest the manuscript, exploit prompt-caching, and run map-reduce *inside* the skill via subagents (Claude Code's `Task` tool with `model: haiku` for chunking + `model: sonnet` for synthesis — see `glebis/claude-skills/daydream` for the architectural pattern).

---

## C. Pattern Libraries / Prompt Decks / Swipe Files

| Source | URL | Free/Paid | Quality | Verdict |
|--------|-----|-----------|---------|---------|
| boringmarketer Direct Response Copy gist | gist.github.com/boringmarketer/96192770df22ac2a9ff4aed72b4c20f4 | Free | High (Schwartz/Halbert/Ogilvy frameworks merged) | **STEAL** |
| swipefile.com (Schwartz 5 Levels) | swipefile.com/the-5-levels-of-awareness | Free | High (canonical) | **REFERENCE** |
| wondelai/skills hundred-million-offers/references/naming-offers.md | github.com/wondelai/skills | Free MIT | High (MAGIC formula + 20 examples + A/B notes) | **COPY** |
| clawfu.com framework library | clawfu.com | Free MIT | High (172 frameworks, named-author attribution) | **CHAIN** |
| Ship 30 for 30 ChatGPT prompt pack (Bush+Cole) | startwritingwithai.com | Free email-gated | Medium (5 prompts, atomic-essay specific) | **STUDY** |
| Justin Welsh PASTOR / hook-story-offer LinkedIn posts | justinwelsh.me/newsletter | Free public | High (operator) | **STUDY**, no artifact to fork |
| Nicolas Cole 7-thread-templates / atomic-essay headline rules | ship30for30.com posts; LinkedIn | Free public | High | **STUDY**, no artifact |
| Nicolas Cole Ghostbase / G1 engine | ghostbase | **PAID** | unknown | **IGNORE** (paid) |
| The Vibe Marketer Vibe Skills | thevibemarketer.com/skills | $199 | unknown | **IGNORE** |
| langgptai/awesome-claude-prompts | github.com/langgptai/awesome-claude-prompts | Free MIT | Medium | **OPTIONAL** |
| MaxsPrompts/Marketing-Prompts | github.com/MaxsPrompts/Marketing-Prompts | Free | Low (broad, unstructured) | **IGNORE** |
| friuns2/BlackFriday-GPTs-Prompts | github.com/friuns2/BlackFriday-GPTs-Prompts | Free | Low (variety, no curation) | **IGNORE** |
| bilalnawaz072/AI-Prompts-200-Ideas | github.com/bilalnawaz072/AI-Prompts-200-Ideas | Free | Low | **IGNORE** |
| Anthropic Prompt Library | docs.anthropic.com prompt library | Free | High (no hook-specific) | **REFERENCE** |
| Eugene Schwartz Breakthrough Advertising (book) | Amazon ~$125+ | Paid | Canonical | **READ** but use clawfu/wondelai encodings instead of re-encoding |
| Hormozi $100M Offers (book) | Amazon | Paid | Canonical | **READ**, clawfu encodes MAGIC for free |

### Notable individual SKILL.md exemplars

- **`alfred1995/the-ai-corner` 25-Skill Founder Pack** (the-ai-corner.com): Includes a literal "Hook Creator" Skill prompt (8-framework × 10-output × labeled-by-framework). Free public Substack. **Direct competitor template — read it, exceed it.** It does NOT do (a) long-form ingestion, (b) Schwartz awareness routing, or (c) book-title shapes — your differentiation is intact.
- **`aiblewmymind` 39 Claude Skills Examples**: Lists a pattern for "Generate 5–7 unique angles for any general topic using SCAMPER, Jobs-to-be-Done, Contrarian Angle Generator." Useful framing for your IDEA axis.

---

## D. APIs / SaaS Worth Chaining

| API/Service | URL | Cost | Rate Limit | ToS for redistribution | Verdict |
|-------------|-----|------|------------|------------------------|---------|
| Anthropic Prompt Caching | docs.anthropic.com prompt-caching | 5-min cache: write 1.25× input, read 0.1× input. 1-hr cache: write 2× input, read 0.1× input. | inherits API limits | First-class for your use case | **USE** — core to long-form ingestion |
| Anthropic Skills API (`/v1/skills`) | docs.anthropic.com agent-skills | API tier required | standard | first-class | **OPTIONAL** for distribution |
| CoSchedule Headline Studio | coschedule.com/headline-analyzer | Paid GUI; **no public API** | n/a | **No redistribution** | ⛔ **IGNORE** (no API; ToS-hostile to scraping) |
| Sharethrough Headline Analyzer | headlines.sharethrough.com | Free GUI; **no public API** | n/a | **No redistribution** | ⛔ **IGNORE** |
| Advanced Marketing Institute EMV Analyzer | aminstitute.com | Free GUI; no API | n/a | unclear | ⛔ **IGNORE** |
| BuzzSumo Headline Analyzer | buzzsumo.com | $99+/mo, API only on top tiers | gated | enterprise-team-tier | ⛔ **IGNORE** (excluded by your filters) |
| Apify Facebook Ad Copywriter MCP (powerai) | apify.com/powerai/facebook-ad-copywriter-creator | per-call ~$0.01–0.05 | Apify rate limits | OK for use, not redistribution | **OPTIONAL** — Facebook-ad-specific, not book-title |
| Hugging Face Inference API (sentence-transformers) | huggingface.co | Free tier ~30k req/mo, paid scaling | per-token | Apache models OK | **USE** if you don't want local sentence-transformers |
| OpenAI Embeddings (`text-embedding-3-small`) | platform.openai.com | $0.02 / 1M tokens | high | OK | **OPTIONAL** alternative to sentence-transformers |

**Conclusion:** No commercial headline-CTR API meets your "cheap, embeddable, ToS-friendly, OSS-aligned" criteria. The pragmatic answer is to *score titles in-LLM* with a rubric (clarity, specificity, curiosity gap, target-awareness fit, MAGIC compliance) — Anthropic's own model is your judge. CTR-prediction is unreliable for *book/course titles* anyway (different conversion mechanic from web-headlines).

---

## E. NLP / ML Adjacencies (per-technique)

### 1. Topic salience / centrality / "hidden hook" extraction
- **SOTA library:** **KeyBERT + sentence-transformers (`all-MiniLM-L6-v2`)** with `use_mmr=True, diversity=0.7`. Active 2024–25, pip-installable, MIT/Apache.
- **Faster alternative:** **PyTextRank (spaCy pipeline)** — no transformer needed, runs CPU in seconds on 100-page manuscripts.
- **Recommended:** YES, both, in two-stage pipeline (PyTextRank → KeyBERT).
- **Integration sketch:** `manuscript-ingester` skill calls a `scripts/extract_angles.py` (UV single-file Python), which returns top-30 diverse keyphrases as JSON. Claude then generates titles seeded by those.
- **Reject:** Pre-2023 LSTM/CNN clickbait detectors (no longer SOTA).

### 2. LLM-based core-message extraction
- **SOTA pattern for Claude Code skills:** **Anthropic prompt caching** (1-hour TTL). Cache the manuscript once; iterate over framework-specific prompts cheaply (~10% of base input cost on cached chunks).
- **For very long manuscripts (>200k tokens):** Use Claude Code's `Task` subagent pattern (cf. `glebis/claude-skills/daydream`): map step in haiku-tier subagents extracts angles from 50 chunks in parallel, reduce step in sonnet/opus synthesizes.
- **Reject for your use case:** LangChain map-reduce, LlamaIndex tree-summarization, DSPy refine — all are heavyweight orchestrators that add a Python dependency layer. Native Claude Code subagents + prompt caching deliver equivalent results in markdown-only SKILL.md.
- **Recommended:** Prompt caching first; subagent map-reduce for >200k token corpora only.

### 3. Embedding-based diversification (MMR) for diverse N-output title generation
- **Recommended library:** **KeyBERT's MMR implementation** (`use_mmr=True, diversity=0.7`) for input-side diversification of seed angles. For output-side diversification of N candidate titles, write a 30-line custom MMR using sentence-transformers cosine similarity.
- **Why MMR:** Prevents the "all 10 titles say the same thing differently" failure mode that plagues vanilla LLM `n=10` sampling. Lambda parameter ~0.5 = balanced, ~0.7 = relevance-leaning, ~0.3 = diversity-leaning.
- **Recommended:** YES.

### 4. 2024–2026 papers on salient-angle extraction from long documents
- **TopicGPT** (Pham et al., NAACL 2024) — prompt-based topic modeling with LLM. Achieves 0.74 harmonic-mean purity vs. 0.64 for strongest baseline. Free-form natural-language topic labels (vs. LDA's bag-of-words). **Recommended:** as conceptual reference, not as a runtime dependency. Their prompting recipe (extract → cluster → label) is reusable.
- **MDERank** (Zhang et al., 2022, code at github.com/LinhanZ/mderank) — masked-document-embedding rank for unsupervised KPE; 1.80 F1@15 over SIFRank on long docs. **Niche; only if KeyBERT performance is insufficient on your manuscripts.**
- **GRETEL** (graph-contrastive topic-enhanced extractive summarization, 2022) — academic, not productized. **Ignore.**
- **ToM (Tree-oriented MapReduce, Nov 2025)** — tree-of-MapReduce for long-context reasoning; preserves cross-chunk dependencies. **Reference pattern**, not yet a productized library.
- **Recommended workflow:** TopicGPT-style prompting *inside Claude*, not as external pipeline. KeyBERT for deterministic pre-pass.

---

## F. Workflows / Community Playbooks

| Source | URL | Type | Verdict |
|--------|-----|------|---------|
| n8n template library (9,500+ workflows) | n8n.io/workflows | search "title", "blog" | **MEDIUM** — auto-blog templates exist; none are book-title specific |
| `Marvomatic/n8n-templates` | github.com/Marvomatic/n8n-templates | Free | **STUDY** — title/meta generators for SEO, AI Overview blueprint generator |
| `enescingoz/awesome-n8n-templates` (280+) | github.com/enescingoz/awesome-n8n-templates | Free | **REFERENCE** — categorized list |
| n8n WordPress Auto-Blogging Pro v2 | n8n.io/workflows/3852 | Template | **IGNORE** (publish-focused, not naming) |
| Justin Welsh Content OS / PASTOR framework | learn.justinwelsh.me/content; justinwelsh.me/newsletter | $$$ | **STUDY for SOP**, don't pay |
| Nicolas Cole / Dickie Bush Ship 30 / Atomic Essay headline rules | ship30for30.com; writewithai.substack.com | Free posts; paid course | **STUDY** — 7-thread templates, headline 5-elements rule |
| Nicolas Cole "John Carlton hook" Substack post | writewithai.substack.com/lean-writer-prompt-pack | Free | **STUDY** |
| Hormozi MAGIC podcast Ep 245 | open.spotify.com Game Ep 245 | Free | **REFERENCE** — primary source for MAGIC formula |
| Sabri Suby Sell Like Crazy playbook | not OSS | Paid book | **IGNORE for OSS sourcing** (consume separately) |
| Alex Hormozi $100M Offers (Wondelai SKILL.md) | github.com/wondelai/skills | Free MIT | **USE** (encoded, free) |
| swipefile.com (Schwartz 5 Levels visual) | swipefile.com | Free public | **REFERENCE** |
| Reddit r/copywriting top posts | reddit.com/r/copywriting | Community | **STUDY** for vernacular; no installable artifact |
| Reddit r/ClaudeAI / r/LocalLLaMA hook-extraction threads | reddit.com | Community | **MEDIUM** — anecdotal, no canonical SOP |
| `agentintegrator.io` "Claude Code for Marketing" article | agentintegrator.io/blog/claude-code-for-marketing | Free | **STUDY** — describes the chain pattern (CRO skill → SEO skill → MCP → published page) end-to-end |

### Operator playbooks worth absorbing as pattern-deck inputs

- **Justin Welsh PASTOR** (Problem, Amplify, Story, Transformation, Offer, Response). **Encode as one of your hook-creator candidate frameworks.**
- **Nicolas Cole 7-thread-template archetypes:** Framework Thread, Curation Thread, "This Just Happened," "If I Had To Do It Over Again," Tutorial, Frameworks, Lessons. **Map to book-title shape archetypes.**
- **Hormozi MAGIC** (Magnet, Avatar, Goal, Interval, Container) — already encoded in `wondelai/skills/hundred-million-offers/references/naming-offers.md`.
- **Heath SUCCESs** (Simple, Unexpected, Concrete, Credible, Emotional, Stories) — encoded in `wondelai/skills/made-to-stick/SKILL.md`.
- **MrBeast IMPACT / 6-pass adversarial refinement** — already in your known `viral-content-forge`. Borrow the *6-pass refinement pattern* (not the platform-virality content) and apply to title-candidate refinement.

---

## G. Environment Setup Notes (Ubuntu 22.04+ on Linux)

### Skill scaffolding
```bash
# Create skill directory
mkdir -p ~/.claude/skills/hook-creator/{references,scripts,assets}

# Fork the realkimbarrett baseline
git clone https://github.com/realkimbarrett/advertising-skills.git /tmp/adv-skills
cp -r /tmp/adv-skills/schwartz-awareness-mapper ~/.claude/skills/
cp -r /tmp/adv-skills/headline-matrix ~/.claude/skills/
cp -r /tmp/adv-skills/ad-angle-multiplier ~/.claude/skills/

# Install clawfu MCP (Node.js 18+ required)
# Add to your project's .mcp.json:
# {"mcpServers": {"clawfu": {"command": "npx", "args": ["@clawfu/mcp-skills"]}}}
```

### Python NLP dependencies (UV single-file scripts recommended for skill portability)
```bash
# System prereqs
sudo apt update && sudo apt install -y python3.11 python3.11-venv python3-pip

# Create isolated env (Claude Code skills should not pollute global Python)
python3.11 -m venv ~/.claude/skills/hook-creator/.venv
source ~/.claude/skills/hook-creator/.venv/bin/activate

# Core libs
pip install keybert==0.8.5 sentence-transformers>=5.4 spacy>=3.7 pytextrank
python -m spacy download en_core_web_sm

# Optional
pip install bertopic txtai
```

**Ubuntu 22.04 gotchas:**
- `sentence-transformers` v5+ needs `transformers>=4.40`; conflicts possible with system-wide pip torch. **Always use venv.**
- `spacy` model download fails behind corp proxies — use `pip install <model wheel>` from spaCy releases as fallback.
- KeyBERT default model `all-MiniLM-L6-v2` is ~80MB — first run downloads it from HuggingFace. Pre-cache with `python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2')"`.
- **Linux path bug in Agent SDK (Oct 18 2025, status check needed):** Some Claude Skills tooling hardcoded macOS paths instead of `$HOME`. As of latest 2026 community reports this should be patched in `claude-code` CLI ≥2.1; verify with `claude --version`. If you hit it, the workaround is symlinking `~/.claude` from the assumed mac path.

### Node-side (for MCP servers)
```bash
# Node 20+ recommended
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node --version  # should be ≥20
```

### Claude Code skill directory layout (final)
```
~/.claude/skills/hook-creator/
├── SKILL.md                        # axis-orchestrator entry point
├── references/
│   ├── schwartz-awareness.md       # 5 levels (paraphrased from Breakthrough Advertising)
│   ├── schwartz-sophistication.md  # 5 stages
│   ├── magic-formula.md            # Hormozi (from wondelai, attributed)
│   ├── successs.md                 # Heath
│   ├── aida-pas-bab.md
│   ├── title-shapes.md             # Adjective+Noun, Number+Unit+Noun, Anti-X, Curiosity-Gap, etc.
│   ├── named-title-archive.md      # Atomic Habits, 4-Hour Workweek, $100M Offers, Deep Work, Hooked... + decomposition
│   └── ai-tells.md                 # (borrow from viral-content-forge)
├── scripts/
│   ├── extract_angles.py           # KeyBERT + PyTextRank pre-pass
│   ├── diversify_outputs.py        # MMR over candidate titles
│   └── score_titles.py             # rubric scoring
└── assets/
    └── examples/                   # 50 worked examples across niches
```

### Subagent / chain wiring (referenced in SKILL.md body)
```
Hook Creator (orchestrator)
├─ Read manuscript (with prompt caching: cache_control: ephemeral, ttl: 1h)
├─ Bash: scripts/extract_angles.py → top-30 diverse keyphrases
├─ Task(model: sonnet) for each Schwartz awareness level (5 parallel) → angle-tagged candidates
├─ Apply pattern-deck filters (MAGIC, SUCCESs, AIDA, title-shapes) → ~50 candidates
├─ Bash: scripts/diversify_outputs.py (MMR over embeddings) → top-15 diverse
├─ Task(model: sonnet) score-and-refine pass (rubric: clarity, specificity, awareness-fit, novelty)
└─ Output: 10 titles tagged by [pattern, awareness-level, sophistication-stage]
```

---

## Final Recommendations

### Fork / build on
1. **`realkimbarrett/advertising-skills`** — primary skeleton. ~3 days work to repurpose toward book-title naming.
2. **`coreyhaines31/marketingskills`** product-marketing-context pattern — 1-day port to `creator-context` foundation skill.
3. **`BrianRWagner/ai-marketing-claude-code-skills`** quick/standard/deep mode pattern — 2-hour ergonomics steal.

### Chain / wrap (don't duplicate)
4. **`@clawfu/mcp-skills`** as MCP server — 172 frameworks queried at runtime. 30 minutes setup.
5. **KeyBERT + PyTextRank + sentence-transformers** as Python sidecar via UV scripts. ~1 day integration.
6. **Anthropic prompt caching** via skill instructions. ~1 hour wiring.

### Borrow content (reference files)
7. `wondelai/skills/hundred-million-offers/references/naming-offers.md` (MAGIC formula deck) — copy with attribution.
8. `boringmarketer` Direct Response Copy gist — copy as `references/direct-response-patterns.md` with attribution (rewrite slightly to be safe re: license ambiguity on gists).
9. From your already-known `viral-content-forge`: borrow only the **6-pass adversarial refinement loop** and the **AI-tells filter list** (~100 patterns) — both are framework-agnostic.

### Ignore (with reasons)
- **All pre-2023 ML clickbait/headline detectors** (saurabhmathur96, peterldowns, alessiovierti, AlisonSalerno, sawinderkaurvohra, MotiBaadror, LorenzoNorcini, bhargaviparanjape) — abandoned, TF1, beaten by zero-shot LLMs.
- **Markov-chain title gens** (`titlegen`, `buzzfeed`, `medium-headline-generator`, `interactive-headline-generator`) — pre-LLM, last-published 2014–2018.
- **`Evolving-Titles`** (genetic algorithm + NN) — 2019, abandoned.
- **L2MAC, LLM-book-generator, ghostwriter-ai, Generating-Books-with-LLMs** — generate whole books, not the inverse problem.
- **CoSchedule / Sharethrough / AMI / BuzzSumo headline analyzers** — no public API, GUI-only, ToS-hostile to redistribution. Not chainable.
- **`copy.ai` Hook Generator, Landingi, Capitalize My Title, Inkfluence, titlegenerator.com, copywritingcourse 100+ generator** — already known, shallow SaaS, no API.
- **LangChain map-reduce / LlamaIndex tree-summarize / DSPy** — heavyweight Python orchestration unnecessary inside a Claude Code skill that has native Read/Bash/Task subagents.
- **Funnel Builder Suite (Bradshaw), The General (Engel), Ship 30 prompt pack, Vibe Skills** — paid, closed, or already known.
- **Most awesome-prompt repos** (sankyn1, MaxsPrompts, friuns2, bilalnawaz072) — low-curation prompt dumps, no structured frameworks.
- **n8n Auto-Blogging templates** — publish-focused, not naming-focused.

### Paradigm-shifts found (the actual leverage)

1. **The chain-of-skills pattern is the real product (~saves 3 weeks).** `realkimbarrett/advertising-skills` proved that Schwartz-mapping is one skill, headline-matrix is another, and chaining gives you the joint optimization for free. Your "IDEA × AVATAR × PATTERN" axes map exactly onto: `manuscript-angle-extractor → schwartz-awareness-mapper → pattern-deck-applier → MMR-diversifier → rubric-scorer`. Math: each sub-skill is ~150 lines of SKILL.md; total ~750 lines. Building monolithically would be ~2,000 lines and fragile. **Saves an estimated 12–15 days vs. solo greenfield.**
2. **MCP-as-framework-library beats SKILL.md-as-framework-library (~saves 1 week per framework added).** clawfu's 172 frameworks should NOT be re-encoded in your skill; they should be queried as needed. Re-encoding 5 frameworks ≈ 5 days of careful authoring; chaining clawfu = 30 min. **Saves ~5 days; scales linearly as you add frameworks.**
3. **Anthropic prompt caching is the long-doc-ingestion answer; LangChain isn't (~saves 5–7 days).** A single `cache_control: {type: "ephemeral", ttl: "1h"}` on the manuscript message gives you 90% input-cost reduction across iterative axis-prompts AND skips the entire LangChain/LlamaIndex orchestration learning curve. **For an estimated 10–50k-token manuscript, this collapses ingestion from a multi-step RAG pipeline (~1 week) to a one-line skill instruction (~30 min).**
4. **MMR on outputs is the cheapest known fix for "10 titles all sound the same" (~saves a week of prompt-iteration).** A 30-line embed-and-rank script eliminates a failure mode that pure prompting cannot reliably solve. Buys you predictability and is testable.
5. **PyTextRank + KeyBERT pre-pass before Claude generation is non-obvious and high-leverage.** Most teams jump straight to LLM "find the hidden angle" prompts and get either generic or hallucinated angles. A deterministic pre-pass seeds the LLM with corpus-grounded candidate concepts → measurably better hooks. **Cost: ~1 day of integration. Payoff: lower variance, lower token spend (smaller in-context candidate sets), higher hit-rate.**

### Gaps still unfilled (potential Prompt 2 / Prompt 3 territory)

- **Named-title-shape pattern dictionary** ("Atomic Habits" = Adjective+Noun + Concrete Mechanism; "The 4-Hour Workweek" = Number+Unit+Noun + Identity Promise; "Anti-X" pattern; "How to X Without Y" pattern; "The X Code/Method/Effect/Trap"). **No public OSS encoding of book-title shapes exists.** This is the highest-leverage authoring task remaining and is a strong candidate for "Prompt 2: Build the named-title-shape reference deck for Hook Creator."
- **A book-title-decomposition corpus** — 200 famous book/course titles, each parsed into [shape, idea, audience-level, sophistication, mechanism]. Doesn't exist anywhere. Builds rubric and few-shot bank simultaneously.
- **Joint-axis evaluation rubric** with calibrated examples per (awareness-level × sophistication-stage × pattern). Doesn't exist; needs custom authoring.
- **Music-composition-niche–specific avatar profile and swipe file** for Cinematic Composing — must be authored by you (no OSS substitute).

---

## Caveats

- **License precision uncertain on a few items:** `realkimbarrett/advertising-skills` does not visibly declare a license in surfaced excerpts; confirm before forking/redistribution. Treat as "study-and-borrow with attribution" until verified.
- **Star counts and last-commit dates are approximate** based on search-result snippets, not direct repo commit timestamps. Verify each repo's actual `git log -1` before depending on it.
- **The `viral-content-forge` v2.0.0 you flagged as known** could not be independently confirmed via search (only `aaaronmiller/create-viral-content` surfaced); your prior brief is treated as authoritative.
- **`agentskill.sh` claims of "69,000+ skills" and `antigravity-awesome-skills` "1,441+" and `VoltAgent/awesome-agent-skills` "1,000+"** are aggregator catalogs that mostly re-list the same upstream repos. Don't be fooled by the volume — the meaningful artifacts in marketing/copywriting are the ~10 covered here.
- **Some 2026-dated articles cite operator behaviors (Hao0321 Facebook skill, BrianRWagner v3.1, alirezarezvani v3.0.1)** that are recent and could shift quickly; pin specific commits when you fork.
- **Anthropic prompt-caching pricing multipliers (1.25× write 5m, 2× write 1h, 0.1× read)** are accurate as of the latest Anthropic docs surfaced. Re-verify pricing when implementing — Anthropic adjusts these tiers.
- **"Saves X weeks because Y" estimates** assume a competent solo developer comfortable with markdown skill authoring; your actual mileage depends on familiarity with Claude Code skill mechanics and Python NLP. Estimates are deliberately conservative-to-moderate.
- **No artifact in the surveyed landscape covers your music-composition niche.** All examples are general marketing/SaaS/copy. Niche adaptation is your responsibility and is not a fork-able task.
- **The "evyAI/Skool MAGIC GPT" and similar ChatGPT-Custom-GPT artifacts are NOT skills** — they're closed GPT Store entries; treat as inspirational references only, not chainable artifacts.