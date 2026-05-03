---
name: forms-router
description: Google Forms webhook payload classifier + downstream-agent dispatcher. Parses 6 Cashfree form types (demo-request, content-download, webinar-registration, nps-survey, churn-exit-survey, partner-signup), normalizes per-form schema, routes to correct downstream agent (ICP-Scout, Churn-Saver, MoEngage, partner-ops). Returns routing decision with rationale.
version: 0.1.0
owner: revops@cashfree.com
status: draft
depends_on: [dpdp-compliance]
tested_with: claude-haiku-4-5
loads_for_agents: [cf-forms-router]
---

# cf-forms-router — Inbound Forms classifier + dispatcher

## When to use this skill

Load when the Forms-Router agent (Google Forms webhook handler) needs to:
- Parse a Forms submission payload (variable schema per form_name)
- Classify the intent type and route to the correct downstream agent
- Apply per-form-type processing rules (demo = high priority, NPS = check score for churn)
- Decide whether to enrich (Clay) or skip (just log + route)
- Return clean dispatch instructions for the agent runtime

Invoked by:
- `cf-forms-router` agent (real-time webhook from any Google Form's Apps Script `onFormSubmit` trigger)

This skill is the **front door** for all inbound. Bad routing = lost demos, missed churn signals, slow response. Good routing = real-time inbound tier-A escalation, automatic NPS-driven churn-save, partner intake automation.

## Inputs expected

```json
{
  "raw_payload": {
    "form_name": "string (e.g., 'gtm.demo-request')",
    "respondent_email": "string",
    "submitted_at": "ISO8601",
    "form_response_id": "string",
    "fields": {
      "<field_name>": "<field_value>",
      "...": "..."
    }
  }
}
```

## Outputs expected

```json
{
  "intent_class": "demo | content | webinar | nps | churn_exit | partner | unclassified",
  "parsed": {
    "respondent_email": "string",
    "company_name": "string | null",
    "company_domain": "string | null",
    "respondent_title": "string | null",
    "key_fields": "object (per-form-type — see body for schema per form)"
  },
  "enrichment_required": "bool",
  "enrichment_priority": "real_time | batch | skip",
  "downstream_agent_invocation": {
    "agent_name": "cf-icp-scout | cf-churn-saver | moengage_journey | partner_ops_handoff | log_only",
    "agent_payload_overrides": "object (per-agent params)",
    "high_intent_explicit": "bool (skip-tier-A flag)"
  },
  "sheet_to_log_to": "string (e.g., 'gtm.form-responses.demo-request')",
  "compliance_flags": ["array of any DPDP / consent issues found"]
}
```

## Body — per-form-type processing

### Form: `gtm.demo-request`

**Expected fields:**
- `company` (required)
- `name` (required)
- `email` (required)
- `phone` (optional)
- `monthly_payments_volume_inr` (optional dropdown)
- `vertical` (optional dropdown: D2C / SaaS / BFSI / Marketplace / Other)
- `urgency` (optional: ASAP / This quarter / Just exploring)
- `consent_to_contact` (required checkbox — DPDP)

**Routing rules:**
- `intent_class = demo`
- `enrichment_priority = real_time` (Clay enrichment within 60s, Apollo + ZoomInfo + Proxycurl)
- `downstream_agent = cf-icp-scout` with `trigger_type='forms_webhook'` and `high_intent_explicit=true` (bypass cron, real-time path)
- ICP-Scout treats this as Tier A/B candidate regardless of normal score (explicit demo = high commercial intent)
- `sheet_to_log_to = gtm.form-responses.demo-request`
- DPDP compliance: confirm `consent_to_contact = true` else flag for compliance review (cannot proceed)

**SLA:** AE Slack alert within 15 minutes of form submit.

### Form: `gtm.content-download`

**Expected fields:**
- `email` (required)
- `name` (optional)
- `company` (optional)
- `content_topic` (the asset they downloaded)
- `consent_to_marketing` (required checkbox — DPDP)

**Routing rules:**
- `intent_class = content`
- `enrichment_priority = batch` (next ICP-Scout cron run, not real-time — lower commercial intent)
- `downstream_agent = moengage_journey` with `journey='content_nurture'` and `topic={content_topic}`
- Add to MoEngage segment for the content topic; trigger 4-touch nurture sequence
- `sheet_to_log_to = gtm.form-responses.content-download`
- Compliance: confirm consent_to_marketing else only allow legal-basis legitimate-interest single follow-up

### Form: `gtm.webinar-registration`

**Expected fields:**
- `email` (required)
- `name` (required)
- `company` (required)
- `webinar_id` (which session)
- `consent_to_contact` (required)

**Routing rules:**
- `intent_class = webinar`
- `enrichment_priority = batch`
- `downstream_agent = moengage_journey` with `journey='webinar_reminders'`
- Also: increment `account.engagement_score` by +0.5 (webinars are mid-funnel signal)
- `sheet_to_log_to = gtm.form-responses.webinar-{webinar_id}`

### Form: `gtm.nps-survey`

**Expected fields:**
- `account_id` (auto-populated via tokenized link)
- `nps_score` (0-10)
- `nps_comment` (optional, often where the gold is)
- `respondent_email`

**Routing rules (score-dependent):**

| NPS score | Class | Action |
|---|---|---|
| 0-6 (detractor) | `nps` + flag for churn | `downstream_agent = cf-churn-saver` with `severity='P1'`; pass `nps_comment` as transcript_evidence equivalent |
| 7-8 (passive) | `nps` | `downstream_agent = log_only`; flag CSM if comment indicates issue |
| 9-10 (promoter) | `nps` + advocacy candidate | `downstream_agent = log_only`; flag PMM for case-study / reference / advocacy invitation |

`sheet_to_log_to = gtm.form-responses.nps`
Compliance: NPS surveys are usually exempt from explicit consent if customer relationship exists (legitimate interest)

### Form: `gtm.churn-exit-survey`

**Expected fields:**
- `account_id` (tokenized)
- `primary_reason` (dropdown: pricing / capability / support / competitor / business_change / other)
- `competitor_chosen` (optional, free-text)
- `verbatim_feedback` (optional, free-text — usually most valuable)

**Routing rules:**
- `intent_class = churn_exit`
- `enrichment_priority = skip` (already a customer; we have data)
- `downstream_agent = product_team_drive` (write to `Drive/GTM/ChurnExit/{YYYY-MM}/{account_id}.md`)
- ALSO: flag for next monthly Win/Loss-Analyzer run (auto-include in extraction batch)
- `sheet_to_log_to = gtm.form-responses.churn-exit`
- DPDP: confirm continued data-retention consent, OR honor right-to-erasure if explicit

**Special:** if `competitor_chosen` is named, auto-trigger Champion-Tracker to monitor whether champion follows the customer to the competitor.

### Form: `gtm.partner-signup`

**Expected fields:**
- `partner_company`
- `partner_name`
- `partner_type` (dropdown: agency / SI / referral_partner / co-sell)
- `target_merchant_segment` (BFSI / D2C / SaaS / Marketplace / Other)
- `email`
- `expected_volume`
- `consent_to_contact`

**Routing rules:**
- `intent_class = partner`
- `enrichment_priority = real_time` (we want to know about the partner company quickly)
- `downstream_agent = partner_ops_handoff` (cross-domain to `partner-ops` repo when it exists; for now, Slack alert to partnerships@cashfree.com)
- `sheet_to_log_to = gtm.form-responses.partner-signup`

### Form: unclassified

If `form_name` doesn't match any known type:
- `intent_class = unclassified`
- `downstream_agent = log_only`
- Slack alert to RevOps with the payload for manual review
- `sheet_to_log_to = gtm.form-responses.unclassified`

## Cashfree-specific compliance rules

For ALL form types:

1. **Confirm consent**: every form must have a consent checkbox or be operating under legitimate-interest basis. Flag in `compliance_flags` if missing.
2. **PII redaction in logs**: when writing to Sheets, redact phone numbers and email addresses if respondent ticked "anonymous" (DPDP right-to-anonymize).
3. **DLT for SMS triggers**: if downstream MoEngage journey includes SMS, verify TRAI DLT registration is current — flag if not.
4. **Right-to-erasure flag**: if `verbatim_feedback` contains "delete my data" / "remove me" / "right to be forgotten" — auto-flag for compliance team within 72 hours.

## Examples

### Good — high-intent demo request

**Input:**
```json
{
  "raw_payload": {
    "form_name": "gtm.demo-request",
    "respondent_email": "anita@nykaa.com",
    "submitted_at": "2026-04-26T14:30:00+05:30",
    "form_response_id": "resp_abc123",
    "fields": {
      "company": "Nykaa",
      "name": "Anita Mehta",
      "email": "anita@nykaa.com",
      "monthly_payments_volume_inr": "₹5Cr+",
      "vertical": "D2C",
      "urgency": "This quarter",
      "consent_to_contact": true
    }
  }
}
```

**Output:**
```json
{
  "intent_class": "demo",
  "parsed": {
    "respondent_email": "anita@nykaa.com",
    "company_name": "Nykaa",
    "company_domain": "nykaa.com",
    "respondent_title": null,
    "key_fields": {
      "monthly_payments_volume_inr": "₹5Cr+",
      "vertical": "D2C",
      "urgency": "This quarter",
      "consent_to_contact": true
    }
  },
  "enrichment_required": true,
  "enrichment_priority": "real_time",
  "downstream_agent_invocation": {
    "agent_name": "cf-icp-scout",
    "agent_payload_overrides": {
      "trigger_type": "forms_webhook",
      "high_intent_explicit": true,
      "skip_to_tier": "A",
      "expected_account_size": "₹5Cr+ monthly volume"
    },
    "high_intent_explicit": true
  },
  "sheet_to_log_to": "gtm.form-responses.demo-request",
  "compliance_flags": []
}
```

### Good — NPS detractor → auto-churn-save

**Input:**
```json
{
  "raw_payload": {
    "form_name": "gtm.nps-survey",
    "respondent_email": "rohan@boat-lifestyle.com",
    "submitted_at": "2026-04-26T11:00:00+05:30",
    "form_response_id": "resp_xyz789",
    "fields": {
      "account_id": "acc_boat_001",
      "nps_score": 4,
      "nps_comment": "Webhooks have been unreliable for the last 3 weeks. Considering Razorpay."
    }
  }
}
```

**Output:**
```json
{
  "intent_class": "nps",
  "parsed": {
    "respondent_email": "rohan@boat-lifestyle.com",
    "company_name": null,
    "company_domain": "boat-lifestyle.com",
    "respondent_title": null,
    "key_fields": {
      "account_id": "acc_boat_001",
      "nps_score": 4,
      "nps_comment": "Webhooks have been unreliable for the last 3 weeks. Considering Razorpay."
    }
  },
  "enrichment_required": false,
  "enrichment_priority": "skip",
  "downstream_agent_invocation": {
    "agent_name": "cf-churn-saver",
    "agent_payload_overrides": {
      "severity": "P1",
      "transcript_evidence_passthrough": [
        {
          "property_name": "churn_risk_phrase",
          "value": "Considering Razorpay; webhooks unreliable 3 weeks",
          "source_quote": "Webhooks have been unreliable for the last 3 weeks. Considering Razorpay.",
          "extracted_at": "2026-04-26T11:00:00+05:30"
        }
      ]
    },
    "high_intent_explicit": false
  },
  "sheet_to_log_to": "gtm.form-responses.nps",
  "compliance_flags": []
}
```

## Anti-patterns to avoid

- ❌ Treating content-download as high-intent demo (over-enriches; wastes Clay credits + AE bandwidth)
- ❌ Routing NPS detractor to log-only (this is the highest-leverage churn signal — must trigger Churn-Saver)
- ❌ Skipping consent verification (DPDP exposure)
- ❌ Not flagging unclassified forms for human review (silent failure)
- ❌ Letting churn_exit feedback rot in a Sheet — must auto-feed Win/Loss-Analyzer monthly
- ❌ Tokenized NPS link without account_id resolution (data unusable)

## Composition rules

Always loaded with:
- `dpdp-compliance` (consent + redaction + erasure rules)

This skill loads ONLY DPDP composition (intentionally minimal — routing is structured, not creative).

## Performance targets

- Latency: <2s per webhook (Haiku tier required for real-time response)
- Cost: <$0.001 per webhook
- Demo-request to AE-alert SLA: <15 minutes
- NPS detractor to Churn-Saver SLA: <5 minutes
- Misrouting rate: <1% (every misroute = lost commercial signal)
