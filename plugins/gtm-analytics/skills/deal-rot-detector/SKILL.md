---
name: deal-rot-detector
description: >
  Use this skill whenever the user wants to detect deals lingering too long in
  a single pipeline stage, signaling risk of decay or lost momentum. Trigger
  when the user mentions phrases like "deal rot", "stalled deals", "deals
  stuck in stage", "stage decay", or wants pipeline hygiene. Use weekly to
  surface decaying deals before they're written off.
---

# Deal Rot Detector

Detects opportunities lingering in a single stage beyond healthy thresholds. Output: ranked list of "rotting" deals with recommended next action.

## Hard Constraints
- Required: open opps with stage history, average stage duration per stage (last 90 days)
- Refuse if no stage history captured (need transition timestamps)

## Workflow
1. Compute average duration per stage from won deals (last 90 days)
2. For each open opp: time in current stage vs average × multiplier (default 1.5×)
3. Tier: Watch (1.5×), Concern (2×), Critical (3×+)
4. For each rotting deal, check engagement (last activity date, last touch) → enrich diagnosis
5. Recommend per deal: re-engage / disqualify / push out close date / schedule sync

## Required Output Format
```
### Deal Rot Detector — [Date]

**Rotting deals:**
| Tier | Count | Total ARR at risk |
|------|-------|-------------------|
| Critical (3×+) | ___ | $ |
| Concern (2×) | ___ | $ |
| Watch (1.5×) | ___ | $ |

### Critical Tier — Action Required

| Deal | Stage | Days in stage | Avg | Multiplier | Last activity | Recommended action |
|------|-------|---------------|-----|------------|---------------|--------------------|

### Patterns

- Most-rotting stage: [stage name] (avg multiplier __×)
- Most-rotting rep: [rep name] (with __ rotting deals)
- Recommendation: [stage-specific or rep-specific intervention]
```

## Common Mistakes
- Using one global "stuck" threshold across stages (Discovery ≠ Closed-Won prep)
- Ignoring deal size when ranking (a $500K rotter > a $5K rotter)
- Treating "watch" tier as "no action" (re-rank weekly to catch escalations)
- Not surfacing patterns (which stage is the bottleneck for everyone)

## Tooling
- GTM analytics MCP, Salesforce (with stage history), HubSpot Sales, Clari, Gong

## Source
Industry GTM analytics pattern — Systems & Data / RevOps
