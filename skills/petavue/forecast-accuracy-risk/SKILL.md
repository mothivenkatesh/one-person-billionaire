---
name: forecast-accuracy-risk
description: >
  Use this skill whenever the user wants to ensure reliable revenue projections
  and proactive risk management by analyzing forecast accuracy and flagging
  at-risk deals. Trigger when the user mentions phrases like "forecast
  accuracy", "forecast risk", "deal slippage", "commit vs actual", "rep
  forecast quality", or shares forecast data. Use weekly during quarter and
  daily in last 3 weeks of quarter.
---

# Forecast Accuracy & Risk

Analyzes forecast accuracy historically + flags at-risk deals in current pipeline. Output: forecast confidence per rep + per deal.

## Hard Constraints
- Required: forecast snapshots (weekly), actual close data, current open pipeline with commit categories
- Refuse: per-rep forecast judgment with < 8 quarters of history

## Workflow
1. Compute historical forecast accuracy per rep (commit vs actual; best-case vs actual)
2. Identify reps who systematically over- or under-commit
3. Apply rep-specific adjustment factor to current pipeline
4. Flag at-risk current-quarter deals (no recent activity, decision-maker not engaged, push history)
5. Output adjusted forecast + risk-weighted view

## Required Output Format
```
### Forecast Accuracy & Risk — [Quarter, Week N]

**Aggregate forecast accuracy (last 4 Q):** __%
**Aggregate over/under commit:** __%

| Rep | Historical accuracy | Commit | Best case | Risk-adjusted commit |
|-----|---------------------|--------|-----------|----------------------|

### At-Risk Deals (Current Quarter)

| Deal | ARR | Owner | Stage | Risk signals | Recommended action |
|------|-----|-------|-------|--------------|--------------------|
| | $ | | | No activity 14d, no exec sponsor | Push to next Q |

**Risk-adjusted forecast:** $___  (vs raw commit $___)
```

## Common Mistakes
- Trusting raw rep commit (most reps systematically over-commit)
- Not flagging single-threaded deals (champion leaving = deal dies silently)
- Quarterly review only (weekly is the right cadence; daily in last 3 weeks)
- Penalizing reps for accurate forecasts that miss target (kills accuracy incentive)

## Tooling
- Petavue MCP, Clari, Gong Forecast, Salesforce Collaborative Forecasting

## Source
[Petavue — Forecast Accuracy & Risk](https://www.petavue.com/resources/prompts) — Sales
