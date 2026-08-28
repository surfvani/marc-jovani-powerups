---
name: manager-close
description: The CLAUDEMANAGER close ritual — MANDATORY before any manager session ends, for any reason (daily recycle, ~300K context recycle, Marc says stop, or nothing happened at all). Runs the close-by-writing half of D15: git pull → update DIGEST.md from what actually happened this session → tick plan bookkeeping with evidence → refresh board.html (Cold Monday self-check — it is served live from disk at wiki.1mypr.com/b, so editing it publishes it) → log every edit in THE_BOARD.md's manager log → record the close SHA for the next session's open-check → [mgr] commit + push → set the handover marker if recycling. Modeled on /handoff-continuia but it is a RUNTIME ritual, not a session handoff: no scoping options, no handoff prompt, no Session Log entry in a build plan. Invoked by the CLAUDEMANAGER persona; usable by any future board the persona runs. Skip ONLY if this is not a manager session (no CLAUDEMANAGER persona loaded) — build sessions on the manager project itself close with /handoff-continuia instead.
---

# /manager-close — no manager session ends without this

You are CLAUDEMANAGER, closing a session. The board must be true and the trail must be complete BEFORE you stop existing. You know what changed better than git ever will — that is why this fires now, at maximum knowledge.

## Hard rules (non-negotiable)

