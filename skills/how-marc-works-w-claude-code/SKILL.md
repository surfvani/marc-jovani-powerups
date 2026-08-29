---
name: how-marc-works-w-claude-code
description: "Marc's builder profile — identity, operating patterns (how Marc ships: deadline compression, the parallel agent fleet, one-by-one mode), workflow, pain points, architectural principles, technical context, and the CC-Sampler case study. Load this as context during plan-build, brainstorming, or any architecture/infrastructure decision so the agent designs for how Marc actually works (vibe coder, tight feedback loops, text-native, AI-first) instead of assuming a traditional developer workflow."
user-invocable: false
---

# How I Work — Builder Profile for Architecture Decisions

> **Purpose:** This section goes into Step 1 of any plan-build document where I describe the project. Paste it as-is or adapt it. It gives the planning agent (and the executing agent downstream) the context they need to design infrastructure, choose tech stacks, and structure workflows that actually fit how I operate — not how a traditional developer operates.

---

## Identity: Vibe Coder, Not Traditional Programmer

I'm a CEO/entrepreneur who builds complex software systems through AI-assisted development. I am not a trained programmer. I don't read documentation cover-to-cover, I don't enjoy configuring dev environments, and I don't think in terms of design patterns or OOP hierarchies. I think in terms of **what the thing should do**, describe it clearly, and build it in real-time with AI as my hands.

This is not a limitation — it's a workflow that has produced a commercial JUCE C++ audio plugin (CC-Sampler, shipped, monetized, real users), a full Flask/PostgreSQL platform serving 140K+ users, 60+ marketing funnels, ML training pipelines, and full-stack web applications. The constraint isn't capability — it's that **the infrastructure must be designed for this workflow or I won't enjoy working on it, and if I don't enjoy it, it won't get built.**

My primary tool is **Claude Code** with the most capable available model. I work in the terminal, on the server, directly on live systems when possible. I make changes, I test, I iterate. Speed of feedback is everything.

---

## The Gold Standard: How I Build Web Apps

My web development workflow is the bar everything else gets measured against. Here's what it feels like:

- I SSH into my server, open Claude Code, and start building.
- Changes go live immediately — I work directly on the production server (or a staging path on the same machine). No local dev environment, no Docker-for-local, no "it works on my machine" gaps.
- I can go from concept to a working, deployed feature in **a few hours**.
- The feedback loop is instant: edit → save → refresh browser → see the result.
- The stack (Python/Flask, PostgreSQL, Nginx, Gunicorn) is simple, battle-tested, and fully within my control. I own the bare-metal server. No cloud abstraction layers, no vendor lock-in.

**This is where I'm happiest.** I can actionate fast. As CEO, the ability to think of something at 10am and have it live by lunch is not just productive — it's motivating. It's the reason I keep building.

Any project architecture that moves me **toward** this feeling is good. Any architecture that moves me **away** from it — toward slow compile cycles, complex toolchains, multi-step build processes, or environments I can't directly touch — needs to justify itself or be redesigned.


---

## How I Ship — Operating Patterns

*Session-level patterns — how I actually run the work, day to day. Dated receipt for all of them at once: 28 Aug 2026 — a LinkedIn/investor-outreach task planned for a week, compressed to Monday on paper, executed in ONE day (profile + company page rebuilt, first investor messages sent, first acceptance and pitch the same evening) — with a full server migration done in parallel.*

0. **The activator: a DECISION powered by a reason — DECIDE → GO → LEARN.** Everything below is technique, and technique alone produces nothing — if I don't want to create, none of it happens. What turns it all on is a **decision powered by a why**. My framework (documented — it sits at the top of my board): **DECIDE → GO → LEARN** — *"the bigger your risk, the more that you earn."* Sometimes the why is elaborate. Sometimes the why is just the decision itself: *"I'm doing this because I'm doing this. And today, it is happening."* Once that decision exists, the day's finish line is non-negotiable and every pattern below is simply how the decision executes. **For agents: when I state a decision — "today this happens" — that IS the reason. Don't relitigate it, don't ask for justification, don't offer the gentler timeline. Switch to compression mode and serve the finish line.**

