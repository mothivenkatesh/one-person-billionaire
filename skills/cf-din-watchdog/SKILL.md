---
name: cf-din-watchdog
description: Anomaly detection skill that scans active campaigns across Smartlead, MoEngage, LinkedIn Ads, Gmail, and SF every 15 minutes to flag launches without an approved DIN. Posts to Slack #gtm-ops within 15 min of any anomaly. Also runs the daily 9am reconciliation report.
version: 0.1.0
owner: revops@cashfree.com
status: draft
depends_on: [dpdp-compliance]
tested_with: claude-haiku-4-5
loads_for_agents: [cf-din-watchdog]
---

# cf-din-watchdog — DIN enforcement anomaly detector

## When to use this skill

Load this skill when the watchdog agent needs to:
- Cross-reference active campaigns across all send channels with the Postgres `campaigns` table
- Classify anomalies and decide severity
- Format the Slack alert payload
- Generate the daily 9am reconciliation report

This skill is the brain of the **3-layer skip-detection** (spec §11.6.2). The agent runs every 15 min for layer 2 (real-time anomaly) and once daily 9am for layer 3 (reconciliation report).

## Inputs expected

For 15-min anomaly scan:

```json
{
  "scan_window_start": "ISO8601",
  "scan_window_end": "ISO8601",
  "channels_scanned": ["smartlead", "moengage", "linkedin_ads", "gmail", "sf_campaign"],
  "active_assets_per_channel": {
    "smartlead": [
      {"campaign_id": "string", "name": "string", "active": true, "cf_din_tag": "string | null"}
    ],
    "moengage": [
      {"flow_id": "string", "name": "string", "active": true, "din_id_attribute": "string | null"}
    ],
    "linkedin_ads": [
      {"campaign_id": "string", "destination_url": "string", "utm_campaign": "string | null"}
    ],
    "gmail": [
      {"send_id": "string", "originating_workflow": "string | null", "from_address": "string", "recipient_count": "int"}
    ],
    "sf_campaign": [
      {"campaign_id": "string", "name": "string", "din_id_field": "string | null"}
    ]
  },
  "approved_dins_in_postgres": [
    {"din_id": "string", "name": "string", "approval_status": "live | paused | archived | approved | in_review | draft"}
  ]
}
```

For daily 9am reconciliation:

```json
{
  "report_date": "YYYY-MM-DD",
  "active_campaigns_count_per_tool": {"smartlead": 0, "moengage": 0, "linkedin_ads": 0},
  "approved_dins_count": 0,
  "dins_in_review_over_48h": [{"din_id": "string", "in_review_for_hours": 0}],
  "briefs_missing_uploads": [{"din_id": "string", "missing_assets": ["array"]}],
  "yesterday_blocked_launches": [{"reason": "string", "din_id": "string | null", "agent": "string"}]
}
```

## Outputs expected

For 15-min anomaly scan:

```json
{
  "anomalies_detected": [
    {
      "channel": "smartlead | moengage | linkedin_ads | gmail | sf_campaign",
      "asset_id": "string",
      "asset_name": "string",
      "issue_type": "NO_DIN | DIN_NOT_APPROVED | DIN_DOES_NOT_EXIST | DIN_ARCHIVED | DIN_DRAFT",
      "severity": "P0 | P1 | P2",
      "owner_email": "string (best-guess from asset metadata)",
      "detected_at": "ISO8601",
      "recommended_action": "halt_within_24h | file_retro_din | escalate_to_vp"
    }
  ],
  "slack_alert_payload": {
    "channel": "#gtm-ops",
    "blocks": "Slack-block-kit-formatted array (per spec §11.6.2)"
  },
  "summary_for_log": "string (1 line per anomaly)"
}
```

For daily reconciliation:

```json
{
  "report_markdown": "string (the full report per spec §11.6.2 layer 3 format)",
  "slack_alert_payload": {
    "channel": "#gtm-ops",
    "blocks": "Slack-block-kit-formatted array"
  },
  "exec_escalation_needed": false,
  "exec_escalation_reason": "string | null"
}
```

## Body — the detection logic

### 15-min anomaly scan: severity + classification rules

| Issue type | Detected by | Severity | Recommended action |
|---|---|---|---|
| **NO_DIN** | Active asset has no `cf_din` tag / `din_id_attribute` / `utm_campaign` | **P0** | Halt within 24h |
| **DIN_DOES_NOT_EXIST** | Tag references DIN ID not in Postgres `campaigns` table | **P0** | Halt immediately, escalate |
| **DIN_NOT_APPROVED** | DIN exists but `approval_status` ∈ {`draft`, `in_review`} | **P0** | Halt + complete approval |
| **DIN_DRAFT** | DIN approval_status = 'draft' | **P0** | Halt + retro-DIN |
| **DIN_ARCHIVED** | DIN approval_status = 'archived' but campaign active | **P1** | Confirm-then-halt or unarchive |
| **DIN_PAUSED** | DIN approval_status = 'paused' but launches happening | **P1** | Investigate + alert owner |

