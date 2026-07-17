---
name: whatdocs
description: Use when Marc asks for any fix, update, refactor, or new implementation in an existing codebase and the right move is to fully understand the system BEFORE touching code — not apply anything yet. Forces a research-first protocol — confirm what's actually being asked, request app structure if missing (or run targeted TREE commands on specific directories, never the whole app), list every document needed for a perfect fix (database/models, routes/forms, templates, JS, HTML, content examples), read each file ENTIRELY (skipping files or parts of files is FORVIDEN), reassess after the first pass and read more if needed, then propose the best solution (or multiple options) that is generic, clean, scalable, long-term, coherent with the existing architecture, and crucially NOT a duplicate of a system that already exists. Outputs a TODO list as the first move and ultrathinks between steps. Skip for trivial typo or indentation fixes that don't require codebase understanding, or when Marc explicitly says 'just do it' or 'execute this'.
---

🛑 RESEARCH-ONLY PHASE. DO NOT TOUCH CODE.

Your goal here: understand the system fully and propose a solution. No edits, no file modifications, no scripts that change state. Read-only commands only (ls, tree, cat, grep, pip list, sqlite queries). If you catch yourself reaching for Edit / Write / MultiEdit — STOP. That's the next phase, governed by /defcode.

ultrathink before executing these steps. Think deeply between steps.

Before you start exploring, actively challenge my request:
- Do you understand what I asked?
- Did I explain it correctly?
- Any questions?
- Anything I'm missing that I should explain to you?
- Anything I'm assuming that I should clarify?

Tell me if there's anything I assumed or missed when explaining this.

IMPORTANT — what counts as a legitimate question at this stage:

ONLY ask about INTENT or SCOPE — things only I can answer:
✅ "Is this fix meant for logged-in users only, or all users?"
✅ "When this triggers, should it run sync or async?"
✅ "Do you want this to apply retroactively to existing records, or only new ones going forward?"
✅ "Is the goal to fix the symptom users see, or the root cause even if users won't notice the difference?"

DO NOT ask about anything the codebase can answer. These are FORVIDEN at this stage:
❌ "Where is X?" → use tree / grep / find
❌ "What does Y do?" → read the file
❌ "How does Z work?" → read the code
❌ "What database / framework / library are you using?" → look at package.json, requirements.txt, CMakeLists.txt, the imports
❌ "Can you show me the [routes/models/templates] file?" → find it yourself

The rule: if a question can be answered by reading the codebase, you don't get to ask it. Do the work first. Lazy questions waste my time and signal you haven't engaged.

=========

The Discovery Loop — execute in order, then loop if needed:

  1. **Restate the task — then dive in.** Tell me what you understand I'm asking you to do. One paragraph max. If your understanding is wrong, I'll redirect now (cheap) instead of after you've read 20 files (expensive). If you have INTENT/SCOPE questions (only I can answer), ask them here. Everything else — find the answer yourself via the codebase. No lazy questions.

  2. **Get the lay of the land.** If I haven't given you app structure, ask for it. If I have, decide: is this enough, or do you need to go deeper? For deeper, run targeted `tree -L 3` commands on SPECIFIC directories — never the whole app. Exclude noise (`node_modules`, `.git`, build artifacts, audio/video binaries).

  3. **List every document you need.** Be specific. Database models, routes, forms, templates, JS, HTML, config files, content examples — name the actual files. Don't write "the relevant files." Write paths.

  4. **Read every file ENTIRELY.** Not snippets. Not "the relevant sections." The whole file. Skipping files or skipping parts of files is FORVIDEN.

  5. **Reassess.** After reading, ask yourself: "Do I now understand enough to propose a clean solution, or do I need to see more?" If more — loop back to step 3 with the new list. Keep looping until you genuinely understand the system. No shortcuts.

Each loop iteration is cheap compared to a wrong fix in production. Loop as many times as needed.


HARD RULES

MANDATORY:
- Read every relevant file, entirely.
- Gain as much context as needed. The more, the better. Don't assume — review.

FORVIDEN:
- Skipping files.
- Omitting parts of files.
- Assuming behavior you haven't verified by reading.
- Missing the JS, HTML, or template layer (these are the silent killers).

FILE TYPES TO COVER (the usual suspects — adapt to the stack):
- Database models + schema
- Routes + forms + endpoints
- Templates + content examples
- JavaScript (especially anything affecting the UI)
- HTML / view layer
- Config files

=========

ENVIRONMENT CHECKS — if applicable to the project

If the project is a Python web app:
- Check for SQLite usage
- Activate the venv: `source <path>/venv/bin/activate`
- List installed packages: `pip list`

If the project is a C++ / JUCE / Node / Rust / other stack:
- Run the equivalent: inspect dependency manifests (CMakeLists.txt, package.json, Cargo.toml), check installed versions, look at build config

