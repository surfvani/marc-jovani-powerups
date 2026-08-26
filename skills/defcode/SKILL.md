---
name: defcode
description: "Use when Marc is about to apply a fix, update, or new implementation to a live production app with real users and live payments — the skill enforces execution-phase discipline before and during file modifications. Runs a final context check (any more files needed, is this duplicating a system that already exists), forbids modifying any file Claude hasn't seen, requires per-file backups with descriptive suffixes before edits, blocks 'ninja' sed/awk/echo code-injection in favor of targeted Edit/MultiEdit calls, demands route/endpoint matching across JS↔API (no route-mismatch where the JS expects /resource/api/x but the server registered /api/x), mandates auto-creating and executing any migration scripts (don't make the user run them), focuses strictly on the task at hand (no scope creep), then after the work is done restarts pm2 and writes a SAFE test script (dry-run, no live emails or mass sends) that actually validates the fix works — not just that files changed. Triggers on phrasings like 'execute the fix', 'ship it', 'apply on prod', 'def code', 'this is going live'. Skip for greenfield builds with no production impact or for pure research/planning turns (use whatdocs for those)."
---

=========

⚠️ LIVE PRODUCTION. STAKES ARE REAL.

You are working in a live production app. Real users are using it right now. Payments are being processed. A broken edit doesn't just fail a test — it costs money, locks users out, or corrupts records. Treat every change with that weight.

ultrathink. Think hard before executing. Think deeply between steps. Think with max effort.

=========

CONTINUITY FROM /whatdocs

If you arrived here from a /whatdocs research phase (same agent, same context), you already have an APPROVED PROPOSED SOLUTION from that phase — approved means the samepage-brainstorming gate closed with an explicit GO. If the gate never ran (no simplll explanation, no alignment conversation, no explicit GO), STOP — run samepage-brainstorming now, before touching any file. THAT is your spec for this phase — the PROPOSED SOLUTION as amended by the gate conversation. Do not re-research. Do not deviate. Apply exactly what was approved.

If you reached /defcode without a prior /whatdocs phase, STOP and ask the user: "We skipped the research phase. Do you want me to run /whatdocs first, or proceed with the context I have?" Do not improvise.

=========

FINAL CONTEXT CHECK

