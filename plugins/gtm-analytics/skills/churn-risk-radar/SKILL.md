---
name: churn-risk-radar
description: >
  Use this skill whenever the user wants to flag at-risk customer accounts by
  combining product usage drops, support ticket spikes, and engagement decay,
  then automate proactive save tasks for CSMs. Trigger when the user mentions
  phrases like "churn risk", "at-risk accounts", "early churn signals", "save
  tasks", "CSM playbook", "usage drop alerts", "renewal at risk", or shares
  account health data. Always use this skill instead of single-signal alerts —
  it enforces multi-signal correlation, ARR-weighted ranking, and CSM-bandwidth
  capping that prevents alert fatigue.
---

# Churn Risk Radar

This skill flags at-risk customer accounts by **combining** (1) product usage drops, (2) support ticket spikes, and (3) engagement decay — then auto-generates ranked save tasks for CSMs. Most "health scores" are noisy single-signal aggregates; this skill applies multi-signal correlation to surface the accounts that ACTUALLY need intervention.

The skill enforces:
- **Multi-signal correlation** (≥ 2 signals required to trigger)
- **Severity tiering**: A (act this week), B (act this month), C (watch)
- **ARR × severity ranking** (saves the biggest losses first)
- **CSM bandwidth cap** (Tier-A list cannot exceed CSM capacity)
- **Concrete save task per account** (not just an alert)
- **Save outcome tracking** (radar without learning loop = not improving)

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

Confirm the user has:
- **Account list** with renewal dates + ARR per account
- **Product usage** per account (last 90 days, weekly buckets) from analytics
- **Support tickets** per account (last 90 days, with severity)
- **Last CSM touchpoint** per account (timestamp + type)
- **CSM bandwidth** (saves per CSM per week — be honest)
- **Stage of customer** (new / mid / mature / renewal-window)

If any are missing, ask before proceeding.

### Constraint 2 — Refuse Single-Signal Alerts

If only one data source is available (e.g., usage drops only):

> "Single-signal alerts have a > 60% false-positive rate. CSMs lose trust in the radar, then ignore real signals. Pull at least 2 of: usage / tickets / engagement / last-touch. If you can't, fix instrumentation FIRST."

### Constraint 3 — Tier-A Cap

Tier-A risk accounts capped at CSM bandwidth. If signals identify 50 Tier-As but CSMs can only act on 10:
- Top-rank by ARR × probability of churn
- Demote remaining 40 to Tier-B
- Flag the cap to leadership (more CSMs needed OR raise threshold)

### Constraint 4 — Refuse to Ship Radar Without Outcome Tracking

If the user wants the radar without a follow-up loop (track which save tasks worked):

> "Without outcome tracking, this becomes another alert dashboard nobody acts on. We need a feedback loop: save action → outcome (saved / churned anyway / expanded). Add this column to your CRM today."

---

## Workflow Overview

```
Step 1: Pull and validate the 4 data sources
Step 2: Compute usage trend per account (30d vs prior 30d)
Step 3: Compute ticket trend per account (30d vs trailing 90d)
Step 4: Compute engagement decay (last touch + last in-product)
Step 5: Apply multi-signal scoring → tier (A / B / C)
Step 6: Rank Tier-A by ARR × severity, cap at CSM bandwidth
Step 7: Generate save tasks per Tier-A account
Step 8: Surface team-level patterns
Step 9: Set up outcome tracking
```

---

## Step 1 — Pull and Validate Data

Before computing anything:

| Data source | Validation check |
|-------------|------------------|
| Account list | All accounts have ARR > 0 + renewal date in next 12 months |
| Product usage | < 5% of accounts have null/zero usage (else instrumentation issue) |
| Support tickets | Severity field populated for ≥ 95% of tickets |
| Last CSM touchpoint | < 10% have null (else CSM logging discipline issue) |

If any validation fails, fix that data layer FIRST before running the radar. Garbage in = garbage radar.

---

## Step 2 — Compute Usage Trend

Per account:
```
last_30d_usage = sum of weekly active sessions in last 30 days
prior_30d_usage = sum of weekly active sessions in days 31-60 prior

usage_drop_% = (prior - last) / prior * 100

Signal: ≥ 30% drop = "usage drop"
```

Edge cases:
- New accounts (< 60 days old): exclude — not enough baseline
- Accounts with prior usage = 0: exclude — likely not yet onboarded
- Accounts with stable low usage (3 sessions/week → 2): flag separately as "low engagement" not "drop"

---

## Step 3 — Compute Ticket Trend

Per account:
```
last_30d_tickets = count in last 30 days, severity ≥ medium
trailing_90d_avg = (sum of ticket counts in days 31-120) / 3

ticket_spike = last_30d_tickets / trailing_90d_avg

Signal: ≥ 2× AND severity ≥ medium = "ticket spike"
```

