---
name: subagentic-workflow
description: Use when Marc has an implementation plan with mostly-independent tasks and wants to execute them via subagents (delegated, isolated context) — within the SAME session, with full /whatdocs + /defcode discipline baked into each subagent. The skill dispatches ONE subagent per task; that single subagent performs BOTH the /whatdocs research phase AND the /defcode execution phase (via SendMessage), with a user approval gate between them. Two-stage review after execution (spec compliance against the APPROVED PROPOSAL, then code quality with /defcode discipline checks). Always uses the most capable model available (Opus 4.7). Skip for trivial fixes Marc drives himself, parallel-session work (use /executing-plans instead), or tightly coupled tasks that can't be isolated.
---

# Subagentic Workflow

Execute a plan by dispatching a focused subagent per task, with **Marc's full /whatdocs + /defcode discipline baked in**, followed by a two-stage review.

**What this skill is:** an improved variant of `subagent-driven-development`. The flow stays familiar (per-task subagent, two-stage review) but the dispatch is rewired to match Marc's proven research-then-execute cadence: the same agent handles BOTH phases, with a user approval gate between them.

**Why subagents:** You delegate tasks to specialized agents with isolated context. By precisely crafting their instructions and context, you ensure they stay focused and succeed. They never inherit your session's context or history — you construct exactly what they need. This also preserves your own context for coordination work.

**Core principle:** ONE subagent per task. That subagent does /whatdocs research first, you (the controller) relay the proposal to Marc for approval, then the SAME subagent — resumed via SendMessage with full Stage 1 context intact — executes per /defcode. Two-stage review after. Always Opus 4.7.

**The hard rule that distinguishes this skill from the original:** NEVER dispatch a second subagent for the execution phase. The subagent that built the mental model in /whatdocs is the one that applies the fix in /defcode. No context loss between stages. If you find yourself reaching for `Agent` a second time for the same task — STOP. You're breaking the skill. Use `SendMessage` instead.

