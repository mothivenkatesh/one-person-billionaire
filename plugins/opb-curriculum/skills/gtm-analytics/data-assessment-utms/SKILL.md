---
name: data-assessment-utms
description: >
  Use this skill whenever the user wants to catch missing UTMs and source
  fields that break campaign ROI and CAC tracking. Trigger when the user
  mentions phrases like "UTM audit", "broken attribution", "missing source
  data", "untracked traffic", or shares URL/source data. Always use before
  computing CAC or campaign ROI.
---

# Data Assessment — UTMs

Audits UTM presence and consistency across web traffic, lead capture, and CRM lead source fields.

## Hard Constraints
- Required: web analytics (GA / Posthog / Plausible) + CRM lead source data + UTM convention doc
- Refuse: audit without UTM naming convention defined

## Workflow
1. Pull last 30 days of web traffic; classify by UTM presence (full / partial / missing)
2. Pull leads created in same window; check UTM source on each
3. Match traffic UTMs to lead UTMs (gap = lost attribution)
4. Detect non-conventional UTMs (e.g., "google-ads" vs "google_ads" vs "GoogleAds")
5. Trace untracked traffic → identify source pages without UTMs

## Required Output Format
```
### UTM Audit

**Traffic with UTMs:** __% (of total sessions)
**Leads with UTMs:** __% (of total leads created)
**Attribution gap:** __ sessions vs __ leads with full attribution

**Non-conventional UTMs detected:**
| Variant | Volume | Should be |
|---------|--------|-----------|

**Untracked source pages:**
| Page | Sessions | Suggested UTM |
|------|----------|---------------|

**Quick wins:**
1. [Add UTMs to: [list of high-traffic untracked pages]]
2. [Standardize: [variant → canonical]]
```

## Common Mistakes
- No naming convention (every team makes their own UTMs)
- Cleaning without enforcing (re-occurs in 30 days)
- Ignoring lower-case vs mixed-case (treated as different sources)
- Not tracking organic / direct (you lose 30-50% of attribution)

## Tooling
- GTM analytics MCP, Google Analytics, Posthog, Plausible, Salesforce, HubSpot
- UTM builders: ga-dev-tools, Google Campaign URL Builder

## Source
Industry GTM analytics pattern — Marketing / Systems & Data / RevOps
