---
name: expansion-account-growth
description: >
  Use this skill whenever the user wants to optimize lead conversion by
  pinpointing funnel drop-offs and high-impact sources, segments, and reps to
  boost pipeline efficiency. Trigger when the user mentions phrases like
  "expansion analysis", "account growth", "upsell pipeline", "land and expand",
  "account-level growth", or shares account-level pipeline data. Use to find
  which existing accounts are highest-EV for expansion outreach.
---

# Expansion & Account Growth

Identifies existing customer accounts most likely to expand based on usage signals, ARR trajectory, and engagement.

## Hard Constraints
- Required: customer accounts with ARR history (last 4 quarters), usage data, expansion opportunities created
- Refuse: ranking without engagement signal (just "high ARR" isn't enough)

## Workflow
1. Compute net dollar retention per cohort (ARR change Q-over-Q)
2. Identify expansion-likely accounts (positive usage trend + recent engagement + < 80% feature adoption)
3. Identify expansion-blocked accounts (negative trend = save first, expand later)
4. Score each account: (Usage growth × Engagement × Available SKUs not yet purchased)
5. Rank top 20 expansion targets

## Required Output Format
```
### Expansion & Account Growth — [Quarter]

**Net Dollar Retention this Q:** __% (target ≥ 110%)

### Top 20 Expansion Targets

| Rank | Account | Current ARR | Usage trend | Engagement | Expansion score | Recommended SKU |
|------|---------|-------------|-------------|------------|------------------|------------------|

### Expansion-Blocked Accounts (save first)

| Account | ARR | Block signal | Action |
|---------|-----|--------------|--------|
```

## Common Mistakes
- Ranking by current ARR alone (high ARR ≠ ready to expand)
- Ignoring usage trend (declining accounts shouldn't get expansion pitches)
- Pitching expansion to unhappy accounts (save first; expand second)
- Not aligning Sales + CSM (split incentives create churn)

## Tooling
- GTM analytics MCP, Salesforce, Gainsight, ChurnZero, Pendo / Mixpanel for usage

## Source
Industry GTM analytics pattern — Sales