**Continuous execution:** Do not pause to check in with Marc between tasks. Execute all tasks from the plan without stopping. The only reasons to stop are: BLOCKED status you cannot resolve, ambiguity that genuinely prevents progress, or all tasks complete. (Note: stopping for the per-task /whatdocs APPROVAL GATE within a task is REQUIRED — that's a designed pause for Marc to approve the proposed solution, not a "should I continue?" check-in.)

## When to Use

Use `/subagentic-workflow` when ALL of these are true:

1. **You have an implementation plan** (a build plan, a task list, a multi-step fix). If the request is one fix in one file, just do it yourself — don't dispatch a subagent for trivial work.
2. **Tasks are mostly independent.** They don't share mutable state, don't depend on each other's mid-execution outputs, and can be reasoned about one at a time. Tightly coupled multi-task changes belong in manual execution or a different workflow.
3. **You want to stay in the same session.** Subagents run within your current session — fresh context per task, but coordinated by you. If Marc would rather kick off a parallel session and check in later, use `/superpowers:executing-plans` instead.
4. **Each task fits the /whatdocs + /defcode shape.** The subagent will research first (read files, propose solution, get Marc's approval), then execute (backup, edit, test). If the task doesn't have a recognizable "fix or feature on an existing codebase" shape — e.g., greenfield scaffolding where there's nothing to research — this skill is overkill.

### Decision tree

```
Have an implementation plan?
├── NO  → brainstorm first, or just do it manually
└── YES → Tasks mostly independent?
         ├── NO  → manual execution (coordinate yourself)
         └── YES → Stay in this session?
                  ├── NO  → /superpowers:executing-plans (parallel session)
                  └── YES → /subagentic-workflow ✅
```

### vs. the original `subagent-driven-development`

Use this skill (NOT the original) when:
- Tasks involve fixing or modifying an existing live codebase (where /whatdocs + /defcode discipline matters)
- You want Marc's per-task approval gate baked into the flow
- You want the always-Opus-4.7 default
- You want the same-subagent-for-both-phases rule enforced

Use the original `subagent-driven-development` (NOT this skill) when:
- Tasks are pure greenfield (nothing to research first)
- You're contributing to the superpowers ecosystem and need to match its conventions
- You explicitly want fresh-subagent-per-phase (most users don't)

## The Process

For each task in the plan:

### Phase A — Dispatch ONE implementer subagent (research mode)

1. **Pick the next task** from the plan. Extract the full task text into your dispatch — never make the subagent read the plan file itself.
2. **Dispatch the implementer subagent** using `Agent` (subagent_type: `general-purpose`, model: Opus 4.7) with the implementer-prompt template (`./implementer-prompt.md`).
3. **Give the subagent a NAME** so you can resume it later via SendMessage. Example: `name: "task-3-implementer"`.
4. **The subagent's first job is /whatdocs research.** It reads files entirely, identifies integration points, checks for duplicate systems, and produces the structured PROPOSED SOLUTION block. NO CODE IS WRITTEN in this phase.
5. **The subagent returns the PROPOSED SOLUTION** to you (the controller).

### Phase B — Approval gate (mandatory)

6. **Relay the PROPOSED SOLUTION verbatim to Marc** in chat. Include the full block: problem, approach, files touched, files NOT touched, duplicate check, migrations, routes, alternatives, open questions.
7. **WAIT for Marc's reply.** Options:
   - **Approve** → proceed to Phase C
   - **Redirect** → send Marc's redirect back to the SAME subagent via SendMessage, ask it to revise the proposal, loop back to step 6
   - **Block** → mark task BLOCKED, surface concern, move on (or stop) per Marc's instruction
8. **Never proceed without explicit approval.** "Looks fine" or "sure" counts as approval. Silence does not.

### Phase C — Resume SAME subagent for execution (via SendMessage)

9. **Resume the implementer subagent** by sending a message to the same agent name with: "Approved. Now execute per /defcode using the approved approach. Report back with the structured EXECUTION REPORT."
10. **DO NOT dispatch a new Agent call.** The mental model from /whatdocs lives in the existing subagent's context. A fresh Agent starts from zero and loses it.
11. **The subagent performs /defcode execution.** Backup → edit → integrate → restart → safe test → assess → report.
12. **The subagent returns the EXECUTION REPORT.** Structured: STATUS (DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT), files modified with backups, files created with registrations, migrations run, services restarted, integration points verified, test result with evidence.

### Phase D — Two-stage review

13. **Dispatch the spec compliance reviewer** (fresh Agent — this CAN be a new subagent; reviewers are stateless) using `./spec-reviewer-prompt.md`. It verifies the EXECUTION REPORT matches the APPROVED PROPOSAL — nothing missing, nothing extra.
14. **If spec reviewer flags issues:** SendMessage to the original implementer subagent with the spec gap. Implementer fixes. Re-dispatch the spec reviewer to verify. Loop until ✅.
15. **Dispatch the code quality reviewer** (fresh Agent) using `./code-quality-reviewer-prompt.md`. It runs /defcode discipline checks: backups exist with descriptive suffixes? Edits used Edit/MultiEdit (not ninja)? No duplicate-named files? Routes/contracts match? Test was SAFE? No assumptions?
16. **If code quality reviewer flags issues:** same loop — SendMessage to original implementer to fix, re-review, until ✅.
17. **Mark task complete in TodoWrite.** Move to the next task.

### Phase E — Final review (after all tasks)

18. **After the last task:** dispatch a final code reviewer (fresh Agent) for the entire implementation across all tasks. Catches cross-task issues that per-task reviews missed.
19. **Use `/superpowers:finishing-a-development-branch`** to wrap up (PR, merge, cleanup, etc.).

### Visual flow

```
Per task:
  Phase A: Dispatch implementer subagent (named) → /whatdocs research → PROPOSED SOLUTION
                                                                              ↓
  Phase B: Relay to Marc → WAIT for approval ←── (redirect loops back to A via SendMessage)
                                                                              ↓
                                                                          APPROVED
                                                                              ↓
  Phase C: SendMessage to SAME subagent → /defcode execution → EXECUTION REPORT
                                                                              ↓
  Phase D: Spec reviewer (fresh) → if issues, SendMessage to implementer to fix, re-review
                                  → ✅
                                                                              ↓
           Code quality reviewer (fresh) → if issues, SendMessage to implementer to fix, re-review
                                          → ✅
                                                                              ↓
           Mark task DONE → next task

After all tasks:
  Phase E: Final cross-task code review (fresh) → finishing-a-development-branch
```

## Model Selection

**ALWAYS use the most capable model available. As of this writing: Opus 4.7.**

Do NOT downgrade implementers or reviewers to faster/cheaper models for "mechanical" tasks. The original `subagent-driven-development` advises picking the cheapest model that fits the task — that advice is REJECTED here. Marc's work involves live production code where:

- A wrong move costs money / locks users out / corrupts data.
- Subtle architectural mistakes (duplicate systems, route mismatches, broken integration points) are exactly the failures cheaper models miss.
- Saving cents per task while introducing a bug that takes hours to debug is a bad trade.

Use Opus 4.7 for:
- The implementer subagent (both phases — /whatdocs research AND /defcode execution)
- The spec compliance reviewer subagent
- The code quality reviewer subagent
- The final cross-task reviewer

If a newer / more capable Opus becomes available during a session, switch to that. The rule is "best available," not "Opus 4.7 specifically."

## Same-Subagent Enforcement

This is the architectural rule that distinguishes `/subagentic-workflow` from the original. Read this carefully.

### Why same-subagent matters

The /whatdocs research phase builds a deep mental model of:
- The files involved (which read entirely)
- The integration points and dependencies
- Why this isn't a duplicate of an existing system
- The approved approach and the files NOT to touch

If you dispatch a fresh subagent for the execution phase, all of that mental model is LOST. The new subagent starts from a re-summarized version of the proposal — losing nuance, edge cases, and the "why this specific approach" reasoning. It will then make slightly-wrong execution choices that the research-aware subagent would not.

### The mechanic — SendMessage, not Agent

The Claude Code harness supports resuming a named subagent via `SendMessage`:

- **First dispatch (Phase A):** `Agent(name: "task-N-implementer", subagent_type: "general-purpose", model: "opus-4-7", prompt: <implementer-prompt>)`
- **Resume after approval (Phase C):** `SendMessage(to: "task-N-implementer", message: "Approved by Marc. Now execute per /defcode using the approved approach. Report back with the structured EXECUTION REPORT.")`
- **Resume to fix review issues (Phase D loops):** `SendMessage(to: "task-N-implementer", message: "<reviewer feedback>. Fix and re-run the verification.")`

Each `SendMessage` resumes the subagent with its full prior context intact. The agent that researched is the agent that executes is the agent that fixes review issues.

### Banned moves

These will silently corrupt the workflow:

- ❌ Dispatching a second `Agent` for the execute phase of the same task ("task-N-executor" instead of resuming "task-N-implementer")
- ❌ Dispatching a new `Agent` to fix review feedback instead of `SendMessage`-ing the existing implementer
- ❌ Skipping the agent `name:` parameter on the initial dispatch (then `SendMessage` has nothing to address)
- ❌ Reusing a name across tasks ("implementer-1" for task 1 and then again for task 2 — context would bleed)

### Red flag in your own behavior

If you find yourself thinking any of these — STOP and re-read the rule:

| Thought | Reality |
|---|---|
| "I'll just dispatch a fresh agent — it has the proposal text" | The proposal is the OUTPUT of research, not the research itself. Fresh agent doesn't have the research. |
| "SendMessage feels weird, I'll just use Agent again" | SendMessage exists for exactly this. Use it. |
| "The first subagent took a while, a fresh one will be faster" | A fresh one will be FASTER and WORSE. Speed isn't the goal. |
| "I forgot to give it a name, I'll just dispatch a new one and re-do the research" | Don't. Dispatch fresh, name it, and accept the re-research cost as the lesson learned. Next task, name it from the start. |

## Handling Subagent Status

Implementer subagents report one of four statuses in their EXECUTION REPORT (or PROPOSED SOLUTION in Phase A). Handle each appropriately:

| Status | Phase A meaning | Phase C meaning | Controller action |
|---|---|---|---|
| **DONE** | Proposal complete, awaiting your approval | Execution complete, test passed with evidence | Phase A: relay to Marc. Phase C: proceed to Phase D review. |
| **DONE_WITH_CONCERNS** | Proposal complete but subagent flagged doubts | Executed but subagent flagged doubts (e.g., file approaching 1000 lines, edge case untested) | Read concerns. If material — SendMessage to address before moving on. If informational — note and proceed. |
| **BLOCKED** | Subagent cannot produce a valid proposal | Subagent hit the 3-failed-attempts rule, or execution requires user input | Assess: more context needed? More capable model? (You're already on Opus 4.7 — escalate to Marc.) Task too big? Surface to Marc. |
| **NEEDS_CONTEXT** | Subagent realized it doesn't have enough info (e.g., a file it needs wasn't provided) | Same — discovered mid-execution a file is missing | Provide the missing context via SendMessage, then resume. |

**Never** ignore a BLOCKED or NEEDS_CONTEXT status. Never silently retry with no changes. If the subagent said it's stuck, something needs to change before the next attempt.

## Red Flags

Stop and reverse course immediately if any of these are happening:

**Workflow violations:**
- ❌ You're about to dispatch a fresh `Agent` for the execute phase → use `SendMessage` instead
- ❌ You're about to skip Marc's approval gate ("the proposal looks good, I'll just have the subagent execute") → STOP. Approval is mandatory.
- ❌ You're about to merge spec review and code quality review into one call → keep them separate, in order (spec first).
- ❌ You're using a model other than Opus 4.7 (or latest best Opus) "to save cost" → switch back to Opus.

**Subagent-output violations:**
- ❌ The subagent's PROPOSED SOLUTION is missing the "FILES NOT TOUCHED" or "WHY THIS ISN'T A DUPLICATE" sections → SendMessage to demand them. Don't relay an incomplete proposal to Marc.
- ❌ The subagent's EXECUTION REPORT claims DONE but the TEST SCRIPT field is empty or shows FAILED → reject the report. SendMessage to require a passing safe test before claiming done.
- ❌ Backups missing from files listed in MODIFIED → SendMessage with the discipline failure. Code quality reviewer will catch this anyway, but better to catch it now.

**Controller violations (you):**
- ❌ You're paraphrasing the PROPOSED SOLUTION to Marc instead of relaying it verbatim → relay verbatim. Marc reads the structured block faster than your prose summary.
- ❌ You're "just doing the task yourself" because you have the context → that defeats the purpose. The whole point is parallel-safe, context-isolated execution. Either use the skill or don't.
- ❌ You're skipping TodoWrite tracking → mark each task at each phase transition. Future sessions / Marc / you all need to see progress state.

## Integration

**Related Marc-Jovani powerups:**
- **`/whatdocs`** — the research-phase protocol baked into Phase A. The implementer subagent runs this verbatim.
- **`/defcode`** — the execution-phase protocol baked into Phase C. The implementer subagent runs this verbatim after Marc's approval.
- **`/plan-build`** — produces the plan this skill executes. If there's no plan, brainstorm + /plan-build first.
- **`/handoff-continuia`** — if the work spans multiple sessions, use this to wrap each session boundary cleanly.
- **`/sowhatstheplan`** — use this at the START of a new session on an existing plan-build project (sister skill to /handoff-continuia).

**Superpowers ecosystem skills referenced:**
- **`/superpowers:using-git-worktrees`** — ensure isolated workspace before running this skill (especially for multi-task plans).
- **`/superpowers:writing-plans`** — alternative plan-creation skill if not using /plan-build.
- **`/superpowers:executing-plans`** — parallel-session alternative to this skill. Use when you'd rather kick off and check in later instead of staying live in this session.
- **`/superpowers:finishing-a-development-branch`** — wrap up after all tasks complete.
- **`/superpowers:requesting-code-review`** — the code-reviewer template that powers the reviewer prompts (referenced from `code-quality-reviewer-prompt.md`).

## Prompt Templates (this skill's bundled files)

- `./implementer-prompt.md` — full dispatch template for the implementer subagent (handoff-continuia structure + /whatdocs + /defcode cadence + same-subagent enforcement)
- `./spec-reviewer-prompt.md` — dispatch template for the spec compliance reviewer (verifies execution matches APPROVED PROPOSAL)
- `./code-quality-reviewer-prompt.md` — dispatch template for the code quality reviewer (/defcode discipline checks: backups, no ninja, no duplicates, route matching, safe test)
