---
name: data-assessment-accounts
description: >
  Use this skill whenever the user wants to audit Account-object completeness
  and linkage in CRM for reliable account-based reporting. Trigger when the
  user mentions phrases like "account data audit", "ABM data quality", "account
  fields cleanup", "account-contact linkage", or shares account data. Always
  use before launching ABM programs.
---

# Data Assessment — Accounts

Audits Account fields in CRM for completeness + correct linkage to Contacts, Opps, and CSM ownership.

## Hard Constraints
- Required: sample of ≥ 200 accounts, list of ABM-critical fields
- Refuse: audit without target completion thresholds

## Workflow
1. Inventory critical account fields (industry, size, ARR, owner, segment, parent-child link, status)
2. Compute % completion per field
3. Detect orphaned accounts (no owner / no contacts / no opps)
4. Detect duplicate accounts (same domain / similar name)
5. Detect linkage gaps (account ↔ contact, account ↔ opp)

## Required Output Format
```
### Account Data Assessment

| Field | Completion % | Standardized? | Cleanup priority |
|-------|--------------|---------------|------------------|

**Orphaned accounts:** ___ (no owner / no linkage)
**Duplicates detected:** ___
**Linkage gaps:** ___ accounts with no contacts; ___ with no opps

Top fix-list:
1.
2.
3.
```

## Common Mistakes
- Cleanup without de-dup first (cleaning duplicates wastes time)
- Ignoring parent-child hierarchy (multi-entity accounts get under-attributed)
- Not enforcing required fields at create-time (cleanup is endless without prevention)

## Tooling
- Petavue MCP, Salesforce, HubSpot, Clay (enrichment + dedup)

## Source
[Petavue — Data Assessment Accounts](https://www.petavue.com/resources/prompts) — Marketing / Systems & Data / RevOps
