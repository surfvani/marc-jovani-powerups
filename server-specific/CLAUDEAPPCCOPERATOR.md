# CLAUDEAPPCCOPERATOR — operating app_cc (production data and code) from an outside server

## What this file is
- Marc loads it — directly, or by telling the manager or another persona to read it — when app_cc work has to be done from lake-vault.
- Loading it IS Marc's authorization to touch app_cc, for the task he named and only that task. If the persona you are running forbids app_cc (the manager's D7), this file wins for that task. Write one line about it in your audit log.
- The discipline is the one a dev session runs: `/whatdocs` → simplll → samepage gate → Marc's GO → `/defcode`. No push, no prod action, without a GO that covered it.

## STEP 0 — NON-NEGOTIABLE (Marc, 4 Sep 2026)
- **No query, no grep, no curl, no ssh read against app_cc until steps 1–4 below are done and the `/whatdocs` TODO list is on screen.** Not for a lookup, not for a "quick check": a read-only audit IS a task and runs the same ladder.

## Read before you start, in this order
1. `ssh dev 'cat /home/ubuntu/app_cc/CLAUDE.md'` — **entirely** (489 lines). The pipeline (dev → GitHub → prod, auto-pull every 2 min, no review gate), the `.env` safety rules on dev, the processes that must never run on dev, the adhoc-scripts rule on prod, the round-trip for tracked files edited on prod.
2. `~/.claude/personas/CLAUDEDEV.md` — how you work and how you talk to Marc. If it is not on this box: `ssh dev 'cat /home/ubuntu/.claude/personas/CLAUDEDEV.md'`.
3. The system's `DOCUMENTATION_<SYSTEM>.md` in app_cc. Headings first (`grep -n '^#' <file>`), then the sections the task needs. Not `DOCUMENTATION.md` unless the task is architectural — Marc's call, 5 Sep 2026.
4. Then `/whatdocs`. Its file reads happen over ssh (`cat`, `sed -n`, `grep -n`, `tree -L 3 <dir>`); whole files, not snippets.

## The boxes
| Box | Reach it | Notes |
|---|---|---|
| lake-vault (`/home/surfvani`) | you are here | keys in `~/.ssh`, hosts in `~/.ssh/config`; fetched copies live in your session scratchpad |
| s1 · production · 148.113.170.120 | `ssh -i ~/.ssh/marc-keypair.pem ubuntu@148.113.170.120` | app at `/home/ubuntu/app_cc`; one-off scripts and backups in `/home/ubuntu/adhoc_scripts/` — never inside the repo |
| dev · 149.202.59.244 | `ssh dev` (key `~/.ssh/dev_link`, host in `~/.ssh/config`) | Fede's box, shared; a copy of the prod DB; `dev.cinematiccomposing.com` behind basic auth `staging:CCdev2026!` |

- Below, `ssh s1 '…'` is shorthand for `ssh -T -o BatchMode=yes -o ConnectTimeout=10 -i ~/.ssh/marc-keypair.pem ubuntu@148.113.170.120 '…'`. Add a `Host s1` entry to `~/.ssh/config` once and the shorthand becomes real.
- First contact with a host fails in BatchMode with "Host key verification failed" until the key is accepted (`-o StrictHostKeyChecking=accept-new`).
- From s1, the dev key is `/home/ubuntu/.ssh/dev_vps` (the round-trip script uses it).

