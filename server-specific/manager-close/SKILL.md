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

**Board folder:** the one named in your persona's § Current Board (today: `/home/ubuntu/NORTH_STAR/BOARDS/PROJECT_HERO/`).

### Step 0 — TODO
Create a task list from these steps (task tools). One item per step. Mark as you go.

### Step 1 — Sync first
```bash
cd /home/ubuntu/NORTH_STAR && git pull
```
If the pull surfaces changes in `BUILD_PLANS/` or the board folder that you have not seen, read those diffs now — they belong in this close.

### Step 2 — Inventory what happened
List, from your own session memory + `git status`: every plan edit you made, every fact you verified, everything Marc decided or corrected, anything that moved a plan's state. This inventory drives every step below. If the inventory is empty, jump to Step 7.

### Step 3 — Update DIGEST.md
Targeted edits only, for the sections your inventory touches: lane states, 🚨 rows, dates, the "Today" block. Each new fact must be traceable to a plan (or to THE_BOARD.md's Marc-reported table). Rebuild a section rather than patch it if drift has accumulated.

### Step 4 — Tick the plans (bookkeeping only)
For each plan whose reality moved: tick the box / refresh the Active State row **with evidence in the edit**. You are a polite guest (D4): status ticks, Active State refreshes, cross-doc consistency — never specs, never build work, never Locked Decisions registers. **Grep the whole document for any fact you correct — never trust the pointer to one section** (the six-places lesson).

### Step 5 — Refresh the board page
Read `board.html` (entirely, first time each session), apply content-only edits reflecting the digest, run the D24 self-check on every changed element. **That is the whole step — the file IS the page** (`/b` reads it from disk per request). Sanity-check with `curl -s -o /dev/null -w '%{http_code}\n' https://wiki.1mypr.com/b` → expect `302` (login redirect) proving the route is alive.

### Step 6 — Log every edit
One row per edit in `THE_BOARD.md` → "The manager's log": date · file · what changed · evidence. Marc audits in seconds because these rows exist.

### Step 7 — Record the close SHA
```bash
cd /home/ubuntu/NORTH_STAR && git rev-parse HEAD > BOARDS/PROJECT_HERO/.last-close-sha
```
This is what the next session's open-check diffs against. If the file does not exist yet, this creates it (first run bootstrap).

### Step 8 — Commit and push
```bash
cd /home/ubuntu/NORTH_STAR && git add -A && git commit -m "[mgr] close: <one-line summary>" && git push
```
If the auto-sync already swept your edits: commit whatever remains (the SHA file at minimum), do not fight the race, note nothing — it is normal.

### Step 9 — Recycling? Set the marker, then end
Only when this close is a self-recycle (context ~300K / harness warnings / session ≥7 days) or Marc ordered shutdown:
```bash
touch ~/.claudemanager.handover
tmux kill-session -t cs-manager
```
The watchdog respawns a fresh manager within ~5 minutes; the marker tells it the death was clean, so it takes over silently. If you are closing but the session should stay alive (e.g., Marc asked for a mid-day close-out), SKIP this step entirely — no marker, no kill.

## Failure modes

| Symptom | Action |
|---|---|
| `git push` rejected | `git pull --rebase`, push again. Still failing → leave committed locally, note it for the next brief (auto-sync will usually carry it) |
| `wiki.1mypr.com/b` does not return 302 | The wiki app is down or the route was lost. `sudo systemctl status wiki-server`; restart it. Route lives in `NORTH_STAR/APP/wiki_server/app.py` (gitignored — back it up before any edit) |
| `.last-close-sha` missing at Step 7 | Normal on first run — create it |
| A plan edit feels like judgment, not bookkeeping | It IS judgment. Revert your edit, bring it to Marc in the next brief with a recommendation |
| You cannot complete the ritual (tool failure, mid-close crash) | Whatever already landed is safe (each step commits durable state). On respawn, the boot open-check sees the partial close — finish the remaining steps FIRST, before any new work |
