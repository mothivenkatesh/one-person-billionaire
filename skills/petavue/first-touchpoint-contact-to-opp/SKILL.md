---
name: first-touchpoint-contact-to-opp
description: >
  Use this skill whenever the user wants to identify which initial GTM
  activities best convert new contacts into opportunities and revenue. Trigger
  when the user mentions phrases like "first-touch attribution", "best first
  touchpoint", "opening touch", "what gets the first meeting", or shares
  first-touch data. Use to optimize top-of-funnel investment.
---

# First Touchpoint Analysis — Contact-to-Opp

Identifies which first-touchpoint types (channel + asset) best convert contacts into Opportunities. Helps reallocate top-of-funnel spend.

## Hard Constraints
- Required: contact creation date + first-touch source per contact + Opp creation per contact
- Refuse: analysis with < 100 contacts per first-touch type (sample noise)

## Workflow
1. For each contact: identify first-touch (channel + asset)
2. Group by first-touch type
3. Compute Contact-to-Opp conversion per group
4. Compute time-to-Opp per group (faster = better lead quality)
5. Cross with downstream Closed-Won (high conversion, high revenue = best)

## Required Output Format
```
### First Touchpoint Analysis — Contact to Opp

| First Touch Type | Channel | Contacts | Opp conversion | Avg days to Opp | Closed-Won rate | Score |
|------------------|---------|----------|----------------|-----------------|-----------------|-------|

**Top performers:** scale these channels / assets next quarter.
**Bottom performers:** kill or refresh asset.
```

## Common Mistakes
- Conversion rate alone (a high-converting touchpoint with tiny volume isn't actionable)
- Ignoring time-to-Opp (slow-converting = lower-quality lead)
- Not connecting first-touch to Closed-Won (high mid-funnel ≠ high revenue)

## Tooling
- Petavue MCP, Salesforce, Bizible / Dreamdata for first-touch attribution

## Source
[Petavue — First Touchpoint Analysis](https://www.petavue.com/resources/prompts) — Marketing / Systems & Data / RevOps