## SSH hygiene — every command
- `ssh -T -o BatchMode=yes -o ConnectTimeout=10 <host> '<command>'`. Single-quote the remote command. Absolute paths inside it, always: `git -C /home/ubuntu/app_cc …`, `cd /home/ubuntu/app_cc && …`. The working directory never persists between commands, and a bare `git pull` from a drifted cwd has already pulled app_cc by accident once (manager, 9 Aug 2026).
- Never interactive: `--nostream`, `--no-pager`, no scripts that prompt (`rollback.sh` prompts — and it is Marc's anyway).
- What you cannot do from here: the Edit tool does not reach remote files (see the round-trip), and there is no browser — `curl -s -u staging:CCdev2026! https://dev.cinematiccomposing.com/<page>` is how you look at a page.

## Where each thing happens
- **dev**: read, edit (round-trip), compile, test, `pm2 restart app_cc`, commit, push. Code changes happen here. Only here.
- **s1**: read anything; run the migration or the `.sql` Marc approved; restart a worker that was in the approved deploy plan; verify. Never edit a tracked file. Never run a `send_*.py` by hand.
- **lake-vault**: holds the fetched copies and nothing else of app_cc.

## Editing a file on dev — the round-trip, the only way
The Edit tool only works on local files, and sed/awk/echo/heredocs over ssh are blind injection — forbidden, exactly as `/defcode` says. So the file comes to you, gets edited with the real tool, and goes back — with a hash check on both ends so nobody's work is overwritten.

1. **Fresh tree.** `ssh dev 'git -C /home/ubuntu/app_cc pull --rebase --autostash origin main && git -C /home/ubuntu/app_cc status --short'`. Autostash carries Fede's in-flight edits across the pull and puts them back; never stash by hand. Dirty or untracked files you did not create are his WIP: never edit, never stage, never revert. (`static/*-preview/`, `FEDE_WORKFLOW.md`, `requirements-dev.txt`, `start_dev.sh`, `tests/*.bak_*` are normal.)
2. **Fetch.** `scp -p dev:/home/ubuntu/app_cc/<path> <scratchpad>/app_cc/<path>` — mirror the repo path under your scratchpad so two files never get confused. Record the remote hash: `ssh dev 'sha256sum /home/ubuntu/app_cc/<path>'`.
3. **Edit locally with the Edit tool.** Read the whole file first — you have it now.
4. **Guard.** Re-run the remote `sha256sum`. It must equal step 2. If it moved, someone changed the file under you: back to step 1.
5. **Back up on dev.** `ssh dev 'cp -p /home/ubuntu/app_cc/<path> /home/ubuntu/app_cc/<path>.bak_pre_<reason>_<YYYYMMDD>'` — `*.bak_*` is gitignored.
6. **Push back.** `scp -p <scratchpad>/app_cc/<path> dev:/home/ubuntu/app_cc/<path>`, then `sha256sum` local and remote: they must match.
7. **Review on dev.** `ssh dev 'git -C /home/ubuntu/app_cc diff -- <path>'` — that diff is what you will commit.

Several files: repeat per file; `git diff --stat` at the end must list your files and nothing else. A new file (a migration, a test): Write it locally, `scp` it up, same hash check.

## Check, render, test — on dev, all of it
- **Python compiles and the app boots.**
  `ssh dev 'cd /home/ubuntu/app_cc && venv/bin/python3 -m py_compile <file>.py && echo COMPILE OK'`
  `ssh dev 'cd /home/ubuntu/app_cc && venv/bin/python3 -c "from app import create_app; create_app(); print(\"APP BOOTS OK\")"'`
- **Templates compile through the app's own Jinja environment** — the app registers its own filters and globals, and a bare `jinja2.Environment().parse()` would wave a wrong filter name through to a 500 in production:
  `ssh dev 'cd /home/ubuntu/app_cc && venv/bin/python3 -c "from app import create_app; create_app().jinja_env.get_template(\"<path under templates/>\"); print(\"TEMPLATE OK\")"'`
- **Every suite of the system, not one.** Suites are standalone scripts (not pytest) that print ✅/❌ and a count. Find them: `ls tests/test_<system>*.py` and `grep -l '<module or template name>' tests/test_*.py`. Read a suite's docstring before running it (they are written read-only or roll back; dev's empty AWS keys are the net). Run each: `ssh dev 'cd /home/ubuntu/app_cc && venv/bin/python3 tests/<file>.py'`, read every count.
- **Render.** After Python changes: `ssh dev 'pm2 restart app_cc >/dev/null; for i in 1 2 3 4 5 6; do c=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:5056/store); [ "$c" = 200 ] && break; sleep 3; done; echo store=$c'` — the first fetch after a restart can be a 502, so poll. Then fetch the changed page with the staging auth and find your change in the HTML.
- **CSS/JS need no version bump.** `static_file()` hashes the content. Never `url_for('static', …)` with a manual `?v=`; `tests/test_cache_theme_decouple.py` fails the suite if it comes back.

## Ship — one GO covers the whole deploy plan
Before asking for the GO, put the plan in front of Marc in plain English, every prod action named:
- what changes (the files), and the evidence so far (counts, the rendered page)
- a migration on prod **first**? (column before code: code lands in 2 min, schema never deploys itself — a column the new code reads must already exist)
- the push
- which workers restart afterwards, and when
- what you will verify on prod

Marc says GO → run all of it, in that order. Nothing that was not on the list.

1. **Migration, if any.** Create it under `migrations/`, run it on dev, test against it, then run it **on prod** before the push (it is a prod DB write: see § Data, the same stage-and-ask rule applies). Read the column or rows back.
2. **Commit and push, from dev.** `git add <your files, by name>` — never `.` or `-A`. `Fix:` / `Add:` / `Update:` / `Remove:` first word, the evidence in the message. `git push origin main`.
3. **Prod pulls within ~2 min** (cron), restarts `app_cc` only, health-checks `/store`, and rolls back by itself if that fails (Slack alert to `#support-tickets`). Poll for up to 3 min:
   `ssh s1 'git -C /home/ubuntu/app_cc rev-parse --short HEAD; systemctl is-active app_cc; curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:5056/store'` — HEAD equals your commit, `active`, `200`. Then fetch the changed surface on `https://cinematiccomposing.com/…`.
