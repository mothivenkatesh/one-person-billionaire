---
name: reply-classifier
description: 6-class intent classifier for Smartlead reply webhooks. Classifies B2B sales reply intent (positive/objection/not_now/unsubscribe/referral/oof/unclear), extracts objections + competitor mentions as typed properties, returns suggested AE follow-up. Calibrated for mothi outbound to BFSI/D2C/SaaS verticals.
version: 0.1.0
owner: revops@mothi.com
status: draft
depends_on: [dpdp-compliance, content-strategist]
tested_with: claude-haiku-4-5
loads_for_agents: [reply-classifier]
---

# reply-classifier — 6-class Smartlead reply intent classifier

## When to use this skill

Load when an agent needs to:
- Classify intent of a B2B sales reply within <1s of receipt
- Extract objections + competitor mentions as typed properties for downstream Stage-Mover / Churn-Saver consumption
- Generate routing decision (alert AE / nurture / suppress / reschedule / manual review)
- Suggest follow-up reply for AE if intent = positive

Invoked by:
- `reply-classifier` agent (Smartlead reply webhook — real-time)

Without this classifier live, mothi SDRs drown when 30K sends/month produces 600-1,000 replies. This is the **non-negotiable Day-1 dependency** for the outbound engine.

## Inputs expected

```json
{
  "smartlead_payload": {
    "from_email": "string",
    "subject": "string",
    "body_text": "string",
    "body_html_stripped": "string",
    "thread_id": "string",
    "campaign_id": "string",
    "campaign_din": "AGS-GTM-...",
    "received_at": "ISO8601"
  },
  "thread_context": {
    "previous_touches": "int (count of prior outbound touches in this thread)",
    "last_touch_template_id": "string",
    "lead_tier": "A | B | C | plg",
    "lead_vertical": "bfsi | d2c | saas | marketplace",
    "lead_persona": "cfo | cto | founder | head_of_payments | other"
  }
}
```

## Outputs expected

```json
{
  "intent": "positive | objection | not_now | unsubscribe | referral | oof | unclear",
  "confidence": 0.0,
  "objection_categories": ["pricing | timing | capability | integration | compliance | competitor_lock | other"],
  "competitor_mentioned": "razorpay | payu | stripe | billdesk | karza | hyperverge | perfios | signzy | none | unknown",
  "champion_signal_present": false,
  "suggested_followup": "1-2 sentence summary of best-next-step for the AE",
  "extracted_properties": [
    {"property_name": "objection_raised", "value": "string", "source_quote": "string"}
  ],
  "routing_action": "alert_ae | alert_ae_with_context | nurture | suppress | reschedule | manual_review"
}
```

## Body — the 6-class taxonomy + classification rules

### Class definitions

| Class | Definition | Example phrases |
|---|---|---|
| **positive** | Explicit interest. Asks for demo / call / pricing / next step | "Sure, send me a deck" · "Can we set up 30 min next week?" · "What's your pricing?" |
| **objection** | Pushback (price, timing, capability) BUT engaging — they're still on the line | "Looks expensive vs what we have" · "We just signed with Razorpay 6 months ago" · "Doesn't your API support webhook retries?" |
| **not_now** | Timing-deferred but open to re-engage later (>30d) | "Reach out again in Q3" · "Not a priority right now but bookmark me" · "We're in code-freeze through June" |
| **unsubscribe** | Explicit opt-out request | "Please remove me" · "Stop emailing" · "Unsubscribe" · "Don't contact again" |
| **referral** | Forwarded internally OR named another contact | "+looping in our CTO" · "@anjali handles this" · "You should talk to our payments lead, copying her" |
| **oof** | Out-of-office auto-reply | "I'm out of office until..." · "Limited email access through..." |
| **unclear** | Doesn't fit cleanly. Send to manual review. | "Hmm interesting" · "Will think about it" · One-word replies without context |

### Confidence rubric

| Confidence | Meaning |
|---|---|
| 0.95–1.00 | Unambiguous — explicit phrase matching the class |
| 0.80–0.95 | Strong — implicit but clear |
| 0.60–0.80 | Moderate — context required for confidence |
| <0.60 | Below threshold → mark intent as `unclear`, route to `manual_review` |

### Objection category taxonomy

| Category | Examples |
|---|---|
| `pricing` | "too expensive", "MDR is high", "pricing model doesn't fit" |
| `timing` | "code freeze", "Q3 budget", "post-holiday" |
| `capability` | "doesn't support X", "missing feature Y", "can it do Z?" |
| `integration` | "complex to migrate", "we're locked into webhooks", "stack incompatibility" |
| `compliance` | "DPDP concerns", "RBI clarification needed", "data residency" |
| `competitor_lock` | "we just signed Razorpay", "12-month contract with Stripe", "PayU multi-year" |
| `other` | catch-all |

### Routing action matrix