Don't trigger on:
- Low-severity ticket spike (P3/P4 inquiries are normal)
- Trailing avg = 0 (some accounts just don't ticket; not a signal)
- Ticket spikes that resolved quickly (< 24h)

---

## Step 4 — Compute Engagement Decay

```
days_since_csm_touch = days since last CSM call/email/meeting
days_since_in_product_engagement = days since last user login

Signal: 
  days_since_csm_touch > 60 AND days_since_in_product > 14 = "engagement decay"
```

For low-touch accounts (self-serve tier), adjust thresholds:
- Self-serve: days_since_in_product > 30
- High-touch enterprise: days_since_csm_touch > 30

---

## Step 5 — Multi-Signal Scoring → Tier

| Signals triggered | Tier | Action timeline |
|-------------------|------|-----------------|
| 3+ | **A — Act this week** | Personal CSM outreach |
| 2 | **B — Act this month** | Standard playbook + check-in |
| 1 | **C — Watch** | Monitor; re-rank weekly |

Why ≥ 2 for action: single signal has > 60% false positive. Two signals correlated = real signal.

---

## Step 6 — Rank Tier-A by ARR × Severity

```
priority_score = ARR × signal_count × renewal_urgency_multiplier

renewal_urgency_multiplier:
  - Renewal in next 30 days: 3×
  - Renewal in next 90 days: 2×
  - Renewal beyond 90 days: 1×
```

Top N = CSM bandwidth (the hard cap from Constraint 3).

Demoted accounts go to Tier-B with note: "would be Tier-A if bandwidth allowed."

---

## Step 7 — Generate Save Tasks per Tier-A

Concrete next step per account based on dominant signal:

| Dominant signal | Save task template |
|-----------------|-------------------|
| Usage drop | "Schedule QBR within 7 days; demo new feature relevant to their use case; check user adoption across team" |
| Ticket spike | "Personal outreach from CSM today; engineering touch if recurring bug; create exec sponsor check-in" |
| Engagement decay | "Re-introduce; share roadmap; ask about org changes; offer success-plan review" |
| Multiple severe | "All-hands save play: CSM + sales rep + eng lead joint touch; consider account manager escalation" |

Each task includes:
- Owner (specific CSM)
- Deadline (this week)
- Expected outcome (saved / escalate / churn)

---

## Step 8 — Surface Team-Level Patterns

Look across all Tier-A and Tier-B accounts:

```
Most common signal: [usage drop / tickets / engagement]
Most common dominant signal by industry / segment / product
Top recurring ticket themes: [pain points across accounts]
CSM portfolio analysis: which CSMs have most red accounts?
```

Patterns drive product / process fixes, not individual saves.

---

## Step 9 — Outcome Tracking

For each Tier-A save action:
- Action taken (date + type)
- Outcome (saved / partial save / churned / expanded)
- Time to outcome
- Lessons learned

After 90 days of data: which save plays work? Which don't? Refine playbook.

---

## Required Output Format

```
### 🚨 Churn Risk Radar — [Date]

**Total accounts analyzed:** ___ (filtered: < 60 days old, etc. excluded)
**Tier A (act this week):** __ accounts ($___ ARR at risk)
**Tier B (act this month):** __ accounts ($___ ARR at risk)
**Tier C (watch):** __ accounts ($___ ARR at risk)
**Demoted-due-to-CSM-cap:** __ accounts (would be Tier-A)

### Tier A — Action Required This Week

| Rank | Account | ARR | Renewal | Signals | Save Task | Owner | Due |
|------|---------|-----|---------|---------|-----------|-------|-----|
| 1 | | $ | [date] | Usage -45%, Tickets 3×, No CSM 70d | [task] | CSM name | [date] |

### Tier B — Standard Playbook

[List with playbook tag — fewer details, more volume]

### Team-Level Patterns

- **Most common dominant signal:** [signal type] (___ accounts)
- **Top recurring ticket themes:** [themes]
- **Industry/segment skew:** [if any pattern]
- **CSM portfolio:** [name] has __ red accounts vs team avg __ — investigate

### Recommended Process Fixes

1. [Pattern fix — e.g., "build self-serve QBR template; usage-drop accounts"]
2. [Process fix — e.g., "fix recurring bug X causing ticket spikes"]

### Re-Run Cadence

Next run: [date — typically weekly]
Outcome review: [60 days from now]
```

---

## Worked Example

**User input:**
- 200 accounts, $5M ARR
- Usage data: Mixpanel, last 90 days
- Tickets: Zendesk
- CSM activity: Salesforce
- CSM bandwidth: 2 CSMs × 5 saves/week = 10 saves/week

**Step 5 results:**
- Tier A: 18 accounts ($1.2M ARR at risk)
- Tier B: 32 accounts ($800K ARR)
- Tier C: 47 accounts ($600K ARR)

**Step 6 — Capped Tier A at 10 (CSM bandwidth):**
- Top 10 ranked by ARR × signals × renewal proximity
- Demoted 8 to Tier B with "bandwidth-limited" tag

**Sample Tier-A row:**
| Rank | Account | ARR | Renewal | Signals | Save Task | Owner |
|------|---------|-----|---------|---------|-----------|-------|
| 1 | Acme Corp | $180K | 2026-06-15 (45d) | Usage -52%, 4 P2 tickets in 30d, No CSM 75d | "Joint CSM+AE outreach today; QBR by Friday; engineering review of recurring auth bug" | Sarah | EOW |

**Team patterns surfaced:**
- 7 of 18 Tier-A accounts have "auth bug" tickets → engineering P0 fix
- E-commerce segment over-represented (10 of 18) → CSM playbook revision needed
- CSM Mike has 4 red accounts (vs team avg 2.5) → coaching needed

---

## Common Mistakes to Avoid

- **Single-signal alerts** → 60%+ false positives → CSMs ignore the radar
- **Ranking by signal count alone** (ignore ARR weight)
- **Ignoring CSM bandwidth** (overflow lists get ignored entirely)
- **Treating Tier-C as "no action"** — at minimum, monitor + re-rank weekly
- **Acting on each account in isolation** (miss the patterns that drive process fixes)
- **No outcome tracking** (radar without learning = stays bad forever)
- **Adjusting thresholds based on one bad week** — let trends settle (4-week rolling)
- **Over-ranking new accounts** (< 60 days) — they don't have baselines
- **Treating P4 ticket as "spike"** — only severity ≥ medium counts
- **Running quarterly only** — weekly is the right cadence; renewal-week-of is daily

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| **GTM analytics MCP** | Primary execution layer — pulls cross-source data, computes radar |
| **Salesforce / HubSpot** | Account + ARR + renewal data; CSM activity log |
| **Mixpanel / Amplitude / Pendo** | Product usage data |
| **Zendesk / Intercom / Help Scout** | Support ticket data |
| **Gainsight / ChurnZero / Vitally** | If available, validate against their composite health scores |
| **Slack** | Surface Tier-A list to CSM channel daily (don't email — gets buried) |

For the outcome-tracking layer, add columns to your account record:
- `last_radar_action_date`
- `last_radar_action_type`
- `last_radar_action_outcome` (saved / churned / expanded / escalated)

Review monthly to refine the playbook.

---

## Quick Reference — The Multi-Signal Decision Tree

```
For each account:
├── < 60 days old? → SKIP (no baseline)
├── Compute usage drop: ≥ 30%? → SIGNAL 1
├── Compute ticket spike: ≥ 2× AND severity ≥ medium? → SIGNAL 2
├── Compute engagement decay: > 60d CSM gap AND > 14d in-product gap? → SIGNAL 3
├── Total signals:
│   ├── 0-1 → Tier C (watch)
│   ├── 2 → Tier B (act this month)
│   └── 3+ → Tier A (act this week)
└── Rank Tier A by ARR × signals × renewal urgency, cap at CSM bandwidth
```

---

## Quick Reference — Save Task Templates by Signal

| Signal | Template |
|--------|----------|
| Usage drop | "Schedule QBR within 7 days. Demo new feature relevant to use case. Check user adoption across team." |
| Ticket spike | "Personal CSM outreach today. Engineering touch if recurring bug. Create exec sponsor check-in." |
| Engagement decay | "Re-introduce. Share roadmap. Ask about org changes. Offer success-plan review." |
| Usage drop + Ticket spike | "Joint CSM+Engineering call this week. Root-cause review. Action plan with their exec sponsor." |
| All 3 | "All-hands save: CSM + AE + Eng joint touch. Consider account manager escalation. 30-day rescue plan." |

---

## Source

Inspired by industry GTM analytics patterns.
Category: CX

Pairs with:
- [`retention-cohort-analyzer`](../../retention-cohort-analyzer/SKILL.md) — solo-operator interview-driven version (calibrated for sub-$10M ARR)
- [`low-account-health`](../low-account-health/SKILL.md) — single-signal (health-score) faster but noisier alternative
- [`product-usage-correlation`](../product-usage-correlation/SKILL.md) — find magic numbers that predict retention
- [`segment-insights`](../segment-insights/SKILL.md) — segment-level retention/CAC/LTV
