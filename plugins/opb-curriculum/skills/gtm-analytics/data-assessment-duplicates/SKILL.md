---
name: data-assessment-duplicates
description: >
  Use this skill whenever the user wants to detect and resolve record
  duplication in CRM (Accounts, Contacts, Leads, Opportunities). Trigger when
  the user mentions phrases like "duplicate records", "dedup my CRM",
  "duplicate accounts", "duplicate contacts", or shares data with suspected
  duplication. Use this skill before any reporting or data analysis work.
---

# Data Assessment — Duplicates

Detects duplicate records across Accounts, Contacts, Leads, and Opportunities. Outputs prioritized merge / delete recommendations.

## Hard Constraints
- Required: sample of records, dedup rules confirmed (exact email vs fuzzy domain match)
- Refuse: bulk merge without manual sample review (false positives ruin trust)

## Workflow
1. Run exact-match dedup (email, domain, phone)
2. Run fuzzy-match dedup (name similarity > 90%, company name similarity > 85%)
3. Score each duplicate cluster (confidence: high / medium / low)
4. For high-confidence: auto-merge plan
5. For medium / low: human review queue

## Required Output Format
```
### Duplicate Detection

| Object | Total records | Exact dups | Fuzzy dups | Total clusters | High confidence |
|--------|---------------|------------|------------|----------------|-----------------|
| Accounts | | | | | |
| Contacts | | | | | |
| Leads | | | | | |

**Auto-merge plan:** ___ high-confidence clusters
**Human review queue:** ___ medium / low confidence clusters
**Estimated cleanup time:** __ hours
```

## Common Mistakes
- Auto-merging fuzzy matches without review (false positives = data loss)
- Not preserving merge audit trail (can't undo)
- Cleanup once and forget (duplicates re-create without prevention rules)
- Trusting domain alone (sub-orgs at large enterprises share domain)

## Tooling
- GTM analytics MCP, Salesforce Duplicate Rules, HubSpot dedup tool, Cloudingo, Plauti, RingLead

## Source
Industry GTM analytics pattern — Marketing / Systems & Data / RevOps
