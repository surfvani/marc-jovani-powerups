---
name: samepage-brainstorming
description: Use immediately after /whatdocs delivers its PROPOSED SOLUTION and the simplll explanation (fires automatically — mandatory gate, /defcode stays locked until the gate closes with an explicit GO), or standalone whenever user and agent need verified alignment before executing something significant (plan reviews, subagentic-workflow Phase B approvals). Runs a clarification + brainstorming conversation — agent announces the gate, exposes its shakiest assumptions, asks one decision-question per message (multiple-choice preferred, 2-3 recommended approaches at forks), states what changed after every answer, minimum 3 exchanges (5 better) tracked silently, closes only on explicit user GO. Marc answers spoken out loud; Fede written. Visual moments get an artifact via artifact-design. Never produces a spec document or code. Skip only when the user explicitly orders the gate skipped.
---

# 🛑 THE ALIGNMENT GATE — no execution until we're on the same page

## WHEN THIS FIRES
- Automatically at the end of /whatdocs, right after the simplll explanation. Mandatory, not optional.
- Standalone: whenever user and agent need verified alignment before something significant gets built (plan reviews, subagentic-workflow Phase B approval).

## THE HARD GATE
Do NOT enter /defcode, write code, modify files, or take any implementation action
until this gate closes with an explicit GO from the user. This applies to EVERY
proposal regardless of perceived simplicity.

Only exception: the user explicitly orders the gate skipped ("skip the gate",
"just execute"). Obey — but first state, in one sentence, the single biggest
unexamined risk.

## WHY THIS EXISTS
Sessions run ~2 hours. Human energy degrades along the way, and the discussion
that would catch a wrong direction usually never happens. A real incident proved
it: one fresh-energy review conversation completely changed a session's outcome.
This gate makes that conversation structural instead of lucky. Five minutes here
saves days — sometimes weeks — of confidently building the wrong thing.

## THE OPENING MOVE
Announce the gate, in this spirit:

> «We are not going to move forward until there's crystal clear evidence that you
> and I are on the same page — so we're having a clarification + brainstorming
> session now.»

Then, in the same message, expose yourself:
- Your 2-3 shakiest assumptions (things you decided without the user saying them)
- The one decision in the proposal you're least sure the user would make the same way

Then ask your first question. One question only.

## ANTI-PATTERN: "TOO OBVIOUS TO NEED THIS"
"Simple" proposals are where unexamined assumptions cause the most wasted work.
The cleaner the proposal looks, the more suspicious you should be that nobody has
challenged it yet. Every proposal goes through the gate.

## CONDUCT RULES
1. One question per message. A bigger topic = multiple turns, not a wall of questions.
2. Multiple choice preferred; open-ended fine when options aren't enumerable.
3. Decision questions only — intent, scope, trade-offs, priorities. Questions the
   codebase can answer are still FORVIDEN (that was /whatdocs' job).
4. At any fork: 2-3 approaches, plain-English trade-offs, lead with your
   recommendation and why.
5. After every user answer, state what just changed in your understanding or the
   proposal ("That changes X" / "That confirms Y"). No silent nodding.
6. Be flexible — loop back when something doesn't add up. Forward-only marching is
   the failure mode.
7. YAGNI ruthlessly. The gate may SHRINK the proposal — cutting scope is one of the
   best outcomes this conversation can produce.
8. Plain English throughout — simplll register, not engineer register.

## VISUAL SUPPORT (Marc is a visual thinker)
Per question, run the test: would the user understand this better by SEEING it
than reading it?
- YES → load the artifact-design skill, build the visual (architecture
  before/after, data flow, side-by-side approach comparison, UI options — mermaid
  renders natively in artifacts), publish it, drop the link. Don't ask permission.
- NO (scope questions, trade-off lists, text options) → stay in the terminal.

A technical topic is not automatically a visual question. Reserve artifacts for
moments where seeing genuinely beats reading — then they land hard.
No Artifact tool in the session? Fall back to a local HTML file opened in the
browser, or a mermaid/ASCII sketch in chat.

## PER-USER MODE
- Marc → encourage SPOKEN answers (dictation) — that's how he communicates ideas
  best. Expect transcription artifacts; confirm anything ambiguous before acting.
- Fede → written works best.

## CLOSING THE GATE
Track silently — never announce "turn 2 of 5". The gate closes when ALL are true:
1. At least 3 substantive exchanges (5 is better).
2. At least one element of the proposal changed — OR was genuinely challenged and
   survived with a reason the user accepted.
3. The user gives an explicit GO ("go", "approved", "aligned — execute").

EARLY GO: if the user says GO before 1-2 are met, push back ONCE with the single
highest-stakes question still open. If they reaffirm — obey. The user is the boss;
your job was making the skip conscious instead of tired.

## WHEN THE GATE CLOSES WITH GO
- If the proposal changed: restate the delta in 3 bullets max (changed / cut /
  confirmed). If the changes require reading additional files, that's the first
  thing /defcode's entry check picks up.
- The same agent continues into /defcode — no fresh agent, no context loss.

## NEVER PRODUCE
- A spec document. This gate outputs shared understanding, not paperwork.
- Code, file edits, or TodoWrite ceremony.
- A delta restatement longer than ~10 lines — past that you're writing a spec. Stop.
