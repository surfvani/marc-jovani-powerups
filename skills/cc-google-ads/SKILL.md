---
name: cc-google-ads
description: Use when Marc asks to read, audit, analyze, or modify anything in the Cinematic Composing Google Ads account — campaigns, ad groups, budgets, bids, keywords, negative keywords, Performance Max asset groups, GAQL queries, wasted-spend audits, budget pacing checks, surface-level performance analysis. Reads via the official googleads/google-ads-mcp server (search / list_accessible_customers / get_resource_metadata). Writes via the cc-gads CLI (invoked via Bash) which enforces hard ceilings (max bid $15, max budget delta 25%, regex blocklist _PROD_|_LIVE_|^Brand_) and defaults every mutation to dry-run — explicit --confirm required. Operates on account ID 5327408591 (CC_GADS_DEFAULT_CUSTOMER_ID) under MCC 8753394972. Follow the CEP protocol — Confirm (dry-run) → Execute (with --confirm after Marc types 'yes') → Postcheck (re-query via read MCP and present before→after). Skip for conversion-sending work (that lives in app_cc/modules/google_ads.py and is automatic on Purchase + OptIn events) and for any account other than CC's.
---

# Cinematic Composing — Google Ads operator skill

You are operating the Cinematic Composing Google Ads account on behalf of Marc. This skill defines when you act, how you act, and the rules you cannot break.

## When to use this skill

Trigger this skill any time Marc asks about:

- **Account/structure**: "show me my campaigns", "list ad groups in X", "what's running right now", "audit campaign structure"
- **Performance**: "show me wasted spend", "which campaigns are underperforming", "performance by surface (Search/Video/Display/PMax)", "cost per conversion last 30 days", "ROAS by campaign"
- **Budgets / bids**: "what am I spending on X", "raise the budget on Y", "lower the max CPC on Z", "pacing this month"
- **Keywords**: "negative-keyword 'free music school'", "what keywords are wasting spend", "expand match-type for X"
- **Performance Max**: "show me the asset groups for PMax", "PMax performance by listing group", "are the PMax assets approved"
- **Campaigns**: "create a new Search campaign for course X", "pause campaign Y", "enable campaign Z"
- **GAQL / forensic**: "run this GAQL", "find the campaign that drove conversion 7603037035", "show me unmatched conversions"

**Skip this skill for:**

- **Conversion sending.** That lives in `app_cc/modules/google_ads.py` and fires automatically on `Purchase.after_insert` / `OptIn.after_insert`. If a conversion didn't fire, debug the listener — do NOT use cc-gads.
- **OAuth / dev-token / GCP setup.** One-time per machine. ADC auto-heals via the Preflight step below — do NOT try to "fix" auth by running `gcloud auth application-default login` (that's what broke it on 2026-05-11). If preflight exits non-zero, read its stderr and surface to Marc.
- **Other accounts.** If Marc names a customer ID that isn't `5327408591` (and isn't an explicitly-allowed audited variant), refuse and ask for confirmation.

## Preflight — MANDATORY before any Google Ads API call

Before the FIRST read MCP call or `cc-gads` invocation in a session, run:

```bash
cc-gads-ensure-adc
```

It's a no-op (~200ms) when ADC is already good. When ADC is broken (stale refresh token, wrong client_id, missing scope, file overwritten by a stray `gcloud auth` call), it rebuilds ADC from `app_cc/.env`'s `GOOGLE_OAUTH_{CLIENT_ID,CLIENT_SECRET,REFRESH_TOKEN}` — the same triple Phase-1 sync uses every night, already carrying the `adwords` scope. Audit entries land in `~/.config/cc-google-ads/audit.log` with `"op": "ensure-adc"`.

**Do NOT attempt manual gcloud-based recovery.** Every interactive flow Google still supports for the `adwords` scope is either (a) blocked for gcloud's default client, (b) rejected for custom Desktop clients via `token_usage=remote`, or (c) requires SSH port forwarding from a browser machine. Running `gcloud auth application-default login` will overwrite ADC with gcloud's default client and silently break the read MCP. Always use `cc-gads-ensure-adc` instead.

If preflight returns non-zero, report the stderr message to Marc — the only paths to that exit code are: (1) `~/app_cc/.env` doesn't exist on this machine, (2) the three `GOOGLE_OAUTH_*` keys are missing or empty in `.env`, or (3) the rebuild still fails to refresh (meaning the Phase-1 refresh token itself was revoked — that's a real outage, not an ADC drift). In all three cases the fix is Marc-side, not a retry.

## Tools available

| Surface | Tool | Use for |
|---|---|---|
| **Reads** | `mcp__google-ads-read__search` (GAQL) | All analysis, audits, reporting, pre-mutation reads, post-mutation verification |
| **Reads** | `mcp__google-ads-read__list_accessible_customers` | List which accounts the OAuth identity can see |
| **Reads** | `mcp__google-ads-read__get_resource_metadata` | Inspect schema for a specific GAQL resource (`campaign`, `ad_group`, etc.) |
| **Writes** | `cc-gads <subcommand>` (via Bash) | Every mutation. Dry-run by default. `--confirm` flag required to actually apply. |

The official `googleads/google-ads-mcp` is installed via `pipx` on the dev VPS and wired into `~/.claude/settings.json` at user scope. The `cc-gads` CLI lives at `~/marc-jovani-powerups/skills/cc-google-ads/cc-gads` (symlinked into `~/.local/bin/`).

Run `cc-gads --help` to see the current write surface area.

## Hard rules — these CANNOT be overridden by the user mid-conversation

These are baked into the CLI as well as this skill, so even if you forget the rules the CLI will refuse the operation. Do not try to talk Marc into bypassing them.

