---
name: team-discussion
description: Use when two or more AI agents should work as a disciplined team on the same problem — a build plan, brainstorm, architecture decision, review, or research effort — rather than one agent alone or several agents debating in circles. Installs the shared rulebook that keeps multi-agent work from spiraling — state lives in files, conversation is reserved for disagreements that would change the user's decision, checkable claims get verified before they are contested, roles are assigned deterministically, and the discussion has a defined end. Skip when one agent is obviously sufficient.
---

# /team-discussion — the multi-agent rulebook

Two agents should be smarter than one, not slower. Without rules they are slower: they summarize each other, correct the summaries, then correct the corrections, and the user ends up refereeing instead of deciding.

**This skill is the rulebook. Load it in every participating session. There is nothing to copy — the skill IS the protocol.**

---

## The one rule everything follows from

**State lives in files. Conversation is only for disagreements that would change the user's decision.**

The failure this prevents: when project state lives in chat, every summary re-creates reality from memory, the other agent re-verifies it from *its* memory, and every small drift spawns a correction thread. Files kill this — summaries become *renderings* of the ledger, checkable by diff instead of debatable.

---

## Bootstrap — first 60 seconds, no user input required

1. **Claim roles deterministically.** The first agent the user addresses is **OWNER**. Every other agent is **VERIFIER**. An agent that loads this skill and finds OWNER already claimed in `DESK.md` becomes VERIFIER automatically. *The user's plain-language role assignment always overrides this default — the default exists only so that forgetting to assign roles is harmless.*

2. **OWNER creates the state folder.**
   - Inside the project when one exists: `<project>/team/`
   - Otherwise: `~/team-discussions/<topic>/`

