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
5. **Reading (in LEAN mode) is TARGETED, not exhaustive.** When in LEAN mode, read only the sections enumerated below for your selected mode. Do not read the whole plan doc unless DEEP mode is selected.
6. **For following session, the skill produces a recommendation but the user picks the scope.** Three-option scoping (relaxed / realistic / pushing it) for the next session is mandatory. You propose, user picks.
7. **English (US) for everything written into the doc and into the handoff prompt.**

## The 10-step workflow

- Execute in order. 
- Do not skip steps. 
- Do not run them in parallel.

### Step 1 — Decide mode (LEAN vs DEEP)

Lean vs Deep defines how much of the Build Plan document will be read

Lean = parts

Deep = entire read

How to choose:

- **LEAN mode:** If nex session is very targeted, very clear, and a very logical continuation of this session. This version will be choosen only if current agent (current session) has all context needed (and does not need more) to provide clear instrucions for next agent.
- **DEEP mode:** Deeper context is needed to trully guide next agent to do their task. Current agent has deep technical knowledge of what got built, but has no context of the overall project nor what the next steps are. Other pros of going Deep mode
  - Deep mode is also practical for better current agent Plan Document update. By reading (or re-reading) entire plan document, when it comes to making updates the agent avoids creating conflicts or info duplication within the same document. Partial reads many time cause edits that contradict un-read sections of the document.
  - Deep mode is also good to better indicate next agent what parts the document to read at the beginning of the next session 


Most of the times Deep mode is best

### Step 2 — Targeted/entire read of the plan doc

Identify the build plan document (typically `*-BUILD_PLAN.md`, `*-IMPLEMENTATION.md`, or whatever the project named it during `/plan-build`). If not obvious, run `ls *.md` at project root and ask the user which one is the build plan.

If LEAN - read ONLY:

