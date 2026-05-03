---
name: cf-drive-transcript-extractor
description: Extracts 7 typed property categories from Drive AI / Fathom call transcripts — objection_raised, competitor_mentioned, expansion_signal, churn_risk_phrase, decision_maker_added, next_step_committed, feature_request. Returns JSON array with verbatim source quotes + confidence ≥0.6 only. The first-party unstructured-signal layer that powers Stage-Mover, Churn-Saver, Cross-Sell-Detector, Outreach-Writer.
version: 0.1.0
owner: revops@cashfree.com
status: draft
depends_on: [dpdp-compliance]
tested_with: claude-haiku-4-5
loads_for_agents: [cf-drive-transcript-extractor]
---

# cf-drive-transcript-extractor — Layer-3.5 unstructured-signal extractor

## When to use this skill

Load when the Drive-Transcript-Extractor agent (Drive watcher 5-min poll) needs to:
- Read a normalized call transcript
- Extract structured properties across 7 typed categories
- Return JSON array with verbatim source quotes (mandatory citation)
- Filter to confidence ≥0.6 — drop anything below

Invoked by:
- `cf-drive-transcript-extractor` agent (continuous Drive watcher — every new transcript within 5 min of meeting end)

This is the **wedge** that no Cashfree competitor (Razorpay's MoEngage stack, Recotap, Factors.ai) is doing. Every other layer of the gtm-ops system depends on the typed properties this skill produces. **Without high-quality extraction, Stage-Mover/Churn-Saver/Cross-Sell-Detector all degrade.**

## Inputs expected

```json
{
  "transcript_id": "string (Drive file ID)",
  "transcript_text": "string (normalized — speaker labels, filler stripped)",
  "metadata": {
    "duration_min": 0,
    "recorded_at": "ISO8601",
    "attendees_external": ["array of external email addresses"],
    "attendees_cashfree": ["array of internal email addresses"],
    "calendar_event_title": "string",
    "resolved_account_id": "string",
    "resolved_account_vertical": "bfsi | d2c | saas | marketplace | other",
    "deal_id": "string | null",
    "deal_stage": "discovery | demo | poc | proposal | negotiation | closed_won | closed_lost | null"
  }
}
```

## Outputs expected

```json
{
  "transcript_id": "string",
  "extracted_properties": [
    {
      "property_name": "objection_raised | competitor_mentioned | expansion_signal | churn_risk_phrase | decision_maker_added | next_step_committed | feature_request",
      "value": "string (the canonical extracted value)",
      "subcategory": "string | null (e.g., for objection_raised: pricing | timing | capability | integration | compliance | competitor_lock)",
      "confidence": 0.0,
      "source_quote": "string ≤200 chars (verbatim from transcript)",
      "source_speaker": "external | cashfree | unknown",
      "source_timestamp_seconds": "int | null"
    }
  ],
  "summary_3_lines": "string (auto-summary of the call for SF Account.latest_call_summary)",
  "next_step_explicit": "string | null (if next_step_committed was extracted, restate clearly)",
  "calls_to_action_for_other_agents": [
    {"agent_to_trigger": "cf-churn-saver | cf-cross-sell-detector | cf-stage-mover", "reason": "string"}
  ]
}
```

## Body — the 7 property categories

For each category, the skill must:
1. Detect the signal in the transcript
2. Extract the canonical `value`
3. Cite a verbatim `source_quote` (≤200 chars, exact wording from the transcript)
4. Estimate `confidence` (only return if ≥0.6)
5. Tag the speaker as external/cashfree/unknown

### Category 1: `objection_raised`

| Subcategory | What to look for | Example source_quote |
|---|---|---|
| `pricing` | Cost concerns, MDR pushback, "expensive", "budget" | "Honestly the MDR is 0.05% higher than what Razorpay quoted us" |
| `timing` | "not now", code freeze, Q-end, post-holiday | "We're in code freeze through end of June so any migration is off the table" |
| `capability` | "doesn't support X", "missing Y", feature gap | "Does Cashfree support webhook retries with exponential backoff? Razorpay does." |
| `integration` | Migration complexity, lock-in, stack incompatibility | "We've got 3 years of integration with Razorpay's SDK; switching is a quarter of work" |
| `compliance` | DPDP, RBI, PCI concerns | "I need to see your DPDP audit report before our security team will sign off" |
| `competitor_lock` | "just signed", "year contract", existing commitment | "We just signed a 2-year deal with PayU last quarter" |

`value` format: brief canonical phrasing of the objection (e.g., "MDR 0.05% higher than Razorpay")

### Category 2: `competitor_mentioned`

Detect named mentions of: Razorpay, PayU, Stripe, BillDesk, Karza, HyperVerge, Perfios, Signzy, IDfy, CCAvenue, Instamojo, Paytm, PhonePe, Pine Labs.

`value`: the competitor name + 1-line context (e.g., "Razorpay — current vendor, evaluating switch")

### Category 3: `expansion_signal`

Phrases indicating they're scaling or considering adjacent products:

- "We're launching [new product/geo/vertical]"
- "Vendor count went from 50 to 200"
- "Considering recurring billing"
- "Need international payouts now"
- "Looking at working capital options"
- "About to hit our Capex committee for [X]"

`value`: the canonical expansion direction (e.g., "international shipping launched — UAE")
`subcategory`: which Cashfree product it implies (e.g., `international_pg`, `payouts`, `capital`, `autopay`)

### Category 4: `churn_risk_phrase`

Phrases that imply they may leave:

- "Considering [competitor]"
- "Evaluating alternatives"
- "Webhooks have been unreliable for [N] weeks"
- "Support response times are getting worse"
- "Renewal is coming up and we're [reviewing/evaluating]"
- "Internally I've been pushing back on [Cashfree]"

`value`: brief canonical phrasing
`subcategory`: `competitor_consideration | reliability_complaint | support_complaint | renewal_evaluation | internal_pushback`

### Category 5: `decision_maker_added`

When a new stakeholder is named in the call:

- "@Anjali handles this on our side"
- "You should talk to our CTO"
- "Let me loop in Rohan from Engineering"
- "Bringing CFO into next call"

`value`: name + title (e.g., "Anjali Mehta — Head of Payments Engineering")
`subcategory`: `champion | economic_buyer | technical_evaluator | influencer | unknown`

### Category 6: `next_step_committed`

Explicit next-step commitments:

- "Let's do Tuesday 4pm"
- "I'll send you the data file by Friday"
- "Bring your SE to next call"
- "Send me the MSA + DPA"

`value`: canonical commit (e.g., "Send Mobile360 1-pager + benchmark deck by EOD Friday")

### Category 7: `feature_request`

Specific feature asks (different from objection_raised: capability):

- "Would love a Sandbox environment with realistic data"
- "Can you add NEFT to the bulk payouts API?"
- "We need a custom dashboard for our finance team"

`value`: canonical feature description

## Confidence scoring rubric

| Confidence | Meaning |
|---|---|
| 0.95–1.00 | Verbatim phrase that uniquely identifies the property; speaker explicitly states |
| 0.80–0.95 | Strong implication, requires minimal inference |
| 0.60–0.80 | Moderate — context required to confirm |
| <0.60 | Skip — do not return |

**Hard rule:** Every returned property MUST have a verbatim source_quote. If you can't quote it from the transcript, you can't extract it.

## Calls-to-action for other agents

Based on extracted properties, signal which downstream agents should fire:

| Extracted properties | Downstream trigger |
|---|---|
| Any `churn_risk_phrase` with confidence ≥0.7 | `cf-churn-saver` |
| Any `expansion_signal` with confidence ≥0.7 | `cf-cross-sell-detector` |
| Any `competitor_mentioned` AND existing deal in active stage | `cf-stage-mover` (stage-mover should re-evaluate) |
| `decision_maker_added` | Update SF Account stakeholder map (no agent trigger) |
| `next_step_committed` AND deal exists | Update SF Opportunity.next_step |

## Cashfree-specific extraction rules

- **DPDP language**: if the transcript mentions "personal data", "consent", "data residency" — flag as `compliance` objection AND alert legal team via Slack
- **RBI signals-not-scores rule**: if transcript hints we're claiming alternate-data capability we don't have, flag for Compliance review
- **Vertical-specific language**: For BFSI, "NTC", "Bureau prefill", "V-CIP", "Mobile360" are key signals; for D2C, "MDR", "settlement time", "RTO" are key signals
- **Champion language detection**: phrases like "I've been pushing this internally", "have my CTO's buy-in", "this is on my Q3 plan" → strong `champion` signal in `decision_maker_added`

## Examples

### Good extraction

**Input transcript excerpt:**
```
[Anita Sharma]: "Look, the issue isn't capability — your Mobile360 numbers look better than Karza's. The issue is, we're in the middle of a 3-month security audit and any new vendor onboarding is paused until July. Also, Karza did a 1-week POC for us last year — they were faster on that. Can you match that turnaround?"

[Mothi]: "Yes, we can offer a Cashfree-managed POC where our SE runs your file and delivers a benchmark deck in 5 days. Let me send you the spec."

[Anita]: "OK, send it. Loop in Rohan our Onboarding Lead — he'll be on the next call."
```

**Expected output (selected properties):**
```json
{
  "extracted_properties": [
    {
      "property_name": "objection_raised",
      "value": "Security audit pause — no vendor onboarding until July",
      "subcategory": "timing",
      "confidence": 0.95,
      "source_quote": "we're in the middle of a 3-month security audit and any new vendor onboarding is paused until July",
      "source_speaker": "external",
      "source_timestamp_seconds": null
    },
    {
      "property_name": "objection_raised",
      "value": "Karza was faster on POC turnaround (1 week)",
      "subcategory": "capability",
      "confidence": 0.92,
      "source_quote": "Karza did a 1-week POC for us last year — they were faster on that. Can you match that turnaround?",
      "source_speaker": "external",
      "source_timestamp_seconds": null
    },
    {
      "property_name": "competitor_mentioned",
      "value": "Karza — incumbent, did 1-week POC",
      "subcategory": null,
      "confidence": 0.98,
      "source_quote": "Karza did a 1-week POC for us last year",
      "source_speaker": "external",
      "source_timestamp_seconds": null
    },
    {
      "property_name": "next_step_committed",
      "value": "Send Cashfree-managed POC spec",
      "subcategory": null,
      "confidence": 0.94,
      "source_quote": "OK, send it",
      "source_speaker": "external",
      "source_timestamp_seconds": null
    },
    {
      "property_name": "decision_maker_added",
      "value": "Rohan — Onboarding Lead",
      "subcategory": "technical_evaluator",
      "confidence": 0.91,
      "source_quote": "Loop in Rohan our Onboarding Lead — he'll be on the next call.",
      "source_speaker": "external",
      "source_timestamp_seconds": null
    }
  ],
  "summary_3_lines": "HDFC's Anita Sharma confirmed Mobile360 capability beats Karza but they're in a 3-month security audit (no vendor onboarding until July). They also need POC speed parity with Karza's 1-week turnaround. Mothi committed to send Cashfree-managed POC spec; Rohan (Onboarding Lead) joining next call.",
  "next_step_explicit": "Send Cashfree-managed POC spec to Anita; loop in Rohan as new technical evaluator",
  "calls_to_action_for_other_agents": [
    {"agent_to_trigger": "cf-stage-mover", "reason": "New objection (security audit timing) + new technical evaluator (Rohan) requires stage-mover to re-evaluate next-step"}
  ]
}
```

## Anti-patterns to avoid

- ❌ Returning a property without a verbatim source_quote (fabrication risk — kills system trust)
- ❌ Returning properties below confidence 0.6 (noise floods downstream agents)
- ❌ Misclassifying capability complaints as objections-of-pricing (different downstream actions)
- ❌ Marking generic phrases as competitor mentions ("the alternatives" ≠ named competitor)
- ❌ Extracting next_step_committed when no specific commit was made (vague "let's keep in touch" is NOT a commit)
- ❌ Speaker mis-attribution (Cashfree person's statement extracted as if external)

## Composition rules

Always loaded with:
- `dpdp-compliance` (extracted properties may contain PII; redaction rules)

This skill loads ONLY this composition (intentionally minimal — extraction is structured, not creative).

## Performance targets

- Latency: <4s per transcript (Haiku tier required for cost at volume)
- Cost: <$0.005 per transcript
- Precision (extracted property is correct): ≥90%
- Recall (caught the property if it existed): ≥85%
- False-positive rate on competitor mentions: <2% (high stakes — wrong "they're switching" claim creates alarm)