### Slack alert payload format (Block Kit)

For each P0 anomaly:

```
🚨 *DIN-ANOMALY DETECTED — P0*
*Channel:* {channel}
*Asset:* {asset_name} (`{asset_id}`)
*Issue:* {issue_type}
*Owner:* {owner_email}
*Detected:* {detected_at}

*Recommended action:* {recommended_action}

cc: @{pmm_lead_handle}, @{vp_marketing_handle}, @{revops_lead_handle}

[Halt asset] [File retro-DIN] [Snooze 1h]
```

For P1: same format but ⚠️ instead of 🚨, no @-mentions of leadership, no escalation.

### Daily reconciliation report — markdown structure

Format exactly per spec §11.6.2 layer 3:

```markdown
DIN Reconciliation — {date}

Active campaigns across tools: {N}
With approved DIN: {N - X}  ✅
Without DIN or with anomaly: {X}  ⚠️
  → {list each with link to halt action}

DINs in 'in_review' >48h: {Y}  ⏰
  → {list each with approver chain status}

Briefs missing required uploads: {Z}  📎
  → {list each with missing asset name}

Yesterday's blocked launches: {N}
  → {list each with reason}
```

### Escalation rules

**Daily reconciliation triggers exec escalation when:**
- More than 5 anomalies open >24h, OR
- Any P0 anomaly open >48h, OR
- Total blocked launches >20 in past 24h (suggests an agent or human is repeatedly trying to bypass)

Escalation = Slack DM to VP Marketing + CRO with one-pager: anomalies, root causes, proposed action.

## Owner-attribution heuristics

When the active asset doesn't have an explicit owner field, infer from:
1. Smartlead: `from_address` → match to known team members → escalate to that person
2. MoEngage: `created_by_user_email` → same
3. LinkedIn Ads: `account_owner_email` from LinkedIn Campaign Manager
4. Gmail: `from_address` directly
5. If no match → escalate to PMM lead by default

## Examples

### Good — caught a real anomaly

**Input snippet:**
```json
{
  "active_assets_per_channel": {
    "smartlead": [
      {"campaign_id": "sl_8412", "name": "BFSI Q2 push", "active": true, "cf_din_tag": null}
    ]
  },
  "approved_dins_in_postgres": [...]
}
```

**Expected output:**
```json
{
  "anomalies_detected": [
    {
      "channel": "smartlead",
      "asset_id": "sl_8412",
      "asset_name": "BFSI Q2 push",
      "issue_type": "NO_DIN",
      "severity": "P0",
      "owner_email": "<inferred or unknown>",
      "detected_at": "2026-04-26T14:30:00Z",
      "recommended_action": "halt_within_24h"
    }
  ],
  "slack_alert_payload": {
    "channel": "#gtm-ops",
    "blocks": [/* Block Kit JSON */]
  },
  "summary_for_log": "P0: smartlead campaign 'BFSI Q2 push' (sl_8412) has no DIN tag — halt within 24h"
}
```

### Good — clean state, no anomalies

**Input:** All active assets have valid `cf_din` tags resolving to approved DINs.

**Expected output:**
```json
{
  "anomalies_detected": [],
  "slack_alert_payload": null,
  "summary_for_log": "Clean scan at 2026-04-26T14:30:00Z — 23 active campaigns all DIN-approved"
}
```

(Don't post to Slack on clean scans — too noisy. Only daily reconciliation posts a summary regardless.)

## Anti-patterns to avoid

- ❌ Don't post to Slack on every clean scan (15-min noise = ignored channel)
- ❌ Don't auto-halt without 24h grace (false positives possible — let owner respond first)
- ❌ Don't escalate to leadership on P1 anomalies (P0 only)
- ❌ Don't mark a DIN as DOES_NOT_EXIST if Postgres query failed — that's a system error, not an anomaly
- ❌ Don't aggregate multiple anomalies for the same DIN into one alert — each gets its own halt action

## Composition rules

This skill loads with:
- `dpdp-compliance` (because halting a campaign mid-flight may have consent-tracking implications)

This skill does NOT load:
- Persona skills (no message-drafting needed)
- Voice skills (output is structured, not prose)
