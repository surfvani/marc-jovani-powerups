---
name: manager-checkout
description: Use when Marc triggers the day checkout ("checkout", "done for the day", "cerramos el día"), when the ~6:15pm PT clock passes with no checkout yet (one-line ping), or when closing a day whose checkout went unanswered (quiet day-close variant). Server-specific to this box — CLAUDEMANAGER sessions only; skip if the CLAUDEMANAGER persona is not loaded. The evening half of the loop the 5:10 brief opens.
---

# /manager-checkout — the day checkout

The brief says what should move; the checkout verifies what did — and plans tomorrow FROM THE PLAN, never from the day's residue. Born as a skill 17 Aug 2026 after a close planned Monday from urgencies and buried the week's #1 intention (Marc: "the opposite outcome of why the agent was designed for").

## Hard rules (non-negotiable)

1. **PLANNER FIRST.** No rapid-fire question, no accountability line, no MAÑANA item until you have fetched and read IN FULL, at checkout time, from the wiki DB (`http://127.0.0.1:5052/api/documents`): the latest WEEKLY (One Domino · numbered intentions · daily_focus rows · Zone 2 including any "confirm at checkout" items and its urgency list · NOT MY NORTH STAR) and the latest DAILY sheets for today and tomorrow (intentions + aligns_with + schedule table). A wake-carrier summary or digest block is staging, NEVER a substitute — the 16 Aug failure was running from the summary. The DB lives outside git; the open-check cannot see it.
2. **Intentions outrank urgencies.** Tomorrow's plan is FRAMED by the weekly intentions (`NORTH_STAR/DOCUMENTATION.md` §5B: every daily plan derives from the weekly). Urgencies slot under or after — they never claim the prime block by default. Conflicts are surfaced, not silently resolved (see The Classification).
3. **Meetings are must-shows.** Only automated sends "run themselves." Any fixed-clock human commitment (meeting, class, call) goes into MAÑANA AND into accountability as show-up-prepared. Time-feasibility check: the MORNING block must physically fit before the first fixed clock.
4. **LIVE-NUMBER RULE** (persona § Daily Brief): every number measured at write time or timestamped as cached; `date` before any clock claim.
5. **Chat first, files second** (Marc, 15 Aug): accountability + MAÑANA + WINS are presented as chat text, Marc adjusts, ONLY THEN the file pass — one pass.
6. **Pre-gains is a LOCKED FOUNDATION** (Marc, 16 Aug): journal formula — present perfect as already accomplished · arrow blocks → MORNING / → DAY / → IN BETWEEN · ≤3 per block · He = his work / Hemos = family · Spanish connects, ENGLISH CAPITALS carry concepts · anti-overwhelm. Additive improvements only.
7. **A "no" costs nothing in the moment.** Mark it, keep firing — never discuss mid-checkout. No's ride tomorrow's brief; anything urgent becomes a NEEDS YOU.
8. **Horizon discipline** (Marc, 15 Aug): the close carries only items whose action window is today→tomorrow. Everything further rides the Monday brief. Family-day closes carry no far-horizon work items.
9. **Retire stale flags with evidence** (Marc, 15 Aug): before surfacing any PENDING item, grep the systems that would embody the answer (prod queue, Hub, committed files). Never re-ask what the world already shows.
10. English (US) for everything written to files; the conversation follows Marc's register (Spanish connects, English carries concepts, short keyword style).

## The Classification (standing duty — all day, not only at checkout)

Every work item you plan, accept, or see Marc propose gets one of three classes:

| Class | Definition | Handling |
|---|---|---|
| **INTENTIONAL** | From inside a plan. Strategic. Designed. Supposed to be done | Default headline of MAÑANA; clean line on the card |
| **URGENCIA** | Has to be done, but lives in NO plan — it just appeared | Slots under/after intentions; **ultra-mini red dot** on the card/bar (experiment, Marc-authorized 17 Aug 2026 — review after a few days) |
| **DISTRACTION** | Self-invented stay-busy work pulling Marc away from what he is supposed to be doing | Never reaches the card silently. Flag it: "hey — this is not part of the week's intention." If Marc overrules, it lands as an unplanned item (red dot). He decides; you steer |

**The standing exception — NEVER distraction:** hobby, time with Ali, time with family, time with kids, flow activities. They are part of the life design.

**The steering duty (Marc, 17 Aug 2026):** "You ultimately obey the visionary, but must also be THE GUIDE, THE REMINDER ('hey: this is not part of the main intention of the week')." Flag drift the MOMENT it appears — mid-day `mgr` line, brief, checkout, anywhere. A direction change is cheapest while it is still live.

## The workflow — beats in Marc's order (11 Aug: rapid-fire → accountability → MAÑANA → WINS)

### Step 0 — TODO
Task list from these steps (task tools where available; a visible manual checklist otherwise).

### Step 1 — Trigger
- Marc, any time: "checkout" / "done for the day".
- No trigger by ~6:15pm PT → ONE ping: "Checkout? N questions — 90 seconds." (He asked for this; it pairs with Parar a las 6.) Already triggered today → no ping. Never nag twice.
- No answer by the late-evening hop → **quiet day-close variant**: Steps 2, 5 (derived, LABELED derived), 6 (evidence-only wins, LABELED), 7, 8 — the unanswered questions ride tomorrow's 5:10 brief.

