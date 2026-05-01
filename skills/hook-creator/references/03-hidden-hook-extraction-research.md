# Hidden-Hook Extraction Methodology — Hook Creator

## TL;DR
- **The "captivating sub-idea" is found, not invented.** Every dominant trade-book title in your reference set ("Atomic Habits," "The 4-Hour Workweek," "Deep Work," "The Lean Startup," "Antifragile," "Sapiens") is a coined sub-idea hidden inside a longer manuscript and surfaced via one of three repeatable disciplines: editorial mining (Sol Stein/Ryan Holiday/Adrian Zackheim), direct-response listing (Eugene Schwartz, Bencivenga, Carlton, Halbert), and content distillation (Heath SUCCESs/Commander's Intent, April Dunford, Brunson's One Big Domino, Naval's specific knowledge).
- **There is now a recent, named precedent in NLP.** Mullick et al., "Introducing Spotlight: A Novel Approach for Generating Captivating Key Information from Documents" (arXiv:2509.10935, EMNLP 2025) defines the exact task — selectively emphasize "intriguing content" in a long document, not summarize it — and validates a two-stage SFT+DPO pipeline. This is the first paper to formally distinguish a "spotlight" from a summary, headline, teaser, or highlight, and it maps almost 1:1 onto the Hook Creator's job.
- **Ship the Schwartz-style Editorial-Mimic procedure first (Procedure 3 below).** It is the cheapest (~$0.30–$1.50/run with prompt caching), highest-fidelity match for trade-book hook hunting, easiest to implement as a single SKILL.md + Claude long-context call, and explicitly mirrors what Schwartz, Stein, Holiday, and Zackheim's editors actually do. Add NLP-augmented diversity (Procedure 2) only after you've shipped, measured, and seen avatar-fit complaints.
- **Hook detection is a 12-signal heuristic, not a single score.** Counter-intuitiveness, specificity, nameability, avatar-resonance, promise, memorability (Heath SUCCESs), anchorability, defensibility, inevitability, polarization, mechanism-implication, and category-creation. Each is implementable as an LLM rubric prompt; the final ranker is a weighted LLM-as-judge call (Zheng et al. 2023 / LLM-Judge / JudgeRank 2024 lineage).
- **Long-context + prompt caching is the core economic enabler.** Anthropic's prompt-caching writes are 1.25× input cost (5-min TTL) or 2× (1-hour); reads are 0.1× (90% off). On Claude Sonnet 4.6 ($3/$15 per MTok, 200K–1M context, no surcharge), a 100K-token manuscript loaded once and queried 10× costs ~$0.40, not ~$3.00. This collapses the cost barrier of "read the whole thing twice like Schwartz did at 3 a.m."
- **Avoid LangChain MapReduce/Refine for this task in 2026.** They're still maintained but optimized for *summarization* (uniform coverage), which is the opposite of "spotlight" (skewed, mini-story, interest-generation). Stuff-with-prompt-caching beats them on quality, cost, and simplicity for ≤200K-token works.
- **Title testing (PickFu, Tim Ferriss's AdWords trick, Upworthy's 25-headlines rule) belongs downstream of this skill, not inside it.** This skill produces 10–25 candidates worthy of testing.

---

## A. Editorial / Publishing Methodology

### A.1 Sol Stein — "Triage" Editing & Title Selection (Stein on Writing, 1995)
**Originator:** Sol Stein, founder of Stein & Day, editor of James Baldwin, Elia Kazan, Jack Higgins.
**Process:**
1. Read manuscript fully without editing.
2. **Triage:** rather than line-edit, fix the largest structural/narrative problem first, only then descend.
3. For titles, Stein's specific dictum: **"the most memorable titles are mixed metaphors"** (e.g., *The Heart Is a Lonely Hunter*, originally Carson McCullers's *The Mute* — Houghton-Mifflin retitled it).
4. The title must be **particular, not general** ("particularity" — his core craft principle). Avoid abstractions and clichés; force one concrete, sensory, surprising image.
**Inputs:** full manuscript. **Outputs:** title that pairs an unexpected concrete noun with an emotional/abstract noun.

### A.2 Adrian Zackheim — Portfolio Imprint Acquisition Triangle
**Originator:** Adrian Zackheim, founder/publisher Portfolio (Penguin Random House, 2001–present); editor of *Good to Great*, *Purple Cow*, *Start with Why*, *The Obstacle Is the Way*, *This Is Marketing*, *Atomic Habits* (Penguin imprint).
**Process** (from Extraordinary Business Book Club podcast, ep. 53):
1. Triangulate three variables: **(a) platform/communicator strength, (b) significance of the ideas, (c) commercial viability of the framing.**
2. Titles emerge from "idea-driven nonfiction…[that] challenge conventional thinking" — the imprint's editorial style favors a single coined construct (Purple Cow, Start with Why, Linchpin, Antifragile-adjacent) over descriptive titles.
3. Many Portfolio titles became the *book's central coined term*, not the pre-existing topic name. The hook IS the idea, and the idea IS the title.
**Implication for skill:** prefer candidate titles that introduce a coined or repurposed term over descriptive titles.

### A.3 Ryan Holiday — "One Sentence, One Paragraph, One Page" (Perennial Seller, 2017)
**Originator:** Ryan Holiday (Brass Check; *Perennial Seller*).
**Process:**
1. Set the manuscript aside; on a blank page, complete: *"This is a ______ that does ______ for ______."*
2. Then expand the same idea to one paragraph, then one page.
3. Compare against the actual draft: where do they diverge? Divergence reveals either (a) the project drifted, or (b) the real hook is hiding in the gap.
4. Holiday's adjacent rule (citing John Steinbeck's letter): "Forget your generalized audience…your audience is one single reader. I have found that sometimes it helps to pick out one person—a real person you know, or an imagined person—and write to that one." → identifies the **proxy avatar** for hook selection.

### A.4 Documented Working-Title → Bestseller Pivots (≥5 case studies)

