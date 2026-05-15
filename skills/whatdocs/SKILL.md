---
name: whatdocs
description: Use when Marc asks for any fix, update, refactor, or new implementation in an existing codebase and the right move is to fully understand the system BEFORE touching code — not apply anything yet. Forces a research-first protocol — confirm what's actually being asked, request app structure if missing (or run targeted TREE commands on specific directories, never the whole app), list every document needed for a perfect fix (database/models, routes/forms, templates, JS, HTML, content examples), read each file ENTIRELY (skipping files or parts of files is FORVIDEN), reassess after the first pass and read more if needed, then propose the best solution (or multiple options) that is generic, clean, scalable, long-term, coherent with the existing architecture, and crucially NOT a duplicate of a system that already exists. Outputs a TODO list as the first move and ultrathinks between steps. Skip for trivial typo or indentation fixes that don't require codebase understanding, or when Marc explicitly says 'just do it' or 'execute this'.
---

utrathink before executing these steps. Think deeply between steps. 

do you understand what I said?
did I explain this correctly?
any question?
anything I'm missing that I should explain you?
anything that I'm assuming that I should clarify?

Tell me if there’s anything that I assumed or missed when explaining this

=========

  Don't apply the fix/update yet. Before you do that:


  1. Tell me what it is that I'm asking you to do
  2. If user hasn't given you app structure, ask for it. Once you have it, if this is all you need, proceed. If you need to understand deeper, run a few TREE commands of specific directories (not entire app)
  3. Make a list of all documents you need to see in order to apply a perfect fix to this
  4. Read all files. All. Entire. Complete. Read all files completely. Not just a few lines.

  Then, if after reading the files you understand you need to see more files

  1. Make a list of all documents you need to see in order to apply a perfect fix to this
  2. Read all files. All. Entire. Complete. Read all files completely. Not just a few lines.


  MANDATORY
  - Read relevant files.

  FORVIDEN
  - Skipping files
  - Omiting reading parts of the files

  GAIN AS MUCH CONTEXT AS NEEDED
  the more the better
  don't assume
  review stuff first
  files
  structures
  databases
  anything you need
  don't miss the js and html files

  Database and Models
  Forms and Routes
  Templates for Tasks
  Content Example Related Files
  JavaScript that Might Affect UI



====

ALSO IF NEEDED
 review if SQLite is being used
find out if there are any installed Python packages
source ~/name_of_the_folder/venv/bin/activate
pip list
Package      Version


=======

REMEMBER: there may be files you don't need to see because you already gerenated them and they are in the chat memory. If you have the file several times in your chat, it's because we've been modifying it. Use the last instance of the file, since it's going to be the updated one. The older ones might be versions that didn't work or needed changes.

=======

ultrathink. Think deeply between steps. 

====

when you are done doing all the research tell me:

What is the best solution? What is the best approach to solving this issue? The solution MUST meat these points
  1. The solution MUST to be generic: it fixes NOT JUST this particuar problem, but it fixes these types of problems in GENERAL.
  2. It doesn't have to make things worse
  3. It doesn't have to fix this problem but create another one somewhere else
  4. It doesn't have to be a bandaid
  5. The solution doesn't have to be a frankenstain.
  6. It doesn't have to be a patch
  7. It doesn't have to be a hack
  8. It has to be long therm
  9. It has to be scalable
  10. It has to be clean.

  Most importantly: It has to be a clean and logical solution that is coherent with the whole app architecture and logic.

AND THE MOST IMPORTANT THING
You MUST make sure that the solution you’re going to apply is NOT a DUPLICATE of a system that already exists. In other words, the solution must NOT reinvent the wheel of something that’s already built in the app. A duplicated system to solve something that another system already solves is bad architecture and is FORVIDEN.

  ultrathink and give me the best solution (or multiple options/solutions) for what we're trying to solve.

START BY CREATING A TODO ... for example:

     ☐ Command Tree (list files directories)
     ☐ List all documents I need to reed
     ☐ Read [whatever document] to understand [whatever it is you need to understand]
     ☐ Read [whatever document] to understand [whatever it is you need to understand]
     ☐ Read [whatever document] to understand [whatever it is you need to understand]
     etc
     ☐ Analyze bla bla bla
     ☐ Identify all integration points bla bla bla
     ☐ Find bla bla bla
     ☐ After first investigation, asses if I need to read more files, or analyze, or identify anything else
     ☐ List new tasks after first analysis
     ☐ Read, analyze, identify more if needed
     ☐ Explain user what files I’ve reviewed
     ☐ Document all integration points and dependencies
     ☐ Ask questions to user if I need clarification
     ☐ Give the user the best solution (or multiple options/solutions) for what we're trying to solve (clean, coherent, generic, long term)



