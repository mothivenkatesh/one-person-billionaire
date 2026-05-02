---
name: churn-risk-radar
description: >
  Use this skill whenever the user wants to flag at-risk accounts by combining
  product usage drops and support ticket spikes, then automate proactive save
  tasks for CSMs. Trigger when the user mentions phrases like "churn risk",
  "at-risk accounts", "early churn signals", "save tasks", "CSM playbook",
  "usage drop alerts", or wants to identify accounts likely to churn before
  renewal. Always use this skill to prioritize CSM time on accounts that
  actually need intervention, not vanity health-score reds.
---

# Churn Risk Radar

This skill flags at-risk customer accounts by combining (1) product usage drops, (2) support ticket spikes, and (3) engagement decay — then auto-generates ranked save tasks for CSMs. Most "health scores" are noisy; this skill applies multi-signal correlation to surface the accounts that ACTUALLY need intervention.

The skill enforces:
- **Multi-signal correlation** — usage drop alone is too noisy; needs ≥ 2 signals
- **Severity ranking** — Tier-A (act this week), Tier-B (act this month), Tier-C (watch)
- **Save task generation** — concrete next action per account, not just an alert
- **CSM bandwidth check** — caps Tier-A list at CSM capacity

---

## Hard Constraints

### Required Inputs
- Account list with renewal dates
- Product usage per account (last 90 days, weekly buckets)
- Support tickets per account (last 90 days, with severity)
- Last CSM touchpoint per account
- CSM bandwidth (saves per CSM per week)

### Refuse if Single-Signal
If only one data source is available, the analysis is too noisy. Require ≥ 2 of (usage / tickets / engagement / last touch).

### Tier-A Cap
Tier-A risk accounts capped at CSM bandwidth. If signals identify 50 Tier-As but CSMs can only act on 10 → top-rank by ARR × probability of churn.

---

## Workflow

### Step 1: Compute usage trend per account

Last-30-day average vs prior-30-day average. Flag drops ≥ 30%.

### Step 2: Compute ticket trend per account

Tickets in last 30 days vs trailing 90-day average. Flag spikes ≥ 2× and severity ≥ medium.

### Step 3: Compute engagement decay

Last CSM touch > 60 days ago AND no in-product engagement in last 14 days.

### Step 4: Apply multi-signal scoring

| Signals triggered | Tier |
|-------------------|------|
| 3+ | A (act this week) |
| 2 | B (act this month) |
| 1 | C (watch) |

### Step 5: Generate save tasks per Tier-A account

Concrete next step per account based on dominant signal:
- **Usage drop** → "Schedule QBR; demo new feature; check user adoption"
- **Ticket spike** → "Personal outreach from CSM; engineering touch if recurring bug"
- **Engagement decay** → "Re-introduce; share roadmap; ask about org changes"

### Step 6: Rank Tier-A by ARR × signal severity

Cap at CSM bandwidth.

---

## Required Output Format

```
### 🚨 Churn Risk Radar — [Date]

**Total accounts analyzed:** ___
**Tier A (act this week):** __ accounts ($___ ARR at risk)
**Tier B (act this month):** __ accounts ($___ ARR at risk)
**Tier C (watch):** __ accounts ($___ ARR at risk)

### Tier A — Action Required This Week

| Rank | Account | ARR | Renewal | Signals | Save Task | Owner |
|------|---------|-----|---------|---------|-----------|-------|
| 1 | | $ | [date] | Usage -45%, Tickets 3×, No CSM 70d | | CSM name |

### Top Patterns

- Most common signal: [usage drop / tickets / engagement]
- Industry / segment skew: [if any]
- Recommendation: [pattern fix — e.g., "build self-serve QBR template"]
```

---

## Common Mistakes to Avoid

- Acting on single-signal alerts (too noisy; CSMs lose trust in the radar)
- Ranking by signal count alone (ignore ARR weight)
- Ignoring CSM bandwidth (overflow lists get ignored entirely)
- Treating Tier-C as "no action" — at minimum, monitor and re-rank weekly
- Not following up on save task outcomes (radar without learning loop = not improving)

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| Petavue MCP | Primary execution |
| Salesforce / HubSpot | Account + ARR data |
| Mixpanel / Amplitude / Pendo | Product usage |
| Zendesk / Intercom | Support tickets |
| Gainsight / ChurnZero | If available, validate against their health scores |

---

## Source

Adapted from [Petavue's GTM Prompt Library — Churn Risk Radar](https://www.petavue.com/resources/prompts).
Petavue category: CX
