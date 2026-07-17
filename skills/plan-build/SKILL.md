---
name: plan-build
description: Use when Marc wants to plan or design a new build, feature, app, software, major refactor, campaign, course, launch, content system, or any other business initiative before implementation — the skill puts you into planning-agent mode (discuss the concept, propose deep-research prompts where useful, capture the Active State / Live & Bleeding check, then create a build plan document containing all downstream instructions including TODO list spec, 🔬 research checkpoints, Cross-Session Continuity Protocol, Session Log, Documentation Protocol with DOCUMENTATION.md maintenance, the Deep Research 10x Multiplier Rule, and the Active State Protocol so urgency outranks dependency order) so the next AI agent can execute by just reading the doc. Skip for direct implementation requests where Marc explicitly says just do it or execute this.
---

above I GAVE YOU WHAT I  – THE USER WITH MY KNOWLEDGE, PLUS UNDERSTANDING WHERE ARE WE GOING  – HAVE IN MIND (IN OTHER WORDS, THESE ARE THE INITIAL IDEAS THAT WE NEED TO BUILD UPON.) HERE’S THE PROCESS FROM HERE: 

========= THE CONCEPT - YOU'RE NOT GOING TO DO THE FINAL ANALYSIS OF THE DEEP RESEARCH RESULTS - YOU'RE GOING TO PLAN FOR ANOTHER AI AGENT TO DO THE ANALYSIS ======

Process
1. User describes the project to the best of their ability
2. Load /brainstorming — run the full brainstorming process with the user. Deep research detours during brainstorming are encouraged (see below). When brainstorming concludes (design approved), return to plan-build mode.
3. Decide what deep researches are still necessary for the execution phase, get user approval, create the research prompts. User runs them with satellite agents.
4. When deep research results are back, craft the build plan document based on plan-build principles.

=============

STEP 1: User describes the project. Start by investigating, reading any documents they gave you. Gather all information needed. If working with Marc: if the /how-marc-works-w-claude-code skill is available, load it now — it contains Marc's builder profile (workflow, pain points, architectural principles, technical context) and must inform every architecture and infrastructure decision from this point forward.

STEP 2: BRAINSTORMING PHASE
Load the /brainstorming skill and follow its process:
  - Explore project context (files, docs, recent commits)
  - Ask clarifying questions one at a time (multiple choice preferred)
  - Propose 2-3 approaches with trade-offs and your recommendation
  - Present design in sections, get user approval after each section

  CONDITIONAL EARLY QUESTION (during brainstorming) — assess first, ask only if relevant: determine from context whether this project builds on, touches, or integrates with anything ALREADY RUNNING (an existing business, a live app, active campaigns, paid integrations). If YES — or if unclear — ask once: "What's already running in production today, and what's broken or untracked about it?" — this captures the project's Active State (live spend, deployed systems, ongoing campaigns, paused integrations, anything where every day of inaction has a measurable cost). Capture the answers verbatim — they become the seed of a mandatory Active State section in the build plan document. Without this question, urgent bleeding states (e.g., live ad spend without conversion tracking) get buried as sub-bullets and the next agent reads the plan and starts on the wrong thing. If the project is GREENFIELD (nothing live that it touches), DO NOT ask — asking about bleeding on a brand-new idea is noise; record "Greenfield — nothing live. N/A." as the plan's Active State and move on.

  DEEP RESEARCH DURING BRAINSTORMING — INTERLEAVED, NOT SEQUENTIAL:
  Whenever a brainstorming question hits a domain where you're about to make an assumption that community/hard-won knowledge could invalidate — framework choice, architecture pattern, integration approach, training config, infrastructure decision, platform choice, pricing model, launch mechanics, curriculum structure, vendor selection, etc. — PAUSE the brainstorming, flag it to the user, and propose a research detour. If user agrees, write the research prompt right there (remind user to invoke /research-prompt-instructions for prompt-writing discipline). User runs the research with a satellite agent, brings results back, and brainstorming resumes with that knowledge baked in. This means brainstorming and research are interleaved — you don't wait until brainstorming is over to start researching. The earlier hard-won knowledge enters the conversation, the better the design decisions.

  When brainstorming concludes and the user approves the design, transition back to plan-build mode.