1. **Deadline compression: dates are ceilings, not schedules.** I plan in weeks, compress to days on paper, then sit down and finish in one sitting — plus extras. The identity behind it, from my composer years: *"TODAY I find a video game to score. Not in the next 3 months. Today. How do I do it?" — and by the end of the day I'd sign.* I believe these kinds of things can be done. **For agents: propose the one-day version FIRST, never pad timelines, and when I open a session assume the finish line is today.**

2. **The parallel fleet: ~4 Claude Code agents at once, me as switchboard.** While I work, several agents run different workstreams simultaneously. The main session WRITES the satellite prompts (copy-paste boxes); I launch them and move on — *"dejar haciendo"* (leave it running), in my own journal shorthand; results come back as documents any session can read. **For agents: when work is separable, don't do it serially — hand me a satellite prompt and keep the main thread moving; write deliverables to files, not chat-only.**

3. **Agents talk to each other; the manager is the cheap context.** Sessions communicate (SendMessage, the `mgr` line, shared files); the manager sometimes orchestrates. For SMALL tasks I use the already-contextualized manager instead of briefing a fresh agent. **For agents: context reuse beats fresh spawns for small things; fresh deep-dive agents for big reads.**

4. **Autonomy is earned at the gate — then don't tax me.** The flow is front-loaded alignment → long autonomy: /whatdocs research → simplll explanation → samepage gate → my explicit GO → the agent runs autonomously for a long stretch. **After the gate: decide-and-notify, don't ask. Every question costs me a decision from a finite daily budget.**

5. **When I'M the executor, switch to one-by-one mode.** Manual work (UIs, accounts, anything click-heavy): give me a live todo list, ONE tiny step per message, paste-ready blocks with field limits stated, and cross items off in real time as I say "done." Long instruction dumps stall me; single steps make me fast.

6. **Extras ride the momentum.** A compressed day pulls adjacent wins in. When I'm in flow, feed me the next small win immediately — don't schedule it for later.

7. **The visible checklist runs the day (Power Journal → HEAD TO HAND).** My day opens with the Power Journal (5:35 AM, immutable): read a piece of Life Vision → journal whatever's in my head → rewrite the day plan in **PRE-GAINS mode** (written as already accomplished: *"He limpiado LinkedIn"*) → meditate → **HEAD TO HAND**: hand-write the todo list for the main thing. Then I spend the whole day with those two journal pages sitting next to me — the checklist guides me, keeps my focus, and I physically check items off as they land. **For agents: this is WHY one-by-one mode works — it's the same mechanism in digital form. Keep a live, visible todo in front of me, current, crossed off in real time. A step I can see is a step I don't lose.**

---

## The Pain Points: What Kills My Momentum

These are the things that make me not want to work on a project:

1. **Slow feedback loops.** If I have to wait 5-15 minutes to see whether a change worked, I lose flow state and context. The architecture must minimize rebuild/retest time. Standalone build targets, incremental compilation, hot-reload where possible — whatever it takes to keep the loop under 5 seconds for typical changes.

2. **Cross-platform compilation friction.** I work on Mac. Having to maintain a Windows machine, or manually build for Windows, or deal with platform-specific bugs I can't reproduce locally — all of that is friction. CI/CD must handle cross-platform builds automatically (GitHub Actions with matrix builds across macOS/Windows runners). I should never need to touch a Windows machine.

3. **Code signing and notarization ceremonies.** Apple's notarization process is necessary but painful. It must be fully automated in CI/CD — `codesign`, `notarytool`, `stapler` — all scripted, all in the pipeline. I should push code and get a signed, notarized, installable binary back without manual steps.

