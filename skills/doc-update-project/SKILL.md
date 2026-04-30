---
name: doc-update-project
description: Use when Marc wants to update an existing DOCUMENTATION.md after a coding session, implementation, bug fix, or upgrade — preserves all critical information, adds new learnings and roadblocks/solutions, removes only fully obsolete content, and stays ~1% shorter while including a clear next-steps plan so a fresh AI session can resume without context loss. Skip for creating documentation from scratch (use doc-new-project instead).
---

good low let's move to documentation

first

list everything we've done in this session first

then organize where each things we'vde done should go

then validate

Is this everything we've done during this session?
is there anything missing in this list
re read entire conversation (session) and if you missed anything include it in the list

===

Now let's update the documentation

FIND the document in your CONTEXT. in your MEMORY.

READ it. Don’t read it AGAIN from the source (don’t load it again into your memory… since you already have it). Read it from your memory to avoid wating context tokens.

UPDATE IT: The file should contain the exact same documentation that you just read... but you have to update it with all the new additions, implementations and upgrades we've done

Entire, in depth, complete, no omissions. The new document should contain the same information, while being about 1% shorter

At the end of the day.... think about this, when I start working on this app again, I'll give the AI the doc file to prime it with context, and then I'll prompt the AI to ask me for the documents that the AI needs to see in order to have a clear idea about the app. Meaning, the Documentation doesn't have to have EVERYTHING. It has to have whatever it is important, so the AI can gain context and ask informed questions to gain further knowledge (whatever it needs to start working on the app)

Also, things you can get rid of are parts of the information that's now obsolete for whatever reason. Or maybe issues that were opened that are now solved. Still leave the issue we had and how we solved it, but if there's any opened loop that doesn't need to be there (in terms of issues) you can get rid of that part. 

Again, think of the main objective, a file that give AI ENOUGH context to get started.

AT THE SAME TIME, DO NOT BE TOO SCHEMATIC THAT WE'RE LOOSING CONTEXT.

Write in Markdown

The new document should contain the same information, plus updates, while being about 1% shorter. 

How to make it 1% shorter - eliminate just things that are completely obsolete at this point in development or summarize areas that don’t need as much detail inthis point in development. 

====

You've seen how useful is to have the challenges and roadblocks that we've overcomed documented. These solutions come very handy in the future when we encounter them again and you don't have context. It saves so much trial and error. Make sure to document them


===========

THE FILES SHOULD BE UPDATED, NOT CREATED
FIND THE FILE MENTIONED ABOVE
UPDATE IT, DO NOT CREATE A NEW FILE

========

Make sure to incorporate a clear explanation of what we are goin to be doing (the plan).

Make sure to explain the plan and the process very well.
make sure to explain that in great detail because you now have the right context. After this I'll move to a new chat session and I don't want to be reexplaining things or the new chat having a lack of context.
And i don't want to be repeating things or you breaking things because lack of context

Create updated version of documentation with learnings and (most importantly) clear plan for next steps when we start in new blank chat with no context

Make sure to add that the next steps are going to be doing 

Any questios?
Maybe before starting it would be save to make a final investigation of filestructure.
make sure to tree L- (filtering wav WAV midi MIDI mid MID as well as checkpoints files, to be token efficcient)
and whatever you need to do to make sure that the documentation matches the actual status

SUMMARY
Your job is to create a comprehensive updated documentation that includes:
- Complete current state
- Clear next steps
- All context needed for a fresh AI session

Make sure to include all needed information so next AI chat has all necessary context to operate at it's best

===================

FINAL IMPORTANT NOTES
DON NOT SKIP OR OMIT THINGS THAT WILL CREATE LACK OF CONTEXT LATER ON
THE FILE HAS BEEN VERY CAREFULLY DESIGNED AS IT IS. DO NOT ELIMINATE, OMIT, SKIP IMPORTANT INFORMATION. MOST INFORMATION IS IMPORTANT AND CUCIAL AND SHOULD NOT BE ELIMINATED, OMITED, SKIPED, OR MODIFYIED UNLESS YOU JUST RECENTLY MODIFIED SOMETHING SPECIFIC IN THE APP AND NEEDS TO BE DOCUMENTED

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

START BY CREATING A TODO ... for example:

     ☐ Read current DOCUMENTATION file from memory 
     ☐ Read conversation carefully to understand all changes done
     ☐ Make targetted update #1
     ☐ Make targetted update #2
     ☐ Make targetted update #3
     etc
     ☐ Think if Clear Next Steps section needs to be added or updated
     ☐ Think if Directory Structure needs to be updated
     ☐ Think if Initial context needs to be updated
     ☐ Analyze entire Documentation to see if there any parts that need to be optimized, reduced, or eleminiated BECAUSE OF the implementation we just did, to help mantain the documentation contained and potentially reducing lenght by 1%
     ☐ Think before reducing if these reductions will generate lack of context
     ☐ Run verification steps


  don't bloat the document with fluf and fat. keep it tight and tocken efficient


====

when done



are all the items from the list been included either in the documentation or plan document (approariate place)

list each item from list again (entire list), inticate where should it go, then tell mi if it has been included (yes/no)