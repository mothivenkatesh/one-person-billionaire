---
name: content-influence-mapping
description: >
  Use this skill whenever the user wants to correlate content asset interactions
  with high-value Closed-Won deals to rank assets by influence and revenue
  impact. Trigger when the user mentions phrases like "content influence",
  "which content drives revenue", "high-value content", "content ROI", or
  shares content + deal data. Use this skill to separate content that
  GENERATES leads from content that INFLUENCES revenue.
---

# Content Influence Mapping

This skill ranks content assets by their influence on Closed-Won deals, especially HIGH-VALUE deals (above-median ACV). Different from raw lead-gen — this measures which content actually moves the revenue needle.

The skill enforces:
- **Closed-Won correlation** — not lead capture
- **High-value deal weighting** — above-median ACV gets 2× weight
- **Multi-touch attribution** — content rarely converts in one touch
- **Refresh / kill recommendations** — quarterly cadence

---

## Hard Constraints

### Required Inputs
- Content asset library (with publish dates + categories)
- Content interaction events per contact
- Closed-Won deal data with attribution to contacts
- Median ACV (for above/below split)

### Refuse if no Closed-Won linkage
Without contact-to-deal mapping, refuse. Lead-gen-only attribution misses revenue influence.

---

## Workflow

### Step 1: Map content interactions to Closed-Won deals
For each Closed-Won deal: which content assets did the buying group interact with in the 90 days before close?

### Step 2: Compute influence score per asset
`Influence = Deals influenced × ACV` (high-value deals weighted 2×).

### Step 3: Compare to overall asset population
Top 10% by influence = "revenue movers." Bottom 50% = "lead-gen only" or "vanity content."

### Step 4: Cross-cut by stage
Which content assets show up in early-stage deals vs late-stage? Different playbooks.

### Step 5: Recommend per asset
- **Top influence + recent** → scale distribution
- **Top influence + old** → refresh and re-promote
- **High lead-gen, low influence** → keep for top of funnel; don't expect revenue
- **Low both** → kill or refresh

---

## Required Output Format

```
### 📈 Content Influence Mapping

**Window:** [last 12 months]
**Median ACV:** $___
**High-value deal weight:** 2×

### Top 10 Revenue-Influencing Assets

| Rank | Asset | Type | Deals influenced | High-value deals | Influence score | Recency |
|------|-------|------|------------------|------------------|-----------------|---------|
| 1 | | | | | | [recent / aging / stale] |

### Stage-Cut Highlights

- Top early-stage influencer: [asset]
- Top late-stage influencer: [asset]
- Late-stage gap: [asset type missing]

### Recommendations

- Scale: [top assets — distribute more]
- Refresh: [old top influencers]
- Kill: [low both]
- Build: [missing stage / topic gaps]
```

---

## Common Mistakes to Avoid

- Ranking by lead capture only (high lead, low revenue = vanity)
- Not weighting high-value deals (one $100K deal > 10 $5K deals)
- Single-touch attribution (content rarely converts alone)
- Killing aging top performers (refresh first)
- Ignoring stage cut (same asset can be great early, useless late)

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| Petavue MCP | Primary execution |
| Salesforce | Closed-Won + contact-to-deal mapping |
| Marketo / HubSpot Marketing | Content interaction events |
| Bizible / Dreamdata | Multi-touch attribution |

---

## Source

Adapted from [Petavue's GTM Prompt Library — Content Influence Mapping](https://www.petavue.com/resources/prompts).
Petavue category: Marketing
