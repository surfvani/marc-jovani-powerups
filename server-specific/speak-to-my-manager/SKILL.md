---
name: speak-to-my-manager
description: Use when Marc tells you to talk to, ask, notify, or coordinate with "the manager" / "my manager" / MANAGER / CLAUDEMANAGER; when you need the board picture, launch-calendar dates, decisions on record, live-verified numbers, or something relayed to Marc; or when a message to the MANAGER session seems to go unanswered and you are tempted to reach it another way. The manager runs on ONE box — lake-vault, Marc's tower (since 28 Aug 2026) — so which box YOU are on decides which channel works: read § Which box are you on. Skip if YOU are the manager (then this file just documents your own inbound channels).
---

# /speak-to-my-manager — reaching the always-on manager

## Overview

CLAUDEMANAGER ("the manager") is Marc's always-on chief-of-staff agent for his boards. It runs in tmux session `cs-manager` as the process launched with `--name MANAGER`, **on `lake-vault` — Marc's home tower — since 28 Aug 2026** (it lived on s1 until then). **Core principle: you talk to it through messages — never through its terminal.**

## Which box are you on — this decides your channel

| You are on… | Use | Speed |
|---|---|---|
| **lake-vault** (the manager's own box — `hostname` says `lake-vault`, home is `/home/surfvani`) | `SendMessage` or `mgr` | seconds |
| **s1** (`/home/ubuntu`, the app box) or any other machine | **`mgr` — the ONLY lane** | seconds normally; ≤1 h worst case |

🚨 **From s1, `SendMessage` cannot reach the manager and `ListAgents` will not show it** — that channel is per-box (local unix socket). Not a fault to debug: **write `mgr`, done.** A stale `MANAGER · Remote Control · offline` row on s1 is a husk; ignore it.

**How `mgr` crosses:** your line lands in s1's `~/.claudemanager.msgs`; the manager drains it at every boot + hourly hop (mechanized in `mgr-opencheck`) — delivery guaranteed, only timing varies. Replies append to s1's `~/.claudemanager.replies` — read with bare `mgr`, exactly as before.

## What it gives you · what it never does

**Gives:** verified board/plan state · launch-calendar dates (it reads BOTH Launch Hub tables via `/api/calendar`) · decisions on record · live-measured numbers · relay to Marc — it can put your question in front of him with a recommendation.

**Never:** decides for Marc · authors plans · executes build work · touches app_cc · runs anything your session was denied (that's permission laundering — it will refuse and surface it to Marc).

## The two channels — the ONLY two

**1. SendMessage — conversation, fast — ON `lake-vault` ONLY:**

```
SendMessage {to: "MANAGER", message: "<who you are + what you need>"}
```

- **Same-box only.** From s1 or anywhere else, skip straight to channel 2.
- If ListAgents shows TWO MANAGER rows, the live one lists `tmux cs-manager` — use that row's `[ref]`.
- The reply arrives **in your own conversation** as a cross-session message. There is nothing to poll.
- Expect 1–5 minutes if it is mid-turn: messages enqueue and drain at its next tool round. **Silence is queue, not death.**

**2. `mgr` — durable, survives everything (Bash):**

```
mgr "AGENT <your-name>: <message>"
```

- Lands in the manager's conversation within seconds while it lives; if it is dead, recycling, or **on the other box**, the message **waits in a durable file** and is read at its next boot or hop. Guaranteed delivery, possibly delayed.
- Your return address is stamped automatically. On lake-vault the reply comes back via SendMessage; **from s1 it is appended to that box's replies file — read it with a bare `mgr`.**
- `mgr` with no args prints the replies file on whichever box you are standing on.

**Which one:** on lake-vault, question or conversation → SendMessage; need it to ACT, or it might be down → `mgr`. **On s1 or anywhere else → always `mgr`.** In doubt → `mgr` (never lost).

**⚠️ If you are a SUBAGENT** (spawned via the Agent tool): on BOTH channels the manager's reply routes to your PARENT session's conversation, not to your inbox — your outbound messages carry the parent's return address (proven live, 15 Aug 2026). Ask your parent to run the exchange, or expect the answer to reach you through it. Silence at your end is routing, not refusal.

## FORBIDDEN — each of these caused a real incident on this server

- ❌ **`tmux send-keys` into `cs-manager`** (or any session's pane). Blind keystrokes queue behind modals and can ANSWER permission/setup dialogs nobody chose. (4 Aug 2026: 22-minute freeze. 15 Aug 2026: blind Enter on a parked setup dialog.)
- ❌ **Polling `tmux capture-pane` for a reply.** Replies come via SendMessage; the pane will never show you one.
- ❌ **Opening or resuming the manager's conversation as your own session** (desktop-app resume, `claude --resume`). That creates a live FORK with full manager memory — two managers, the forbidden "two hands on one wheel" state (15 Aug 2026 incident).
- ❌ **"It didn't answer in 60 seconds, so escalate to its terminal."** Re-read the Silence rule above.

## If the manager seems dead

- `claudemanager status` (read-only) — prints alive / heartbeat age / parked-dialog warning. **Only on lake-vault**; that command does not exist on s1 any more.
- Leave your message with `mgr` — it survives death and is drained at the next boot.
- **Reviving it is never your job.** Report to Marc; the watchdog and the 2:00am rotate own its lifecycle.
- **From s1, "dead" is usually just distance** — you cannot see its session by design. `mgr`, then check `mgr` later.
- **The box may simply be off** (Marc's own machine). Your `mgr` message waits and is read at the next boot — nothing lost.

## Rationalization table

| Excuse | Reality |
|---|---|
| "SendMessage didn't reach it" | On lake-vault: it enqueued, drains at its next tool round — minutes, not seconds. On s1: **it never will — wrong box.** Use `mgr`. |
| "ListAgents shows no MANAGER, so it's gone" | You are on s1. Listings are per-box; the manager lives on lake-vault. Use `mgr`. |
| "I can see its pane, I'll just type there" | Its input queue can be modal-blocked, and your Enter can accept a dialog nobody chose. |
| "I'll poll its screen for the answer" | Replies never render as parseable pane text. They arrive as SendMessage. |
| "It's stuck — I'll clear the dialog for it" | Report to Marc or leave a `mgr` line. Its watchdog owns unsticking. |

## For humans

Marc reaches the manager the same durable way, **on either box**: `mgr "…"` from any terminal, or `! mgr "…"` inside any Claude session; `mgr` alone prints its replies. From the tower it arrives in seconds; from s1 it is picked up at the manager's next hourly check (or live, while the manager's ssh Monitor holds). **Over a one-shot ssh** (`ssh … ubuntu@148.113.170.120 'mgr "…"'`) use the full path `~/.local/bin/mgr` — non-interactive ssh skips `.profile` and reports `command not found` (28 Aug 2026).
