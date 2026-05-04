---
name: weekly-report
description: Generates the canonical Monday-9am GTM weekly digest. 6 sections (overview/channel performance/lifecycle benchmarks/observations/key actions/DIN leaderboard) sourced from mart_buyer_journey + DIN registry + agent decisions. mothi-specific Razorpay-floor comparison + 5-7 evidence-backed observations + 3-5 measurable assignable actions.
version: 0.1.0
owner: revops@mothi.com
status: draft
depends_on: [scqa-pyramid, animalz-bluf-mece, executive-briefing, content-strategist]
tested_with: claude-opus-4-7
loads_for_agents: [weekly-report]
---

# weekly-report — GTM weekly digest generator

## When to use this skill

Load when the Weekly-Report agent (Monday 9am IST cron) needs to:
- Synthesize the past 7 days of GTM activity into a 6-section digest
- Generate evidence-backed observations (not opinions)
- Propose measurable assignable actions for the upcoming week
- Compare lifecycle metrics against the public Razorpay benchmark floor
- Produce both the Slack Block Kit summary AND the full Sheets-ready payload

Invoked by:
- `weekly-report` agent (Monday 9am IST cron — see dashboards/sheets/gtm.weekly-dashboard.gs)

This is the **highest-stakes communication artifact** — it's the only piece many leaders read end-to-end every week. Quality of observations + sharpness of actions determines whether the system gets credibility or gets ignored.

## Inputs expected

```json
{
  "week_ending": "YYYY-MM-DD (Sunday)",
  "north_star_metrics": {
    "calendar_fill_pct_avg_per_ae": 0.0,
    "calendar_fill_pct_4wk_avg": 0.0,
    "demos_booked": 0,
    "demos_booked_4wk_avg": 0,
    "pipeline_created_inr": 0,
    "pipeline_created_4wk_avg_inr": 0,
    "mql_to_sql_pct": 0.0,
    "sql_to_won_pct": 0.0,
    "median_cycle_days": 0
  },
  "channel_performance": [
    {
      "channel": "cold_email | linkedin_inmail | linkedin_ads | meta_ads | google_ads | webinar | content_inbound | partner | wtfraud_community | ae_outbound_manual | csm_outreach | moengage_lifecycle",
      "touches": 0, "mqls": 0, "sqls": 0, "demos": 0, "won": 0,
      "pipeline_inr": 0, "win_rate_pct": 0.0, "avg_cycle_days": 0
    }
  ],
  "lifecycle_metrics": [
    {"motion": "onboarding_completion | re_engagement | retention | adoption", "this_week_pct": 0.0, "four_week_avg_pct": 0.0, "razorpay_floor_pct": 0.0}
  ],
  "din_leaderboard": [
    {"din": "AGS-GTM-...", "name": "string", "channels": ["array"], "spend_inr": 0, "touches": 0, "mqls": 0, "sqls": 0, "demos": 0, "won": 0, "pipeline_inr": 0, "win_rate_pct": 0.0, "cost_per_demo_inr": 0, "cost_per_pipeline_rupee": 0.0}
  ],
  "agent_health": {
    "icp_scout_runs_completed": 0, "outreach_writer_runs_completed": 0, "reply_classifier_replies_handled": 0,
    "drive_transcripts_processed": 0, "extracted_properties_written": 0,
    "din_anomalies_p0_open": 0, "din_anomalies_p1_open": 0,
    "total_llm_cost_usd": 0.0, "avg_latency_ms": 0
  },
  "deliverability_health": [
    {"domain": "string", "reply_rate_pct": 0.0, "bounce_rate_pct": 0.0, "spam_complaint_rate_pct": 0.0, "status": "healthy | warning | quarantine"}
  ],
  "previous_week_actions_status": [
    {"action": "string", "owner": "string", "status": "done | in_progress | blocked | dropped", "outcome": "string | null"}
  ]
}
```

## Outputs expected

```json
{
  "report_markdown": "string (the full digest in markdown, ready for Drive archive)",
  "slack_blocks": "Block Kit JSON for #gtm-weekly post (per dashboards/sheets/gtm.weekly-dashboard.gs format)",
  "sheets_payload": "structured object that gtm.weekly-dashboard.gs renders",
  "alert_severity": "green | yellow | red",
  "alert_reason": "string | null (when not green)"
}
```

## Body — the 6-section structure (in this exact order)

### Section A — North-star + KPI snapshot

Format as a compact table. For every metric, show: this week / 4-wk avg / delta. Use ↑↓→ arrows.

**Quality bar:** if any metric is RED (>15% below 4-wk avg AND below target), it gets called out in Section D observations explicitly.

### Section B — Channel performance table

Sort by `pipeline_inr` descending. Highlight (in observations later) the top mover and the biggest drop.

### Section C — Lifecycle benchmarks vs Razorpay public floor

For each motion, show: this week / 4-wk avg / Razorpay public number / gap. Razorpay floors:
- Onboarding completion uplift: 29%
- Re-engagement: 19%
- Retention uplift: 25%
- Adoption campaigns: 16%

If mothi is below Razorpay floor on any motion → call out in Section D as RED.

### Section D — Observations (5-7 bullets, evidence-backed)

These are the soul of the digest. Rules:

1. **Every observation cites a specific number** (not "performance is up" but "BFSI vertical reply rate jumped from 2.1% to 4.3% w/o/w")
2. **Every observation links to either action or risk** (not pure curiosity)
3. **Mix surface-level + signal-level** — don't just describe what happened; surface the WHY when known
4. **Order by importance**, not chronology. The most actionable goes first.

