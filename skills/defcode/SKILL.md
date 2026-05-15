---
name: defcode
description: "Use when Marc is about to apply a fix, update, or new implementation to a live production app with real users and live payments — the skill enforces execution-phase discipline before and during file modifications. Runs a final context check (any more files needed, is this duplicating a system that already exists), forbids modifying any file Claude hasn't seen, requires per-file backups with descriptive suffixes before edits, blocks 'ninja' sed/awk/echo code-injection in favor of targeted Edit/MultiEdit calls, demands route/endpoint matching across JS↔API (no route-mismatch where the JS expects /resource/api/x but the server registered /api/x), mandates auto-creating and executing any migration scripts (don't make the user run them), focuses strictly on the task at hand (no scope creep), then after the work is done restarts pm2 and writes a SAFE test script (dry-run, no live emails or mass sends) that actually validates the fix works — not just that files changed. Triggers on phrasings like 'execute the fix', 'ship it', 'apply on prod', 'def code', 'this is going live'. Skip for greenfield builds with no production impact or for pure research/planning turns (use whatdocs for those)."
---

=========

You are working in a live production app. You’re making changes in a live app. The app is being used. There are hundreds of users. There are payments being processed inside this app.

ultrathink   

Think a lot before executing these steps. Think deeply between steps. 

=============

FINAL CONTEXT CHECK 
After everything discussed, 
- do you need to see any other files for extra context? 
- are you sure that the solution you’re going to apply is NOT a DUPLICATE of a system that already exists?
If yes
  1. Make a list of all documents you need to see in order to apply a fix to that doesn’t break anythig or reinvents the wheel of something that’s already built in the app
  2. Read all files.

If after reading this files you discovered you need to see more files:
  1. Make a list of all documents you need to see in order to apply a fix to that doesn’t break anything
  2. Read all files. 

=====

If you don’t need to read any other file… GET STARTED

Include all the files that need to be updated or created. 
Do not skip any file or part of file that needs to be updated.
If any new directory or files need to be created, create it. 

If you need to create new files that get referenced from other files, you must add these references, path directories, or routes to other files that reference these other files. 
(an example:. Creating a JS and then adding route in index.html). 

If functions need to be called, you must update relevant documents. 

====

SOLUTION TYPE
Strategically speaking: The solution you’re applied must have been discussed with user before you apply it. It must be clean, scalable, long term. Not a hack, patch, bandaid, or a solution that creates another problem somewhere else. It has to be a clean and logical solution that is coherent with the whole app architecture and logic.

Tactically speaking: the solution must be targeted and applied safely. Use the file editing tool. The fix must be applied the simplest, most secure, way, and it has to be reliable, assured to work, bulletproof.

You are working in a live production app. You’re making changes in a live app. The app is being used. There are hundreds of users. There are payments being processed inside this app.

It is forviden to make changes that can break the system or compromise functionalities of the app.

=====

ROUTES
You must not create any route mismatch (ie. route mismatch that causes end point to not exist)

For example: make sure you're making the API route match what the JavaScript expects

A more specific example:
The JavaScript is looking for: /resource/api/content_buckets/search
But the API endpoint is registered as: /api/content_buckets/search

These were just examples

====

If migration scripts need to be created, create and execute them. Do not make the user execute them.


====

ASSUMING IS FORVIDEN
When providing solutions, you MUST NOT ASSUME. Always review 
- codebase, 
- database content and moderls 
- Logs
- or anything else needed) 
in order to gain necessary context to execute the fix confidently. Working from assumptions is FORVIDEN. Do NOT assume.

If you need to update, implement, or changes something and you don't have the requiered context, don’t wing it. Do NOT ASSUME. You MUST not apply the fix if you don’t have enough context

=====

FOCUS ON THE TASK AT HAND

Do not update, implement, or change things that don't need to be updated, implemented, or changed.
Do not update, implement, or change things I haven't asked you to update, implement, or change.

======

IMPORTANT: DO **NOT** EXECUTE IF YOU STILL NEED TO SEE MORE FILES
REVIEW CODEBASE, MODELS, DATABASE, LOGS, ETC
YOU MUST BE SURE AND FEEL CERTAIN THAT YOU HAVE A COMPLETE PICTURE TO APPLY FIX WITH CONFIDENCE THAT THE FIX WON’T BREAK ANYTHING
DO NOT ASSUME

=======

REMEMBER: there may be files you don't need to see because you already gerenated them and they are in the chat memory. If you have the file several times in your chat, it's because we've been modifying it. Use the last instance of the file, since it's going to be the updated one. The older ones might be versions that didn't work or needed changes.

