---
name: campaign-leaderboard-analysis
description: >
  Use this skill whenever the user wants to compute campaign ROI and pipeline
  efficiency for all marketing channels over the last fiscal quarter and rank
  performance. Trigger when the user mentions phrases like "campaign leaderboard",
  "rank my campaigns", "channel performance", "campaign ROI ranking", "marketing
  effectiveness", or shares campaign data. Always use this skill instead of
  free-form ranking — it enforces ROI math, pipeline-attribution, and the
  channel-vs-channel comparability check.
---

# Campaign Leaderboard Analysis

This skill ranks marketing campaigns across ALL channels (paid, organic, email, events, partner) for the last fiscal quarter by ROI and pipeline efficiency. Used to answer: "where should we put more budget next quarter?"

The skill enforces:
- **ROI math: (Pipeline / Spend)** as the primary ranking criterion
- **Pipeline efficiency = Pipeline / Influenced contacts** as secondary
- **Time-window normalization** — quarterly comparisons only
- **Channel-class comparability** — flag mixed-attribution-model campaigns

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

- Campaign list (name, channel, start/end date, spend)
- Pipeline created per campaign (use first-touch or weighted attribution; user picks)
- Closed-Won revenue per campaign (for actual ROI, not just pipeline ROI)
- Quarter dates (e.g., FY25 Q4 = Oct 1 - Dec 31)

### Constraint 2 — Reject Mixed Attribution

If campaigns use different attribution models (some first-touch, some multi-touch, some last-touch), flag and require unified model before ranking. Mixed-model leaderboards are misleading.

### Constraint 3 — Minimum Spend Threshold

Campaigns with < $500 spend → exclude from ROI ranking (noise). Show separately as "experimental campaigns."

---

## Workflow

### Step 1: Aggregate spend per campaign
Sum all costs (media, agency fees, internal time if tracked).

### Step 2: Attribute pipeline + closed revenue per campaign
Use single attribution model. Default: first-touch for upper-funnel campaigns, multi-touch for nurture campaigns.

### Step 3: Compute ROI metrics
- **Pipeline ROI** = Pipeline created / Spend
- **Revenue ROI** = Closed-Won / Spend (more accurate but lags by sales cycle)
- **Pipeline efficiency** = Pipeline / Number of touched contacts

### Step 4: Rank and bucket
Top 25% = Scale. Bottom 25% = Kill or rework. Middle 50% = Maintain.

### Step 5: Channel-level summary
Roll up to channel (paid search, paid social, content, events, partner) for budget reallocation.

---

## Required Output Format

```
### 🏆 Campaign Leaderboard — [FY__ Q__]

**Total spend:** $___      **Total pipeline:** $___      **Total closed:** $___
**Avg Pipeline ROI:** __×  **Avg Revenue ROI:** __×

### Top 10 Campaigns

| Rank | Campaign | Channel | Spend | Pipeline | Closed | Pipeline ROI | Verdict |
|------|----------|---------|-------|----------|--------|--------------|---------|
| 1 | | | $ | $ | $ | __× | Scale |
| ... | | | | | | | |

### Channel Roll-Up

| Channel | Spend | Pipeline | Pipeline ROI | Recommended Q-next allocation |
|---------|-------|----------|--------------|-------------------------------|
| Paid search | | | | +/- $ |
| Paid social | | | | +/- $ |
| Content | | | | +/- $ |
| Events | | | | +/- $ |
| Partner | | | | +/- $ |

### Recommendations

1. Scale: [Campaign] — increase budget by __%
2. Kill: [Campaign] — reallocate to [Top performer]
3. Test: [New campaign idea aligned with top channel]
```

---

## Common Mistakes to Avoid

- Mixing attribution models across campaigns
- Using Pipeline ROI alone (skip Revenue ROI for sales-cycle-lagged truth)
- Not normalizing spend (some campaigns include agency fees, others don't)
- Comparing campaigns of different durations without normalization
- Ranking < $500-spend campaigns next to $50K-spend campaigns
- Killing a campaign on one quarter's bad numbers (give 2 quarters)

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| GTM analytics MCP | Primary execution |
| Salesforce / HubSpot | Pipeline + Closed-Won |
| Marketo / HubSpot Marketing | Campaign cost data |
| Google Analytics + UTM | Channel attribution |
| Bizible / Demandbase / Dreamdata | Multi-touch attribution if available |

---

## Source

Inspired by industry GTM analytics patterns.
Category: Marketing
