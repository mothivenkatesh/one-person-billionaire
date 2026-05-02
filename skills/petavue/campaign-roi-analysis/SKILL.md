---
name: campaign-roi-analysis
description: >
  Use this skill whenever the user wants to calculate true campaign ROI by
  merging ad spend with Closed-Won revenue and ranking performance by pipeline
  impact. Trigger when the user mentions phrases like "campaign ROI", "true ROI",
  "Closed-Won attribution", "marketing ROI", "ad spend efficiency", or shares
  spend + revenue data. Always use this skill instead of pipeline-only ROI —
  it enforces the Closed-Won truth check that pipeline ROI hides.
---

# Campaign ROI Analysis

This skill computes TRUE campaign ROI by merging ad spend with **Closed-Won revenue** (not pipeline) and ranking campaigns by actual impact. Pipeline ROI lies; Closed-Won ROI doesn't (it just lags).

The skill enforces:
- **Closed-Won as the truth** — pipeline ROI is a leading indicator, not the answer
- **Lag-aware analysis** — accounts for sales cycle length
- **Single-source-of-truth attribution** — refuses cross-model comparison
- **Per-channel + per-campaign breakdowns**

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

- Total ad spend per campaign
- Closed-Won revenue per campaign (with attribution method)
- Average sales cycle length (for lag adjustment)
- Time window (must be sales-cycle-adjusted; e.g., for 90-day cycle, look at campaigns from 90+ days ago)

### Constraint 2 — Reject Premature ROI

If campaign ran < 1 sales-cycle-length ago, refuse to compute final ROI. Show pipeline ROI only and flag: "ROI premature — recheck in [date]."

### Constraint 3 — Account for Cost-Plus Attribution

Some channels have implicit costs (sales rep follow-up, customer success time). Default to ad-spend-only ROI; flag the user that fully-loaded ROI requires cost allocation work.

---

## Workflow

### Step 1: Pull spend per campaign
Direct ad spend + agency fees if tracked.

### Step 2: Pull Closed-Won revenue per campaign
Use the user's chosen attribution model (first-touch / last-touch / multi-touch). Single model only.

### Step 3: Lag-adjust the window
For an N-day sales cycle, only include campaigns that ran ≥ N days ago for full ROI. For newer campaigns, show pipeline ROI as proxy.

### Step 4: Compute ROI per campaign
- **Closed-Won ROI** = Closed Revenue / Spend
- **Pipeline ROI** = Pipeline Created / Spend
- **Win rate from campaign** = Closed-Won / Pipeline (campaign-level lead quality)

### Step 5: Bucket + recommend
| ROI bucket | Action |
|------------|--------|
| > 5× | Scale 2× |
| 3-5× | Maintain or test scale |
| 1-3× | Optimize creative / targeting |
| < 1× | Kill |

---

## Required Output Format

```
### 💰 True Campaign ROI Analysis

**Window:** [date range, sales-cycle-adjusted]
**Sales cycle assumption:** [N] days
**Attribution model:** [first-touch / last-touch / multi-touch]

### Mature Campaigns (full ROI available)

| Campaign | Channel | Spend | Closed-Won | ROI | Win rate | Verdict |
|----------|---------|-------|------------|-----|----------|---------|
| | | $ | $ | __× | __% | Scale 2× / Maintain / Optimize / Kill |

### Premature Campaigns (pipeline ROI only)

| Campaign | Channel | Spend | Pipeline | Pipeline ROI | Recheck date |
|----------|---------|-------|----------|--------------|--------------|
| | | $ | $ | __× | [date + sales cycle length] |

### Recommendations

- Scale: [campaigns] — total reallocation: $___
- Kill: [campaigns] — total reallocation: $___
- Recheck: [campaigns] on [dates]
```

---

## Common Mistakes to Avoid

- Treating pipeline ROI as final ROI (it's a leading indicator only)
- Not adjusting for sales cycle length (premature ROI = misleading)
- Mixing attribution models in one analysis
- Killing a campaign on 1 quarter of bad numbers (give 2 cycles)
- Ignoring win rate per campaign (high pipeline + low close = bad lead quality)
- Not accounting for cost-plus (sales time, CS time) in ROI math

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| Petavue MCP | Primary execution |
| Salesforce / HubSpot | Closed-Won data |
| Google Ads / Meta / LinkedIn Ads | Spend data |
| Multi-touch attribution: Bizible / Dreamdata / Demandbase | If available |

---

## Source

Adapted from [Petavue's GTM Prompt Library — Campaign ROI Analysis](https://www.petavue.com/resources/prompts).
Petavue category: Marketing