=====

NEVER
❌ Ignore Existing Content - instead ✅ always preserve the part of the code that works, and just update the parts that need to be updated

NEVER
❌ Overwrite the entire file. Instead of ✅ Update: Make updates inside the file. 

Never replace the entire file instead of updating.
Find the file. Read the file. Create a backup. Add descriptive ending to the backup file name. Make updates to the original file. 
❌  Do NOT rewrite and recreate an entire new document with a new name. That’s a NONO. ❌

=====


**MANDATORY: DO NOT MODIFY ANY FILE THAT YOU HAVEN'T SEEN YET** If you have to modify a file and you haven't seen it, ask me to give it to you first so you can see its content

**ULTRA IMPORTANT: Do NOT provide INCOMPLETE fixes. Think of everything that needs to happen for the fix to be complete. 

======

### FOR CODE UPDATES


For code updates (files that already exist), first create a backup and then (and only then) perform updates to the file

When creating backup, the end of the backed up filename should be descriptive so we remember what this file was about

For old files (code update) do a backup of the file first. Then READ THE ENTIRE FILE. Then update the file itself. Do NOT create a new file with similar name. (Ie app_final.py, audio_processing_deffinitive_fix.py. This creates confusion and junk in the filesystem.  

Never update the file without doing the backup of the file first. Otherwhiese we would loose the old version.

For code update (that implies updating old files (one or multiple):
- **DO NOT** rewrite complete code files
- instead, **DO** make a backup of the file or files.
- **DO** read entire file
- **DO** make specific targeted updates



## Things to AVOID when updating files

DO NOT DO ninja stuff (like commands to inject code, etc). Instead, just make specific targeted updates. Most likely you'll have the old file in your chat memory. And if you don’t have it in memory, just ask me for the file. I’ll give the file code to you so you can see it and provide changes without assuming. 


**Use the tool to update documents.** DO NOT DO ninja stuff like injecting code with a terminal command. Do not create scripts to inject code in the middle of files. Most of the times this breaks things.


Instead, make specific targeted update.


Update a document only if:
- You have read it ENTIRELY already
- You read it in the past, it's part of your context, and you know for sure you're using the last updated version of that file

If you have the file in your context multiple times, make sure to use the last instance of the file as reference to do the updates.

**If you have any doubt, do not proceed with the update.** Instead, ask me (the user) for the file or find it in the server.

If you don't find the file, or if you don't know if you found the right file, **DO NOT ASSUME!** Ask me for verification.


---
===========

## For Front-end Design

for front end design invoke frontend-design plugin skill

===========

IMPORTANT:

Do not fall into a bad pattern of trying to "show your work" by writing out the entire
file to demonstrate you understood it, rather than following the simpler, safer approach we agreed on.

Do not defaulted to showing the "complete solution" rather than focusing on the minimal changes we discussed.

If you do this, this will be a mistake on your part - You should:
1. Use Bash to copy the file
2. Used Edit or MultiEdit to make the specific changes
3. Left everything else untouched

==========

Before creating the test script (below) - restart the pm2 service

Then… 

🚨 WHEN DONE CREATE A TEST SCRIPT AND RUN IT TO VERIFY THE FIXES WORK PROPERLY 🚨

The secript has to safely TEST the fix or new implementation, not just verify that the changes where applied correctly.

When testing, test safely. For example, if a new email implementation was done, a test should NOT be sending an email to the entire database. Do not to LIVE tests. Always run dray.

Run the script
Read the script results entirely
Assess if your fix or implementation worked or faild
If it failed, make adjustments and run the script again untill the fix or implementation is successful

=========

You are working in a live production app. You’re making changes in a live app. The app is being used. There are hundreds of users. There are payments being processed inside this app.

ultrathink   

Think a lot before executing these steps. Think deeply between steps. Think with max effort.

=============

START BY CREATING A TODO ... for example:

     ☐ Decide if I need to see more files, models, read logs, idenfity integration points, analyze or identify anything else
     ☐ If needed… Reading extra files, logs, bla bla bla
     ☐ Ask questions to user if I need clarification
     ☐ Explain plan to user
     ☐ List all files that will need to be updated. Incorporate list in ToDo
     ☐ Think deeply before executing next steps
     ☐ Document all integration points and dependencies
     ☐ Execute task #1 without making assumptions. Back up before modifying
     ☐ Execute task #2 without making assumptions. Back up before modifying
     etc

this todo is just an example. Create your own based on specifications.