Before touching code, verify one more time:
- Do I need to see any additional files? (If your APPROVED PROPOSAL names files you haven't read entirely, read them now.)
- Am I sure this is NOT a DUPLICATE of an existing system in the codebase? (The /whatdocs phase already checked this — but if any doubt remains, reconfirm now.)

If you need more files:
  1. List every file still needed.
  2. Read each one ENTIRELY (no skipping).
  3. Reassess. Loop until you have a complete picture.

If you do NOT need more files — proceed to execution.

=====

COMPLETENESS + INTEGRATION

Once you've passed the FINAL CONTEXT CHECK and you've internalized the HARD RULES, execute the change. These are the rules for HOW the change must be complete.

—

COMPLETENESS — touch every file the change requires.

- Include EVERY file that needs updating. Skip nothing.
- Do not leave half-finished implementations. If the change requires updating 4 files, update all 4.
- If new files must be created, create them.
- If new files are referenced from other files, ADD those references at every site that needs them. Example: created a new JS file → add the `<script>` tag in `index.html`. Added a new model → register it in the import file. Added a new route → register it in the router.
- If you've added a new function, find every caller that needs to use it and wire it up.

The rule: at the end of execution, the system must be in a working, integrated state. Not "almost done." Not "the user will finish wiring it up." DONE.

—

INTEGRATION — no route mismatches, no broken contracts.

If the change touches BOTH client and server (web app), or BOTH a public interface and its consumers (any stack), verify the contract matches on both ends BEFORE declaring done.

The classic failure (web example):
- The JavaScript expects: `/resource/api/content_buckets/search`
- The API is registered as: `/api/content_buckets/search`
- Result: silent 404, broken feature in production.

Match the route. Match the function signature. Match the event name. Match the data shape. Match every contract that crosses a boundary.

For non-web stacks (C++ / JUCE / Rust / etc.):
- Match the function signatures across declaration and definition.
- Match the message/event names across producer and consumer.
- Match the data structures across serialization and deserialization.
- Match parameter names across hierarchical APIVTS layers (or equivalent).

Same principle. Different surface.

—

MIGRATIONS — create them AND run them yourself.

If your change requires a database migration, schema change, or data backfill:
1. Create the migration script.
2. Activate the venv / load the env if applicable.
3. Run the script yourself, in this session.
4. Read the output. Verify it succeeded.
5. Confirm the migration applied (query the DB to see the change took effect).

DO NOT hand the migration script back to the user with "please run this." You have a terminal. Use it.

For non-DB equivalents: rebuilds, config regeneration, asset compilation, codegen — same rule. If your change requires it, you run it.

—

NO INCOMPLETE FIXES. If you find yourself thinking "I'll leave the rest for later" — STOP. Either finish the integration in this session, or BLOCK with a clear note about what's missing and why. Never hand the user a half-wired change and claim done.

====

HARD RULES FOR HOW YOU EDIT

These rules are non-negotiable. Breaking any one of them on a live production app is how you cost the user money. Read them carefully, internalize them, then execute.

—

RULE 1 — NEVER MODIFY A FILE YOU HAVEN'T READ ENTIRELY.

If you have to modify a file and you haven't seen it (or saw only parts), STOP. Read it entirely first. If you can't find it or aren't sure you found the right one, ASK the user. Do not assume. Do not guess.

If the file is already in your context multiple times (from earlier iterations), use the LAST instance — that's the current version.

—

RULE 2 — BACKUP BEFORE EVERY EDIT.

Before modifying any existing file, copy it to a backup with a DESCRIPTIVE suffix so future-you can identify it:
- ✅ `auth.py.bak_pre_login_redirect_fix`
- ✅ `index.html.bak_pre_navbar_refactor`
- ❌ `auth.py.bak` (uninformative — what was this about?)

No backup = no edit. Period.

—

RULE 3 — USE THE `Edit` / `MultiEdit` TOOL ONLY. NO NINJA INJECTION.

FORBIDDEN:
- ❌ sed / awk / perl-in-place code injection
- ❌ echo / cat heredoc to overwrite or splice files
- ❌ Shell scripts that mutate file contents
- ❌ Any "clever" terminal command that edits code

REQUIRED:
- ✅ `Edit` tool for targeted single-string replacements
- ✅ `MultiEdit` tool for multiple changes in one file in one call (where available — newer Claude Code versions dropped MultiEdit; repeated `Edit` calls are the same thing)
- ✅ `Write` tool ONLY for genuinely new files (never to "rewrite" an existing one)

Ninja injection is how files break silently. Use the right tool by name. Every time.

—

RULE 4 — NEVER REWRITE THE WHOLE FILE.

Do not "show your work" by writing out the entire file to demonstrate you understood it. Do not default to a "complete solution" dump. The correct pattern:
1. `Bash` copy the file to a backup (Rule 2).
2. `Edit` or `MultiEdit` for the specific changes.
3. Leave everything else untouched.

If you find yourself about to use `Write` on an existing file — STOP. That's the anti-pattern. Use `Edit` / `MultiEdit`.

—

RULE 5 — NO DUPLICATE-NAMED FILES.

FORBIDDEN:
- ❌ `auth_final.py`
- ❌ `audio_processing_definitive_fix.py`
- ❌ `routes_v2.js`
- ❌ Any "new version" file with a similar name

This creates junk in the filesystem and confuses everyone (including future-you). If a file needs to change, edit the real file (after backup). The backup is the only acceptable "second copy."

—

RULE 6 — STAY IN SCOPE.

Do not update, implement, or change anything outside the APPROVED PROPOSED SOLUTION. No scope creep. No "while I'm here, let me also..." No bonus refactors. No drive-by improvements.

If you spot something genuinely broken outside scope — note it for the user, do NOT fix it in this session.

—

RULE 7 — NO ASSUMPTIONS.

ASSUMING IS FORBIDDEN. If you don't have the context you need (a file, a value, a behavior, a decision), do not wing it. Stop and ask the user. The cost of asking is seconds. The cost of assuming wrong, on a live production app, can be hours of cleanup and lost user trust.

=====


## For Front-end Design

for front end design invoke frontend-design plugin skill

=========

VERIFICATION PROTOCOL — the change isn't done until you've proven it works.

STEP 1 — Restart the service (if applicable).

After your edits land, restart whatever runs the code so the change is actually live:
- Web app with PM2: `pm2 restart <name>` (or full sequence if the change spans frontend build, server, reverse proxy)
- Web app with systemd / Docker / cloud: restart the appropriate service
- JUCE / native app: rebuild and relaunch the host (DAW for plugins, standalone exe otherwise)
- Node service: restart the process
- Skip this step if the runtime auto-reloads (hot reload, file watcher) — but verify the reload actually happened

If the change spans multiple layers (frontend bundle + backend server + nginx config), restart ALL of them in the right order. Don't assume one layer "doesn't need" a restart.

—

STEP 2 — Write a SAFE test script.

The test must safely VALIDATE the fix actually works — not just verify the file changes were saved.

Examples of SAFE tests:
- ✅ Dry-run against a single record / a test user / a sandbox endpoint
- ✅ Test in read-only mode where possible (query, don't write)
- ✅ Test with a flag that prevents external side effects (no real emails, no real charges, no real SMS)
- ✅ Hit a staging endpoint, not production
- ✅ Use a known test record that you can verify before/after

Examples of UNSAFE tests (NEVER do these):
- ❌ Send an email to the entire database to "test the email fix"
- ❌ Charge a real card to "test the payment integration"
- ❌ Mass-update production records to "verify the migration"
- ❌ Hit a live webhook that triggers downstream side effects
- ❌ Anything that touches more than 1-3 real records

Default to DRY-RUN. Default to safe. If you can't think of a safe test, ASK the user how they want to verify.

—

STEP 3 — Run the script. Read the output. Assess.

1. Run the test script yourself.
2. Read the ENTIRE output (not just the last line, not just "exit 0").
3. Assess: did the fix actually do what it was supposed to do? Did the user-visible behavior change as expected? Did the affected records / data / files reach the expected state?
4. If the test passed: proceed to STEP 4.
5. If the test failed: diagnose the failure, adjust the fix, re-run. Repeat until passing.

After 3 failed attempts at the same fix: STOP. Escalate to the user with what you've tried, what failed, and what evidence you have. Don't keep retrying the same approach.

—

STEP 4 — Report DONE only after verified.

Banned claims when you have NOT just verified with a passing test:
- ❌ "should work"
- ❌ "probably works"
- ❌ "the change looks correct"
- ❌ "done" / "fixed" / "complete"

Only acceptable claim of done = "I ran the test, the output showed X, here's the evidence."

Evidence before assertions. Always.

=========

START BY CREATING A TODO LIST

Use the task tools — `TaskCreate` one item per step, `TaskUpdate` to move each through in_progress/completed, `TaskList` to read the list back — to lay out your execution plan before touching code. Build it from the APPROVED PROPOSED SOLUTION (from the /whatdocs phase) — not from scratch. Example shape:

     ☐ Confirm I have the APPROVED PROPOSAL in context (problem, approach, files to touch, files NOT to touch)
     ☐ Final context check — any file in the proposal I haven't read entirely yet?
     ☐ Ask user any remaining INTENT/SCOPE questions (no lazy questions)
     ☐ Backup [specific file path] → [file].bak_pre_[descriptive_suffix]
     ☐ Edit [specific file path] — [specific change per proposal]
     ☐ Backup [specific file path] → [file].bak_pre_[descriptive_suffix]
     ☐ Edit [specific file path] — [specific change per proposal]
     ☐ Create [new file path] — [purpose] + register it in [where it's referenced]
     ☐ Create + run migration script (if applicable) — verify output
     ☐ Verify route/contract matches across all boundaries
     ☐ Restart service(s) — [list which ones]
     ☐ Write SAFE test script — dry-run, no live side effects
     ☐ Run test — read output entirely — assess pass/fail
     ☐ If fail: diagnose, adjust, re-run (max 3 attempts before escalating)
     ☐ Report DONE with structured execution report (see below)

Adapt to your specific change. But every execution todo list MUST include: backups, edits, integration wiring, service restart, and SAFE test with assessment.

=========

WHEN YOU FINISH — required output structure

End your execution phase with a structured EXECUTION REPORT in this exact shape. This is what the controller (or user) will use to verify your work without re-reading every file:

```
=== EXECUTION REPORT ===

STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT

WHAT I DID:
[1-2 sentences — what change landed, mapped back to the APPROVED PROPOSAL]

FILES MODIFIED:
- [path] — [what changed] — backup: [backup file name]
- [path] — [what changed] — backup: [backup file name]

FILES CREATED:
- [path] — [purpose] — registered in: [referencing file(s)]

MIGRATIONS / SCRIPTS RUN:
- [migration name] — executed at [timestamp/HEAD] — output: [success/result summary]

SERVICES RESTARTED:
- [service name] — restarted, confirmed healthy

INTEGRATION POINTS VERIFIED:
- [boundary X] ↔ [boundary Y] — match confirmed via [how you verified]

TEST SCRIPT:
- Location: [path to test script]
- Result: PASSED | FAILED (with details)
- Output excerpt (last 10-20 lines or the relevant assertion lines):
  [paste]
- Why this proves the fix works: [1 sentence]

CONCERNS (if any):
- [anything you'd flag — files near 1000-line threshold, related-but-out-of-scope issues you noticed, edge cases you couldn't test, etc.]

WHAT I DID NOT TOUCH (and why):
- [files in the proposal marked NOT to touch, confirming you respected scope]

OPEN QUESTIONS / NEXT STEPS FOR USER:
- [anything that needs user follow-up after this session]

=========
```

Use DONE_WITH_CONCERNS if you completed the work but have doubts. Use BLOCKED if you couldn't complete (3-attempts rule hit, or a step impossible without more user input). Use NEEDS_CONTEXT if you discovered mid-execution that a file you hadn't seen is required.

Never silently report DONE on work you're unsure about.



