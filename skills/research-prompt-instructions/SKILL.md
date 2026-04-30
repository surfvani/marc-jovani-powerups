---
name: research-prompt-instructions
description: Use when Marc or the planning agent needs to write a deep-research prompt to send to a satellite Deep Research agent — typically during a plan-build session before committing to a tech stack, architecture, training config, or any decision that conditions future work — the skill loads the full instruction set for writing a good research prompt (paradigm-shifting framing, no-abandoned-tech filter, splitting into multiple parallel prompts when needed, the mandatory contextualization checklist, and the validation questions to ask after results come back). Skip when running the research itself — this skill only loads instructions for writing the prompt.
---

Do you need to see any other document or anything else in the codebase of the project?

Before you start, and based on this project characteristics, create a prompt for next AI agent to do a research. 

Why? What we’re trying to build, mut have been solved alread or partially solved. There must be hundreds of open source projects, repositores, documentation, that the next AI Deep Research agent can find out and bring the solution back to us (so we don’t reinvent the wheel).

Research proven concepts. Do not reinvent the wheel. Use battle tested solutions. No old avandoned tech. (for example, in the audio AI neural model training… DDSP and RAVE are very well documented… but DDSP is old uses TensorFlow and is avandoned and RAVE has pitch recognition problems… a reasearch in that domain has to be able to weight recency and true functionality, not just documentation existence)

Then come up with a safe implementation, that's simple and fast to execute. 

If some libraries need to be installed or if we need to set up an enviroment… then we need environment set up correctly with all libraries etc. This step is importnat. But it’s even more important  if this research is being done at the begining (conception) of a new projects, where this crucial decision will conditions the entire future build. 

What does this research has to give us?
- Most efficient approach
- Solutions that fit the model as we described it earlier in our conversation (IF NOT DEFINED ENOUGH, STOP HERE AND CLARIFY WITH USER)
- Environemnt that fits workflow style
- Best approach based on above definition

When I mean best approach what do I mean?
Thnk "PARADIGM SHIFTING" concept: some times we plan on doing things... and we're actually planing to doing things the hard way. That's exactly what we're trying to avoid.

Example: It's like saying... "ok I'm going to develop a sampler with C++..." to later on discover JUCE existed and it would’ve taken a fraction of the time. 

Same concept here: there must be a way to leverage tech that already exists to make this happens faster than we building the whole thing

Another example: for a neural model, we can go with the approach "we have to condition the transforer with every single sound in the world urselves"... or maybe this is already done... maybe there already is a tech that does that.

Approach 1 takes years and millions of dollars. Approach 2 is so timebending that's disruptive

The solutions have to be
- Tested (NO OLD AVANDONE TECH)
- Efficient
- Fit description
- Fit working style

Deep researches with a ton of questions usually crash (never finish). If you think multiple DEEP RESEARCH PROMPTS are necssary, make sure to split it into multiple. User will run them in parallel. 

Think and work with high effort - ultrathink

Deep research Prompt cannot be shallow. Do not assume Deep Research AI Agent has any context. Deep Research AI Agent has ZERO context. 

Suggestion of what prompt should include (suggestions, but not limited to)
- Complete contextualization
- Vision
- Goal
- System
- Environment
- Workflow characteristics
- Working style
- What we’re trying to build
- Problem definition
- What we’re looking for
- Solutions we’re seaking
- What do we need
- The type of solutions we seek
- Erros to avoid and gotchas
- Type of information exclusions


===========

🚨 MANDATORY - REMEMBER THIS:

USER MUST GIVE YOU THE RESULT OF THE RESEARCHES FOR YOU TO READ

WHEN YOU RECEIVE THE DEEP RESEARCH RESULTS, YOU MUST READ THEM, AND YOU MUST VALIDATE THESE QUESTIONS

Do we have good stuff or was it shallow?
Do we have answers or do we need information to specific questions that didn't get answered?
Do we have the solutions we need or still fall short?
Do we have what we need to be able to implement what we described the way we described it, using the workflow and environment defined?

YOU MUST ASK THIS QUESTIONS TO YOURSELF AFTER READING THE RESULT OF THE DEEP RESEARCHES.

If information is missing, new research needs to be prepared to fill up gaps.