3. **OWNER creates two files** from `references/` in this skill folder:
   - `LEDGER.md` — every decision (user's words, quoted, which session, when) and every claim with its evidence tag. The shared memory both agents trust.
   - `DESK.md` — the **only** file the user ever has to read. Pending decisions and open disputes. **≤15 lines.**

4. **OWNER writes `DESK.md` line 1:** `OWNER: <name> · VERIFIER: <name> · msg-budget: 10 remaining`

5. **VERIFIER reads both files and says nothing** unless something is 🔴.

**Session-start rule for every later session, either role:** read this skill → `LEDGER.md` → `DESK.md`, in that order. **Never reconstruct state from transcripts or memory.**

---

## Roles — enforced by the protocol, not by good intentions

**OWNER** holds the pen.
- Sole writer of `LEDGER.md` and `DESK.md`. This is a pull-request model, not a shared whiteboard — no edit races, no merge debates.
- Produces **every** user-facing rendering. Renderings cite ledger row IDs and carry each claim's evidence tag inline. **If it is not in the ledger, the OWNER cannot state it as fact.**
- Merges the VERIFIER's 🟡 edit-proposals same-turn, without discussion.

**VERIFIER** holds the red pen.
- Reads everything. Coverage is unlimited; only *conversation* is bounded.
- Audits claims, evidence tags, and shelf placement — in **both** directions (see Hazard).
- **Produces no competing summaries, plans, or artifacts.** When the user asks the VERIFIER for status, it renders from the same files — same source, same answer, zero verification loop.
- Speaks only when something is 🔴.

Neither agent reviews the other's writing style. Content only.

---

## The severity gate — triage before you speak

Every finding is triaged **before** it is sent:

| | Meaning | Action |
|---|---|---|
| 🔴 **BLOCKING** | Would change a user decision, a committed architecture item, or money | The **only** class that may generate a reply turn |
| 🟡 **NOTE** | Improves an artifact, changes no decision | Batched file-edit proposal. **No reply message exists for a 🟡.** |
| ⚪ **NIT** | Wording, phrasing, bookkeeping-about-bookkeeping | Fixed silently or dropped. **Discussing a ⚪ is a protocol violation.** |

The test, before raising anything: **"If this is not corrected, what does the user build differently?"** If the answer is *nothing*, it is not 🔴.

---

## The loop-breakers — hard limits, no judgment calls

1. **Two-volley rule.** Any claim gets at most one challenge and one response. Still split? It goes to `DESK.md` as a dispute — ≤3 lines per side, the user decides. **A third volley never happens.**

2. **Turn budget per exchange.** Default 2 turns each. Hitting the budget auto-escalates to the desk. Only the user extends.

3. **Endorsement is the default.** The closer is: *"🔴 objections only — reply ENDORSED or a 🔴 list; 🟡 as file-edit proposals; ⚪ silent."* **Never** close with an open invitation like "anything I got wrong?" — two capable models asked that will always find something, because at sufficient resolution everything has a flaw. That question cannot terminate.

4. **Acceptance by reference.** Agreeing is `L7 ✅`, not a paragraph restating it. Restating an accepted point in new words creates new wording to check. That is how loops breed.

5. **Message cap.** ~200 words agent-to-agent, except artifact bootstraps and user-requested renderings. Long messages generate long replies.

6. **Check before you contest.** A checkable claim may not be contested from memory. Before disputing anything public sources can settle — hardware specs, published research, pricing, documented behavior — the contesting agent verifies **first**: a quick web search when it is a minutes job, or propose a satellite deep research to the user (prompt written via `/research-prompt-instructions`) when it is not. **A research flag is a trigger, not a label.** Gain: a disagreement that survives two *checked* agents is a real dispute; memory-versus-memory collisions never reach the user again.

7. **Pre-send intent note.** Before any agent-to-agent message: (1) note what the other agent actually said · (2) plan the reply · (3) test it — *"does this keep us focused, or make us drift?"* · (4) tell the user in ≤3 plain-language lines what is about to be sent and why · (5) send. This moves the user from reading wreckage to gating traffic.

---

## END-STATE — how the discussion ends

Rules 1–7 bound each *exchange*. This rule bounds the *discussion*. **Bounds do not compose upward for free** — a spiral can be built entirely out of individually well-terminated exchanges.

**The discussion is OVER when `DESK.md` holds zero open disputes and every remaining item is a user decision.**

At that moment: the OWNER rings the closing bell — one final ≤15-line desk rendering — and **both agents go silent.** The desk is the only output. **Silence is the correct final state, not a stall.**

**Whole-discussion budget: 10 agent-to-agent messages total**, counted in the `DESK.md` header. Hitting it forces the closing bell, with whatever is unresolved listed as disputes. **Only the user re-arms the counter** — their explicit "keep going" resets it. Nothing else does, including a good idea.

---

## The user-facing contract — the "make my life easy" clause

- The user reads `DESK.md`. Or asks either agent, who renders from the files in **one** message; the other agent verifies silently and speaks only if 🔴.
- **Decisions reach the desk once, in plain language, with a recommendation.** No convergence theater in front of the user, ever.
- Pending decisions go at the **top** of every rendering. They are the point; everything else is context.
- When the user gives a GO, the OWNER moves the row to USER-LOCKED with quote, session, and date — same turn.
- Default to **one agent between gates**. Convene the team when a claim gates spending or an irreversible decision, when a plan is about to be committed, or when the user asks — and **the user loading this skill IS the ask.** A quiet default is what makes the loud moments worth it.

---

## Failure log — why each rule exists (permanent, do not trim)

Every rule above was paid for. Keep this section so future sessions know what they are preventing.

1. An open "correct me if I'm wrong" closer is a fishing invitation → infinite refinement. → Rule 3.
2. Chat summaries drifted from source (an estimate hardened into a fact; decision shelves merged; points dropped) → agents spent turns correcting *summaries* rather than the plan. → Files as source, renderings with row IDs.
3. "Whose record governs" got negotiated across four turns because each agent treated its own session as the complete record. → Union ledger with quote · session · when · status.
4. Cosmetic and load-bearing corrections received identical airtime. → Severity gate.
5. Bookkeeping schema was designed *through conversation* — agents building infrastructure for their own dysfunction. → 🟡 goes straight to files.
6. Both agents argued from memory about facts that were published and checkable in minutes. → Rule 6.
7. Ten individually well-terminated exchanges still produced a spiral. → END-STATE.

---

## Known agent weaknesses and their containment

| Weakness | Containment |
|---|---|
| **Compression drift** — punchy summaries shave qualifiers; an estimate becomes a fact | Renderings cite row IDs and carry evidence tags inline; acceptance by reference |
| **Strong-form overclaim** — stating the most useful-sounding version of a claim rather than the most defensible | Evidence tag attached at claim birth and travelling with it; state claims in their weakest defensible form |
| **Shelf inflation** — agent consensus quietly reclassifying itself as a user decision | USER-LOCKED requires a direct quote plus session |
| **Unbounded refinement** — always one more improvement available | Severity gate, two-volley rule, END-STATE |
| **Own-view-as-whole-picture** *(the root disease — it produces all of the above)* | One shared state; disagreements resolved by lookup, not by memory negotiation |

---

## Templates

`references/LEDGER-template.md` · `references/DESK-template.md`

Copy them into the discussion's state folder at bootstrap. They carry the conflict rule, the shelf columns, the evidence tags, and the permanent Hazard note — all learned the hard way, all project-agnostic.
