---
name: deal-velocity-bottleneck
description: >
  Use this skill whenever the user wants to diagnose AE performance by linking
  activity levels, pipeline coverage, and win rates to uncover coaching
  opportunities. Trigger when the user mentions phrases like "deal velocity",
  "AE coaching", "rep performance diagnostics", "pipeline bottleneck",
  "stage conversion", or shares rep-level data. Use before quarterly rep
  reviews.
---

# Deal Velocity & Bottleneck

Diagnoses where AEs slow deals down. Output: per-stage velocity per rep + coaching priorities.

## Hard Constraints
- Required: rep-level activity logs, pipeline by stage, win rates by stage, last 2 quarters
- Refuse: per-rep recommendations with < 10 deals per rep (small sample)

## Workflow
1. Compute avg days per stage, per rep
2. Compute stage-conversion rate per rep
3. Cross with activity volume (calls, emails, meetings per deal)
4. Identify bottlenecks: stages where rep is 2× slower or 50% lower conversion than peers
5. Recommend coaching focus per rep

## Required Output Format
```
### Deal Velocity Diagnostic — [Quarter]

| Rep | Avg deal cycle | Discovery → Demo | Demo → Negotiate | Negotiate → Close | Bottleneck stage | Coaching priority |
|-----|---------------|------------------|------------------|-------------------|------------------|-------------------|

**Team-level patterns:**
- Slowest stage on team: [stage]
- Highest variance stage: [stage]
- Recommended team-wide intervention: [training / playbook / tooling]
```

## Common Mistakes
- Comparing reps with different deal sizes (enterprise rep vs SMB rep)
- Ignoring lead source (a rep getting all inbound vs all outbound)
- Single-quarter analysis (need 2+ for stable signal)
- Coaching the wrong stage (fix the EARLIEST bottleneck first)

## Tooling
- GTM analytics MCP, Salesforce, Gong, Clari, Outreach / Salesloft for activity

## Source
Industry GTM analytics pattern — Sales