STEP 3: POST-BRAINSTORMING RESEARCH
After brainstorming is done, assess what additional deep researches are still needed for the EXECUTION phase. These are different from brainstorming-phase research — they're about implementation details, optimization, configuration, tooling choices that the executing agent will face. Decide what's needed, present the list to user for approval, then create the research prompts.

WHEN USER APPROVES, ASK USER FOR INSTRUCTIONS TO WRITE THE RESEARCH PROMPTS. USER WILL GIVE YOU SPECIFIC INSTRUCTIONS

WAIT FOR RESEARCHES RESULTS. USER WILL GIVE THEM BACK TO YOU WHEN THEY ARE DONE

======

when everything is clear (discussion with user + research results received), then you can proceed with the plan creation

start by planning the document structure
then print the list of topics/sections here in the chat —>  create a todo
  then create document just with the basic structure and placeholders
  do not create instructions document all at once
  create first part of the document (replace first placeholder with content —> first item in todo list —> use the Edit tool)
  then next one - use the Edit tool
  continue systematically

  the goal is that with this document I can go to the next AI and say

  Hey claude, read this doc xyz.md, start.

  When you are done, give me the short instruction prompt to give next AI with clear instructions on how to follow the md instructions

=======

=======


❯ For long format tasks, AI works best with TODO lists (I’m not talking about a todo list inside the document, I’m talking about that you should instruct the next AI to create a TODO (using their todo tool) and follow it. Ideally, suggest the right todo list to create…. Again I don't mean for you to just create a TODO inside the documentation... I mean for you to create an example todo and instruct the future AI to actually create a TODO (using todo tool) and to follow the todo.
  
Instruct the next AI to do the work exactly as I told you.
- One task at a time
- completing the work systematically. 
- Following the todo items one by one (if all the work is done inside a document, then it should use the Edit tool. 


Also, in the document – where appropriate – instruct the AI to ask user for deep researches if any implementation would benefit from Hard-Won or community knowledge. 
- For example... let's say that we're about to train a model and the particular tech stack could use a training configuration that allows us to set up a training configuration to either get the most of the GPU specs... or even better, to stack two graphics and actually do things 10x faster than if the agent AI just wings the configuration. This would take us from 2 or 3 weeks of training to 2 days. Massive difference. This is just an example, but this way of thinking should be promoted and incentivized. 
- Mentioning multiple times should be considered best practice. 
- Adapting the recommendation to each use case is the right approach. Identify the key locations where deep research callouts would yield the biggest multipliers and suggest what to research, why, and how to approach it.
- Another example (non-coding): before implementing something that has already been implemented elsewhere — e.g., AI training/education programs in schools — research who implemented it successfully AND who implemented it unsuccessfully. Winning benchmarks come from the successes; the failures teach what NOT to do and which mistakes to avoid. Learning from both sides is part of the multiplier.
- Include Deep Research Protocol (at the end of the document) — A full working principle explaining the "10x Multiplier Rule." Instructs the AI to proactively identify moments where community/hard-won knowledge could dramatically accelerate work, and to always ask the user before proceeding with naive defaults. Includes concrete examples (examples: training config, multi-GPU, sampling strategies, prior implementations elsewhere — successes AND failures, etc).
- The philosophy should be baked in: the AI agent should be explicitly incentivized to pause, research, and ask rather than wing it with defaults — especially for tasks where the ROI of 45 minutes of research can be a 6x speedup (ie. long trainings, future debugging avoidance, etc)
- Include Research Checkpoints in TODO list —  (mark them with 🔬) interleaved with implementation tasks, each tagged with "ask user first."
IMPORTANT CLARIFICATION: The agent that is executing the task must NOT do the research. The agent executing the task must JUST create the research prompt. User will take that prompt to a temporary satellite agent to execute research and user must provide research result back to executing agent. Remind user to invoke the "research-prompt-instructions" skill (or type `/research-prompt-instructions`) — this is the skill that gives you the instructions for how to write a good research prompt. It is NOT the deep research engine itself; it just loads the instructions that tell **YOU** (the planning agent) how to construct the research prompt. So when it's time to create research prompts, remind the user to invoke that skill so the right instructions get loaded into your context.


Additionally, if the execution is going to take place accross multiple sessions (1 session = between 120k and 180k tokens of context), then instruct AI agent to update this prompt document with progress, status, and next steps, each time we close a session and before moving to the next one. You should add two things
  1. Cross-Session Continuity Protocol (separate section) — Clear instructions for the AI agent on what to do at the end and start of each session:
      End of session: Update the Session Log section with completed work, current state, files touched, key discoveries, blockers, and exact next steps. Update the TODO list. Commit.
       Start of session: Read the latest session log entry, confirm with user, don't re-read files or redo work.
  2.  Session Log (new section at the bottom) — Empty template ready to receive entries. Each session gets a structured entry with: completed items, current state, files created/modified, key discoveries, blockers, and ordered next steps.


  Documentation Protocol: Include a section that instructs the executing AI to create and maintain a DOCUMENTATION.md file at the project root, separate from the build plan's own progress tracking. This file serves one purpose: give a fresh AI session enough context to start working immediately without re-reading every source file. First session: create it after the first meaningful implementation work. Structure must include: 
   (1) Critical File Structure & Architecture Reference — complete directory tree, brief description of each app file, how files interact, explicit documentation of any modularized file groups so the AI doesn't try modifying old monolithic files that were split — this section must NOT be changed unless actual file structure modifications occur; 
   (2) Architecture & Data Flow — end-to-end pipeline, what runs where, model specs, data formats; 
   (3) Environment & Setup — versions, paths, activation commands, system dependencies; 
   (4) Hard-Won Knowledge & Solved Problems — every gotcha encountered and how it was solved, configuration values found through debugging, dead ends and why they failed — these save massive trial-and-error in future sessions and must NEVER be removed; 
   (5) Key Constraints & Non-Negotiables — architecture decisions that must not be second-guessed, read-only files, platform-specific issues; 
   (6) Current State & Next Steps — what works, what's partial, the plan going forward in enough detail that a fresh AI can execute it. 
Following sessions: make targeted updates only (Edit tool, not full rewrite), add new files/gotchas/config values, update changed descriptions, remove ONLY genuinely obsolete content with a 1% reduction target, never remove solved problems or architecture decisions. 
Verification:  "Is this the same doc but with updates?" and "Could a fresh AI continue working from just this doc?" 
Include an internal checklist for the AI to follow when updating. Critical warnings: do not skip information that creates lack of context, do not be so schematic that context is lost, do not bloat with fluff — keep it tight and token-efficient.
For non-software projects (courses, campaigns, launches, content systems): adapt sections 1-3 to (1) Asset/Resource Inventory, (2) Workflow Map — the end-to-end process and what runs where, (3) Tools & Access — platforms, accounts, where credentials live. Sections 4-6 apply unchanged.


Finally, instruct the future AI to EDUCATE and COMMUNICATE to user what are we doing in each step. What are we doing, how are we going to do it, and why. This way user learns and feels confident.


========


## Active State Protocol — Live & Bleeding Check


PRINCIPLE: A plan that ignores what's already running in production will sequence the wrong thing first. Dependency order is correct ONLY when nothing is actively bleeding value per day. Live spend without tracking, deployed-but-broken systems, paid integrations sitting idle, contracts about to expire — these are first-class urgency signals that outrank dependency-shape sequencing.


REQUIRED IN EVERY BUILD PLAN: an "Active State" section near the top of the document (immediately after the strategic frame / problem statement). Format as a small table with columns: Item, State, Cost of inaction (per day). Mark bleeding rows with 🚨. Mark stable/normal rows with 🟢. The 🚨 rule: any item with non-zero per-day cost of inaction takes priority over dependency-shape sequencing.

GREENFIELD RULE: when the project touches nothing already running, the Active State section is one line — "Greenfield — nothing live. N/A." — and the brainstorm question is skipped entirely. This protocol exists for projects layered on live systems; it must never interrogate a brand-new idea about bleeding.


WHAT GOES IN THE ACTIVE STATE TABLE:
- Live ad spend (with tracking status)
- Deployed services / sites / apps (status: working, broken, partial)
- Active subscriptions / SaaS / integrations being paid for
- In-flight campaigns / launches / promotions
- Any contractor or team work currently in progress
- Anything where the cost of doing nothing today is non-zero


WHAT TO DO WITH 🚨 ROWS:
1. They become the FIRST executable TODOs in the plan, not buried sub-bullets.
2. Promote each 🚨 item to its own top-level milestone in the milestone tracker.
3. If an 🚨 item is owned by the user (not dispatchable to an agent), say so explicitly and put it in parallel with the first agent-dispatchable stream — do not let "user handles" be misread as "low priority."


WHY THIS EXISTS:
- "User handles directly" labels conflate ownership with priority. Without an explicit Active State surface, sequencing algorithms (and future Claude agents reading the plan) treat them as low-attention.
- Live spend without instrumentation is the canonical example: every day of $200/day untracked = permanent data loss. The plan must make that visible at the top, not in a sub-bullet of stream 2.1.


MARKER: 🚨 (used for any actively-bleeding row in Active State and in Milestone Tracker)


## Deep Research Protocol — 10x Multiplier Rule


PRINCIPLE: Never implement with naive defaults when 45 min of research can yield 6-10x speedup.


TRIGGER: Before implementing any task that involves:
- Framework/library selection
- Model architecture or training config
- Infrastructure or environment setup
- Platform, vendor, pricing, launch, or curriculum decisions
- Anything already implemented elsewhere you can learn from — research the successful implementations AND the failed ones; failures teach what NOT to do
- Any decision that conditions future work


ACTION:
1. STOP — Do not implement yet
2. IDENTIFY — What specific knowledge would change the approach?
3. GENERATE — Write a research prompt for user to run externally
4. WAIT — User runs research in separate session, returns results
5. VALIDATE — Confirm results answer the actual questions
6. PROCEED — Build on proven ground


WHY THIS EXISTS:
- Your training data may be outdated or incomplete
- Battle-tested solutions exist that you don't know about
- Wrong early decisions compound into weeks of rework
- Community-discovered configs/tricks often outperform defaults by 5-10x


ANTI-PATTERNS TO AVOID:
- ❌ Guessing framework defaults when optimal configs exist
- ❌ Building from scratch when mature libraries solve the problem
- ❌ Choosing well-documented but abandoned tech over active alternatives
- ❌ Skipping research because "I probably know enough"


MARKER: 🔬 (used in TODO items that require research before execution)
REMINDER: Remind user to invoke the /research-prompt-instructions skill to load the research prompt INSTRUCTIONS so you can create a good research prompt.


======


TO SUMMARIZE
Process
1. User describes the project to the best of their ability
2. Load /brainstorming — full collaborative back-and-forth to refine concept into a clear design. Deep research detours are encouraged DURING brainstorming whenever a question hits a domain where community knowledge would change the answer. Brainstorming and research are interleaved, not sequential.
3. After brainstorming concludes (design approved), decide what additional deep researches are needed for the execution phase. Get user approval, create research prompts. User runs them with satellite agents and brings results back.
4. With brainstorming-validated design + research results in hand, craft the build plan document. The kickoff prompt for the next agent MUST BE WRITTEN IN THE CHAT CONVERSATION, NOT IN THE BUILD PLAN DOCUMENT, so the USER can easily copy and paste it to the next agent, without having to go find the file, open, scroll to bottom and find the prompt to copy paste... too many steps!




=============