**Observation patterns to use (one per type per week):**

| Pattern | Example phrasing |
|---|---|
| Velocity shift | "BFSI Tier A demos booked dropped from 8 last week to 2 — investigate template fatigue OR competitive event" |
| Channel emergence | "WTFraud community sourced 4 SQLs this week (vs 1 4-wk avg) — Mothi's Mar 21 newsletter is generating returns" |
| Compliance warning | "Domain `mothiteam.io` spam-complaint rate hit 0.08% — quarantine if it crosses 0.1% next week" |
| Vertical concentration | "63% of pipeline this week is BFSI; D2C share dropped from 30% to 18% — diversification risk" |
| Cycle change | "Median D2C cycle dropped from 78 to 52 days — mothi-managed POC offering is working, scale to BFSI?" |
| Agent health | "DIN-Watchdog flagged 5 P1 anomalies this week (2 sustained over 24h) — RevOps to audit Friday" |
| Cross-sell signal | "Cross-Sell-Detector flagged 47 Payments-only D2C merchants this week (vs 22 last week) — usage signal strengthening" |

### Section E — Key actions for the week (3-5)

Rules:

1. **Every action has a named owner** (a real person email, not "team")
2. **Every action has a measurable outcome** (not "improve X" but "ship Y by Friday")
3. **Order by impact × urgency**, not by who's most likely to do it
4. **Carry-over policy:** any action from previous week with status `blocked` or `in_progress` becomes a top-3 action this week with the blocker explicit

**Action format:**
```
{verb} {what} by {date} — owner: {email} — measurable: {how we know it's done}
```

Example:
```
Refresh BFSI cold-email template (rotate hook from 'fraud cost' to 'NTC coverage') by EOD Wed — owner: pmm@mothi.com — measurable: new template DIN-approved + first 100 sends data in Friday's deliverability sheet
```

### Section F — DIN performance leaderboard (top 5 DINs by pipeline contribution)

Sort by `pipeline_inr`. Show: DIN · Name · Channels · Spend · Touches · Demos · Won · Pipeline · Win rate · Cost-per-demo · Cost-per-₹-pipeline

Call out:
- **Top performer** of the week
- **Worst cost efficiency** (highest cost-per-demo) — candidate for DIN pause
- **DINs to repeat** — top performers worth duplicating into next quarter

### Section G — Risks flagged

Always populate (if no risks: "No P0/P1 risks this week"). Include:
- Compliance: any DPDP/TRAI/PCI/RBI exposure flags
- Deliverability: any domain near quarantine threshold
- Brand safety: any agent-generated send that triggered HITL escalation
- Cost overruns: agent LLM cost vs budget
- Capacity: any AE/CSM at >80% calendar fill (good problem, but flag for hiring)

### Alert severity

| Severity | Trigger |
|---|---|
| **green** | All metrics within 10% of 4-wk avg, no P0 anomalies, all 4 lifecycle motions ≥ Razorpay floor |
| **yellow** | Any metric 10-25% below 4-wk avg, OR any 1 lifecycle motion below floor, OR P1 anomalies sustained, OR deliverability warning |
| **red** | Any metric >25% below avg, OR multiple lifecycle motions below floor, OR P0 anomaly open >24h, OR domain quarantine triggered, OR carry-over actions blocked 2+ weeks |

## mothi-specific framing

- Use ₹ formatting throughout (Indian numbering: ₹1,23,45,678 — not Western $1,234,567.89)
- Razorpay benchmarks are public — cite them by name. Do NOT cite Razorpay-internal data we don't have access to.
- "Top of mind for leadership" — Anubhav (sales), Reeju (PMM), Ritesh (CRO) — actions assigned to them are auto-elevated
- WTFraud community is a unique channel — always highlight if it sourced any pipeline (it's mothi's competitive moat in BFSI)
- Vertical mix matters more than total numbers — leadership reads "are we still winning BFSI?" before they read total pipeline

## Examples

### Good — observation phrasing

✅ "BFSI vertical reply rate dropped from 4.2% to 2.1% — investigate template fatigue (template hasn't rotated in 6 weeks) AND check if the 2 RBI circulars last week shifted prospect attention"

❌ "BFSI performance was lower than expected"

### Good — action phrasing

✅ "Refresh BFSI cold-email template by EOD Wed (rotate hook from 'fraud cost' to 'NTC coverage') — owner: mothi@mothi.com — measurable: new template DIN-approved + first 100 sends data in Friday's deliverability sheet"

❌ "Need to improve BFSI campaigns"

## Anti-patterns to avoid

- ❌ Observations without numbers
- ❌ Actions without owners or due dates
- ❌ Repeating last week's report verbatim (use carry-over only when blocker is explicit)
- ❌ Generic "we should do better" framing
- ❌ Burying RED metrics in optimistic prose — call them out FIRST
- ❌ Using Razorpay-internal numbers (we only have their public MoEngage case-study benchmarks)
- ❌ Claiming agent attribution that isn't traceable to a DIN (every credited deal must trace to a `mart_buyer_journey` row)

## Composition rules

Always loaded with:
- `scqa-pyramid` (executive-readable structure)
- `animalz-bluf-mece` (BLUF in Section A)
- `executive-briefing` (concise C-level voice)
- `content-strategist` (voice consistency)

## Performance targets

- Latency: <30s (Opus tier — once-weekly so cost-per-run is acceptable)
- Cost: <$0.50 per weekly digest
- Leadership read-through rate: 90%+ (PostHog tracking on Slack post + Sheet open)
- Action completion rate week-over-week: 75%+ (carry-over rate <25%)
