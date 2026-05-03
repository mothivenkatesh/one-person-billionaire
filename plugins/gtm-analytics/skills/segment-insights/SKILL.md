---
name: segment-insights
description: >
  Use this skill whenever the user wants to diagnose segment-level performance
  and risk to drive targeted growth and retention actions. Trigger when the
  user mentions phrases like "segment insights", "segment-level analysis",
  "ICP segment performance", "vertical performance comparison", or shares
  customer-segment data.
---

# Segment Insights

Diagnoses performance and risk at the segment level (industry, size, geo, persona) to drive targeted GTM action.

## Hard Constraints
- Required: customer accounts with segment tags, performance metrics per segment (CAC, LTV, NRR, churn)
- Refuse: per-segment recommendation with < 30 accounts per segment

## Workflow
1. Inventory segments + account counts
2. Compute key metrics per segment: CAC, LTV, NRR, churn rate, expansion rate
3. Identify outperforming segments (high LTV / low CAC) → invest more
4. Identify underperforming (low LTV / high CAC / high churn) → exit or fix
5. Cross with sales rep mix per segment (rep-segment fit matters)
6. Recommend segment-level GTM actions

## Required Output Format
```
### Segment Insights — [Date]

| Segment | Accounts | ARR | CAC | LTV | LTV/CAC | NRR | Churn | Verdict |
|---------|----------|-----|-----|-----|---------|-----|-------|---------|
| Industry A | | $ | $ | $ | __× | __% | __% | Invest more |
| Industry B | | $ | $ | $ | __× | __% | __% | Maintain |
| Industry C | | $ | $ | $ | __× | __% | __% | Exit / fix |

### Recommendations per segment
- [Industry A] → invest: scale outbound + content for this segment
- [Industry B] → maintain: protect retention; selective expansion
- [Industry C] → fix: diagnose churn root cause OR exit segment

### Rep-segment fit
- [Best rep × segment combos]
- [Worst rep × segment combos — reassign]
```

## Common Mistakes
- Segment definitions changing between analyses (use stable taxonomy)
- LTV computed without churn assumption (always pair)
- LTV/CAC < 3 = unsustainable; flag immediately
- Ignoring rep-segment fit (a segment looks bad because the wrong rep covers it)

## Tooling
- GTM analytics MCP, Salesforce, ChartMogul / ProfitWell for unit economics, custom SQL

## Source
Industry GTM analytics pattern — CX
