---
name: inactive-at-risk-opportunities
description: >
  Use this skill whenever the user wants to identify open opportunities that
  show no engagement activity post-creation, signaling risk of stall or silent
  loss. Trigger when the user mentions phrases like "inactive opps", "silent
  loss", "no activity opps", "ghosted deals", or wants pipeline hygiene. Use
  weekly to surface deals before they're written off.
---

# Inactive / At-Risk Opportunities

Flags open opportunities with no engagement activity post-creation. These are "silent loss" candidates — deals that quietly die without being marked Closed-Lost.

## Hard Constraints
- Required: open opps + activity history (calls, emails, meetings) per opp
- Refuse: blanket close-out without rep input (some inactive deals are mid-evaluation by buyer)

## Workflow
1. For each open opp: time since last activity (any type)
2. Bucket: < 7 days (active), 7-21 days (slow), 21-60 days (cold), 60+ days (silent loss candidate)
3. Cross with stage age (an old-stage opp with no activity = highest risk)
4. Flag patterns (deals from particular source / rep / segment that go silent more often)
5. Recommend per opp: re-engage / ask rep for status / close out

## Required Output Format
```
### Inactive / At-Risk Opportunities — [Date]

**Activity buckets:**
| Bucket | Count | ARR at risk |
|--------|-------|-------------|
| Active (< 7d) | | $ |
| Slow (7-21d) | | $ |
| Cold (21-60d) | | $ |
| Silent loss (60+d) | | $ |

### Silent Loss Candidates (60+ days inactive)

| Opp | ARR | Owner | Stage | Days inactive | Days in stage | Action |
|-----|-----|-------|-------|---------------|---------------|--------|

### Patterns

- Most-going-silent rep: [rep] (with __ inactive opps)
- Most-going-silent stage: [stage]
- Most-going-silent source: [lead source]
- Recommended fix: [pattern intervention]
```

## Common Mistakes
- Auto-closing inactive opps (some are buyer-side delays, not loss)
- Ignoring stage age in the cross-cut
- Single weekly snapshot without trend (an opp going from "active" to "cold" is the signal)
- Not surfacing rep-level patterns (some reps systematically forget to log activity)

## Tooling
- GTM analytics MCP, Salesforce, HubSpot Sales, Clari, Gong, Outreach / Salesloft

## Source
Industry GTM analytics pattern — Marketing / Systems & Data / RevOps