Skip whatever doesn't apply to the stack you're in. The principle is: know your environment before proposing a fix that depends on it.

=========

CHAT MEMORY RULE

If a file is already in your context multiple times (because we've been iterating on it), use the LAST instance — that's the latest version. Older instances are dead drafts; don't reference them.

If you're unsure which version is current, ASK before assuming.

=========

ultrathink. Think deeply between steps.

====

When you've finished researching, propose your solution.

The solution MUST meet ALL of these:

  1. **Generic.** It fixes this problem AND prevents this type of problem in general. Not a one-off.
  2. **Doesn't make things worse.** Doesn't degrade anything that currently works.
  3. **Doesn't fix this and break something else.** No collateral damage elsewhere in the codebase.
  4. **Not a bandaid.** Addresses root cause, not the symptom.
  5. **Not a frankenstein.** Doesn't cobble together incompatible patterns or duct-tape layers.
  6. **Not a patch.** No "we'll fix it properly later" — fix it properly now.
  7. **Not a hack.** No clever shortcuts that obscure intent or trap future maintainers.
  8. **Long-term.** Survives the next 12 months of feature additions.
  9. **Scalable.** Works at 10x current load / users / data volume.
  10. **Clean.** Readable. Follows the codebase's existing patterns and conventions.

THE OVERRIDING RULE — coherent with architecture:
The solution MUST be a clean and logical fit with the whole app's architecture and logic. If it doesn't feel native to the codebase, it isn't the right solution — go back and look harder.

THE NON-NEGOTIABLE — no duplicates:
You MUST verify the solution is NOT a DUPLICATE of a system that already exists in the codebase. Reinventing a wheel that's already built is bad architecture and is FORVIDEN.

Before proposing, ask yourself: "Is there already a service / module / helper / pattern in this codebase that solves this category of problem?" If yes, USE IT (or extend it). Don't build a parallel system.

ultrathink and give me the best solution (or multiple options if there are genuine trade-offs to weigh).

START BY CREATING A TODO LIST

Use TodoWrite to lay out your discovery plan before reading anything. Example shape:

     ☐ Restate the task back to user — confirm I understand
     ☐ Run targeted tree on [specific directory] to see structure
     ☐ List all documents I need to read
     ☐ Read [specific file path] — to understand [what specifically]
     ☐ Read [specific file path] — to understand [what specifically]
     ☐ Read [specific file path] — to understand [what specifically]
     ...
     ☐ Analyze integration points between [system A] and [system B]
     ☐ Identify whether this category of problem is already solved elsewhere in the codebase
     ☐ Reassess after first pass — do I need to read more?
     ☐ If yes: list new files, read them entirely
     ☐ Tell user which files I reviewed
     ☐ Document all integration points and dependencies found
     ☐ Ask user any clarifying questions
     ☐ Propose the best solution (or multiple options) — clean, coherent, generic, long-term, NOT a duplicate

=========

WHEN YOU PROPOSE THE SOLUTION — required output structure

End your research phase by giving me a PROPOSAL block in this exact shape. This is what I'll approve / redirect, and what /defcode will consume when we move to execution:

```
=== PROPOSED SOLUTION ===

PROBLEM:
[1-2 sentences — what's actually broken or missing, root cause]

PROPOSED APPROACH:
[The clean solution in 1 paragraph. What changes, how, and why this is the right fit for the architecture.]

FILES THAT WILL BE TOUCHED:
- [path] — [what changes]
- [path] — [what changes]
- [path] — [what changes]

FILES THAT WILL NOT BE TOUCHED (but were considered):
- [path] — [why it stays untouched]

WHY THIS ISN'T A DUPLICATE:
[Name the existing systems you checked. Explicitly state why none of them already solve this.]

MIGRATIONS / SCRIPTS REQUIRED (if any):
- [migration name] — [what it does]

ROUTE / ENDPOINT CHANGES (if any):
- [JS expects X] ↔ [API registered as Y] — confirmed match

ALTERNATIVE OPTIONS CONSIDERED (only if there are genuine trade-offs):
- Option B: [approach] — [why I deprioritized it]

OPEN QUESTIONS FOR USER:
- [question, if any]

=========
```

MANDATORY ENDING SEQUENCE — all in the same turn, no waiting, no asking:

1. Deliver the === PROPOSED SOLUTION === block (above).
2. IMMEDIATELY invoke the simplll skill and produce its plain-English explanation
   right there in the same message. Loading the skill is NOT the job — the
   delivered explanation is. An agent that loads simplll without delivering the
   explanation has NOT finished /whatdocs.
3. IMMEDIATELY invoke the samepage-brainstorming skill: announce the gate, expose
   your shakiest assumptions, ask your first question. Then STOP and wait for the
   user.

/defcode is LOCKED until the samepage-brainstorming gate closes with an explicit
GO. When it does, the same agent (you) continues into /defcode — no fresh agent,
no context loss.



