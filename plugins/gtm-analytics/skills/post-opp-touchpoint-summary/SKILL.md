---
name: post-opp-touchpoint-summary
description: >
  Use this skill whenever the user wants to understand how engagement after
  opportunity creation differs between Closed-Won and Closed-Lost deals.
  Trigger when the user mentions phrases like "post-opp engagement", "in-deal
  touchpoints", "what closes deals after opp creation", "lost deal engagement
  pattern", or shares post-opp engagement data.
---

# Post-Opp Touchpoint Summary

Compares engagement patterns AFTER opportunity creation between Closed-Won and Closed-Lost deals. Surfaces what mid-funnel actions correlate with winning.

## Hard Constraints
- Required: Closed-Won + Closed-Lost deals (last 4 Q) with all touchpoints in opp lifetime
- Refuse: comparison without ≥ 50 deals per category

## Workflow
1. For each Won deal: count touchpoints by type (calls, emails, meetings, content shared, demos, exec touch)
2. For each Lost deal: same
3. Compute averages per category and per stage
4. Identify the 3-5 touchpoint types with biggest Won-vs-Lost gap
5. Recommend playbook moves to make Won-pattern touches more common

## Required Output Format
```
### Post-Opp Touchpoint Summary — [Window]

| Touchpoint type | Won avg | Lost avg | Won/Lost ratio |
|-----------------|---------|----------|----------------|
| Sales call | __ | __ | __× |
| ROI review session | __ | __ | __× |
| Multi-stakeholder demo | __ | __ | __× |
| Exec sponsor touch | __ | __ | __× |
| Custom proposal | __ | __ | __× |

**Top 3 winning behaviors (in won deals, rare in lost):**
1.
2.
3.

**Playbook recommendation:** Make these defaults in opp playbook.
```

## Common Mistakes
- Treating volume as causal ("more touches = win" — could be the opposite for lost deals dragging on)
- Ignoring stage of touch (post-Demo touches matter differently than Pre-Close)
- Not accounting for deal size (enterprise needs more touches always)
- Missing exec sponsor touch (often the biggest Won-vs-Lost differentiator)

## Tooling
- GTM analytics MCP, Salesforce, Gong, Outreach / Salesloft for activity log

## Source
Industry GTM analytics pattern — RevOps / Marketing