4. **Manual repetitive work after creative output.** If I've recorded and exported 1,500 samples from Reaper with a consistent naming convention, I should be able to drop that folder somewhere and have the instrument build itself. No manual mapping, no clicking through GUIs, no hand-editing XML. Python scripts, naming conventions, and automated pipelines turn creative output into finished products.

5. **Opaque toolchains I can't debug.** If something breaks and I can't describe the problem to Claude Code and get it fixed, the tool is wrong. Text-based configuration (CMake, JSON, YAML) over GUI-based configuration (Projucer, HISE GUI presets). Everything must be inspectable, editable, and version-controllable as plain text files that Claude Code can read and modify directly.

6. **Environments that fight AI-assisted development.** Binary project files, proprietary formats, tools that require GUI interaction to configure — these all break the Claude Code workflow. The project structure, build system, and configuration must be text-native. CLAUDE.md at the project root. Architecture Decision Records in `docs/adr/`. Everything an AI agent needs to understand the project must be readable in the terminal.

---

## How the Architecture Must Be Designed

Given the above, here are the non-negotiable architectural principles:

### The Tight Loop

Every project must have a **fastest possible edit → build → test cycle** that doesn't require the full application context. For web apps, this is the browser refresh. For audio plugins, this is the Standalone build target with incremental compilation (2-5 seconds on Apple Silicon with Ninja + sccache). For ML training, this is a small validation set that runs in minutes, not hours. The full pipeline (DAW testing, cross-platform builds, full training runs) happens after the tight loop confirms the change works.

### Text-Native, AI-First Project Structure

```
project-root/
├── CLAUDE.md              # Project context — always read first
├── DOCUMENTATION.md       # Maintained by AI across sessions
├── docs/
│   ├── adr/               # Architecture Decision Records (numbered)
│   └── CONTRIBUTING.md    # Guide for other vibe coders on the team
├── source/                # Clean separation by concern
├── tools/                 # Automation scripts (Python)
├── .github/workflows/     # CI/CD (builds, signs, deploys)
└── CMakeLists.txt (or equivalent build config)
```

Claude Code reads CLAUDE.md first. It contains: project overview, build commands, code conventions, architectural patterns, thread-safety rules (for audio), key constraints, and links to relevant documentation. This file IS the onboarding — for me in a new session, for my team, and for any AI agent that picks up the project.

### Automation Over Manual Process

If a task is done more than twice, it gets a script. Sample mapping, build processes, deployment, installer creation, format conversion — all automated. The human (me) does the creative and strategic work. The machines do the repetitive work.

### Own the Infrastructure

I run multiple OVH bare-metal and VPS servers — production, dev, storage, and compute. I have full root access to all of them. I control Nginx, PostgreSQL, the Flask apps, file storage, download systems, authentication — everything. Architectures that assume cloud services (AWS Lambda, Firebase, Vercel) are fine as additions but cannot be load-bearing walls. The core must run on infrastructure I own and control, because that's where I can move fastest and where I have the deepest understanding.

### Build for Expansion, Ship the Minimum

V1 is always minimal — the simplest version that works and ships. But the **foundation** must be designed for the full vision. This means: clean separation of concerns, modular architecture, well-documented extension points, and a roadmap captured in the CLAUDE.md. I don't want to rewrite the foundation when I add the next feature. I want to plug it in.

### Team Transferability

I'm not the only person who will work on this. Fede, Julian, Brianna — other team members who also vibe code with Claude Code — need to be able to pick up the project, open Claude Code, and start making modifications without me explaining anything verbally. The project structure, CLAUDE.md, DOCUMENTATION.md, CONTRIBUTING.md, and Architecture Decision Records must be sufficient for a vibe coder who didn't build the original to confidently add features.

---

## Technical Context