| # | Final title | Working/rejected title(s) | Why the change (documented) |
|---|---|---|---|
| 1 | **The 4-Hour Workweek** (Tim Ferriss) | *Broadband and White Sand*, *Millionaire Chameleon*, *Drug Dealing for Fun and Profit* | Ferriss bought ~$200 of Google AdWords ads, each headlined with a candidate title, bid on keywords like "401k" and "language learning"; tracked CTR; "The 4-Hour Workweek" won. He has spoken about this at trade shows and in podcast #295. |
| 2 | **To Kill a Mockingbird** (Harper Lee) | *Atticus* | Lee changed it to be less character-specific once she realized the book was about more than Atticus (per editor Tay Hohoff's notes; widely documented). |
| 3 | **The Great Gatsby** (Fitzgerald) | *Trimalchio in West Egg*, *Among Ash-Heaps and Millionaires*, *The High-Bouncing Lover*, *Under the Red, White and Blue* | Editor Maxwell Perkins rejected the obscure classical reference; Fitzgerald was talked out of *Under the Red, White and Blue* days before publication. |
| 4 | **Lord of the Flies** (Golding) | *Strangers from Within* | Faber & Faber editor Charles Monteith rescued from slush pile and renamed for concrete, image-driven specificity. |
| 5 | **1984** (Orwell) | *The Last Man in Europe* | Publisher (Fred Warburg) called the working title too dour/commercial; Orwell switched to a year. |
| 6 | **Catch-22** (Heller) | *Catch-18*, then *Catch-11* | Editor Robert Gottlieb changed it because Leon Uris's *Mila 18* preceded it in 1961, and *Ocean's 11* movie blocked Catch-11; "22 is just 11 doubled." |
| 7 | **The Heart Is a Lonely Hunter** (McCullers) | *The Mute* | Houghton Mifflin renamed; the new title is the textbook example Stein cites for "mixed metaphor titles last." |
| 8 | **All the President's Men** (Bernstein/Woodward) | *At This Point in Time* | Renamed for drama and pop-culture resonance (Humpty Dumpty / "all the king's men"). |

(*Atomic Habits*: James Clear's blog and Wikipedia confirm Avery/Penguin published in Oct 2018; the title was Clear's own "atoms / atomic habits" coinage, validated against blog readership; no public record of a major working-title pivot.)

### A.5 Title Testing Services
- **PickFu** — operationally, the modern standard. Workflow: (1) draft 4–8 candidate titles, (2) target audience by genre/age/gender, (3) 50-respondent head-to-head or ranked poll returns in ~20 min, (4) AI-generated sentiment summary with key themes. **This is the right downstream tool for the Hook Creator's outputs.**
- **Upworthy 25-Headlines Rule** — every Upworthy article required ≥25 headline candidates; pairs picked top 3 each, overlap → testing pool of 4. Validated by the Upworthy Research Archive (32,487 A/B tests, 2013–2015) and a 2024 *Scientific Reports* paper showing concreteness is the single most predictive feature: more concrete headlines win at low concreteness levels but *lose* at high concreteness levels (the curiosity-gap sweet spot).
- **Tim Ferriss AdWords method** — historical; still valid in principle as Google Ads or Meta Ads pre-launch test.

---

## B. Direct-Response Copywriter Methodology (Schwartz Lineage)

### B.1 Eugene Schwartz — Breakthrough Advertising (1966) — **THE foundational extraction procedure**
**The 3 a.m. manuscript-reading process** (reconstructed from the book and Brian Kurtz's authorized commentary in *Breakthrough Advertising Mastery*):
1. Read the entire client manuscript/product manual **twice**, without writing copy.
2. On legal pads, list — in distinct categories — every **promise, every fact, every story, every objection, every curiosity hook, every specificity (numbers/timeframes), every counter-intuitive claim, every mechanism, every named concept**.
3. **Do not invent.** "The headline you want — the breakthrough you want — are all wrapped up inside that product and that market. Nowhere else."
4. Match each candidate against (a) **Mass Desire** — the strongest pre-existing want (he calls it "the one element that makes them unique"), (b) **Awareness Level** (1–5: most aware → completely unaware), (c) **Sophistication Level** (1–5: how many similar products the market has been exposed to).
5. The chosen headline must touch **one** dominant Mass Desire, at the right Awareness × Sophistication coordinate. "You can only use one in your headline."
6. Test (split-run was Schwartz's mechanism; PickFu/AdWords are the modern equivalents).
**This is the canonical pattern Procedure 3 below mimics.**

### B.2 Schwartz "33-Headline Exercise" / "120-Headline Exercise" (Brian Kurtz / Bencivenga lineage)
- Schwartz's documented practice: write at minimum 50 headlines per promotion before choosing.
- The "33-headline" / "120-headline" framing is folk-attributed via Brian Kurtz and Bencivenga lineage but is not a single named exercise in Schwartz's own book; treat it as: **forced-quantity divergent generation precedes any selection.** This is identical to Upworthy's 25-headline rule and Carlton's "50–100+ supposições" method.

### B.3 Gary Halbert — The Boron Letters (1984)
**Process:** Halbert's "A-pile / B-pile" sorting (in personal mail, what gets opened vs. trashed) — applied to titles: read your candidates as if you were the prospect deciding whether to even open the email. Killed any candidate that sounded like institutional copy. **Mining technique:** Halbert's swipe file — collect the controls (winning ads) in your category, identify the Big Promise + Mechanism + Specificity pattern, then look for the analog inside your own manuscript.

### B.4 Gary Bencivenga — Bencivenga 100 / Marketing Bullets
- **Mr. Why technique** (Bullet #4): "Appoint Mr. Why as your lead detective. Instruct him to come back with at least seven times more information than you can use." → forces sub-idea surfacing by repeated "why" interrogation of the manuscript, until you have 7× the raw material you'll use.
- **SCAMPER** (Bullet #6): Substitute, Combine, Adapt, Modify/Magnify, Put-to-other-uses, Eliminate, Rearrange/Reverse — applied to headline candidates to multiply variants.
- **Credo Technique** (Bullet #1): "Stand for something" — every winning headline implies a belief the writer would defend. Detection prompt: "What does this title force the author to believe is true?"

### B.5 John Carlton — The "Hook" as Hidden Story
- Carlton's hook discovery method (documented in *Kick-Ass Copywriting Secrets of a Marketing Rebel* and on his blog "Fishing for Hooks"): **interview the creator until something jaw-dropping comes out off the cuff.** The "one-legged golfer" headline came from a 2-hour interview at minute ~120 when the client mentioned an offhand anecdote. Carlton: "Go deep…it's not something you can discover with a glance at the product, or even a long chat with the client."
- **Implication for AI:** the LLM equivalent of the 2-hour interview is a long-context pass plus a deliberate "what are the odd, off-hand, unbelievable, jaw-dropping anecdotes/numbers/claims hiding in this manuscript?" prompt.

### B.6 David Ogilvy — The "Big Idea" Five-Test (Ogilvy on Advertising, 1983)
"It will help you recognize a big idea if you ask yourself five questions:
1. Did it make me gasp when I first saw it?
2. Do I wish I had thought of it myself?
3. Is it unique?
4. Does it fit the strategy to perfection?
5. Could it be used for 30 years?"
**Use as the final-pass LLM rubric for the top 5–10 candidate hooks.**

### B.7 Drew Eric Whitman — Cashvertising "Life Force 8"
Map every candidate hook to one of: (1) survival/life-extension, (2) enjoyment of food/drink, (3) freedom from fear/pain/danger, (4) sexual companionship, (5) comfortable living, (6) being superior/winning, (7) care/protection of loved ones, (8) social approval. **A hook that maps to LF8 plus 9 secondary wants beats one that doesn't.** For the cinematic-music niche specifically: LF6 (be superior/recognized as a real composer), LF8 (peer/social approval), and the secondary want "creative self-expression / mastery."

### B.8 Modern Direct-Response Practitioners (verified extraction routines)
- **Stefan Georgi (RMBC method):** Research → Mechanism → Big Idea → Copy. The "Mechanism" step is explicitly the hidden-hook step.
- **Justin Goff:** "Single-mechanism" promos win. The hook is the mechanism named for the first time.
- **Brian Kurtz:** "Read 'Breakthrough Advertising' three times, then read it once a year." Mass Desire × Awareness × Sophistication is the operating system.
- **Daniel Throssell:** Reads the manuscript three times before writing email copy; lists every email-worthy moment as a separate "story node."

---

## C. Marketing/Positioning Extraction Frameworks

### C.1 Donald Miller — StoryBrand BrandScript (7 elements)
1. **Character** — what does the customer want?
2. **Problem** — external + internal + philosophical
3. **Guide** — empathy + authority
4. **Plan** — 3-step process
5. **Call to Action** — direct + transitional
6. **Failure** — stakes if they don't act
7. **Success** — happy ending (status, completeness, self-realization)
**Use:** the BrandScript becomes a 7-cell input grid; hook candidates that map cleanly into the "internal problem" + "philosophical problem" cells tend to be the captivating ones (these are the cells most authors leave blank).

### C.2 April Dunford — Obviously Awesome 10-Step Positioning
1. Understand customers who love your product
2. Form a positioning team
3. Align vocabulary, drop baggage
4. List true competitive alternatives
5. Isolate unique attributes
6. Map attributes to value themes
7. Determine who cares a lot
8. Find a market frame of reference, position within it
9. Layer on a trend (carefully)
10. Capture & share
**Note:** 2026 expanded edition collapses to 5 components/5 steps. The hook-relevant move is steps 4–6: **"only X-Y-Z can deliver Q"** — the candidate hook should answer who, uniquely, can credibly deliver this transformation.

### C.3 Russell Brunson — Epiphany Bridge + One Big Domino (Expert Secrets)
**One Big Domino question:** "What's the one thing that, if they believe that one thing, they have to buy from me?"
**Epiphany Bridge script (8 steps):** Backstory → Desire → Wall → Epiphany → Plan → Conflict → Achievement → Transformation.
**Use for hook extraction:** the Big Domino is *the* candidate hook. For each candidate title, ask: "If the avatar believes this one statement, do they have to engage with the work?" If yes, it's a contender.

### C.4 Sabri Suby — Halo Strategy (Sell Like Crazy, 2019)
Document, for the dream buyer:
- Pains (top 5)
- Hopes/dreams (top 5)
- Fears/objections (top 5)
- Vocabulary they actually use (verbatim from forums, Reddit, Quora, AnswerThePublic)
- Demographics + psychographics
The **"result they want most"** is the single highest-priority output. Hook candidates that name that exact result, in their exact vocabulary, win.

### C.5 Naval Ravikant — "Specific Knowledge" + "Idea Sex"
- **Specific knowledge** = "what feels like play to you but looks like work to others." Found at the intersection of innate talent + genuine curiosity + passion. **For Cinematic Composing:** the avatar's specific knowledge is what they're already obsessed with that doesn't yet have a name.
- **Idea sex:** combine two unrelated domains the avatar already cares about. Hook candidates that fuse two of their existing internal-monologue topics outperform single-domain candidates.

### C.6 Heath Brothers — "Find the Core" + Commander's Intent (Made to Stick, 2007)
**Procedure:**
1. List every candidate idea in the manuscript.
2. Ask: "If we do nothing else with this work, we must ______." (Combat Maneuver Training Center prompt.)
3. Ask: "The single, most-important thing this work must do is ______."
4. Ask "Why?" three times (Toyota's 5-Whys variant).
5. Test against **SUCCESs**: Simple, Unexpected, Concrete, Credible, Emotional, Story.
**This and Schwartz's process are the two pillars of Procedure 3.**

### C.7 Other Frameworks (compressed)
- **Allan Dib (1-Page Marketing Plan):** the "core message" slot — one sentence that captures the ideal-prospect promise.
- **Roy H. Williams (Wizard of Ads):** "Talking-to-strangers test" — would you say this to a stranger at a bar without embarrassment? If not, it's not the hook.
- **Mark Manson — "Ladder Theory":** essay structure climbs from concrete pain → abstract principle → reframe. Hook = the rung where reframe lands.
- **Derek Sivers:** very short titles ("Hell Yeah or No", "Anything You Want") — forces the hook to be one syntactic unit.

---

## D. Journalism Craft

### D.1 The Lede / "Burying the Lede"
**Concrete editorial routine** (Poynter, Nieman Storyboard, Jack Hart's *StoryCraft*):
1. After draft, ask the writer: "What is this story about?" → if their answer is not in paragraph 1 or 2, the lede is buried.
2. Identify the single sentence that, removed, would collapse the story. That's the kernel.
3. Move it up.
**Adapted for hook extraction:** ask the LLM to find the one sentence in the manuscript that, if removed, would make the entire work collapse. That sentence's NOUN PHRASE is a hook candidate.

### D.2 Nut Graf (Wall Street Journal Formula)
Originated 1941 by Barney Kilgore at WSJ. Structure:
1. Anecdotal/scenic lede (1–2 paragraphs)
2. **Nut graf** — "a paragraph that says what this whole story is about and why you should read it" (Ken Wells, WSJ)
3. Body
4. Kicker (returns to the lede subject)
**Theme statement** (William Blundell): "the single most important bit of writing I do on any story." The nut graf compresses the theme.
**For hook extraction:** force the LLM to write a 50-word nut graf for the manuscript. The nut graf's most concrete, surprising clause is a hook candidate.

### D.3 Magazine Title-Pivot Documented Examples
- *The New Yorker, The Atlantic, Wired, GQ, Vanity Fair* — long-form features routinely have 20+ headline candidates by the title editor; the published title is rarely the writer's working title. Specific cases are mostly behind editor anecdotes; few formally documented case studies exist outside Nieman Storyboard and Longform podcast interviews. Treat as confirmation of the "20+ candidates" norm rather than a separate procedure.

### D.4 Upworthy's 25-Headlines (re-confirmed, with caveats)
- Every Upworthy article required ≥25 headline candidates per the company's published process; the pair picked top 3 each, agreed-overlap → testing.
- The 2024 Aubin Le Quéré & Matias *Scientific Reports* paper, using the Upworthy Research Archive, shows: only 8.7% of Upworthy headlines benefited from *more* concreteness; 50.9% benefited from *less*. **Implication:** The cinematic-music avatar is plausibly already-curious (sophisticated audience), so concreteness should be set high — Atomic Habits-style, not BuzzFeed-style.

### D.5 Newsletter Title Craft
- The Skimm / Morning Brew use second-person + verb-first construction + one specific number/name. Useful as a candidate-style only.

---

## E. NLP / ML Approaches (recency-checked, abandonment-flagged)

| Technique | Maintained? | Last update | Recommended? | Why / Integration sketch |
|---|---|---|---|---|
| **Anthropic prompt caching** (5-min/1-hour TTL) | ✅ Active | Production 2024–2026; ZDR-eligible | **Yes — required** | Cache the manuscript once, run 10–20 different extraction prompts at 0.1× cost. Canonical pattern: cache the manuscript as a system block with `cache_control: {type: "ephemeral", ttl: "1h"}` for batch use, "5m" for interactive. Min 1024 tokens (Sonnet 3.7) / similar Sonnet 4.5/4.6. |
| **LLM "needle-in-haystack" extraction** | ✅ Active | Standard technique 2024–2026 | Yes | Long-context Claude (200K standard, 1M beta on Sonnet) handles full books. Use "Stuff" pattern + caching. |
| **TextRank / LexRank / sumy** | ⚠️ Maintained but dated | sumy v0.11 (2023); pytextrank in spaCy still maintained | **Optional only** | Useful as a cheap *pre-filter* to find candidate "important" sentences before LLM ranks; does not understand "captivating." Skip for v1. |
| **BERTopic** | ✅ Very active | v0.17.x, Nov 2025 — multi-GPU UMAP, Model2Vec lightweight backend | Optional (Procedure 2) | Use only if manuscript has clear multi-chapter sub-topics; cluster chapter summaries to get sub-idea space. |
| **KeyBERT / KeyLLM** | ✅ Active | Feb 2025 release | Optional | Cheap candidate keyword extractor. Useful for the "noun-phrase coining" step. |
| **Top2Vec** | ⚠️ Slow updates | Last release 2023 | No | BERTopic is strictly better. |
| **Sentence-Transformers / Embeddings (2024–2026 SOTA)** | ✅ Very active | — | **Yes** for diversity filtering (MMR) | 2026 leaders: **Voyage voyage-3-large / voyage-4-large** (retrieval), **Cohere embed-v4** (multilingual, 100+ langs), **OpenAI text-embedding-3-large** (3072d, Matryoshka), **Google Gemini Embedding 2** (multimodal, MTEB ~67.7), **NV-Embed-v2** (top open-source). For Hook Creator's MMR diversity filter: embed candidate hooks, run MMR with λ≈0.7. |
| **LangChain Map-Reduce / Refine / Stuff / Map-Rerank** | ✅ Maintained | LangChain ≥0.3 (2024–2026); LCEL/LangGraph preferred | **No for this task** | Designed for *uniform-coverage summarization*. Hook extraction wants the *opposite* (skewed/spotlight). Use plain Stuff with prompt caching instead. |
| **LlamaIndex TreeSummary / Refine / SubQuestionQueryEngine** | ✅ Active | 2025 | Optional | SubQuestionQueryEngine is useful if you want to ask the manuscript multiple structured sub-questions; otherwise overkill. |
| **DSPy** (Stanford, Khattab et al.) | ✅ Very active | 2024–2025 | **Optional v2** | DSPy modules excel at extract-then-rank with `dspy.Predict` + `Reranker` signatures + MIPROv2 optimizer. Pattern: ExtractCandidates → Reranker (float-typed) → MMR. Recommended only after you have a labeled eval set of "good hooks vs. bad hooks" because DSPy's value is *optimization* — without examples, you're just writing prompts. |
| **Constitutional AI / self-critique** | ✅ Anthropic-native | Active | **Yes** | Use as the "Skeptic" pass in Procedure 1. Native to Claude. |
| **Multi-agent extract-and-rank** (orchestrator-worker, Anthropic Research pattern) | ✅ Active reference architecture | Anthropic engineering blog 2024 | **Yes for Procedure 1** | Lead agent dispatches: Extractor → Critic → Avatar-Sim → Editor. Anthropic published the orchestrator-worker pattern; replicable in Claude Code via subagents/skills. |
| **Spotlight (Mullick et al.)** — captivating key info from documents | ✅ Active | arXiv:2509.10935, EMNLP 2025; code at github.com/ankan2/Spotlight-EMNLP2025 | **Conceptually yes; practically reference-only** | This is the closest published academic precedent. Their two-stage pipeline (SFT on a curated benchmark + DPO alignment) requires labeled data you won't have at v1. **But borrow their evaluation rubric:** Info-Distribution=Skewed, Compactness=Low, Readability=High, Extractive=High, Informative=High, Interest-Generation=High, Faithful=High, Length=Long, Mini-Story=Yes. These nine axes are an excellent LLM-judge prompt template. |
| **TextGrad** | ✅ Active 2024 | Stanford | Optional | Useful only if you fine-tune prompts on labeled hooks. |
| **RAGAS** | ✅ Active | 2024–2025 | No (RAG-specific) | Wrong domain; built for RAG faithfulness, not creative ranking. |
| **LM-as-judge (Zheng 2023, JudgeRank 2024, Niu et al.)** | ✅ Standard practice | 2023–2025 | **Yes — core pattern** | Use a separate Claude/Sonnet pass as judge with explicit rubric. Watch for **position bias** (randomize candidate order), **length bias** (normalize length in prompt), **agreeableness bias** (force a "this is bad because…" justification). Standard mitigation: pairwise ranking with order-shuffling, average over 2 orderings. |

---

## F. Candidate Procedures

### Procedure 1 — Heavy-LLM "Adversarial Council"
**Steps (12):**
1. **Ingest** full content (manuscript/transcript/course module) ≤ 200K tokens; load into Claude Sonnet 4.6 system prompt with `cache_control: ephemeral, ttl: "1h"`.
2. **Avatar definition** — user provides 1-page avatar doc (cinematic-music students at Cinematic Composing); load as cached system context.
3. **Pattern catalog** (from sister skill) loaded as cached system context.
4. **Generate 100 raw angles** in a single pass with a "list every captivating sub-idea, anecdote, counter-intuitive claim, named concept, specific number, jaw-dropping moment" prompt.
5. **Coin-or-find pass:** for each angle, propose a 2–6 word coined name (Atomic Habits style).
6. **Apply 12 detection signals** (Section G) as a parallel rubric — score each angle 0–5 on each.
7. **Skeptic adversarial pass:** new Claude call with persona "skeptical NYT book editor" critiquing each top-30 angle.
8. **Avatar-simulation adversarial pass:** new Claude call simulating the cinematic-music composer avatar, scoring "would I click this title?"
9. **Editor adversarial pass:** new Claude call as Adrian-Zackheim-style trade editor, applying Ogilvy's 5-question test.
10. **MMR diversity filter** on candidate embeddings (Voyage-3-large or text-embedding-3-large) with λ=0.7 to ensure top-20 aren't synonyms.
11. **Final ranking:** weighted score = 0.4·avatar + 0.3·detection-signals + 0.2·editor + 0.1·skeptic.
12. **Output:** top 20 hooks with one-paragraph rationale and signal scorecard.
**Inputs:** manuscript, avatar doc, pattern catalog. **Outputs:** ranked top 20.
**Cost per run** (200K-token manuscript, Sonnet 4.6 at $3/$15 per MTok with prompt caching):
- Cache write: 200K × $3.75/MTok (1h TTL) = $0.75 once.
- ~10 cached reads × 200K × $0.30/MTok = $0.60.
- ~30K output tokens × $15/MTok = $0.45.
- **Total: ~$1.80/run.**
**Quality:** **High** — multiple lenses catch different failure modes, mirrors human editorial committee.
**Ease of implementation:** **3/5** — requires multi-agent orchestration (subagents in Claude Code), state passing, judge calibration.
**Failure modes & mitigations:**
- *LLM-judge position bias* → randomize candidate order, average 2 orderings.
- *Sycophancy in self-evaluation* → use separate model instance for judging vs generating.
- *Diversity collapse* (all top-20 sound alike) → MMR with λ=0.7; explicit "max 3 candidates per coined-noun root."
- *Avatar-simulation drift* → load 5+ verbatim avatar quotes; force quotation in scoring rationale.

### Procedure 2 — Hybrid (NLP + LLM)
**Steps (11):**
1. Chunk manuscript into chapter/section units (semantic chunking, 1–2K tokens each).
2. Generate per-chunk summaries (Claude Haiku 4.5, $1/$5 per MTok — cheap).
3. **BERTopic** over chunk summaries to find latent sub-idea clusters (k=5–15).
4. **KeyBERT/KeyLLM** to extract candidate noun phrases per cluster.
5. For each cluster, ask Claude to **coin** a 2–6 word name.
6. **TextRank** within each cluster to find the single most-central anecdote/quote.
7. **LLM avatar-fit scoring** of each cluster's coined name (Claude Sonnet, LF8 + 12 signals).
8. **Embed** all candidates (Voyage-3 or text-embedding-3-large), MMR diversity filter.
9. Take top 5 from each cluster, then global top 20.
10. **LLM editor pass** (Ogilvy 5-test).
11. Output ranked 20.
**Inputs/Outputs:** same as Procedure 1.
**Cost per run:** ~$0.40 (Haiku summaries + small Sonnet ranking + cheap embeddings).
**Quality:** **Medium** — better diversity, weaker on the single jaw-dropping moment. NLP-driven sub-topic detection sometimes finds *topical* sub-ideas, not *captivating* sub-ideas; the latter are often singular off-hand anecdotes (Carlton's one-legged-golfer) that don't cluster.
**Ease of implementation:** **2/5** — Python deps for BERTopic, KeyBERT, sentence-transformers; harder for a markdown-driven skill; needs `uv`/venv management.
**Failure modes & mitigations:**
- *Captivating ≠ central* (Carlton's one-legged-golfer is one paragraph in a 300-page book) → keep an explicit "anomaly/outlier" parallel pass that surfaces low-frequency but high-emotion sentences.
- *Cluster contamination* with frontmatter/boilerplate → strip TOC, dedications, footnotes pre-clustering.

### Procedure 3 — Schwartz-Style Editorial-Mimic ★ **RECOMMENDED v1**
**Steps (10):**
1. **Cache-load** manuscript + avatar doc + pattern catalog as Anthropic ephemeral cache (1h TTL).
2. **Pass 1 — Read-through inventory** (single LLM call): "Read this manuscript twice as Eugene Schwartz read manuscripts at 3 a.m. Then list, in 8 separate categories, every: (1) PROMISE, (2) OBJECTION/SKEPTICISM, (3) CURIOSITY GAP, (4) COUNTER-INTUITIVE CLAIM, (5) SPECIFICITY (numbers/timeframes/names), (6) STORY/ANECDOTE, (7) MECHANISM (named how-it-works), (8) IDENTITY/STATUS PROMISE. Aim for 10+ items per category." → ~80 raw items.
3. **Pass 2 — Coin-or-find:** for each raw item, generate 2–4 candidate 2–6 word coinages (Atomic-Habits/Antifragile style).
4. **Pass 3 — 12-signal rubric** (Section G) scored 0–5 each, with one-sentence justification per signal.
5. **Pass 4 — Avatar-resonance** (Sabri Suby Halo): "Would the cinematic-music composer avatar say this title aloud to a peer? Quote a verbatim avatar phrase that matches."
6. **Pass 5 — Ogilvy 5-test** on top 20 candidates ("Did it make me gasp?…Could it be used 30 years?").
7. **Pass 6 — Heath SUCCESs** on top 10.
8. **MMR diversity filter** to ensure variety of patterns/coined roots in final 20.
9. **Output:** ranked top 20 candidate hooks, each with: (a) source passage in manuscript, (b) signal scorecard, (c) avatar-resonance quote, (d) one-sentence "why this works" rationale.
10. **Optional handoff** to PickFu/PickFu-style A/B test downstream.
**Inputs:** full content, avatar doc, pattern catalog. **Outputs:** top 20 ranked hooks with full scorecards.
**Cost per run** (200K-token book on Sonnet 4.6):
- Cache write: ~$0.75
- ~6 cached reads × 200K × $0.30/MTok = $0.36
- ~20K output × $15/MTok = $0.30
- **Total: ~$1.40/run.** A 30K-word course module: **~$0.30/run.**
**Quality:** **High** — directly mimics the documented procedure of the most successful direct-response copywriter in modern history, plus Ogilvy's 5-test and Heath's SUCCESs as quality gates.
**Ease of implementation:** **5/5** — single SKILL.md with sequential prompts; optional Python helper only for MMR (numpy + voyageai client). All passes are cached LLM calls; no orchestration framework needed; no NLP libraries needed.
**Failure modes & mitigations:**
- *Hook = specific plot point that doesn't generalize* → Pass 4 forces avatar-test ("would the avatar care?").
- *LLM coining produces academic-sounding nouns* → seed Pass 3 with 30 examples from the pattern catalog (Atomic Habits, Antifragile, Deep Work, Lean Startup, Sapiens, Purple Cow, Linchpin, Hooked, Drive, Grit).
- *Recency drift* (top 20 all sound 2024-trendy) → Ogilvy test #5 ("could it be used for 30 years?") explicitly penalizes.
- *Cinematic-music niche language* → Pass 5 includes a vocabulary lock: title must use words the avatar uses, surfaced from a small corpus of avatar-language (Reddit r/composer, Spitfire forums, Cinematic Composing testimonials).

### Recommendation — Ship Procedure 3 first.
Reasons:
1. **Markdown-native.** Single `~/.claude/skills/hook-creator/SKILL.md` plus `references/patterns-catalog.md`, `references/signals-rubric.md`, `references/avatar.md`, optional `scripts/mmr.py`. No orchestrator, no agent framework.
2. **Cheapest** (~$0.30–$1.50/run with prompt caching).
3. **Highest fidelity** to the documented bestseller-titling discipline (Schwartz + Stein + Holiday + Heath all converge on this approach).
4. **Procedure 1's adversarial council adds value mainly when there's disagreement** — premature optimization for a solo creator. Add adversarial passes only after 20+ real runs reveal repeated failure modes.
5. **Procedure 2's NLP value is zero on a single short course module** (cinematic-music modules are likely 5K–30K words). BERTopic/KeyBERT are designed for corpora, not single works.

**Add later:**
- After 20 real runs: a Skeptic adversarial pass (Procedure 1, step 7).
- After 100 real runs with hook-performance feedback: a DSPy MIPROv2 optimizer over the rubric prompts.
- After Cinematic Composing accumulates a "won/lost" hook dataset: a custom Spotlight-style fine-tune using the Mullick et al. paper's two-stage SFT+DPO recipe.

---

## G. Captivating-Sub-Idea Detection Signals

Each signal: definition → why it works → LLM-runnable detection heuristic.

1. **Counter-intuitive** — Violates a widely held belief in the avatar's world. *Works because:* surprise breaks the "guessing machine" (Heath). *Detect:* "State the conventional wisdom on this topic in one sentence. Does this idea contradict it? Score 0–5 on contradiction strength."
2. **High specificity** — Uses concrete numbers/timeframes ("4 hours," "1%," "10,000 hours"), not "less time" or "small amounts." *Works because:* concreteness predicts CTR up to a sweet spot (Aubin Le Quéré & Matias 2024). *Detect:* "Count specific numbers, named timeframes, named places, named people. ≥1 = pass; ≥2 = score 5."
3. **Coined/nameable** — A 1–4 word phrase the reader can repeat ("Atomic Habits," "Antifragile," "Deep Work"). *Works because:* memorability requires a unique noun phrase. *Detect:* "Generate a 2–4 word coinage. Search Google (mentally) — does it return ≤1 page of unrelated results? Score: highly nameable / partially / not nameable."
4. **Avatar-resonant** — Lives in the avatar's existing internal monologue (Schwartz's Mass Desire). *Works because:* you can't create demand, only channel it. *Detect:* "Quote one verbatim phrase the cinematic-music-composer avatar uses on Reddit/forums that this idea answers. If you cannot, score 0."
5. **Promise-laden** — Implies a specific transformation. *Works because:* people buy outcomes (Schwartz, Whitman LF8). *Detect:* "Map to one of LF8 + 9 secondary wants. Score 0 if no map."
6. **Memorable (Heath SUCCESs)** — Simple, Unexpected, Concrete, Credible, Emotional, Story. *Detect:* 6-axis 0–5 rubric; minimum sum threshold = 18.
7. **Anchorable** — You could give a 1-hour talk on it without running out. *Works because:* a hook that's only a clever phrase has no body of work. *Detect:* "List 7 sub-points this idea can hold. <5 = fail."
8. **Defensible** — The author has earned authority to claim it (Cinematic Composing's 15+ years teaching cinematic composition). *Detect:* "What proof does the author have to make this claim? List 3 concrete credentials. <2 = fail."
9. **Inevitable-sounding** — Once heard, feels obvious in retrospect ("of course habits compound"). *Works because:* Ogilvy's "Do I wish I had thought of it myself?" test. *Detect:* "Read it cold. Score 0–5 on 'this feels obvious now that I hear it.'"
10. **Polarizing** — Some hate it, some love it; nobody says "meh." *Works because:* polarization is the only escape from being ignored (Bencivenga's Credo Technique). *Detect:* "Generate the strongest counter-argument a smart skeptic in the avatar's world would give. Strength 0–5; <2 = not polarizing enough."
11. **Mechanism-implication** — Implies a how-it-works the reader doesn't yet know (Stefan Georgi/Schwartz "new mechanism"). *Detect:* "Does the title imply 'I'll show you HOW'? Y/N + name the implied mechanism."
12. **Category-creating** — Names a category that didn't exist by that name yesterday (Antifragile, Atomic Habits, Lean Startup, Blue Ocean). *Works because:* April Dunford's "market frame of reference" — owning a category beats competing in one. *Detect:* "Search prior usage of this exact phrase. If <50 prior uses in the avatar's domain, score 5."

**Additional signals discovered in research:**
13. **Nut-graf compatibility** — Can the title's expansion sit at paragraph 2 of a feature story? (WSJ formula). *Detect:* "Write a 50-word nut graf. Coherent? Y/N."
14. **Talking-to-strangers test** (Roy H. Williams) — Would you say it to a stranger at a bar without embarrassment? *Detect:* "Read aloud. Cringe? Y/N."
15. **30-year test** (Ogilvy) — Will this still make sense in 30 years? *Detect:* "Year-strip the title. Still readable? Y/N."

**Final ranker** = weighted geometric mean of (4) avatar-resonant × (1) counter-intuitive × (3) coined × (8) defensible × (7) anchorable, with (6) Heath SUCCESs as a min-threshold gate (must score ≥18/30) and (9) inevitable + (10) polarizing as bonus multipliers.

---

## H. Final Synthesis: Recommended Hidden-Hook Extraction Procedure

### File layout
```
~/.claude/skills/hook-creator/
├── SKILL.md                        # entry point, ~1500 words
├── references/
│   ├── patterns-catalog.md         # 30 named patterns w/ exemplars
│   ├── signals-rubric.md           # 12+3 detection signals
│   ├── avatar-cinematic-composer.md
│   ├── ogilvy-5-test.md
│   ├── heath-success.md
│   └── schwartz-categories.md
└── scripts/
    └── mmr_diversify.py            # optional: embedding-based diversity
```

### SKILL.md (frontmatter + body skeleton)
```yaml
---
name: hook-creator
description: |
  Extract 20 captivating hook-style book/course/module titles from any long-form
  work (manuscript, transcript, chapter, course module) by running the Schwartz-
  style 6-pass extraction discipline. Use this skill whenever the user provides
  a body of long-form content and asks for title candidates, hook ideas, marketing
  angles, or "what should I call this." Especially relevant for cinematic-music
  composition educational content (brand: Cinematic Composing).
allowed-tools: Read, Bash
---
```

### Body — 6 prompt templates (LLM-ready)

**Template 1 — Cache-load (system block):**
```
You are a hook archaeologist trained on Eugene Schwartz's Breakthrough Advertising
(1966), Sol Stein's Stein on Writing, Ryan Holiday's Perennial Seller, the Heath
Brothers' Made to Stick, David Ogilvy's Ogilvy on Advertising, and the Cinematic
Composing brand voice.

Your single job: find captivating sub-ideas hidden inside long-form content the
way Tim Ferriss found "The 4-Hour Workweek" inside his lifestyle-design book and
the way James Clear found "Atomic Habits" inside his habits research.

A captivating sub-idea is rarely the topic of the work. It is one specific,
counter-intuitive, nameable construct that lives somewhere inside the work and
that, once named, becomes the work's center of gravity.

[CACHED: full manuscript]
[CACHED: avatar doc — Cinematic Composing student]
[CACHED: 30-pattern catalog]
[CACHED: 15-signal rubric]
```

**Template 2 — Pass 1 Inventory:**
```
Read the cached manuscript twice mentally. Then produce a structured inventory
in exactly 8 categories. For each category, surface AT LEAST 10 items quoted
or paraphrased from the manuscript with a chapter/page reference.

1. PROMISES — every transformation, outcome, or end-state the work promises
2. OBJECTIONS — every skepticism, doubt, or "yeah but" the avatar would raise
3. CURIOSITY GAPS — every question the manuscript opens but does not immediately close
4. COUNTER-INTUITIVE CLAIMS — every assertion that violates conventional wisdom
   in the cinematic-music-composer world
5. SPECIFICITIES — every concrete number, named timeframe, named technique,
   named person, named piece, named studio
6. STORIES/ANECDOTES — every narrative moment, especially off-hand or jaw-dropping
   anecdotes (the John-Carlton-one-legged-golfer kind)
7. MECHANISMS — every named how-it-works construct, every "the reason this
   works is X" passage
8. IDENTITY/STATUS — every implicit "the kind of composer who does this is..."

Output as a markdown table. No commentary.
```

**Template 3 — Pass 2 Coining:**
```
For each row in the inventory, generate 2–4 candidate hook-style names following
these constraints:
- 2 to 6 words
- Noun phrase, not sentence
- One coined or repurposed term where possible (Atomic Habits, Antifragile,
  Deep Work, Lean Startup, Purple Cow, Sapiens, Blue Ocean, Linchpin)
- Must use vocabulary that appears in the avatar's verbatim language (see
  cached avatar doc)
- MAY include one number or specific (4-Hour Workweek, 10,000 Hour Rule,
  80/20 Principle)
- MUST avoid: jargon-only academic titles, generic gerund titles
  ("Composing for Films"), "ultimate guide" patterns, AI-cliché openings

Output: candidate name | source row | pattern matched (from cached pattern catalog)
```

**Template 4 — Pass 3 Signal Scoring:**
```
For each candidate name, score 0–5 on each of the 15 signals from the cached
rubric (counter-intuitive, specific, coined, avatar-resonant, promise-laden,
SUCCESs[6], anchorable, defensible, inevitable, polarizing, mechanism-implying,
category-creating, nut-graf-compatible, stranger-test, 30-year-test).

For each non-zero score, give a one-sentence justification quoting either the
manuscript or the avatar doc verbatim. No score without quoted evidence.

Apply the SUCCESs gate: candidates scoring <18/30 on the 6 SUCCESs axes are
eliminated.

Output: scorecard table sorted by weighted score.
Weighted score formula:
  W = (avatar*0.25 + counter_intuitive*0.15 + coined*0.15 +
       defensible*0.10 + anchorable*0.10 + mechanism*0.10 +
       category*0.05 + inevitable*0.05 + polarizing*0.05) ×
       (1 if SUCCESs >= 18 else 0)
```

**Template 5 — Pass 4 Adversarial Review:**
```
Top 30 candidates only. For each, run three personas in parallel:

A) SKEPTICAL TRADE EDITOR (Adrian Zackheim style):
   - "Would I gasp?" (Ogilvy Q1)
   - "Do I wish I'd thought of this?" (Ogilvy Q2)
   - "Could this be used in 30 years?" (Ogilvy Q5)
   - Score 0–5 overall + one-sentence verdict.

B) AVATAR (cinematic-music composer trying to break in):
   - Would I click this in an email subject line? Y/N
   - Would I screenshot this title and send to a peer? Y/N
   - Does it use a phrase I would actually say? Quote it.
   - Score 0–5.

C) STEVEN PRESSFIELD-STYLE CRAFT SKEPTIC:
   - Is this real, or is it a marketing wrapper around vapor?
   - Can the author defensibly hold a 60-minute talk on this without
     repeating themselves? Y/N
   - Score 0–5.

Final candidate score = 0.4*Avatar + 0.4*Editor + 0.2*Skeptic.
```

**Template 6 — Pass 5 Output:**
```
Produce final ranked top 20 hooks. For each:

1. **Hook title** (the candidate)
2. **Source** — chapter/section + 1-sentence quoted passage
3. **Pattern** — which named pattern from the catalog
4. **Avatar quote** — verbatim avatar language this hook activates
5. **Mechanism implied** — what does the title promise to teach
6. **Signal scorecard** — 15-row table
7. **Why this works** — 2–3 sentence editorial rationale
8. **One-paragraph "nut graf"** — what the work would say at paragraph 2
9. **Subtitle suggestion** — 6–14 word descriptive complement
   (the 4-Hour-Workweek-style "Escape 9-5, Live Anywhere…")
10. **A/B test recommendation** — 2 hooks from the top 5 to send to PickFu

Diversity check: ensure no two hooks share the same coined-noun root.
If they do, demote the lower-scoring one and pull the next from rank 21+.

Format as markdown. No prose preamble. Begin with the table.
```

### Optional Python helper (`scripts/mmr_diversify.py`)
```python
# ~30 LOC: voyageai or openai embeddings + sklearn MMR (λ=0.7)
# Input: top 30 candidate strings
# Output: top 20 maximally diverse, by embedding cosine
# Run only if Pass 5 reports >2 candidates with same noun root
```

### Operational notes
- **Model:** Sonnet 4.6 ($3/$15 per MTok, supports 1M context with no surcharge for content >200K). Avoid Sonnet 4.5 for >200K-token works (2× input surcharge).
- **Caching:** mark manuscript, avatar doc, pattern catalog, and rubric as `cache_control: {"type": "ephemeral", "ttl": "1h"}`. First call writes (1.25× input cost), subsequent 6 calls read at 0.1× input cost.
- **Token budget per run (200K-word book):** ~250K input, ~25K output. With caching, ~$1.40. Without caching, ~$1.10 + $0.38 = $1.48 — caching wins meaningfully only at ≥3 reads, which this procedure satisfies (6 passes).
- **Latency:** ~3–5 minutes end-to-end on Sonnet 4.6.
- **Eval loop:** persist top-20 outputs to a `runs/` log. Once you have 30+ runs with downstream PickFu data, feed back as DSPy training data for prompt optimization (MIPROv2).

---

## Caveats

1. **Reliability of "Schwartz at 3 a.m." anecdote:** The "read manuscript twice" practice is widely attributed to Schwartz by his protégé Brian Kurtz and in Bencivenga's lineage, and it's consistent with Schwartz's own statements in *Breakthrough Advertising* ("the headline you want is wrapped up inside that product…nowhere else"). I have *not* found a primary source where Schwartz himself describes the literal 3 a.m. timing or a fixed 8-category list — those specifics are reconstructions from secondary sources and the spirit of his book. Treat the 8 categories as an operationally useful synthesis, not Schwartz's verbatim taxonomy.

2. **"33-Headline" / "120-Headline" exercises:** Folk-attributed in copywriting forums; I could not verify a primary citation. The robust, citable practice is "write at minimum 50 candidates before choosing" (Schwartz) and "25 per article" (Upworthy, formally documented in their published process and the 2024 Aubin Le Quéré & Matias paper).

3. **Atomic Habits title pivot:** I found no public record of a major working-title pivot for *Atomic Habits*. James Clear has blogged extensively about content selection but the "Atomic Habits" coinage appears to be his original framing. If a deeper pivot story exists, it lives in private editorial correspondence with Avery/Penguin.

4. **Spotlight paper (Mullick et al. 2509.10935):** This is the strongest academic precedent for the exact task. However: (a) only published Sep 2025 with a v3 in Oct 2025; (b) requires labeled training data the user won't have; (c) the released code (`github.com/ankan2/Spotlight-EMNLP2025`) is research-grade, not productized. **Borrow the evaluation rubric and the Info-Distribution=Skewed framing; do not depend on their model.**

5. **Editor processes are largely undocumented in primary sources.** Sonny Mehta (Knopf), Ann Godoff (Penguin Press), Will Schwalbe, Bonnie Solow, Hollis Heimbouch, Stephanie Frerich, Niki Papadopoulos — most title selection is verbal/email-driven and unrecorded. Adrian Zackheim's podcast appearances (Extraordinary Business Book Club ep. 53, others) are the most operationally useful interviews. Treat editor methodology as triangulated craft consensus, not single-source-cited.

6. **NLP recency on this specific task is thin.** Outside the Spotlight paper, "interestingness detection" / "captivating-angle extraction" is not yet a well-established benchmark. Most adjacent academic work is summarization (uniform coverage) or headline generation (different optimization target). The recommendation to do this *as an LLM-prompted procedure rather than a learned model* reflects this state of the art.

7. **Cost estimates use Anthropic's published pricing as of early 2026** (Sonnet 4.6 at $3/$15 per MTok, caching read at 0.1×, 1h TTL write at 2× / 5-min TTL write at 1.25×). Pricing is stable since 2025 but check `platform.claude.com/docs/en/build-with-claude/prompt-caching` before deploying.

8. **The cinematic-music-composition niche specifically:** I did *not* run the procedure end-to-end on Cinematic Composing's actual content. The avatar doc, vocabulary corpus, and 30-pattern catalog all need to be authored by you (or generated as a sister skill). The Hook Creator skill's quality is bounded by the quality of those references; budget 4–8 hours to assemble them well before the first run.

9. **PickFu testing is downstream.** This skill outputs candidates worthy of testing; it does not test them. Plan a complementary skill that takes the top 5 outputs and constructs PickFu polls (or an AdWords/Meta ad split-test in Tim Ferriss's style).

10. **Polarizing signals are double-edged.** A hook that polarizes generates engagement, but for an educator's brand (Cinematic Composing) excessive polarization can cost subscribers. The detection rubric scores polarization 0–5 *as a positive*; you may want to cap polarization at ≤3/5 for brand-safe outputs. Tune in step 4 of Procedure 3 if your post-launch analytics show subscriber-loss correlation with high-polarization titles.