| Intent | Tier A/B | Tier C/plg |
|---|---|---|
| positive | alert_ae (Slack DM with full context + suggested reply) | alert_ae (queued for SDR review) |
| objection | alert_ae_with_context (include extracted_properties so AE can address) | alert_ae_with_context (SDR queue) |
| not_now | nurture (pause Smartlead seq, enroll in MoEngage 90-day nurture) | nurture |
| unsubscribe | suppress (add to gtm.suppression-list + Smartlead suppression) | suppress |
| referral | alert_ae (immediate) — referrals are gold; create new SF Lead for the referred contact | alert_ae |
| oof | reschedule (parse OOF return-date if present, pause Smartlead until then) | reschedule |
| unclear | manual_review (queue for PMM/RevOps eyes; don't auto-route) | manual_review |

### mothi-specific signal extraction

Beyond intent, extract these typed properties to write to Postgres `extracted_property`:

1. **Competitor mentioned** — parse for: Razorpay, PayU, Stripe, BillDesk, Karza, HyperVerge, Perfios, Signzy, IDfy, mothi Payments (rare but possible if forwarded externally), CCAvenue, Instamojo
2. **Specific objection cited** — verbatim quote ≤200 chars
3. **Champion signal** — phrases like "I'm pushing this internally", "have my CTO's buy-in", "this is on our roadmap"
4. **Decision-maker named** — pattern: "@<name>" or "[reach out to] <Name> our [Title]"
5. **Specific next step proposed** — "Tuesday 4pm", "next quarter", "after our renewal in March"

### mothi compliance edge cases

- **DPDP unsubscribe**: even if intent is unsubscribe, preserve the SF Lead (don't delete) — DPDP requires audit trail of consent withdrawal. Just suppress future contact.
- **RBI signals-not-scores rule**: if reply mentions "credit bureau" / "alternate data" / "scoring", mark for compliance review — never auto-respond claiming we use that data
- **TRAI DLT context**: if reply is on SMS or WhatsApp channel, frequency caps tighter

## Examples

### Good — positive intent, Tier A BFSI

**Input excerpt:**
```
"Hi Mothi, your Mobile360 NTC angle is interesting — we're actively reviewing our V-CIP stack. Could we set up 30 min next week? Tuesday 4pm IST works."
```

**Expected output:**
```json
{
  "intent": "positive",
  "confidence": 0.96,
  "objection_categories": [],
  "competitor_mentioned": "none",
  "champion_signal_present": true,
  "suggested_followup": "Confirm Tuesday 4pm IST, send Mobile360 1-pager + NTC coverage benchmark vs incumbent. Loop in SE for technical Q&A.",
  "extracted_properties": [
    {"property_name": "expansion_signal", "value": "actively reviewing V-CIP stack", "source_quote": "we're actively reviewing our V-CIP stack"},
    {"property_name": "next_step_committed", "value": "Tuesday 4pm IST meeting", "source_quote": "Tuesday 4pm IST works"}
  ],
  "routing_action": "alert_ae"
}
```

### Good — objection with competitor lock-in

**Input excerpt:**
```
"Thanks for reaching out. We just signed a 2-year deal with Razorpay last quarter so timing's bad. Maybe revisit in Q4 2027."
```

**Expected output:**
```json
{
  "intent": "not_now",
  "confidence": 0.91,
  "objection_categories": ["competitor_lock", "timing"],
  "competitor_mentioned": "razorpay",
  "champion_signal_present": false,
  "suggested_followup": "Suppress active outreach. Add to Champion-tracker watch list. Re-engage Q3 2027 with 'renewal-window' angle. Add Razorpay lock-in note to SF.",
  "extracted_properties": [
    {"property_name": "competitor_mentioned", "value": "razorpay (2-year contract)", "source_quote": "We just signed a 2-year deal with Razorpay last quarter"},
    {"property_name": "objection_raised", "value": "timing — competitor lock-in until Q4 2027", "source_quote": "Maybe revisit in Q4 2027"}
  ],
  "routing_action": "nurture"
}
```

### Good — referral

**Input excerpt:**
```
"Not me but +Anjali Mehta who runs payments engineering. Anjali, can you take this?"
```

**Expected output:**
```json
{
  "intent": "referral",
  "confidence": 0.94,
  "objection_categories": [],
  "competitor_mentioned": "none",
  "champion_signal_present": false,
  "suggested_followup": "IMMEDIATE: Create new SF Lead for Anjali Mehta (Payments Engineering); thank original contact + brief Anjali separately within 24h with context summary; do not re-engage original unless Anjali loops them in.",
  "extracted_properties": [
    {"property_name": "decision_maker_added", "value": "Anjali Mehta — Payments Engineering", "source_quote": "+Anjali Mehta who runs payments engineering"}
  ],
  "routing_action": "alert_ae"
}
```

### Bad — would mis-classify as positive

**Input excerpt:**
```
"Thanks, will check with team."
```

**WRONG:** intent: positive, confidence: 0.85
**RIGHT:** intent: unclear, confidence: 0.45 → manual_review (no commitment, no specific signal, vague-acknowledge pattern that often dies)

## Anti-patterns to avoid

- ❌ Don't classify polite-but-vague replies as positive (kills AE trust when they get false alarms)
- ❌ Don't auto-suppress on "remove" mentioned in passing — only when it's the primary intent
- ❌ Don't extract a competitor mention from generic phrases ("compared to others") — must be a named vendor
- ❌ Don't fabricate suggested_followup when intent is unclear — return "needs human review" instead
- ❌ Don't ignore the OOF return-date — parse it and pause until then; otherwise sequence resumes mid-vacation
- ❌ Don't classify unsubscribe-language combined with positive interest as positive (some prospects say "stop the cold sequence but I'd love a real call" — this is still unsubscribe-from-sequence + positive-on-meeting; route to AE manually)

## Composition rules

Always loaded with:
- `dpdp-compliance` (consent-withdrawal audit trail rules)
- `content-strategist` (for `suggested_followup` voice consistency)

Optionally loaded for richer context:
- Tier-specific outbound playbook (`enterprise-deals` / `mid-market-deals` / etc.)
- Vertical-specific competitor context (`bfsi-competitive-landscape` / `d2c-competitive-landscape`)

## Performance targets

- Latency: <1s per classification (Haiku tier required)
- Cost: <$0.001 per classification (~600 tokens average)
- Accuracy on positive intent: ≥92% (Promptfoo eval baseline)
- False-positive rate on unsubscribe: <0.5% (regulatory exposure)