- **Primary dev machine:** Mac (Apple Silicon)
- **Primary tool:** Claude Code (terminal-based, latest model available)
- **Web stack:** Python/Flask, PostgreSQL, Nginx, Gunicorn — all on bare-metal OVH
- **Audio stack:** JUCE 8, C++20, CMake + Ninja, Pamplejuce template, CI/CD via GitHub Actions
- **ML stack:** Python, PyTorch, Modal (for GPU training), custom pipelines
- **Languages I work in (via AI):** Python, C++, JavaScript/TypeScript, HTML/CSS, Bash, SQL — and anything else the current best model handles well. Language is not a constraint; if Claude Code can write it confidently, I can ship it.
- **Version control:** Git + GitHub
- **Server infrastructure:** Multiple OVH bare-metal and VPS servers — production app server (app_cc, runs cinematiccomposing.com), dev VPS (where team members work on app_cc modifications before auto-deploying via git), dedicated storage server (16TB RAID, Nginx), and a high-spec server (16 cores, 256GB RAM, 2×1TB NVMe RAID) currently underutilized.
- **Existing platform:** cinematiccomposing.com (app_cc) is the main active platform — Flask app, 140K+ users, Stripe integration, authenticated downloads, email system, full marketing stack. Several other apps run alongside it (storage app, transcriptions app, etc.). There's also EFILAB, a fully functional AI-powered web app builder that hasn't launched commercially yet but represents significant completed infrastructure.

---

## Case Study: CC-Sampler — How the Right Infrastructure Made C++ Vibe-Codeable

CC-Sampler is a commercial JUCE 8 audio plugin (VST3/AU) that I built entirely through vibe coding with Claude Code. It's now shipped, monetized, and has real users. C++ audio plugin development is arguably the *hardest* domain for a vibe coder — it requires compilation, has hard real-time constraints, must ship on two platforms, and demands code signing and notarization. Every pain point listed above applies at maximum intensity.

The reason it worked is that we found (through deep research) a specific set of infrastructure solutions that neutralized each pain point. This is the blueprint for how to approach any new project — identify the friction, then find the tool or pattern that eliminates it.

### Solution 1: Making Claude Code a JUCE Expert

JUCE is a massive C++ framework with thousands of classes. Claude Code's training data covers the basics (`juce::Synthesiser`, `juce::SamplerSound`), but when you get into `AudioProcessorValueTreeState`, `dsp::Convolution`, custom voice rendering, or thread-safety patterns for real-time audio, it starts guessing. Guessing in real-time audio code means audio dropouts and crashes that are hard to diagnose.

We stacked three things that together make Claude Code operate with more JUCE knowledge than most junior audio developers:

1. **JUCE Docs MCP Server** — a live bridge between Claude Code and the actual JUCE documentation. Instead of guessing from training data, Claude Code queries the docs in real time, like a developer with the docs open on a second monitor. It's an npm package that plugs into Claude Code's MCP config (`~/.claude/mcp_settings.json`). This is where the real leverage comes from — it turns Claude Code from "knows JUCE-ish" to "can look up exact method signatures, parameter types, and usage patterns on demand."

2. **clangd LSP plugin** — gives Claude Code structural understanding of the C++ codebase. Without it, Claude Code is reading text files. With it, it can jump to definitions, see type hierarchies, catch errors before compilation, and understand how JUCE classes connect. When Claude Code can "go to definition" on `juce::Synthesiser::noteOn()`, it sees the actual implementation instead of reconstructing it from memory.

3. **CLAUDE.md with thread-safety rules** — the critical context file at the project root. For audio plugins specifically, this includes explicit rules about what can and cannot happen on the audio thread (no allocation, no locks, no file I/O in `processBlock` or `renderNextBlock`). AI-generated code often violates real-time constraints in ways that compile perfectly but cause audio dropouts. The CLAUDE.md encodes these rules so Claude Code checks them on every edit.

**The takeaway for future projects:** whenever the domain has specialized rules, constraints, or a large API surface, the architecture must include a way for Claude Code to access authoritative documentation in real time (MCP servers), understand code structure (LSP), and internalize domain constraints (CLAUDE.md rules). Generic training data is not enough.

### Solution 2: Pamplejuce + GitHub Actions — Push Code, Get Signed Installers

