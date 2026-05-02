---
name: first-vs-last-touch-attribution
description: >
  Use this skill whenever the user wants to compare revenue credit under
  First-Touch and Last-Touch attribution models for channels and top campaigns.
  Trigger when the user mentions phrases like "first-touch vs last-touch",
  "attribution model comparison", "revenue credit by model", or shares
  attribution data. Use this skill to surface attribution disparities before
  budget reallocation decisions.
---

# First vs Last Touch Attribution

Compares revenue credit under First-Touch and Last-Touch attribution for the same set of Closed-Won deals. Surfaces which channels are upper-funnel heroes (first-touch winners) vs closer heroes (last-touch winners).

## Hard Constraints
- Required: all touchpoints per Closed-Won deal in last 4 quarters
- Refuse: comparison without ≥ 50 deals per channel (small sample noise)

## Workflow
1. For each Closed-Won deal: identify first touchpoint AND last touchpoint
2. Aggregate revenue by channel under both models
3. Compute % difference per channel
4. Classify channels: upper-funnel (first-touch heavy), closer (last-touch heavy), balanced
5. Recommend per channel based on role

## Required Output Format
```
### First-Touch vs Last-Touch — [Window]

| Channel | First-Touch revenue | Last-Touch revenue | Difference | Role |
|---------|---------------------|--------------------|------------|------|
| Paid search | | | __% | Upper-funnel / Closer / Balanced |
| Content | | | | |
| Email nurture | | | | |
| Sales outbound | | | | |

**Insight:** Best upper-funnel: [channel] | Best closer: [channel]
**Recommendation:** Don't kill upper-funnel channels because last-touch ranks them low. Don't over-credit closers.
```

## Common Mistakes
- Killing upper-funnel channels because last-touch shows zero credit
- Over-investing in closer channels (last-touch heavy ≠ source of revenue)
- Comparing only two models — use multi-touch (W-shaped) as third reference
- Not explaining model differences to leadership before budget decisions

## Tooling
- Petavue MCP, Bizible / Dreamdata / Demandbase for multi-model

## Source
[Petavue — First vs Last Touch Attribution](https://www.petavue.com/resources/prompts) — Marketing
