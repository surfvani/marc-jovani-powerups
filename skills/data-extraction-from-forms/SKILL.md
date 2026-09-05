---
name: data-extraction-from-forms
description: Use when Marc wants the verbatim voice of real people pulled out of a large form/survey export (CSV, Excel, Markdown, a DB table) for a specific topic — to write webinar copy, emails, landing pages, hooks, or to understand an avatar. Runs a coordinated team of separate Claude sessions (readers define subtopics, writers transcribe phrases verbatim in 50-row tranches) sized by file weight (~800 KB per agent), on Opus 5 (1M), with minimal chatter. Skip for small files a single session can read in one pass (< ~500 KB), and never use it to summarize or paraphrase — the output is the humans' exact words.
---

# Data extraction from forms — verbatim voice-of-customer at scale

**Born 4 Sep 2026** from the SVO survey extraction (2,227 composers, 27 columns, 3 MB CSV) for the "It's not your notes. It's the production wall" class. It worked. It also killed three sessions on the way. Both halves are in here.

**What it produces:** one merged subtopic list + N part files where every line is a real person's sentence, verbatim, with its row and column. Nothing paraphrased. Nothing summarized. A downstream writer (emails, landing pages, webinar) reads those files and never the raw export.

## 0. Ask Marc three things, then stop asking

1. **The source** — path to the CSV / Excel / MD / DB export. (Excel or DB → export to CSV first.)
2. **The topic** — the area of pain or desire to extract (e.g., "how their music sounds: production, mixing, realism"). One topic per run.
3. **The output folder** — a project folder outside the repos (e.g., `/home/surfvani/<project>/`).

Everything else is decided by this skill. Do not open an alignment gate. Do not load `/whatdocs` for the worker sessions.

## 1. Size the team from the file weight

Count rows (CSV via the `csv` module, not line counts — cells contain line breaks) and weigh the file.

| File weight | Agents | Rows per agent |
|---|---|---|
| ≤ 0.8 MB | 1 reader + 1 writer | all |
| ≤ 1.6 MB | 2 + 2 | halves |
| ≤ 2.6 MB | 3 + 3 | thirds |
| ≤ 3.4 MB | 4 + 4 | quarters |
| more | add a pair per ~0.8 MB | equal slices |

Rule of thumb: **~800 KB of lean text per agent, never more.** A 1M-context session reading 1,000 fat rows died at 85%; 800 lean rows costs ~300K tokens and leaves room to write.

## 2. Prepare lean chunk files (the one mechanical step)

Split the export into **50-row chunk files** with a script (this is preprocessing, not selection):

- One line per non-empty cell: `cK: text` (K = 1-based column number). Legend with the column headers **once**, at the top of each file.
- Collapse whitespace inside cells; omit PII columns (name, email, social URLs) and timestamps.
- Name them `rows_0001-0050.txt` … so ranges are obvious. Target ≈ 60–70 KB per file, ~1,100 lines.

**Why:** the first attempt repeated the full column header on every cell and put each cell on several lines — 5.9 MB for a 3 MB export, ~4,000 lines per chunk. With the Read tool's line-number overhead that doubled the token cost and killed a reader at row 637.

## 3. Launch separate sessions (agents, not subagents)

Marc's rule: real sessions he can see and steer from the app.

```bash
tmux new-session -d -s csvx1 -c $HOME "claude --name CSV-Extraction-1 --remote-control CSV-Extraction-1 --permission-mode auto --model 'claude-opus-5[1m]' none"
```

