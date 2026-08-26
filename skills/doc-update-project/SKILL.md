---
name: doc-update-project
description: Use when Marc wants to update an existing DOCUMENTATION.md after a coding session, implementation, bug fix, or upgrade — preserves all critical information, adds new learnings and roadblocks/solutions, removes only fully obsolete content, and stays ~1% shorter while keeping everything a fresh AI session needs to resume without context loss (Next Steps section only when no build plan / handoff doc owns the roadmap). STEP 0, before anything — route: grep the project's build-plan family for 'Documentation Protocol' and obey it; some projects deliberately have NO DOCUMENTATION.md (the CLAUDEMANAGER/board machinery documents itself in the persona, plan §7.2 — updates go THERE, not to any repo's DOCUMENTATION.md). Also verify you're updating the doc that OWNS the system you touched, not the nearest doc file. Skip for creating documentation from scratch (use doc-new-project instead).
---

good, now let's move to documentation

first

list everything we've done in this session first

then organize where each thing we've done should go

then validate

Is this everything we've done during this session?
is there anything missing in this list
re read entire conversation (session) and if you missed anything include it in the list

===

Now let's update the documentation

FIND the document. READ IT FRESH FROM DISK before updating — even if you think you already have it in memory. In long sessions the in-memory version may be summarized or stale, and you're about to overwrite the real file. Always re-read from disk first to get the current state.

UPDATE IT: The file should contain the exact same documentation that you just read... but you have to update it with all the new additions, implementations and upgrades we've done

Entire, in depth, complete, no omissions. The new document should contain the same information plus updates, while being about 1% shorter. If you can't hit 1%, that's fine — getting close means you applied a real tightening pass, which is the point.

At the end of the day.... think about this, when I start working on this app again, I'll give the AI the doc file to prime it with context, and then I'll prompt the AI to ask me for the documents that the AI needs to see in order to have a clear idea about the app. Meaning, the Documentation doesn't have to have EVERYTHING. It has to have whatever it is important, so the AI can gain context and ask informed questions to gain further knowledge (whatever it needs to start working on the app)

Also, things you can get rid of are parts of the information that's now obsolete for whatever reason. Or maybe issues that were opened that are now solved. Still leave the issue we had and how we solved it, but if there's any opened loop that doesn't need to be there (in terms of issues) you can get rid of that part. 

Again, think of the main objective, a file that gives AI ENOUGH context to get started.

AT THE SAME TIME, DO NOT BE TOO SCHEMATIC THAT WE'RE LOSING CONTEXT.

Write in Markdown

The new document should contain the same information plus updates, while being about 1% shorter. If you can't hit exactly 1%, getting close is fine — the goal of the target is to force a real optimization pass, not to hit a specific number.

How to make it 1% shorter — eliminate just things that are completely obsolete at this point in development (resolved issues that left no useful learning, deprecated code that no longer exists, abandoned approaches) or summarize areas that don't need as much detail at this point in development. Do NOT remove hard-won knowledge or solved-problem entries — those stay forever.

====

You've seen how useful it is to have the challenges and roadblocks that we've overcome documented. These solutions come very handy in the future when we encounter them again and you don't have context. It saves so much trial and error. Make sure to document them


===========

THE FILES SHOULD BE UPDATED, NOT CREATED
FIND THE FILE MENTIONED ABOVE
UPDATE IT, DO NOT CREATE A NEW FILE

========

ONLY IF this session produced a clear roadmap for what's coming next AND there is no separate build plan / handoff doc owning that roadmap: add or update a brief Next Steps section. Otherwise, skip it — Next Steps belongs in the build plan or the handoff prompt, not in this reference doc. This doc captures what the system IS, not what's next.

Before finishing, do a final investigation of file structure if anything in the architecture has changed this session. Run tree -L 3 filtered for noise (node_modules, .git, *.wav, *.WAV, *.mid, *.MID, *.midi, *.MIDI, checkpoints, build artifacts) to confirm the documentation matches the actual status.

SUMMARY
Your job is to create a comprehensive updated documentation that includes:
- Complete current state
- All hard-won knowledge and solved-problem entries (these stay forever)
- All context needed for a fresh AI session
- Next steps ONLY if no build plan / handoff doc owns the roadmap (see conditional rule above)

Make sure to include all needed information so next AI chat has all necessary context to operate at its best

===================

ANTI-VERBOSITY RULES (apply at every section, regardless of length):

- Use tables and bullet lists where they fit. Don't write 3 paragraphs when a 4-row table does the same job.
- Never duplicate info across sections — cross-reference instead ("see § Architecture").
- Each section as tight as it can be while staying complete. "Complete" does NOT mean "verbose."
- After updating, scan for repeated explanations of the same concept and consolidate to one place.
- Maximalist instructions ("entire, in depth, complete, no omissions") mean COVERAGE, not WORD COUNT. Cover everything. Tightly.

=========

FINAL IMPORTANT NOTES
DO NOT SKIP OR OMIT THINGS THAT WILL CREATE LACK OF CONTEXT LATER ON
THE FILE HAS BEEN VERY CAREFULLY DESIGNED AS IT IS. DO NOT ELIMINATE, OMIT, SKIP IMPORTANT INFORMATION. MOST INFORMATION IS IMPORTANT AND CRUCIAL AND SHOULD NOT BE ELIMINATED, OMITTED, SKIPPED, OR MODIFIED UNLESS YOU JUST RECENTLY MODIFIED SOMETHING SPECIFIC IN THE APP AND NEEDS TO BE DOCUMENTED

=============

The key is maintaining enough context so the next AI can understand:
  - What is the project about and how this implementation works
  - The specific architecture 
  - How to run and modify things
  - What constraints exist and why and how we solved them

Update the documentation. Keep it streamlined with clear setup instructions for the new AI. Must stay comprehensive but token-efficient.


======

Do not remove critical information that we worked hard to discover.

========

Do NOT rewrite entire documentation. Just make updates

========

Verification: 
- Is this the same documentation but with updates and progress? If yes, you did a good job.
- Are you confident that if I delete your context right now you could continue working where we left off by just reading at this documentation?

Think deeply. Think a lot before executing these steps. Think deeply between steps. 

START BY CREATING A TODO — use the task tools (`TaskCreate` one item per step, `TaskUpdate` to mark progress), not just a printed list ... for example:

     ☐ Read current DOCUMENTATION file FRESH FROM DISK (do not trust in-memory copy)
     ☐ Read conversation carefully to understand all changes done
     ☐ Make targeted update #1
     ☐ Make targeted update #2
     ☐ Make targeted update #3
     etc
     ☐ Think if Next Steps section should be added/updated (ONLY if no build plan / handoff doc owns the roadmap)
     ☐ Think if Directory Structure needs to be updated
     ☐ Think if Initial context needs to be updated
     ☐ Analyze entire Documentation to see if there any parts that need to be optimized, reduced, or eliminated BECAUSE OF the implementation we just did, to help maintain the documentation contained and potentially reducing length by 1% (falling short of 1% is fine — the point is the optimization pass)
     ☐ Think before reducing if these reductions will generate lack of context
     ☐ Never remove hard-won knowledge or solved-problem entries
     ☐ Run verification steps


  don't bloat the document with fluff and fat. keep it tight and token efficient


====

when done



have all the items from the list been included either in the documentation or plan document (appropriate place)

list each item from list again (entire list), indicate where it should go, then tell me if it has been included (yes/no)