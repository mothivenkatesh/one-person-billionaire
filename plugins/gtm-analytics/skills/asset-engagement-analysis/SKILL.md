---
name: asset-engagement-analysis
description: >
  Use this skill whenever the user wants to measure and rank marketing asset
  engagement across web and email channels and correlate it with Lead-to-MQL
  conversion uplift. Trigger when the user mentions phrases like "asset
  engagement", "content performance", "which assets convert", "MQL by asset",
  "ebook / whitepaper performance", or shares marketing asset data. Always
  use this skill instead of free-form asset analysis — it enforces the
  engagement-to-conversion correlation that separates "popular" from
  "performant" content.
---

# Asset Engagement Analysis

This skill ranks marketing assets (ebooks, whitepapers, landing pages, videos, webinars) by engagement AND by their causal influence on Lead-to-MQL conversion. Most teams confuse popularity (downloads, views) with conversion impact — this skill separates them.

The skill enforces:
- **Engagement metrics across web AND email channels** (not just one)
- **Correlation with Lead-to-MQL** as the success signal — not raw downloads
- **Statistical significance check** — small samples get flagged, not ranked

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

Before analysis, confirm the user has:
- Asset inventory (name, type, channel, publish date)
- Engagement events per asset (views, downloads, time-on-page, opens, clicks)
- Lead-to-MQL conversion data per lead, ideally with first-touch asset attribution
- Time window for analysis (recommended: rolling 90 days)

### Constraint 2 — Refuse to Rank Below Sample Threshold

Any asset with < 30 leads attributed → flag as "insufficient sample"; do NOT rank. Tell the user to wait or merge with similar assets.

### Constraint 3 — Distinguish Popularity from Performance

Refuse to call an asset "top performing" based on raw views/downloads alone. Top performance = high engagement AND positive conversion uplift vs baseline.

---

## Workflow

### Step 1: Pull engagement events per asset
For each asset: views (web), downloads (web), opens (email), clicks (email), avg time-on-page (web).

### Step 2: Map leads to first-touch asset
For each lead: which asset did they first engage with? (If multi-touch attribution available, use that; otherwise first-touch is fine.)

### Step 3: Compute Lead-to-MQL conversion per asset
For each asset (with ≥ 30 leads): % of leads attributed to this asset that became MQLs in the analysis window.

### Step 4: Compare to baseline
Baseline = aggregate Lead-to-MQL rate across all leads. Asset uplift = (asset MQL rate − baseline) / baseline.

### Step 5: Rank by composite score
Score = (engagement rate × 0.3) + (MQL uplift × 0.7). Bias toward conversion impact, not vanity metrics.

---

## Required Output Format

```
### 📊 Asset Engagement Analysis — [Window: last 90 days]

| Rank | Asset | Type | Channel | Leads | MQL rate | Uplift vs baseline | Composite | Verdict |
|------|-------|------|---------|-------|----------|---------------------|-----------|---------|
| 1 | | | | | __% | __% | __ | Top performer |
| 2 | | | | | __% | __% | __ | Strong |
| ... | | | | | | | | |
| N | | | | | __% | __% | __ | Drop / refresh |

**Insufficient sample (< 30 leads):**
- [Asset] — collect more data before ranking

**Recommendations:**
1. Double down on: [Asset] — high uplift, scale distribution
2. Refresh / kill: [Asset] — strong views but negative MQL uplift (vanity signal)
3. Test next: [Asset type] — under-represented in top 3
```

---

## Common Mistakes to Avoid

- Ranking by downloads/views alone → vanity metric trap
- Including assets with < 30 leads → noise, not signal
- Ignoring email engagement when web engagement is high → missing half the channel
- Single-asset attribution when multi-touch is available
- Comparing across asset types without normalization (ebooks vs videos)
- Not refreshing analysis quarterly → stale recommendations

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| GTM analytics MCP | Primary execution; pulls cross-source data |
| Salesforce / HubSpot | Lead + MQL data |
| Marketo / HubSpot Marketing | Asset engagement (email + web) |
| Google Analytics | Web engagement supplement |
| Mutiny / 6sense | Account-level engagement signals |

---

## Source

Inspired by industry GTM analytics patterns.
Category: Marketing
