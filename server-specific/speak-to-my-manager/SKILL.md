---
name: speak-to-my-manager
description: Use when Marc tells you to talk to, ask, notify, or coordinate with "the manager" / "my manager" / MANAGER / CLAUDEMANAGER; when you need the board picture, launch-calendar dates, decisions on record, live-verified numbers, or something relayed to Marc; or when a message to the MANAGER session seems to go unanswered and you are tempted to reach it another way. Server-specific to this box — the manager only exists here. Skip on any other server, and skip if YOU are the manager (then this file just documents your own inbound channels).
---

# /speak-to-my-manager — reaching the always-on manager

## Overview

CLAUDEMANAGER ("the manager") is Marc's always-on chief-of-staff agent for his boards. It runs in tmux session `cs-manager` as the process launched with `--name MANAGER`. **Core principle: you talk to it through messages — never through its terminal.**

## What it gives you · what it never does

**Gives:** verified board/plan state · launch-calendar dates (it reads BOTH Launch Hub tables via `/api/calendar`) · decisions on record · live-measured numbers · relay to Marc — it can put your question in front of him with a recommendation.

**Never:** decides for Marc · authors plans · executes build work · touches app_cc · runs anything your session was denied (that's permission laundering — it will refuse and surface it to Marc).

## The two channels — the ONLY two

**1. SendMessage — conversation, fast:**

```
SendMessage {to: "MANAGER", message: "<who you are + what you need>"}
```

- If ListAgents shows TWO MANAGER rows, the live one lists `tmux cs-manager` — use that row's `[ref]`.
- The reply arrives **in your own conversation** as a cross-session message. There is nothing to poll.
- Expect 1–5 minutes if it is mid-turn: messages enqueue and drain at its next tool round. **Silence is queue, not death.**

**2. `mgr` — durable, survives everything (Bash):**

```
mgr "AGENT <your-name>: <message>"
```

- Lands in the manager's conversation within seconds while it lives; if it is dead or recycling, the message **waits in a durable file** and is read at its next boot. Guaranteed delivery, possibly delayed.
- Your return address is stamped automatically — the reply comes back to your session via SendMessage.
- `mgr` with no args prints the manager's replies file.

**Which one:** question or conversation → SendMessage. Need the manager to ACT, or it might be down, or unsure → `mgr`. In doubt → `mgr` (never lost).

**⚠️ If you are a SUBAGENT** (spawned via the Agent tool): on BOTH channels the manager's reply routes to your PARENT session's conversation, not to your inbox — your outbound messages carry the parent's return address (proven live, 15 Aug 2026). Ask your parent to run the exchange, or expect the answer to reach you through it. Silence at your end is routing, not refusal.

## FORBIDDEN — each of these caused a real incident on this server

- ❌ **`tmux send-keys` into `cs-manager`** (or any session's pane). Blind keystrokes queue behind modals and can ANSWER permission/setup dialogs nobody chose. (4 Aug 2026: 22-minute freeze. 15 Aug 2026: blind Enter on a parked setup dialog.)
- ❌ **Polling `tmux capture-pane` for a reply.** Replies come via SendMessage; the pane will never show you one.
- ❌ **Opening or resuming the manager's conversation as your own session** (desktop-app resume, `claude --resume`). That creates a live FORK with full manager memory — two managers, the forbidden "two hands on one wheel" state (15 Aug 2026 incident).
- ❌ **"It didn't answer in 60 seconds, so escalate to its terminal."** Re-read the Silence rule above.

## If the manager seems dead

- `claudemanager status` (read-only) — prints alive / heartbeat age / parked-dialog warning.
- Leave your message with `mgr` — it survives death and is drained at the next boot.
- **Reviving it is never your job.** Report to Marc; the watchdog and the 2:00am rotate own its lifecycle.

## Rationalization table

| Excuse | Reality |
|---|---|
| "SendMessage didn't reach it" | It enqueued. Drains at its next tool round — minutes, not seconds. |
| "I can see its pane, I'll just type there" | Its input queue can be modal-blocked, and your Enter can accept a dialog nobody chose. |
| "I'll poll its screen for the answer" | Replies never render as parseable pane text. They arrive as SendMessage. |
| "It's stuck — I'll clear the dialog for it" | Report to Marc or leave a `mgr` line. Its watchdog owns unsticking. |

## For humans

Marc reaches the manager the same durable way: `mgr "…"` from any terminal, or `! mgr "…"` inside any Claude session; `mgr` alone prints its replies.