4. **The restarts auto-deploy will not do.** Enumerate every process that imports what you changed. `ssh s1 'grep -l app_cc /etc/systemd/system/*.service'` lists every unit that runs app code; verified 5 Sep 2026, the long-running ones are:
   - `campaign_sender` — loads the whole app at start, so any change to `modules/email_campaigns.py`, `modules/emails.py` or `modules/models.py` runs stale until restarted. Only in a send gap:
     `ssh s1 "sudo -u postgres psql -d app_cc -c \"SELECT count(*) FROM email_campaigns WHERE status IN ('queued','sending');\""` — must be 0 — then `ssh s1 'sudo systemctl restart campaign_sender && sudo journalctl -u campaign_sender --since "2 min ago" --no-pager | tail -3'`.
   - `community-worker-distill` — the RQ worker; restart when pipeline/worker code changed.
   - `community-sse` — imports no app modules; restart only when `community_sse.py` itself changed.
   - The timers (`ceo_dashboard_cache`, `sales_analysis_cache`, `email_events_retention`) and the cron jobs are one-shots: they pick up new code on their next run. Nothing to do.
5. **The system's `DOCUMENTATION_<SYSTEM>.md` rides the same commit** — round-trip it like any other file.

## Undo
- Health check failed → auto-deploy already rolled back and alerted. Fix forward from dev.
- App up, page broken → `git revert <your sha>` on dev and push, **without waiting** — it restores what was live an hour earlier. Only your own commit from this task; then report. Do not "roll back" prod by checking out an older commit: the next cron tick sees HEAD ≠ origin/main and deploys the bad commit again. `rollback.sh` is Marc's.

## Never edit tracked files on prod
- `ssh s1 'git -C /home/ubuntu/app_cc status --short'` must print nothing before you push; a dirty prod tree blocks auto-deploy with a Slack alert.
- If it prints files, someone edited on prod. Run the documented round-trip **first**, on s1: `DRY_RUN=1 /home/ubuntu/adhoc_scripts/sync_prod_edits_to_dev.sh "Update: <reason>"`, then without `DRY_RUN`.
- Until Marc fixes the script: with **more than one file, always pass the list yourself** — `FILES="path1 path2" /home/ubuntu/adhoc_scripts/sync_prod_edits_to_dev.sh "…"`. Without `FILES` the list arrives one file per line, the second filename runs as a command on dev, and the script dies after applying the patch: nothing committed, nothing pushed, prod not reset. (Verified 5 Sep 2026.)
- Untracked files on prod (a new test, for example) are not carried by the script. `scp` them to dev, commit them with their code, then `rm` them on prod.

## Data lives in prod's Postgres
- `ssh s1 'sudo -u postgres psql -d app_cc -c "…"'` — what every app_cc doc uses; no secret to handle, never print `DATABASE_URL`.
- Read first: `information_schema.columns` for the shape, then the rows with `-x`.
- A write is five steps: (1) a `.sql` file in `/home/ubuntu/adhoc_scripts/` (never inside app_cc — that trips the dirty-tree Slack alert), with `\set ON_ERROR_STOP on`, one transaction, dollar-quoted text (`$t$…$t$`), and a guard (`DO $$ … RAISE EXCEPTION …`) for anything that must be unique; (2) a row backup, `psql -x` output to `/home/ubuntu/adhoc_scripts/backup_<what>_<timestamp>.txt`; (3) apply; (4) read the rows back; (5) fetch the live page.
- Marc's note (4 Sep 2026): the auto-mode permission classifier blocks every prod DB write over ssh, even after his spoken GO. Stage the file and the backup, then ask him to accept the prompt (retry the same command) or to run the staged file himself with `!`. Do not look for a way around it.
- `timestamptz` columns take explicit offsets (`'2026-09-10 08:00:00-07'`). Pages render times in the visitor's zone, client side.

## Talking to Marc while doing this
- One line on what you are about to do. Then do it.
- Say in one sentence whether the task is data or code, before starting. He decides scope, not mechanics.
- No pipeline jargon in the report. "Code is edited on the dev server, pushed, and prod pulls it within two minutes" is the whole explanation.
- Every "done" comes with evidence from this turn: the rows read back, the page fetched, the test counts, HEAD on prod.
