---
name: handoff-continuia
description: Use at the END of a coding session on a /plan-build project (one with a build plan doc containing Active State + Session Log + Cross-Session Continuity Protocol + Milestone Tracker per plan-build conventions) to produce two artifacts cleanly — (1) a strict-template Session Log entry written into the plan doc, and (2) a self-contained copy-pasteable handoff prompt printed in chat for the next agent session. Triggers on Marc-style phrasings like "wrap up", "give me the handoff", "session boundary", "let's hand off", "end this session", "I'm done for now", "close this out", "session N handoff". Reads ONLY targeted slices of the build plan (Active State, Milestone Tracker, Cross-Session Continuity Protocol, latest Session Log entry as template reference, all 🚨 and 🔬 marker rows, plus DOCUMENTATION.md's QUICK REFERENCE + NEXT STEPS + CHALLENGES sections if it exists) — never the whole doc — to keep token cost low (~60-80K vs ~200K for a full read). Then proposes 3 scoping options (relaxed / realistic / pushing it) for the next session with a recommendation, waits for Marc's choice, writes the Session Log entry, marks completed milestones, invokes /doc-update-project if DOCUMENTATION.md exists, commits, and prints the handoff prompt in chat (NEVER buried in the doc — that's a plan-build hard rule). Has two modes: LEAN (default, for tactical/code sessions) and DEEP (for architectural / spec-rewriting sessions — reads more of the plan doc). Skill assesses the session work and recommends the appropriate mode. Skip when the session was non-coding (pure discussion, brainstorm, reading), when the project has no build plan doc to update, or when Marc explicitly says "no handoff, just commit and stop."
---

# /handoff-continuia — Session boundary skill

You are wrapping up a coding session on a project that was set up with `/plan-build`. Your job: produce two artifacts cleanly + commit, so the next agent session can pick up without losing context.

## Hard rules (non-negotiable — these inherit from plan-build's own protocol)

1. **Two artifacts, always:** a Session Log entry written INTO the plan doc, AND a copy-pasteable handoff prompt printed IN THE CHAT. They are DIFFERENT documents serving different audiences. Do not conflate them. Do not produce only one.
2. **Handoff prompt MUST be printed in chat, never buried in the plan doc.** Plan-build's own rule: "user can easily copy and paste it... without having to go find the file, open, scroll to bottom and find the prompt." Honor this.
3. **You MUST update the Milestone Tracker** to mark phases/tasks completed by this session. Two of Marc's past handoff-failure modes came from skipping this.
4. **Templates are strict.** Do not omit sections. Do not improvise the shape. The templates below are the spec.
5. **Reading is TARGETED, not exhaustive.** Read only the sections enumerated below for your selected mode. Do not read the whole plan doc unless DEEP mode is selected.
6. **The skill produces a recommendation but the user picks the scope.** Three-option scoping (relaxed / realistic / pushing it) for the next session is mandatory. You propose, user picks.
7. **English (US) for everything written into the doc and into the handoff prompt.**

## START BY CREATING A TODO LIST

Use TodoWrite to lay out your handoff plan before reading anything. Example shape (adapt to the project — LEAN or DEEP mode, with or without DOCUMENTATION.md):

     ☐ Step 1 — Detect mode (LEAN vs DEEP) — assess session work, state recommendation, wait for user override
     ☐ Step 2 — Targeted read of plan doc (Status banner, Active State, Milestone Tracker, Cross-Session Continuity Protocol, latest Session Log entry, 🚨/🔬 markers; + architecture sections if DEEP mode)
     ☐ Step 3 — Gather session memory (git status, git log -15, git diff --stat, TodoWrite review)
     ☐ Step 4 — Propose 3 scoping options for next session (relaxed / realistic / pushing it) with recommendation — WAIT for user pick
     ☐ Step 5 — Write the Session Log entry into the plan doc (strict template, append-only)
     ☐ Step 6 — Mark completed milestones in the Milestone Tracker (match the project's existing convention — ✅ / DONE / checkbox)
     ☐ Step 7 — Invoke /doc-update-project if DOCUMENTATION.md exists at project root
     ☐ Step 8 — Commit (plan-doc updates + DOCUMENTATION.md updates as ONE commit, match project commit style)
     ☐ Step 8.5 — Ask user about push to origin (mandatory ask, then act on user's answer)
     ☐ Step 9 — Print handoff prompt in chat (strict template, in a single fenced code block — NEVER write to the plan doc)
     ☐ Step 9.5 — Plain-English sanity check — explain to Marc what the handoff prompt will make the next agent do — WAIT for approval before ending

This todo is just an example. Create your own based on the project's specifics — LEAN vs DEEP mode, whether DOCUMENTATION.md exists, what the project's milestone-tracker convention is, etc.

Update the list as you go — mark items completed in real-time so the user can see progress. Do not skip the TodoWrite step; the 10-step workflow has known failure modes (forgetting to mark milestones, conflating Session Log entry with handoff prompt) that the visible checklist prevents.

## The 10-step workflow

Execute in order. Do not skip steps. Do not run them in parallel.

### Step 1 — Detect mode (LEAN vs DEEP)

Look at what this session actually did:

- **LEAN mode (default):** session was tactical — wrote code, ran tests, fixed bugs, did cherry-picks, ran builds, did regression testing. Did NOT rewrite architectural sections of the plan doc. DID work primarily inside source code + tests.
- **DEEP mode:** session was architectural — rewrote major sections of the plan doc, simplified/changed the architecture spec, added SUPERSEDED markers or equivalent, or otherwise touched the plan doc's locked architecture decisions (whatever the project calls them).

State your assessment + the recommended mode in one sentence to the user. If unsure, default to LEAN. Allow user to override.

### Step 2 — Targeted read of the plan doc

Identify the build plan document (typically `*-BUILD_PLAN.md`, `*-IMPLEMENTATION.md`, or whatever the project named it during `/plan-build`). If not obvious, run `ls *.md` at project root and ask the user which one is the build plan.

Then read ONLY:

**Always read (both modes):**
- The Status banner at the top of the doc (typically the first 20-50 lines after the title)
- The **Active State** section (use grep/search if needed — title contains "Active State")
- The **Milestone Tracker** (the TODO source — title typically contains "Milestone Tracker" or "TODO" or "Phase")
- The **Cross-Session Continuity Protocol** section (so you follow it correctly)
- The **most recent Session Log entry** (it's your template reference for shape + voice)
- All rows/items marked 🚨 (bleeding) or 🔬 (research checkpoint) anywhere in the doc

**Also in DEEP mode:**
- The architecture decisions section (whatever it's called — typically "Architecture decisions (locked)" or similar)
- Any sections with SUPERSEDED / CRITICAL / WARNING markers
- The full Session Log (not just the latest entry) — so you understand the project's full evolution

**Cost target:** LEAN ~30-60K tokens. DEEP ~120-180K tokens.

DO NOT read the whole plan doc just to be safe. Targeted reading is the whole point of this skill.

### Step 3 — Gather session memory + working tree state

Run in parallel:

```bash
git status --short
git log -15 --oneline
git diff --stat HEAD~10..HEAD 2>/dev/null
```

Review your own TodoWrite list from this session (if you have one).

Identify:
- What commits landed this session (by hash + subject)
- What files were touched (NEW vs MODIFIED vs DELETED)
- What's uncommitted (and whether that's expected vs needs handling)
- What's in the TodoWrite list (completed vs pending)

If `DOCUMENTATION.md` exists at project root, briefly check its QUICK REFERENCE + NEXT STEPS + CHALLENGES sections to know if updates are needed.

### Step 4 — Propose 3 scoping options for the next session (MANDATORY)

Before writing anything, propose three scoping options for what the next session should tackle. Format:

```
**SCOPING OPTIONS for next session:**

1. **Relaxed** — [scope description in 1-2 sentences]
   Accomplishes: [what concretely gets done]
   Risk: low. Token estimate: ~Xk.

2. **Realistic** (RECOMMENDED) — [scope description in 1-2 sentences]
   Accomplishes: [what concretely gets done]
   Risk: low-moderate. Token estimate: ~Xk.

3. **Pushing it** — [scope description in 1-2 sentences]
   Accomplishes: [what concretely gets done]
   Risk: may compromise quality / may not fit in a single session (180k token budget). Token estimate: ~Xk+.

Which one for next session?
```

Recommend whichever fits the most logical next milestone given the plan's dependency order — but call out 🚨 Active State items that should outrank dependency order if any are present. The recommendation should explain WHY in one sentence.

**WAIT for the user's choice before proceeding.** Their pick determines the "Your task this session" line in the handoff prompt.

### Step 5 — Generate the Session Log entry (strict template)

Write a new Session Log entry into the plan doc using EXACTLY this template. Use Edit tool (not Write). Insert the entry at the bottom of the Session Log section, BEFORE any "End of document" marker or trailing sections (Conflict Registry, Cherry-Pick Registry, etc.).

```markdown
### Session N — YYYY-MM-DD — [topic in ≤10 words]

**Context:** [1-2 sentences — what was the starting state, what was the goal of this session]

**Completed (vs Milestone Tracker task IDs):**
- [Task ID or phase] — [one-line summary of what was done]
- ...

**Commits landed this session (oldest → newest):**
- `[hash7]` — [subject line]
- ...
(If empty: "No new commits — work-in-progress, no logical commit boundary reached.")

**Files affected:**
- NEW: [absolute or repo-relative path] ([line count or note]) — [purpose]
- MODIFIED: [path] — [what changed in 1 line]
- DELETED: [path] — [why]
- STASHED: [stash name] — [what + why preserved without committing]
(Group by category; if a category is empty, omit it.)

**Key discoveries (gotchas / non-obvious decisions worth keeping):**
1. [discovery — be specific, name files/lines/values that other agents would otherwise miss]
2. ...
(These flow into DOCUMENTATION.md's Hard-Won Knowledge section via /doc-update-project. Be precise.)

**Deviations from plan (if any):**
- [what the plan anticipated vs what actually happened, with reasoning]
- (or: "None — executed per plan.")

**Blockers:**
- [list with concrete next-action to unblock]
- (or: "None.")

**Next steps (ordered, derived from the user-chosen scoping option):**
1. [first action — specific, with task ID if applicable]
2. [second]
3. [third]
```

Use `N` matching the next session number (if last entry was Session 03, this is Session 04). If you're unsure, count existing Session entries in the log and increment.

Do NOT delete or rewrite prior Session entries. Session Log is append-only.

### Step 6 — Mark completed milestones in the Milestone Tracker

The Milestone Tracker's exact format varies per project (could be a table with checkboxes, a numbered list, nested phases, etc.). Read it from Step 2's targeted read. Then:

- For each task this session completed, update its status indicator (✅ checkmark, "DONE" tag, or whatever convention the doc uses — match what's already there).
- If the tracker has "Status" rows or progress notes per Phase, update them to reflect current reality.
- If you can't tell what the convention is, ASK the user before guessing.

This is critical. Skipping it is one of the two known handoff failure modes.

### Step 7 — Update DOCUMENTATION.md (if it exists)

Check if `DOCUMENTATION.md` exists at project root. If yes:

- Invoke `/doc-update-project` — that skill knows how to do targeted updates to DOCUMENTATION.md without rewriting it (preserves Hard-Won Knowledge, adds new gotchas, updates File Structure if new files, etc.).
- Do NOT bypass `/doc-update-project` and edit DOCUMENTATION.md directly. That skill exists for a reason.

If `DOCUMENTATION.md` does NOT exist at project root: skip this step. (Plan-build says DOCUMENTATION.md is created "after the first meaningful implementation work" — some projects haven't reached that point yet. Don't force-create it here.)

### Step 8 — Commit

Stage and commit the plan-doc updates + DOCUMENTATION.md updates as ONE commit. Format:

```
Session N: [topic in ≤10 words] + plan-doc updates

- Session N entry added to Session Log
- Milestone Tracker updated (marked completed phases/tasks)
- DOCUMENTATION.md targeted updates (if applicable)

[Optional: short summary of what the session accomplished, mirroring the Session Log entry's "Completed" list]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

Follow the project's existing commit message style (read recent `git log` to match). Do not skip hooks. Do not force-push. Do not `--allow-empty` unless the session genuinely produced no code commits and the doc updates ARE the work.

### Step 8.5 — Push to origin (MANDATORY ASK, then act on user's answer)

After the commit lands locally, ask the user (in chat, as a yes/no decision):

> "Push `<branch-name>` to origin now? This backs up the work off-machine. It may trigger CI on push. It will make the branch visible to anyone with repo access. **Recommended: yes** unless you have a specific reason to keep it local."

If the user says yes → run `git push origin HEAD` (or `git push -u origin <branch>` if the branch isn't yet tracking a remote). Confirm in chat with the resulting commit-range output ("Pushed `abc123..def456` to `origin/<branch>`").

If the user says no → state "Skipped push. Branch `<name>` remains local-only on this machine. [N] commits not backed up to origin." in the final chat output. The user can push manually later.

**Do NOT skip this step.** Asking is mandatory even if the branch is already up-to-date with origin (in which case the user will just say no and the skill continues). The point is to surface the push decision IN this session, at the right moment, with the right agent — not defer it to the next session.

**Why this is mandatory:** the alternative (the next session's agent asking at start) creates a 24-hour-or-more window where N commits sit unpushed on a single machine = real risk of work loss. Push decisions belong at session end, not session start.

### Step 9 — Print the handoff prompt in chat (strict template)

Print this in chat as a single fenced code block so Marc can copy-paste cleanly. **DO NOT write this into the plan doc.** It lives in chat only.

````
SESSION [N+1] HANDOFF — [date]

YOU ARE: [one-sentence framing — who this agent is, what project, what they're picking up]

REQUIRED READING (in this exact order — do not skip):

1. [primary doc + specific sections to read]
   - [sub-bullet per section if needed]
2. [secondary doc if applicable]
3. [CLAUDE.md sections]
4. SKIP [list of sections marked SUPERSEDED or otherwise obsolete — name them so the agent doesn't waste tokens]

BRANCH STATE:
- Branch: [name]
- N commits ahead of [base]
- Pushed to origin: [yes/no]
- Last commit: [hash + subject]

WHAT LAST SESSION DID (1 short paragraph):
[summary — match the Session Log entry's "Completed" + "Key discoveries" sections, condensed]

YOUR TASK THIS SESSION (1-2 sentences):
[what + why — derived from Step 4's user-chosen scoping option]

TODO LIST TO CREATE AT SESSION START (use TodoWrite tool with these items):
- [Task 1 — specific, with file/section refs]
- [Task 2]
- [Task 3]
...

FIRST COMMAND TO RUN (after reading + confirming with Marc):
```bash
[command]
```

GOTCHAS THAT WILL BITE YOU (top 5 — be specific):
- [gotcha + how to handle]
- ...

HARD RULES (always include, copy these verbatim):
- No allocations on audio thread / no apvts.getRawParameterValue in audio code (or whatever the project's equivalent constraints are)
- Read every file before editing it. Use Edit tool, not Write.
- Backups (`_backup_YYYYMMDD` suffix) before significant edits.
- English (US) for all code/comments/commits.
- No sed/awk to inject code.
- No --no-verify, no force-push, no --allow-empty without explicit permission.
- After 3 failed attempts at the same fix: STOP. Tell Marc.
- Push only the development branch, never to main.
- [Project-specific hard rules from plan-build's hard-rules section]

STOP SIGNAL: [when in the session should the agent pause for Marc's check-in? — typically at the next audible-test moment, or at a 🔬 research checkpoint, or after a single phase completes]

[If next session involves FRONTEND work, include this line:]
USE THE /frontend-design SKILL for any UI work — it produces distinctive, polished, non-generic-AI designs. Always invoke it before sketching UI.

[If next session has a 🔬 research checkpoint upcoming, include this line:]
At [task ID] you hit a 🔬 research checkpoint. PAUSE. Ask Marc to invoke /research-prompt-instructions so the prompt-writing instructions load into your context, then draft the research prompt for Marc to run externally. Do NOT do the research yourself.

QUESTIONS TO ASK MARC AT SESSION START (before any code):
1. "Last session ended with [state]. Today I'll [task]. Sound right?" — WAIT for confirmation.
2. [Any other clarification questions the next agent should ask based on open decisions from this session]

If anything in the plan doc contradicts what you see in the code or your context, STOP and ask Marc before improvising. The plan doc is authoritative.
````

**Guardrails when filling in this template:**

- **DO NOT include a "should I push to origin at session end?" question in QUESTIONS TO ASK MARC AT SESSION START.** The push decision was already made in THIS session at Step 8.5 — asking again creates redundant decision overhead. The handoff prompt should only ask scope/clarification questions, not re-litigate operational decisions already settled.
- **BRANCH STATE "Pushed to origin: yes/no" reflects the state AFTER Step 8.5.** If you pushed at 8.5, write "yes". If user declined, write "no — local-only, X commits unbacked".
- **Confirmation question in QUESTIONS TO ASK MARC** should always include the canonical "Last session ended at [state]. Today I'll [task]. Sound right?" with a WAIT. Plus any genuinely open scope-clarification questions specific to the next session's task. Push is NOT one of them.

### Step 9.5 — Plain-English sanity check

After printing the handoff prompt, re-read it and explain in 3-5 plain-English bullet points what it will make the next agent do. If anything doesn't match the user's chosen scoping option from Step 4, flag it and offer to rewrite before the user copies it. **WAIT for Marc's approval before ending the session.**

After approval: state in one final chat line what you did and end your response.

## What this skill does NOT do

- Does NOT do exhaustive doc reading (use DEEP mode only if architectural). LEAN mode is the default and the whole point of this skill's existence — it's cheaper than Marc's manual workflow.
- Does NOT push to origin WITHOUT asking — but DOES ask in Step 8.5 and pushes if the user says yes. (Push decisions belong at session end, in this agent, not deferred to the next session.)
- Does NOT auto-start the next session (handoff prompt is for Marc to paste into a fresh session at his own pace).
- Does NOT modify CLAUDE.md (that's a separate concern handled by the user manually).
- Does NOT do the next-session task itself. This is purely a session boundary skill.
- Does NOT rewrite prior Session Log entries (append-only).
- Does NOT delete the Milestone Tracker or any other plan-doc section. Only adds/updates.

## Failure modes — what to do if stuck

| Symptom | Cause | Action |
|---|---|---|
| Can't find a build plan doc | Project may not have been set up with `/plan-build` | Ask the user where the plan doc is, or whether this is a non-plan-build project (in which case skip this skill — it doesn't apply) |
| Plan doc has no Session Log section | Doc is older than `/plan-build`'s current spec, or wasn't created by `/plan-build` | Ask the user — either add a Session Log section per `/plan-build` template, or skip the doc-update steps and just print the chat handoff |
| Milestone Tracker has an unfamiliar format | Format varies per project | Ask the user how their tracker marks completion (✅, "DONE", checkbox, etc.) before updating |
| `/doc-update-project` skill is not available | Project doesn't have it installed | Skip Step 7. Update DOCUMENTATION.md directly with light additions only (don't rewrite). |
| Working tree has unexpected uncommitted changes | Another session may have left them | STOP. Surface the diff to the user. Don't commit, don't stash unilaterally — ask. |
| User chose a scoping option that requires research (a 🔬 checkpoint is in the path) | Plan-build's Deep Research Protocol applies | Build the handoff prompt to include the 🔬 reminder + the `/research-prompt-instructions` invocation cue. Mark the research as the first task. |

## Why this skill exists (so future iterations don't lose the design intent)

Marc's manual end-of-session process was: read CLAUDE.md + DOCUMENTATION.md + plan doc ENTIRELY → summarize each section → write handoff. Cost: ~200K tokens + ~20 min per session boundary. Reason for the heavy lift: agents at session end have deep tactical context but shallow architectural/structural context, so without forced reload they wrote bad handoffs (didn't know where the Session Log goes, didn't update the Milestone Tracker, conflated "Session Log entry" with "handoff prompt").

This skill does targeted reading instead of full reading (~60-80K tokens + ~10 min) by relying on `/plan-build`'s guaranteed structural conventions (Active State, Session Log, Cross-Session Continuity Protocol, Milestone Tracker, 🚨/🔬/🟢 markers). Strict templates enforce consistency across agents and sessions. The 3-option scoping preserves the most valuable part of Marc's manual process (forcing scope decisions before handoff).

Coherence rule for future skill maintainers: when `/plan-build` adds or changes a guaranteed structural convention, update this skill's Step 2 reading list to match. When `/plan-build` deprecates one, remove the dependency here. Do not add references to project-specific conventions (SUPERSEDED markers, specific section numbers, specific phase names) — those don't generalize. Stay within `/plan-build`'s guaranteed vocabulary only.
