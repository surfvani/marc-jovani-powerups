---
name: cc-launch-pace
description: Use whenever Marc asks how a launch is doing, whether it is worth extending, or how it compares to other launches — "how's X going", "is this good", "should we extend", "best launch", "which is winning", or any launch-vs-launch comparison. Runs cc-launch-pace, which compares every launch at the SAME day-range (day-N cumulative vs day-N cumulative), because measuring a launch's first days against another's full run is invalid — launches valley in the middle and spike at the close. Reports revenue-to-date, $/day, sends and $/send, ranked, with NEW vs RELAUNCH read from the Launch Hub (never guessed). Revenue is always measured by funnel/checkout, never by product name. Also use before any extend/delay decision on the launch calendar.
---

# Launch Pace — is this launch actually good?

Marc's question, in his own words:

> "How many days in? 3? How much so far? $3k? So $1k a day.
> Now compare against every other launch **at the same date range** — comparing
> the first 3 days against a full launch is no good, because launches valley in
> the middle. Oh! Top performer, and staying stable. Keep an eye on this one.
> Could be worth extending — and could become a workhorse after launch."

That is the whole skill. Normalise to **per day**, compare at the **same day-N**, then rank.

## Run it

```bash
cc-launch-pace                          # auto-detects the most recent live launch
cc-launch-pace --focus fluid-flutes     # pin a funnel slug
cc-launch-pace --day 7                  # force the comparison day
cc-launch-pace --all                    # every run, not just the top 15
cc-launch-pace --months 24 --min-rev 500
```

Never hand-write the SQL instead. The script exists because hand-written queries
produced the wrong number twice (see "Why this is a script" below).

## Reading the output

| Column | Means |
|---|---|
| `Rev @dN` | Cumulative revenue through day N of **that launch's own run** |
| `$/day` | `Rev @dN ÷ days actually elapsed` — the number Marc thinks in |
| `Sends` | Emails linking that funnel's slug, sent inside day 1..N |
| `$/send` | Revenue per email. The number that decides calendar trades |
| `Started` | Day 1 of that run |
| `*` | The run was shorter than N days — `Rev @dN` is its entire run |

The footer ranks the focus launch overall and within its own kind, and flags a
NEW launch sitting at the top of its class as an extension candidate.

## How to answer Marc after running it

Give him the ladder, in this order, and stop:

1. **Day N of M.**
2. **$X so far → $Y/day.**
3. **Where that ranks** at the same day-N, NEW vs RELAUNCH.
4. **The call** — top of class → watch for extension / possible post-launch
   workhorse. Middle → leave it alone. Bottom → don't spend more sends on it.

Then, only if he's weighing a calendar change, add the `$/send` comparison
against what is currently scheduled in the slot. A send is the scarce resource,
not the calendar week.

## Rules that must not be broken

- **Revenue is measured by `funnel_id` / `builder_checkout_id`. Never by product
  name, never by `product_id`.** Bumps and upsells carry the same funnel with a
  different product. Filtering by product makes them vanish.
- **NEW vs RELAUNCH is read from the Launch Hub**, not inferred. `launches` = NEW,
  `old_launches` = RELAUNCH. Anything unmapped prints `?` — report it as unknown,
  never guess it into a bucket. To classify one permanently, add
  `"<funnel_id>": "NEW"` (or `"RELAUNCH"`) to `overrides.json` next to this file.
- **Never compare a launch's first days against another launch's full run.**
  That's the error this skill exists to prevent.
- **First days are not comparable across launches in isolation** — every launch
  spikes on day 1 (hyperactive buyers, launch bonuses). Day-N-vs-day-N is what
  makes them comparable; a single day-1 number still isn't a verdict.

## Gotchas the script already handles — don't "fix" them by hand

- **Runs, not funnels.** A funnel sells again on every relaunch, and often has a
  stray sale months before its real launch. Both corrupt "day 1". Revenue is
  split into runs separated by 7+ quiet days; each run is its own comparable
  instance.
- **Lookback truncation.** A run starting within 2 days of the lookback edge is
  dropped — otherwise the window boundary masquerades as a launch date.
  (This bug once reported Fast String Motors at $37/day-4 instead of $10,884.)
- **Partial day 1.** Evening launches get a short day 1; the header warns and the
  cumulative total is conservative. Say so when quoting the number.

## Why this is a script and not persona prose

Prose gets re-derived every session, and the derivation has gone wrong before —
Fluid Flutes was reported at $2,997 when the funnel had made $5,510, because the
query filtered by product name and missed a $1,568 upsell and a $396 bump. Code
fixes a bug once, for every future session and every machine.

## When NOT to use this

- Overall business health (revenue/spend/profit) → `ceo_dashboard_cache`, not this.
- Ad-set level ROAS, scaling or pausing → `sales_analysis_cache` and the Sales
  Analysis dashboard.
- Email-level attribution inside one launch → the attribution queries in
  `CLAUDEEMAILS.md`. This skill counts sends; it does not attribute them.