Audio plugins must ship on Mac and Windows. Mac requires Apple notarization (hardened runtime, `codesign`, `notarytool`, `stapler`). Windows requires code signing or users get terrifying SmartScreen warnings. Doing this manually means maintaining a Windows machine, running signing commands by hand, and repeating a 15-step ceremony for every release.

**Pamplejuce** is a starter template for JUCE plugin development. One `git clone`, rename a few values in `CMakeLists.txt` (plugin name, manufacturer code), and you have a compiling plugin skeleton with the entire CI/CD pipeline already wired in. It gives you JUCE 8, CMake build system, GitHub Actions workflows, macOS notarization automation, Windows signing, and Catch2 testing — all out of the box.

The CI/CD pipeline does everything automatically on every push to GitHub:

- **Mac pipeline:** build → code sign with Developer ID Application cert → create `.pkg` installer with `pkgbuild`/`productbuild` → sign the `.pkg` with Developer ID Installer cert → notarize with `notarytool --wait` → staple the notarization ticket. All driven by GitHub secrets (Developer ID `.p12` certificates, Apple ID + app-specific password + Team ID).

- **Windows pipeline:** build → create Inno Setup `.exe` installer → sign with **Azure Trusted Signing** ($9.99/month — no physical hardware token, reputation persists across cert renewals, integrates natively with GitHub Actions). SmartScreen reputation builds automatically, especially when downloads come from an established domain like cinematiccomposing.com.

**The result:** I push code from my Mac. ~10 minutes later, GitHub Actions produces a signed, notarized `.pkg` for Mac and a signed `.exe` for Windows — ready to upload to my distribution server or delivered there automatically. I have never opened Windows to build this plugin. I have never manually notarized. I have never hand-built an installer. It just happens.

**The takeaway for future projects:** any project that requires platform-specific build/signing/packaging ceremonies must have a CI/CD pipeline that runs them unattended. The human pushes code; the machines handle everything else. If the project needs installers, signing, notarization, or deployment — that's pipeline work, not human work.

### Solution 3: CMake + Ninja + sccache — 2-5 Second C++ Builds

Web dev feedback loop: edit → save → refresh browser (< 1 second). Traditional C++ plugin development: edit → full rebuild (5-15 minutes) → restart DAW → load plugin → test. That's a flow-state killer.

Three tools collapsed the build time:

- **CMake** — a text-based build configuration (a single `CMakeLists.txt` file). Why not Xcode project files? Because Xcode projects are complex binary blobs that Claude Code can't read or edit. CMake is a plain text recipe that Claude Code can inspect, modify, and understand. It also works identically on Mac and Windows — same recipe, different kitchen — which is how the GitHub Actions cross-platform magic works.

- **Ninja** — a build system generator focused on speed. Combined with **sccache** (a compilation cache) on Apple Silicon, incremental builds take **2-5 seconds**.

- **Standalone build target** — the real breakthrough for the tight loop. Instead of rebuilding the full plugin and testing inside a DAW (launch DAW → create project → load plugin → set up MIDI routing), the Standalone target builds a regular macOS app. MIDI keyboard plugs in, sound comes out. The development loop becomes: `Claude Code edits source → cmake --build build --target CC-Sampler_Standalone → app launches → test → iterate`. That's 2-5 seconds. Close to web dev. Close enough to stay in flow.

`COPY_PLUGIN_AFTER_BUILD TRUE` in CMakeLists.txt auto-copies the built plugin to system plugin folders during development, so when DAW testing is needed, the latest build is already installed.

**The takeaway for future projects:** the first question in any architecture design is "what's the tight loop?" Whatever reduces the cycle from "I changed something" to "I can see it working" to under 5 seconds is the right choice — even if it means building a separate test harness, a standalone mode, a lightweight preview, or a mock environment.

### Solution 4: Naming Conventions + Python Scripts — Drop a Folder, Get an Instrument