### Step 2 — PLANNER FIRST + fresh systems read
1. Wiki DB IN FULL (Hard rule 1). `?limit=10` to spot the newest docs; `GET /api/documents/<id>` for today + tomorrow dailies; `GET /api/documents/latest/weekly`.
2. `(cd /home/ubuntu/NORTH_STAR && git pull)` · prod send calendar read-only in a subshell `(cd /home/ubuntu/app_cc && …)` — scheduled/sent rows `AT TIME ZONE 'America/Los_Angeles'` · live numbers (members, launch revenue by funnel/checkout — never by product name).
3. Build the "should have happened today" list FROM: today's daily sheet + the weekly (daily_focus row AND intentions AND its checkout-confirmation items AND its urgency list) → then plans' Active State, standing watch, chases, prior NO's.
4. If the day pivoted, mark displaced items dead before building questions (3 Aug lesson).

### Step 3 — Rapid-fire binaries
"These should have happened today:" — numbered, each with a TINY anchor in MARC'S vocabulary (3–4 words; one line of real context for items he hasn't touched in days — a wrong anchor costs more than a long one). He answers in one line ("1 yes, 2 no…"). ~7 questions typical; more is fine when the day genuinely holds more. Never ask what a system already answered.

### Step 4 — Accountability close
"**Locked.**" → consequence-framed dependencies, never a schedule:
- **ON YOU** — Marc's must-acts first (action → what stays locked without it). Meetings/classes/calls = **must-show-prepared items with their clocks**. NEVER "corre solo" for anything requiring his presence.
- **ON <each team member>** — "if X doesn't Y, Z stays stopped (date)".
- Scheduled/automatic sends stay OUT (one reassurance line at most; a full what's-coming schedule only on explicit request).

### Step 5 — MAÑANA (pre-gains, chat first)
0. **TIMING (locked by Marc, 17 Aug 2026):** if a daily alignment landed MID-DAY, the MAÑANA surfaces (sheet → bar → card) were already refreshed THE MOMENT the alignment was processed — fresh context, the alignment always wins. This checkout then **ADJUSTS** what changed since; it never re-creates. On days with NO mid-day alignment, this checkout is where MAÑANA is born.
1. **Source:** tomorrow's daily sheet if it exists; else derive from the weekly's daily_focus row + intentions, LABELED derived.
2. **Frame:** weekly intentions first (aligns_with mentally attached) → urgencies under/after → time-feasibility vs tomorrow's schedule table (Hard rule 3).
3. **Classify every item** (see The Classification). Name conflicts in one line ("el weekly dice mañana AM = componer CA; tus 3 del vault van después — ¿ok?"). Marc decides with the frame visible — even against his own late-night words, restate the frame once, then obey his call.
4. **Render** in the journal formula (Hard rule 6) · 🌊 flow = a SPECIFIC physical trigger activity (`NORTH_STAR/DOCUMENTATION.md` §5B — bike best; never "how the day flows") · 💭 feeling intention.
5. Present in CHAT. Marc adjusts. Files wait.

### Step 6 — THE WINS (the final conversational beat — nothing after it)
The day's meaningful accomplishments, most → least important, one needle-moved line each, every win evidence-backed (facts, systems, his answers — never invented, never padded; his own adds count). End: "**The three that mattered:**" — the three biggest in one line. Register: tiny mono labels · bold only decision-words · his language mix · "·" separators · cuanto más cortito, mejor.

### Step 7 — ONE file pass (only after Marc's adjustments)
- WINS three layers: `BOARDS/PROJECT_HERO/WINS.md` (append, newest-week-first) · board **Hero Log** box (current week, ALL wins) · `wins.html` (the /wins archive). Monday's close starts a fresh week section.
- Board **MAÑANA bar** + **`dia-card.html`** → redeploy the "EL DÍA" artifact, SAME url (https://claude.ai/code/artifact/74279c94-37ac-474d-8144-45f0c4cfdcc6). URGENCIA items carry the ultra-mini red dot; INTENTIONAL items stay clean. **The FLOW line carries design WEIGHT and a CONCRETE HOUR** — larger type, the hour in mono accent, "no negociable" (Marc, 17 Aug: *"el flow hay que schedulearlo — si no se schedulea, me lo salto… ocurre a esta hora, no es negociable; todo lo demás ocurre alrededor"*). Footer stamp updated (`date` first).
- Checkout answers are EVIDENCE: tick plans with it ("Marc confirmed, checkout N Aug"), one log row per edit in `THE_BOARD.md`.

### Step 8 — Hand off to /manager-close
The close stages tomorrow (digest Today block + brief leads) FROM this checkout's planner-framed output. Invoke it when the session is ending; after a mid-evening checkout, the late-evening quiet hop runs it.

## Failure modes

| Symptom | Action |
|---|---|
| Tomorrow's daily sheet doesn't exist | Derive from weekly daily_focus + intentions, LABEL as derived — never invent specifics |
| Marc's instruction conflicts with the weekly | Restate the weekly frame ONCE, with the classification, then obey his call |
| An item fits no class cleanly | That is judgment → one line to Marc with a recommendation |
| Checkout unanswered by late evening | Quiet day-close variant (Step 1); wins from evidence only, labeled; questions ride the brief |
| A rapid-fire answer contradicts a system reading | Trust Marc for off-server facts; re-verify on-server facts before writing them anywhere |
| "The digest already says it — skip the DB read" | That is the 16 Aug failure verbatim. The digest is staging. READ THE DB |