- One per agent; names `CSV-Extraction-1…N` (readers = the first half, writers = the second half). The trailing `none` answers the persona picker.
- **Opus 5 (1M context)** for this work — Marc: it follows the reading rules better; 1M is required for the row counts above.
- Verify each pane shows the statusline before sending a brief (`tmux capture-pane -p -t csvx1 | tail`). If a name resolves to two sessions (a dead one's Remote Control husk), send with the `[ref]` from `ListAgents`.
- Message them with `SendMessage`. Never type into their panes.

## 4. The reader brief (one message, English)

Readers read their slice **once** and define the subtopics. Send them exactly this shape:

- Goal of the team (the topic, in one paragraph) and who does what.
- Their range and the chunk file names; "read every file completely with the Read tool in as few calls as possible; read each file **once**".
- **Do NOT write notes, state files or scratch files while reading.** (A reader that kept per-tranche notes died on context.)
- **No grep, no regex, no scripts to find or select phrases** — a human reading, not a search.
- Output: ONE file `SUBTOPICS_reader{N}.md` — 6–8 subtopics inside the topic (offer a seed list to confirm/refine), each with a one-line definition, 5 verbatim examples (exact words, row + column) and a rough frequency; plus a short "surprises" section.
- Close with: "No questions, no confirmations — do the task, message MANAGER once when done."

## 5. Merge the subtopics yourself

When all readers report, write `SUBTOPICS.md`: the final 6–9 subtopic names **exactly as the writers must use them, in order**, one-line definitions, plus a last section `Uncategorized — clearly about <topic>, fits no subtopic`. Readers converge almost 1:1 when the topic is real; merging takes minutes. Do not ask Marc.

## 6. The writer brief (one message, English)

Writers wait for `SUBTOPICS.md`, then transcribe in tranches. Send:

- Same goal paragraph; their range and chunk files; **"Do NOT start reading until MANAGER sends GO — reading twice wastes your context. Until then read this brief and one chunk file to learn the format, then wait idle."**
- Output file `<TOPIC>_VERBATIM_PHRASES_rows_<a>-<b>.md`: header (source, range, progress line), one section per subtopic **with the exact names and order from SUBTOPICS.md**, then Uncategorized.
- Protocol: read one 50-row chunk completely → add that chunk's phrases under each subtopic → save → update the progress line → next chunk. Never several chunks at once.
- **Line format, one line per phrase, always:** `- "phrase exactly as written, any language" (row N, col K)`. Row N = the ROW label in the chunk file.
- Verbatim rules (Marc's, final): exact spelling and words · **no paraphrase, no grammar fixes, no merging two people** · cut only at sentence boundaries — the whole sentence(s) that carry the point, never a fragment · **non-English stays in the original, no translation, no gloss** · **no tags or markers** of any kind (nothing agent-written in the file except section headers, the progress line and the final section) · a phrase may sit under two subtopics if it truly belongs to both.
- Net: **inclusive.** Phrases that describe the pain without the vocabulary ("it never sounds finished", "I'm embarrassed to let anyone hear it") count. Bare gear/spec lists stay out unless the person editorializes.
- Reporting: one line to MANAGER every 250 rows (rows done + count per subtopic); at the end add `Most repeated formulations (rows a–b)` — the 20 phrasings seen most often with rough counts — and message "Writer N complete".
- Close with: "No questions, no confirmations — do the task."

Then, when `SUBTOPICS.md` exists: one line to each writer — **"GO. <path> is ready. Start tranche 1."**

## 7. Coordinator conduct (this is where it went wrong)

- **Minimal chatter.** Marc: "6 agentes con modelos potentes se vuelven locos cuando empiezan a hablar. Es una tarea simple: just do it." Answer a ruling **once, to all agents of that role at the same time**, in one line. Never let a thread of clarifications run; if two rulings cross, send one consolidated "final rules" line to everyone.
- **Agents ask the coordinator, never Marc.** If Marc answers one agent directly, his ruling overrides yours — propagate it to the others immediately.
- Relay to Marc in one line per milestone (reader done · writer at 250-row marks · all complete). He wants: "Agente 1: aquí · 2: aquí · 3: casi…".
- Keep a task list for the three phases (readers → merge → writers → hand-off).

## 8. Hand-off to the downstream writer

The session that will write emails/landing/webinar copy **never reads the raw export.** It reads `SUBTOPICS.md`, the readers' files and the part files when all are complete — and only then. Tell it explicitly, in capitals: DO NOT READ THE CSV OR THE CHUNK FILES. (A writer session died on context because its brief said "read the survey in full".)

## 9. Don'ts — each one cost a session or an hour on 4 Sep 2026

- **Don't load `/whatdocs` (or any read-everything / alignment-gate skill) into the worker sessions.** Its "read every file entirely" rule made agents read past their budget, and its gate made six Opus sessions interrogate Marc and the coordinator in parallel. These are workers with a closed spec.
- **Don't give one session the whole file.** DEV2 read 1,000 rows and hit 85% of 1M before extracting anything.
- **Don't ship fat chunk files** (header per cell, cell per line). Lean format or death.
- **Don't let readers keep running notes** or state files "to be safe" — that is the context they need to finish.
- **Don't let a writer read the corpus twice** (once "to learn", once to transcribe). Learn the format from one row.
- **Don't add tags, glosses, translations or "helpful" markers.** Marc ruled twice: the file is the humans' words only.
- **Don't relay agent questions to Marc.** Rule, propagate, move on.
- **Don't kill Marc's own sessions.** The coordinator kills only the workers it spawned, when their job is done and Marc agrees.

## 10. Reuse checklist (copy into the run)

☐ source · topic · output folder confirmed with Marc · ☐ rows counted, file weighed, team sized · ☐ lean chunks written · ☐ N sessions spawned on Opus 5 (1M), panes verified · ☐ reader briefs sent · ☐ readers done → `SUBTOPICS.md` merged · ☐ writer briefs sent earlier, GO sent now · ☐ 250-row reports relayed in one line each · ☐ all writers complete → downstream writer told "read these, never the raw file" · ☐ workers stood down.
