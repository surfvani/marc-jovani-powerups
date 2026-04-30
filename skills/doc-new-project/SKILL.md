---
name: doc-new-project
description: Use when Marc wants to create a new DOCUMENTATION.md from scratch for a new project, app, or build — the skill produces a comprehensive Markdown doc starting with the locked ⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE section, explaining file structure (including modularized clusters), and giving a future AI session enough context to ask informed questions. Skip for updates to an existing documentation file (use doc-update-project instead).
---

Create a documentation file.


Entire, in depth, complete, no omissions

Think about this, when I start working on this app again, I'll give the AI the doc file and then I'll prompt the AI to ask me for the documents that the AI needs to see in order to have a clear idea about the app. Meaning, the Documentation doesn't have to have EVERYTHING. But it has to have whatever it is important, so the AI can gain context and ask informed questions to gain further knowledge (whatever it needs to start working on the server)

Again, think of the main objective, a file that give AI all the needed context to get started

AT THE SAME TIME, DO NOT BE TOO SCHEMATIC THAT WE'RE LOOSING CONTEXT.

Write in Markdown

The new document should contain all the necessary information.



====

VERY IMPORTANT - FIRST SECTION

## ⚠️ CRITICAL FILE STRUCTURE & ARCHITECTURE REFERENCE

**📌 NOTE: This section must NOT be changed unless actual file structure modifications occur. Do NOT omit when updating documentation. Update ONLY if real changes are made to the codebase structure.**

This section should include clear and detailed structure of the file structure and how each file interacts with each other

Include brief description of each APP file (not flask and stuff) just main app.

Include detailed description of modularized clusters
Some times we refactored big files into a group of smaller files. AI gets confused about this because it sees the old large file and goes modify that file. 
Make sure to include clear and detailed documentation regarding file structure and how it inter relates, paying close attention to modularized groups.
Understand the app and provide clear file structure and how each file interacts with each other

For this step, do not assume. Obviously, leave the same structure that you see in the documentation that I've given you at the beginning of the chat. But update if needed anything that we've updated during this session. Important: If you need to see any additional task, let me know. 


========

FINAL IMPORTANT NOTES
DON NOT SKIP OR OMIT THINGS THAT WILL CREATE LACK OF CONTEXT LATER ON
THE FILE HAS BEEN VERY CAREFULLY DESIGNED AS IT IS. DO NOT ELIMINATE, OMIT, SKIP IMPORTANT INFORMATION. MOST INFORMATION IS IMPORTANT AND CUCIAL AND SHOULD NOT BE ELIMINATED, OMITED, SKIPED, OR MODIFYIED UNLESS YOU JUST RECENTLY MODIFIED SOMETHING SPECIFIC IN THE APP AND NEEDS TO BE DOCUMENTED