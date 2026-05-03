---
name: rep-performance-vs-activity
description: >
  Use this skill whenever the user wants to diagnose AE performance by
  correlating activity levels, pipeline coverage, and win rates to pinpoint
  coaching needs and boost revenue. Trigger when the user mentions phrases
  like "rep performance vs activity", "AE coaching diagnostic", "activity to
  outcome correlation", "coverage vs win rate", or shares rep activity +
  performance data.
---

# Rep Performance vs. Activity

Correlates AE activity (calls, emails, meetings) with outcomes (pipeline created, win rate, revenue) to identify the activity patterns that actually move the needle per rep.

## Hard Constraints
- Required: rep activity log + outcomes (last 2 quarters), pipeline coverage data
- Refuse: per-rep recommendation with < 8 weeks of data per rep

## Workflow
1. Per rep: weekly activity volume by type, weekly pipeline created, weekly closed-won
2. Compute correlation: activity → pipeline → revenue
3. Identify high-leverage activities per rep (calls per pipeline $, meetings per won deal)
4. Identify "busy but not productive" reps (high activity, low outcomes)
5. Identify "lazy but lucky" reps (low activity, high outcomes — usually = quality lead source)
6. Recommend coaching focus per rep

## Required Output Format
```
### Rep Performance vs Activity — [Quarter]

| Rep | Calls/wk | Emails/wk | Meetings/wk | Pipeline created | Won | Activity-to-pipeline ratio | Coaching priority |
|-----|----------|-----------|-------------|------------------|-----|----------------------------|-------------------|

### Patterns
- Most efficient (high outcomes per activity): [rep] — replicate behaviors
- Least efficient (high activity, low outcomes): [rep] — coach on quality not quantity
- "Lazy but lucky" (low activity, high outcomes): [rep] — investigate lead source skew

### Team-level recommendation
- Team-wide activity benchmark to target: [N calls / week]
- Team-wide pipeline coverage target: [3-4× quota]
```

## Common Mistakes
- Treating activity volume as the metric (it's a means, not an end)
- Comparing reps with different lead sources / segments
- Penalizing "lazy but lucky" without investigating cause (might be replicable)
- Coaching the wrong rep (busy ones look productive but are wasting time)

## Tooling
- GTM analytics MCP, Salesforce, Gong, Outreach / Salesloft, Clari

## Source
Industry GTM analytics pattern — Sales