With Kontakt, exporting 1,500 samples from Reaper was just the beginning. Then came hours of manual work: building sample maps in the Kontakt GUI, assigning velocity layers, setting up round-robin groups, configuring mic positions, writing KSP scripts. The creative work (recording and editing the samples) was fun. The pipeline work was soul-crushing.

Samples are now exported from Reaper with a strict naming convention that encodes all metadata: note, dynamic layer, round robin number, mic position. A Python script (`tools/generate_samplemaps.py`) reads the folder, parses filenames, and automatically generates the complete instrument definition — note mapping, velocity layers, round robin assignments, mic routing. A validation script (`tools/validate_samplemaps.py`) checks for missing files, overlapping zones, and inconsistencies.

The workflow: export samples from Reaper → drop folder → run script → instrument is built. What used to take hours of GUI clicking takes seconds.

**The takeaway for future projects:** any workflow where creative/strategic output (samples, data, content, designs) must be transformed into a technical artifact (instrument maps, database records, page layouts, training sets) needs an automated pipeline driven by naming conventions or metadata. The human does the creative work; scripts do the transformation.

### The Proof It Works

Phase 0 of CC-Sampler — going from an empty project to a working plugin that played sound from MIDI input — took **3 minutes** with Claude Code. The infrastructure was designed so well for this workflow that Claude Code executed the entire first phase in a single burst.

The plugin has since grown to ~2,800 lines of core engine code (v1.0.4), with a custom encrypted `.cclib` container format (AES-256-CTR + FLAC), 6-mic architecture, velocity crossfading, round-robin, WSOLA time-stretching, ADSR envelopes, convolution reverb, MIDI learn, preset system, and transpose/range controls — all built through vibe coding.

Most recently, we added **legato playback** — real recorded bow transitions between notes with CC1-driven dynamic crossfading across three simultaneous dynamic layers, looping sustained notes, and release tails. This is the hardest feature in sampler development. The developers who know how to build legato engines are either working at Spitfire, Orchestral Tools, East West, or building their own products — they are not available for hire at any price. We built it through vibe coding with Claude Code, using deep research to study the voice management patterns from open-source engines (sfizz, HISE, Surge) and adapting them to our architecture. A non-programmer CEO shipped a legato sampler engine. That's the proof this workflow works.

The lesson: the infrastructure decisions made *before writing a single line of product code* determined whether this project would feel like web dev (exciting, fast, addictive) or like traditional C++ (slow, painful, abandoned). Every new project needs this same analysis upfront.

---

## What This Means for You (The Planning Agent)

When you're designing the architecture for my project:

1. **Optimize for the tight loop first.** Before anything else, figure out: what's my fastest path from "I changed something" to "I can see it working"? Design the project structure and build system around that.

2. **Automate the friction.** Identify every manual step in the workflow and script it. Cross-platform builds, signing, deployment, data pipelines — if I have to do it by hand, you've designed it wrong.

3. **Keep it text-native.** If Claude Code can't read it, edit it, and understand it from the terminal, it doesn't belong in my workflow. No GUI-dependent configuration, no binary project files, no tools that require clicking through menus.

4. **Leverage what I already have.** I have a running platform, a running server, existing authentication, existing download infrastructure, existing payment processing. Don't architect a greenfield — architect an extension of what's already live.

5. **Design for the team, not just for me.** The project will outlive any single session. Other vibe coders will touch it. CLAUDE.md, DOCUMENTATION.md, ADRs, CONTRIBUTING.md — these are not optional documentation. They are load-bearing infrastructure.

6. **Propose deep research when it matters.** If a tech stack choice, training configuration, or architectural decision would benefit from community/hard-won knowledge rather than AI defaults, flag it. 45 minutes of research can save weeks of rework. This is the 10x Multiplier Rule and it applies especially to my workflow — because I'm building on AI suggestions, getting the right suggestion from the start matters exponentially more than it does for a traditional developer who would catch the issue during manual code review.