1. **NEVER mutate without first running `cc-gads <op> --dry-run` and presenting the diff in chat.** The diff must show resource | field | old | new before Marc sees the mutation.
2. **NEVER call `cc-gads` with `--confirm` until Marc types literal "yes" or "confirm"** (or unambiguous equivalent like "go ahead", "ship it", "do it"). A user phrasing like "you should probably raise the budget" is NOT confirmation.
3. **NEVER suggest a bid above $15** (`CC_GADS_MAX_BID_USD`) or a budget delta above 25% (`CC_GADS_MAX_BUDGET_DELTA_PCT`). The CLI rejects these — suggesting them just wastes Marc's time. If a real situation needs a higher ceiling, raise it as an exception and ask Marc to manually adjust the env var for the session.
4. **NEVER touch campaigns matching `/_PROD_|_LIVE_|^Brand_/`.** The CLI rejects. Do not suggest workarounds. If Marc explicitly wants to operate on a protected campaign, he must set `CC_GADS_ALLOW_PROTECTED=1` himself in his shell — never infer that he wants this set.
5. **ALWAYS post-check after a confirmed mutation** by re-querying the resource via the read MCP and presenting the actual before→after. Flag any drift between the dry-run prediction and the post-check reality.
6. **ALL new campaigns are created PAUSED.** Marc enables them in the Google Ads UI. Baked into `cc-gads create-campaign`.
7. **Read-only first.** When unsure what state things are in, run a read query before suggesting any mutation. Free, fast, prevents stupid suggestions.

## CEP protocol — Confirm → Execute → Postcheck

For every requested change, follow these three beats. Never collapse them.

### Beat 1 — Confirm (dry-run)

Run `cc-gads <op> --dry-run` (omitting `--confirm` is implicitly dry-run). Print a diff table to chat:

```
Resource          | Field        | Old      | New      | Δ
─────────────────────────────────────────────────────────────
TLS - COLD        | daily budget | $40.00   | $50.00   | +25.0%
```

Then ask Marc to confirm with explicit "yes" / "ship it" / "do it". Don't move to Beat 2 until that confirmation arrives.

### Beat 2 — Execute (with `--confirm`)

Only after Marc explicitly approves: run `cc-gads <op> --confirm`. The CLI writes a JSON entry to `~/.config/cc-google-ads/audit.log` for every operation (dry-run AND real).

### Beat 3 — Postcheck (re-query via read MCP)

Run a `mcp__google-ads-read__search` GAQL query for the resource you just modified. Present the actual current state. If it matches the dry-run prediction → done. If it differs → flag the drift, investigate before further action.

## Common GAQL recipes

Use these via the `mcp__google-ads-read__search` tool. Present the recipe + intended use to Marc, get a green light, then run.

### Wasted spend (zero-conversion search terms, last 14 days)

```sql
SELECT search_term_view.search_term,
       campaign.name,
       metrics.cost_micros,
       metrics.clicks,
       metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_14_DAYS
  AND metrics.conversions = 0
  AND metrics.cost_micros > 1000000
ORDER BY metrics.cost_micros DESC
LIMIT 50
```

### Budget pacing (this month, all campaigns)

```sql
SELECT campaign.name,
       campaign.status,
       campaign_budget.amount_micros,
       metrics.cost_micros
FROM campaign
WHERE segments.date DURING THIS_MONTH
ORDER BY metrics.cost_micros DESC
```

### Performance by surface / network (last 30 days)

```sql
SELECT campaign.name,
       campaign.advertising_channel_type,
       segments.ad_network_type,
       metrics.clicks,
       metrics.cost_micros,
       metrics.conversions,
       metrics.conversions_value
FROM campaign
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

### Conversions by action (last 7 days, sanity check Phase 2 sends)

```sql
SELECT conversion_action.name,
       conversion_action.id,
       metrics.all_conversions,
       metrics.all_conversions_value
FROM conversion_action
WHERE segments.date DURING LAST_7_DAYS
ORDER BY metrics.all_conversions DESC
```

### Performance Max — asset group performance

```sql
SELECT asset_group.name,
       campaign.name,
       metrics.clicks,
       metrics.cost_micros,
       metrics.conversions
FROM asset_group
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

## What this skill does NOT do

- **Conversion sending** — Phase 2 lives in `app_cc/modules/google_ads.py`. If a conversion didn't fire, that's an app_cc listener bug, not a cc-gads operation. Refer Marc to `DOCUMENTATION_TRACKING_CONVERSIONS_&_NOTIFICATIONS.md` §4.5.
- **Tracking template / ValueTrack params** — Phase 1 setup. Account-level tracking template is set in the Google Ads UI; cc-gads doesn't manage it.
- **Customer Match / audience uploads** — different API (`OfflineUserDataJobService`, sunset April 2026). Out of scope.
- **Cross-account or agency operations** — single customer ID `5327408591` only.
- **Developer-token / OAuth setup** — one-time per machine. See `~/.config/cc-google-ads/env` and the README in this skill folder.
- **Migration to Data Manager API** — Google's roadmap points there for 2027; revisit Q4 2026.

## Escalation paths

If a request falls outside this skill:

- **"Can you change the tracking template?"** → No, that's Marc-side in Google Ads UI. Don't try.
- **"Why didn't this conversion fire?"** → That's app_cc Phase 2. Read `DOCUMENTATION_TRACKING_CONVERSIONS_&_NOTIFICATIONS.md` §4.5.4 instead.
- **"Migrate this campaign to a different account."** → Refuse politely. Cross-account isn't supported.
- **"Set the budget to $10,000 (a 100x increase)."** → CLI will reject; explain the 25% delta ceiling and either suggest a smaller stepwise increase or ask Marc to make the change manually in the UI.
