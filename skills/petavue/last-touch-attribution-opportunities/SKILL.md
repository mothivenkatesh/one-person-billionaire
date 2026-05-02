---
name: last-touch-attribution-opportunities
description: >
  Use this skill whenever the user wants to identify which final GTM
  activities most commonly trigger opportunity creation to optimize
  high-intent conversion points. Trigger when the user mentions phrases like
  "last-touch attribution", "what triggers opps", "opp-trigger touchpoints",
  "high-intent conversion", or shares opp-trigger data. Use to optimize
  bottom-of-funnel CTAs.
---

# Last-Touch Attribution for Opportunities

Identifies the GTM activities (channel + asset + action) that most commonly trigger Opportunity creation — the high-intent conversion points.

## Hard Constraints
- Required: Opp creation events with last touchpoint within 7 days prior
- Refuse: analysis combining attribution windows ≠ 7 days (use single window for consistency)

## Workflow
1. For each Opp created: identify last touchpoint within 7 days prior to Opp creation
2. Group by touchpoint type (demo request, pricing page view, sales call, content download)
3. Compute Opp-trigger volume per type
4. Cross with Closed-Won rate (which last-touches lead to actual revenue)
5. Recommend CTA optimizations

## Required Output Format
```
### Last-Touch Attribution for Opportunities — [Window]

| Last Touchpoint | Opps triggered | Closed-Won rate | High-quality trigger? |
|-----------------|----------------|-----------------|----------------------|
| Demo request | | __% | Yes / No |
| Pricing page | | __% | |
| Sales call (SDR) | | __% | |
| Content download | | __% | |

**Insight:** Best CTA: [touchpoint] | Worst CTA (pretty volume but bad close rate): [touchpoint]
**Recommendation:** Optimize [pages] for the high-quality trigger; de-emphasize the low-quality trigger.
```

## Common Mistakes
- Last-touch only (incomplete attribution; pair with first-touch + multi-touch)
- Ignoring close rate (high Opp volume + low close = wrong people getting CTAs)
- 30-day attribution window (too long for last-touch; use 7 days)
- Optimizing CTAs by volume only

## Tooling
- Petavue MCP, Salesforce, Bizible / Dreamdata, Marketo / HubSpot

## Source
[Petavue — Last-Touch Attribution Analysis for Opportunities](https://www.petavue.com/resources/prompts) — Marketing / Systems & Data / RevOps
