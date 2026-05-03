---
name: lead-source-hygiene-audit
description: >
  Use this skill whenever the user wants to audit lead-source attribution
  fields for completeness and standardization, flag gaps below targets, and
  recommend enforcement rules. Trigger when the user mentions phrases like
  "lead source hygiene", "broken lead attribution", "lead source enforcement",
  "source field completeness", or shares lead-source data.
---

# Lead Source Hygiene Audit

Audits lead-source fields for completeness, standardization, and enforcement gaps. Recommends form / API / CRM rules to prevent future drift.

## Hard Constraints
- Required: ≥ 1000 leads sample, source field naming convention, target completion %
- Refuse: cleanup recommendation without prevention rules (cleanup recurs in 30 days)

## Workflow
1. Compute source field completion % overall + per channel
2. Detect non-standard variants (e.g., "Google Ads" vs "google_ads" vs "GoogleAds")
3. Detect orphaned sources (named source but no campaign / no UTM)
4. Trace source-data origins (form? API? import? manual entry?)
5. Recommend prevention rules (required fields at form-submit, validation rules, mapping tables)

## Required Output Format
```
### Lead Source Hygiene Audit

**Source completion:** __% (target ≥ 95%)
**Source standardization:** ___ non-standard variants detected

**Top variants to consolidate:**
| Variant | Volume | Should be |
|---------|--------|-----------|

**Orphaned sources:** [list]

**Origin breakdown:**
| Origin | Source completion | Standardization | Action |
|--------|-------------------|-----------------|--------|
| Web form | __% | __% | |
| API import | __% | __% | |
| Manual entry | __% | __% | |

**Prevention rules to implement:**
1. [Form: make source field required + dropdown only]
2. [API: validate against canonical source list]
3. [CRM: workflow alert on missing source for new leads]
```

## Common Mistakes
- Cleanup without prevention (it recurs)
- Treating manual-entry leads as untrustworthy without fixing the root cause
- Not enforcing dropdown vs free-text at form-level
- Ignoring channel-source disagreement (UTM says X, lead source says Y)

## Tooling
- GTM analytics MCP, Salesforce / HubSpot, form builders (Marketo / Pardot / Webflow), Tray.io / Zapier for validation

## Source
Industry GTM analytics pattern — Marketing / RevOps