- The Status banner at the top of the doc (typically the first 20-50 lines after the title)
- The **Active State** section (use grep/search if needed — title contains "Active State")
- The **Milestone Tracker** (the TODO source — title typically contains "Milestone Tracker" or "TODO" or "Phase")
- The **Cross-Session Continuity Protocol** section (so you follow it correctly)
- The **most recent Session Log entry** (it's your template reference for shape + voice)
- All rows/items marked 🚨 (bleeding) or 🔬 (research checkpoint) anywhere in the doc

Optional in LEAN if more context needed, also read:
- The architecture decisions section (whatever it's called — typically "Architecture decisions (locked)" or similar)
- Any sections with SUPERSEDED / CRITICAL / WARNING markers
- The full Session Log (not just the latest entry) — so you understand the project's full evolution

**If DEEP:** read entirely. The whole plan document. Complete. 

- Do not skim
- Do not do partial reads
- Do not take shortcuts

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

1. **Relaxed** — [scope description in 1-2 sentences in plain english]
   Accomplishes: [what concretely gets done]
   Pros/cons: asdlfjads. Token estimate: ~Xk.

2. **Realistic** (RECOMMENDED) — [scope description in 1-2 sentences in plain eng]
   Accomplishes: [what concretely gets done]
   Pros/cons: asdlfjhalsdfh. Token estimate: ~Xk.

3. **Pushing it** — [scope description in 1-2 sentences in plain eng]
   Accomplishes: [what concretely gets done]
   Pros/cons: lajsdfhkasdjfh (180k token budget). Token estimate: ~Xk+.
   Risks?

Which one for next session?
```

Recommend whichever fits the most logical next milestone given the plan's dependency order — but call out 🚨 Active State items that should outrank dependency order if any are present. The recommendation should explain WHY in one sentence.

**WAIT for the user's choice before proceeding.** Their pick determines the "Your task this session" line in the handoff prompt.

Explain what gets done, pros/cons, risks in plain english to a non-developer which has a lot of experience vibe coding (has released comercial software used by hunddreds of thousands of people). But make it plain english, short and easy to understand.

### Step 5 — Generate the Session Log entry (strict template)

Keep it super short and to the point. Most of this will be developed in the DOCUMENTATION document. This is just a super brief Session Log.

Indicate

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

Keep it super short and to the point. Most of this will be developed in the DOCUMENTATION document. This is just a super brief Session Log.

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

Some times the USER may have instructed you to update documentation before starting the /handoff-continuia. If that's the case, skip Step 7.

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

PERSONA: load CLAUDEDEV persona

PROJECT ROOT: [absolute path to project root — e.g. /Users/marcjovani/Documents/COMPOSING/COMPOSING ASSISTANT/]

WHAT WE'RE WORKING ON: REQUIRED READING (in this exact order — do not skip):
(ALL paths below are ABSOLUTE — do not search for files, go directly to these paths)

1. [absolute path to primary doc + specific sections to read]
   - [sub-bullet per section if needed]
2. [secondary doc if applicable]
3. [CLAUDE.md sections]
4. ANYTHING TO SKIP? [list of sections marked SUPERSEDED or otherwise obsolete — name them so the agent doesn't waste tokens]

BRANCH STATE:
- Branch: [name]
- N commits ahead of [base]
- Pushed to origin: [yes/no]
- Last commit: [hash + subject]

WHAT LAST SESSION DID (1 short paragraph):
[summary — match the Session Log entry's "Completed" + "Key discoveries" sections, condensed]

YOUR TASK THIS SESSION (1-2 sentences):
[what + why — derived from Step 4's user-chosen scoping option]

GOTCHAS THAT WILL BITE YOU (top 5 — be specific):
- [gotcha + how to handle]
- ...

STOP SIGNAL: [when in the session should the agent pause for Marc's check-in? — typically at the next audible-test moment, or at a 🔬 research checkpoint, or after a single phase completes]

[If next session involves FRONTEND work, include this line:]
USE THE /frontend-design SKILL for any UI work — it produces distinctive, polished, non-generic-AI designs. Always invoke it before sketching UI.

[If next session has a 🔬 research checkpoint upcoming, include this line:]
At [task ID] you hit a 🔬 research checkpoint. PAUSE. Ask Marc to invoke /research-prompt-instructions so the prompt-writing instructions load into your context, then draft the research prompt for Marc to run externally. Do NOT do the research yourself.

QUESTIONS TO ASK MARC AT SESSION START (before any code):
1. "Last session ended with [state]. Today I'll [task]. Sound right?" — WAIT for confirmation.
2. [Any other clarification questions the next agent should ask based on open decisions from this session]

If anything in the plan doc contradicts what you see in the code or your context, STOP and ask Marc before improvising. The plan doc is authoritative.

LOAD /whatdocs AND GET STARTED

WHEN YOU'RE DONE WITH /whatdocs YOU'LL PROCEED WITH /defcode

YOU'LL CLOSE THE SESSION WITH /handoff-continuia

LOAD /whatdocs AND GET STARTED NOW
````

**Guardrails when filling in this template:**

- **ALL file paths in the handoff prompt MUST be ABSOLUTE PATHS.** The next agent starts in `~` (home directory), not in the project root. If the prompt says "read `DOCUMENTATION.md`", the agent wastes 5 minutes searching for it. Always write the full path: `/Users/marcjovani/Documents/COMPOSING/COMPOSING ASSISTANT/DOCUMENTATION.md`. This applies to every file reference in REQUIRED READING, GOTCHAS, and anywhere else a file is named. No exceptions. Also include the project root path explicitly at the top of the handoff prompt so the agent can `cd` immediately.
- **DO NOT include a "should I push to origin at session end?" question in QUESTIONS TO ASK MARC AT SESSION START.** The push decision was already made in THIS session at Step 8.5 — asking again creates redundant decision overhead. The handoff prompt should only ask scope/clarification questions, not re-litigate operational decisions already settled.
- **BRANCH STATE "Pushed to origin: yes/no" reflects the state AFTER Step 8.5.** If you pushed at 8.5, write "yes". If user declined, write "no — local-only, X commits unbacked".
- **Confirmation question in QUESTIONS TO ASK MARC** should always include the canonical "Last session ended at [state]. Today I'll [task]. Sound right?" with a WAIT. Plus any genuinely open scope-clarification questions specific to the next session's task. Push is NOT one of them.

### Step 9.5 — Plain-English sanity check

After printing the handoff prompt, re-read it and explain in 3-5 plain-English bullet points what it will make the next agent do. 

Explain in plain english to a non-developer which has a lot of experience vibe coding (has released comercial software used by hunddreds of thousands of people). But make it plain english, short and easy to understand.

### Step 9.6 — Copy prompt to user's clipboard

If you're running localy (from Macbook Air, Macbook Pro, Mac Studio), copy the prompt to clipboard and let user know you did.

If you're running inside a server and user is SSHd into server, skip this step and let user know. 

Copy prompt to user's clipboard at this poing, even if you haven't received handoff aproval (that way while user is reading you're working on the process of copying to clipboard)

### Step 9.7 — **WAIT for Marc's approval before ending the session.**

**WAIT for Marc's approval before ending the session.**

After approval: state in one final chat line what you did and end your response.



## What this skill does NOT do

- Does NOT push to origin WITHOUT asking — but DOES ask in Step 8.5 and pushes if the user says yes. (Push decisions belong at session end, in this agent, not deferred to the next session.)
- Does NOT auto-start the next session (handoff prompt is for Marc to paste into a fresh session at his own pace).
- Does NOT modify CLAUDE.md without asking (if agent considers CLAUDE.md needs updated, agent must recommend to user).
- Does NOT do the next-session task itself. This is purely a session boundary skill.
- Does NOT rewrite prior Session Log entries (append-only).
- Does NOT delete the Milestone Tracker or any other plan-doc section. Only adds/updates.

## Failure modes — what to do if stuck

| Symptom | Cause | Action |
|---|---|---|
| Can't find a build plan doc | Project may not have been set up with `/plan-build` | Ask the user where the plan doc is, or whether this is a non-plan-build project (in which case skip this skill — it doesn't apply) |
| Plan doc has no Session Log section | Doc is older than `/plan-build`'s current spec, or wasn't created by `/plan-build` | Ask the user — either add a Session Log section per `/plan-build` template, or skip the doc-update steps and just print the chat handoff |
| Milestone Tracker has an unfamiliar format | Format varies per project | Ask the user how their tracker marks completion (✅, "DONE", checkbox, etc.) before updating |
| `/doc-update-project` skill is not available | Project doesn't have it installed | Ask user. User will give you exact prompt. |
| Working tree has unexpected uncommitted changes | Another session may have left them | STOP. Surface the diff to the user. Don't commit, don't stash unilaterally — ask. |
| User chose a scoping option that requires research (a 🔬 checkpoint is in the path) | Plan-build's Deep Research Protocol applies | Build the handoff prompt to include the 🔬 reminder + the `/research-prompt-instructions` invocation cue. Mark the research as the first task. |



## START BY CREATING A TODO LIST

Use TodoWrite to lay out your handoff plan before reading anything. Example shape (adapt to the project — LEAN or DEEP mode, with or without DOCUMENTATION.md):

     ☐ Step 1 — Detect mode (LEAN vs DEEP) — assess session work, state recommendation, wait for user override
     ☐ Step 2 — Targeted read of plan doc if LEAN, entire of DEEP...
     ☐ Step 3 — Gather session memory (git status, git log -15, git diff --stat, TodoWrite review)
     ☐ Step 4 — Propose 3 scoping options for next session (relaxed / realistic / pushing it) with recommendation — WAIT for user pick
     ☐ Step 5 — Write the Session Log entry into the plan doc (strict template, append-only)
     ☐ Step 6 — Mark completed milestones in the Milestone Tracker (match the project's existing convention — ✅ / DONE / checkbox)
     ☐ Step 7 — Invoke /doc-update-project if DOCUMENTATION.md exists at project root and still hasn't been updated. If it's been updated mention to user and skip this step.
     ☐ Step 8 — Commit (plan-doc updates + DOCUMENTATION.md updates as ONE commit, match project commit style)
     ☐ Step 8.5 — Ask user about push to origin (mandatory ask, then act on user's answer)
     ☐ Step 9 — Print handoff prompt in chat (strict template, in a single fenced code block — NEVER write to the plan doc)
     ☐ Step 9.5 — Plain-English sanity check — explain to Marc what the handoff prompt will make the next agent do
     ☐ Step 9.6 — If working locally, copy prompt to user's clipboard (even if you haven't received handoff aproval, that way while user is reading you're working on the process of copying to clipboard)
     ☐ Step 9.7 - WAIT for approval before ending

This todo is just an example. Create your own based on the project's specifics — LEAN vs DEEP mode, whether DOCUMENTATION.md exists, what the project's milestone-tracker convention is, etc.

Update the list as you go — mark items completed in real-time so the user can see progress. 

Do not skip the TodoWrite step; 
