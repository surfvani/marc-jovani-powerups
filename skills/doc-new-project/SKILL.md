---
name: doc-new-project
description: Use when Marc wants to create a new DOCUMENTATION.md from scratch for a new project, app, or build — the skill produces a comprehensive Markdown doc starting with the locked ⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE section, explaining file structure (including modularized clusters), and giving a future AI session enough context to ask informed questions. STEP 0, before creating — route: grep the project's build-plan family for 'Documentation Protocol'; if the project already declares where its docs live (some deliberately have NO DOCUMENTATION.md — e.g. the CLAUDEMANAGER/board machinery documents itself in the persona, plan §7.2), follow that instead of creating a new file. Skip for updates to an existing documentation file (use doc-update-project instead).
---

Create a documentation file.


Entire, in depth, complete, no omissions

Think about this, when I start working on this app again, I'll give the AI the doc file and then I'll prompt the AI to ask me for the documents that the AI needs to see in order to have a clear idea about the app. Meaning, the Documentation doesn't have to have EVERYTHING. But it has to have whatever it is important, so the AI can gain context and ask informed questions to gain further knowledge (whatever it needs to start working on the server)

Again, think of the main objective, a file that gives AI all the needed context to get started

AT THE SAME TIME, DO NOT BE TOO SCHEMATIC THAT WE'RE LOSING CONTEXT.

Write in Markdown

The new document should contain all the necessary information.



====

SIZE TARGET — ASK FIRST

Before writing the doc, propose a target line count and ask for approval.

DEFAULT ANCHOR: an initial documentation typically starts at ~500-700 lines. This is the baseline — adjust up or down based on what you actually see:

1. CODEBASE SCOPE — look at the actual codebase (tree, file types, what's in the files).
   How much surface area does the next agent need to navigate?

2. SESSION WORK SCOPE — look at this chat's context.
   What was actually built / touched / decided this session?
   Is this doc covering the WHOLE app, or just the slice from this session inside a larger app?
   How dense is the hard-won knowledge — many gotchas, or straightforward work?

Then ask:

"Codebase: [1-line summary of what you see].
This session: [1-line summary of what was built / decided].
Hard-won knowledge density: [low / medium / high — say why].
Proposed doc target: ~[N] lines (default ~500-700, adjusted because [reasoning]).
Approve, override with a different number, or give guidance?"

Whatever the user approves is the HARD CEILING. If you blow past it while writing, stop and re-tighten before finishing.


====

VERY IMPORTANT - FIRST SECTION

## ⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE

**📌 NOTE: This section must NOT be changed unless actual file structure modifications occur. Do NOT omit when updating documentation. Update ONLY if real changes are made to the codebase structure.**

This section should include clear and detailed structure of the file structure and how each file interacts with each other

Include brief description of each APP file (not flask and stuff) just main app.

Include detailed description of modularized clusters
Sometimes we refactored big files into a group of smaller files. AI gets confused about this because it sees the old large file and goes modify that file. 
Make sure to include clear and detailed documentation regarding file structure and how it interrelates, paying close attention to modularized groups.
Understand the app and provide clear file structure and how each file interacts with each other

For this step, do not assume. Run `tree -L 3` (filtered for noise: node_modules, .git, *.wav, *.WAV, *.mid, *.MID, *.midi, *.MIDI, checkpoints, build artifacts) to see the actual current file structure. Use what you find. If our chat conversation already documented file structure, preserve that and update with anything we modified this session. Important: if you need to see any additional file or directory, ask.


========

ANTI-VERBOSITY RULES (apply at every section, regardless of target):

- Use tables and bullet lists where they fit. Don't write 3 paragraphs when a 4-row table does the same job.
- Never duplicate info across sections — cross-reference instead ("see § Architecture").
- Each section as tight as it can be while staying complete. "Complete" does NOT mean "verbose."
- If a section is naturally short (e.g., a 4-file project's structure), keep it short. Don't pad to "look thorough."
- After writing, scan for repeated explanations of the same concept and consolidate to one place.
- Maximalist instructions ("entire, in depth, complete, no omissions") mean COVERAGE, not WORD COUNT. Cover everything. Tightly.

=========

FINAL IMPORTANT NOTES
DO NOT SKIP OR OMIT THINGS THAT WILL CREATE LACK OF CONTEXT LATER ON
THE FILE HAS BEEN VERY CAREFULLY DESIGNED AS IT IS. DO NOT ELIMINATE, OMIT, SKIP IMPORTANT INFORMATION. MOST INFORMATION IS IMPORTANT AND CRUCIAL AND SHOULD NOT BE ELIMINATED, OMITTED, SKIPPED, OR MODIFIED UNLESS YOU JUST RECENTLY MODIFIED SOMETHING SPECIFIC IN THE APP AND NEEDS TO BE DOCUMENTED

NEXT STEPS SECTION: Include a Next Steps section ONLY if there is no separate build plan / handoff doc owning the project roadmap. If a build plan exists, it owns "what's next" — this doc captures what the system IS, not what's planned. Don't duplicate the roadmap here.

HARD-WON KNOWLEDGE: As the project evolves, you'll add a "Hard-Won Knowledge & Solved Problems" section. Once entries land there, they STAY FOREVER — they're the irreplaceable distillation of debugging time. Never remove them in future updates.