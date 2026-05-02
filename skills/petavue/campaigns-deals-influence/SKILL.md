---
name: campaigns-deals-influence
description: >
  Use this skill whenever the user wants to compare single-touch and
  position-based attribution for Closed-Won deals, aggregate revenue per
  campaign, and flag major attribution disparities. Trigger when the user
  mentions phrases like "attribution model comparison", "first-touch vs
  multi-touch", "attribution disparity", "campaign influence", "position-
  based attribution", or shares attribution data. Use this skill before
  finalizing budget reallocation — different attribution models can swing
  campaign rankings dramatically.
---

# Campaigns — Deals Influence Analysis

This skill compares single-touch (first/last) and position-based (multi-touch) attribution for Closed-Won deals to surface disparities. If first-touch says Campaign A is the winner but multi-touch says Campaign B, you have an attribution-driven decision risk.

The skill enforces:
- **At least 2 attribution models** compared side-by-side
- **Disparity threshold of ≥ 30%** — flagged as "model-sensitive" campaigns
- **Win rate × deal size** — not just revenue
- **Recommendation hedge** — suggest holistic view, not single-model decisions

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

- Closed-Won deals (last 4 quarters)
- All marketing touchpoints per deal (campaign, date, channel, position in journey)
- At least 2 attribution model results per deal (or raw data to compute)

### Constraint 2 — Refuse Single-Model Analysis

If only 1 attribution model is available, refuse and ask: "compare to [other model] for disparity check." Single-model rankings are not robust.

### Constraint 3 — Minimum Touchpoints

Deals with only 1 touchpoint → exclude from multi-touch analysis (no journey to weight).

---

## Workflow

### Step 1: Compute revenue per campaign per attribution model

Two columns: First-Touch revenue vs Position-Based (W-shaped: first 30%, lead-create 30%, opportunity 30%, last 10%).

### Step 2: Compute disparity per campaign

`Disparity = abs(First-Touch revenue − Multi-Touch revenue) / max(First-Touch, Multi-Touch)`

### Step 3: Flag model-sensitive campaigns

Disparity ≥ 30% = model-sensitive. These campaigns will rank very differently depending on which model finance/leadership uses.

### Step 4: Generate recommendation per campaign

- **Stable winner (high revenue both models)** → scale confidently
- **Stable loser (low both)** → kill
- **First-touch winner only** → strong upper-funnel; pair with mid-funnel campaigns to capture
- **Last-touch / multi-touch winner only** → strong nurture; ensure upper-funnel feeds it

---

## Required Output Format

```
### ⚖️ Campaigns — Deals Influence (Attribution Comparison)

**Window:** [last 4 quarters]
**Models compared:** First-Touch vs Position-Based (W-shaped)

| Campaign | Channel | First-Touch $ | Multi-Touch $ | Disparity | Verdict |
|----------|---------|---------------|---------------|-----------|---------|
| | | $ | $ | __% | Stable winner / Model-sensitive / Stable loser |

### Model-Sensitive Campaigns (≥ 30% disparity)

[List with explanation of WHY they're model-sensitive — usually upper-funnel-only or nurture-only]

### Recommendation

- Trust both models for stable winners → scale: [list]
- Hedge model-sensitive campaigns → analyze full journey, not isolated ranking
- Kill stable losers: [list]
```

---

## Common Mistakes to Avoid

- Picking one attribution model and treating it as truth
- Ignoring deals with single touchpoints (they ARE first-touch winners by definition)
- Comparing models without normalizing to total Closed-Won
- Killing a "first-touch loser" that's actually a great mid-funnel asset
- Not surfacing disparity to leadership (decisions get made on stale model)

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| Petavue MCP | Primary execution |
| Bizible / Dreamdata | Multi-touch attribution computed |
| Salesforce | Closed-Won + opportunity data |
| Custom SQL | If no attribution tool, compute in warehouse |

---

## Source

Adapted from [Petavue's GTM Prompt Library — Campaigns — Deals Analysis (Influence)](https://www.petavue.com/resources/prompts).
Petavue category: Marketing / RevOps / Sales
