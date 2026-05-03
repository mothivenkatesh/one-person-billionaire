---
name: lead-conversion-analysis
description: >
  Use this skill whenever the user wants to diagnose and optimize lead
  conversion performance across sources, segments, and reps to boost pipeline
  efficiency and ROI. Trigger when the user mentions phrases like "lead
  conversion", "lead-to-MQL", "lead quality by source", "rep conversion
  rates", or shares lead conversion data.
---

# Lead Conversion Analysis

Diagnoses where leads convert (and don't) across sources, segments, and reps. Output: prioritized fix list per dimension.

## Hard Constraints
- Required: lead data with source / segment / assigned rep + conversion-stage events
- Refuse: per-source ranking with < 50 leads per source

## Workflow
1. Compute Lead → MQL → SQL → Opp → Win conversion per source
2. Cross with segment (industry / size)
3. Cross with rep (assignment-to-conversion)
4. Identify outliers (sources / segments / reps that systematically convert above or below average)
5. Recommend per outlier: scale / kill / coach

## Required Output Format
```
### Lead Conversion Analysis — [Window]

**Overall funnel:**
Lead → MQL: __% | MQL → SQL: __% | SQL → Opp: __% | Opp → Win: __%

**By source:**
| Source | Leads | MQL% | SQL% | Opp% | Win% | Verdict |
|--------|-------|------|------|------|------|---------|

**By segment:**
| Segment | Leads | Win% | Verdict |
|---------|-------|------|---------|

**By rep:**
| Rep | Assigned | Win% | Coaching priority |
|-----|----------|------|-------------------|

**Top fix:** [specific source / segment / rep + intervention]
```

## Common Mistakes
- Comparing across attribution models (use consistent model)
- Ranking sources without volume threshold
- Ignoring segment when comparing reps (some reps get easier segments)
- Surface-level "rep X is bad" without root-cause investigation

## Tooling
- GTM analytics MCP, Salesforce, HubSpot, Bizible

## Source
Industry GTM analytics pattern — Sales / Marketing