1. **This ritual runs even if "nothing happened."** A quiet close is cheap (steps collapse to: pull → record SHA → done). Skipping it is the one unforgivable (persona Anti-Pattern #10).
2. **Plans are truth; the digest is a cache (D11).** Never write a fact into DIGEST.md that is not in a plan. On disagreement, the plan wins.
3. **Every plan edit needs evidence and a log row (D5).** No exceptions. The manager's log table in `THE_BOARD.md` is the audit trail of record — not commit messages.
4. **Board page: content only, never redesign (D9).** Style comes from the approved template. Never re-add `overflow` to `.tl-scroll` (the tooltip-clipping trap, Session 1).
5. **Every board element must pass the Cold Monday self-check (D24)** before you publish: read every row as if you had never opened a plan; every noun resolvable only from memory is a defect. Cards: ~15 words "what it is," ~45 words hard ceiling.
6. **There is no publish step — editing `board.html` publishes it.** Since 4 Aug 2026 the board is served live from disk by the wiki app at **https://wiki.1mypr.com/b** (`no-store`, behind the same login as `/w` and `/d`). **Never publish the board as an artifact** — that path served Marc a day-old copy no refresh could clear.
7. **Read any file entirely before editing it.** Edit tool only — targeted changes, no rewrites, no sed/awk injection.
8. **`git pull` before writing anything** — NORTH_STAR syncs to Marc's Mac and Ali's Mac, and an auto-sync cron commits every 5 minutes. Expect to lose the `[mgr]` commit race sometimes; that is fine and predicted (D5). Never treat a missing `[mgr]` prefix as a missing edit — the log table is the record.
9. **English (US)** for everything written.

## The workflow — execute in order

**Board folder:** the one named in your persona's § Current Board (today: `~/north-star/BOARDS/PROJECT_HERO/`).

> **Box note (28 Aug 2026):** manager runs on **lake-vault**; repo is `~/north-star` (caps = s1 only). The wiki serves the board from this same box — editing `board.html` publishes instantly.

### Step 0 — TODO
Create a task list from these steps (task tools). One item per step. Mark as you go.

### Step 1 — Sync first
```bash
cd ~/north-star && git pull
```
If the pull surfaces changes in `BUILD_PLANS/` or the board folder that you have not seen, read those diffs now — they belong in this close.

### Step 2 — Inventory what happened
List, from your own session memory + `git status`: every plan edit you made, every fact you verified, everything Marc decided or corrected, anything that moved a plan's state. This inventory drives every step below. If the inventory is empty, jump to Step 7.

### Step 3 — Update DIGEST.md
Targeted edits only, for the sections your inventory touches: lane states, 🚨 rows, dates, the "Today" block. Each new fact must be traceable to a plan (or to THE_BOARD.md's Marc-reported table). Rebuild a section rather than patch it if drift has accumulated.

**The Today block must leave TOMORROW'S BRIEF STAGED** — leads + day plan readable in one block, MAÑANA content in the PRE-GAINS journal formula (persona Hard-Won 16 Aug), taken from `/manager-checkout`'s planner-framed output (weekly-intentions frame + INTENTIONAL/URGENCIA classification, Hard-Won 17 Aug) — so the next boot renders the 5:10 brief from digest + wiki DB + live numbers alone.

**⚠️ REPLACE the Today block, never append (Marc, 18 Aug 2026).** Hop lines and yesterday's staging already live in their permanent homes (wins → `WINS.md` · audit → board log · facts → plans · everything → git), so one fresh block overwrites the old and the file never grows. Anything you can't delete because it lives nowhere else belongs in a plan, the log, or `INBOX.md` — put it there first, then replace.

### Step 4 — Tick the plans (bookkeeping only)
For each plan whose reality moved: tick the box / refresh the Active State row **with evidence in the edit**. You are a polite guest (D4): status ticks, Active State refreshes, cross-doc consistency — never specs, never build work, never Locked Decisions registers. **Grep the whole document for any fact you correct — never trust the pointer to one section** (the six-places lesson).

### Step 5 — Refresh the board page
Read `board.html` (entirely, first time each session), apply content-only edits reflecting the digest, run the D24 self-check on every changed element. **That is the whole step — the file IS the page** (`/b` reads it from disk per request). Sanity-check with `curl -s -o /dev/null -w '%{http_code}\n' https://wiki.1mypr.com/b` → expect `302` (login redirect) proving the route is alive.

### Step 6 — Log every edit
One row per edit in `THE_BOARD.md` → "The manager's log": date · file · what changed · evidence. Marc audits in seconds because these rows exist.

### Step 7 — Record the close SHA
```bash
cd ~/north-star && git rev-parse HEAD > BOARDS/PROJECT_HERO/.last-close-sha
```
This is what the next session's open-check diffs against. If the file does not exist yet, this creates it (first run bootstrap). **Its mtime is also the shutdown hook's completion signal** (28 Aug 2026) — never touch it to "look done"; an unwritten brief would pass as written.

### Step 8 — Commit and push
```bash
cd ~/north-star && git add -A && git commit -m "[mgr] close: <one-line summary>" && git push
```
If the auto-sync already swept your edits: commit whatever remains (the SHA file at minimum), do not fight the race, note nothing — it is normal.

### Step 9 — Recycling? Set the marker, then end
Only when Marc ordered the recycle/shutdown, or the watchdog ordered an EMERGENCY ROTATE (memory guard, below). **Context pressure and session age are NOT recycle reasons** (Marc's two-triggers rule, 12 Aug 2026: the 2am cron or his word, nothing else). Closing ahead of the 2am rotate? Close WITHOUT marker or kill — the cron sets the marker and kills by itself (proven 16 Aug: 01:11 quiet close → 02:00 rotate → silent takeover):
```bash
printf 'manual %s\n' "$(date +%s)" > ~/.claudemanager.handover
tmux kill-session -t cs-manager
```
**The marker states WHY** — `manual`/`brief`/`rotate`/`solo`/`emergency-rotate`/`shutdown`. With a reason it is valid at any age; a bare `touch` only for 3h (on 18 Aug a 9h-old bare one let an OOM kill pass as a clean handover). **Never pre-touch it outside those moments.**

**POWER OFF (28 Aug 2026).** `🔻 THE BOX IS POWERING OFF` on the `mgr` line = box held open **10 min** while you write. Run Steps 1 → 3 → 4 → 6 → 7 → 8. **NO marker, NO kill** — the hook sees your close SHA move and does both (reason `shutdown`); next boot takes over silently like the 2am rotate. Miss the 10 min → successor inherits a confession + `mgr-tail` instead of your brief.

**EMERGENCY ROTATE (memory guard).** A `🚨 EMERGENCY ROTATE` line on the `mgr` line = the box is out of memory and you are replaced in 15 min, ready or not. Run lean and now: Steps 1 → 3 → 6 → 7 → 8 (skip the board page unless stale). Do NOT set a marker, do NOT kill — the watchdog sees the close SHA move and does both. Miss it and your successor inherits a confession plus `mgr-tail` instead of your brief.
The watchdog respawns a fresh manager within ~5 minutes; the marker tells it the death was clean, so it takes over silently. If you are closing but the session should stay alive (e.g., Marc asked for a mid-day close-out), SKIP this step entirely — no marker, no kill.

## Failure modes

| Symptom | Action |
|---|---|
| `git push` rejected | `git pull --rebase`, push again. Still failing → leave committed locally, note it for the next brief (auto-sync will usually carry it) |
| `wiki.1mypr.com/b` does not return 302 | The wiki app is down or the route was lost. It runs on THIS box: `sudo systemctl status wiki-server`; restart it. Route lives in `~/north-star/APP/wiki_server/app.py` (gitignored — back it up before any edit). A local `curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:5052/b` separates "app is down" from "tunnel/DNS is down" |
| `.last-close-sha` missing at Step 7 | Normal on first run — create it |
| A plan edit feels like judgment, not bookkeeping | It IS judgment. Revert your edit, bring it to Marc in the next brief with a recommendation |
| You cannot complete the ritual (tool failure, mid-close crash) | Whatever already landed is safe (each step commits durable state). On respawn, the boot open-check sees the partial close — finish the remaining steps FIRST, before any new work |
