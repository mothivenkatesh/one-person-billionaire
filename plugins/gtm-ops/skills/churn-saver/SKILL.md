---
name: churn-saver
description: CSM-grade save brief generator for at-risk Cashfree merchants. Composite churn signal (usage drop + ticket sentiment + competitor mention + low NPS) + verbatim transcript evidence → 5-section save brief with talking points, draft outreach, objection pre-empt, escalation criteria. Tier-routed: CSM Slack for high-value (>₹10L/mo), MoEngage save journey for SMB.
version: 0.1.0
owner: cs@cashfree.com
status: draft
depends_on: [content-strategist, follow-up-email, story-email-campaign, psy-trigs, dpdp-compliance]
tested_with: claude-opus-4-7
loads_for_agents: [cf-churn-saver]
---

# cf-churn-saver — Cashfree merchant save-brief generator

## When to use this skill

Load when the Churn-Saver agent (daily 6am cron) flags a merchant with composite churn-risk score ≥3.0 and needs to:
- Diagnose why they're at risk (citing 2+ specific evidence items by date)
- Generate top 3 talking points for the CSM call
- Draft a 3-line check-in message (WhatsApp + email format)
- Pre-empt the most likely objection
- Set escalation criteria (when to involve VP CS)

Invoked by:
- `cf-churn-saver` agent (daily 6am cron + Google Forms NPS webhook)

This is a **revenue-defensive skill**: saving a single ₹50L/mo merchant from churn = 50× the cost of running this agent for a year.

## Inputs expected

```json
{
  "merchant": {
    "account_id": "string",
    "name": "string",
    "vertical": "bfsi | d2c | saas | marketplace",
    "tier": "A | B | C | plg",
    "monthly_revenue_inr": 0,
    "tenure_days": 0,
    "primary_csm_email": "string",
    "primary_contact": {"name": "string", "title": "string", "persona": "founder | cfo | cto | head_of_ops | other"}
  },
  "churn_signals": {
    "usage_drop_pct_14d": 0.0,
    "support_ticket_sentiment_30d": "negative | neutral | positive | mixed",
    "support_ticket_count_30d": 0,
    "support_escalations_30d": 0,
    "nps_score_latest": "int | null (0-10 if available)",
    "nps_response_text": "string | null",
    "in_app_session_drop_pct_14d": 0.0,
    "moengage_engagement_drop_pct_30d": 0.0
  },
  "transcript_evidence": [
    {
      "property_name": "churn_risk_phrase | competitor_mentioned | objection_raised",
      "value": "string",
      "source_quote": "string ≤200 chars (verbatim)",
      "extracted_at": "ISO8601",
      "transcript_id": "string"
    }
  ],
  "save_history": {
    "similar_merchants_at_risk_last_365d": "int",
    "save_rate_pct_for_similar": 0.0,
    "best_save_tactics": ["array of strings — what worked for similar"]
  },
  "competitor_mentioned_recent": "razorpay | payu | stripe | billdesk | none | unknown",
  "renewal_date": "ISO8601 | null"
}
```

## Outputs expected

```json
{
  "risk_severity": "P0 | P1 | P2",
  "save_brief": {
    "diagnosis": "1-line cited diagnosis (must reference 2 specific evidence items by date)",
    "top_3_talking_points": ["array of 3 bullet points, AE-grade not marketing copy"],
    "draft_check_in_message": {
      "whatsapp": "string ≤160 chars (BSP template-compatible)",
      "email_subject": "string ≤45 chars",
      "email_body": "string ≤80 words"
    },
    "likely_objection_to_preempt": {"objection": "string", "preempt_response": "string ≤40 words"},
    "escalation_criteria": "string — when to loop in VP CS / VP Sales / Founder"
  },
  "recommended_action_per_tier": {
    "tier_specific_action": "csm_slack_alert | moengage_save_journey | both | exec_intervention",
    "auto_send_allowed": "bool — true only for SMB tier; high-value always requires CSM HITL"
  },
  "expected_save_probability_pct": 0.0
}
```

## Body — save logic

### Severity tiers

| Severity | Trigger | Treatment |
|---|---|---|
| **P0** | Usage drop >70% AND competitor mentioned in last 30d AND tenure >90d | Same-day CSM call + VP CS notified within 4h |
| **P1** | Usage drop 30-70% OR (competitor mention OR negative NPS ≤6) | CSM brief delivered same morning, action within 48h |
| **P2** | Usage drop 15-30% OR support sentiment turning negative | CSM-aware via daily digest; soft re-engagement via MoEngage save journey |

### The 5-section brief structure (mandatory in this exact order)

1. **Diagnosis** — 1 line. Format: "Risk driven by {evidence_1 dated YYYY-MM-DD} + {evidence_2 dated YYYY-MM-DD}; pattern matches {save_history precedent}."
2. **Top 3 talking points** — bullets. Must be CSM-callable (not marketing). Each leads with a question to open dialogue, not a statement.
3. **Draft check-in message** — WhatsApp (≤160 chars) + email (≤80 words). Tone: warm, low-pressure, no marketing-speak. Reference 1 specific thing that prompted the outreach (vague "wanted to check in" is forbidden).
4. **Likely objection + preempt** — based on the cited evidence. Most common objections: pricing pushback, capability gap (specific feature), competitor switch consideration, integration complexity. Preempt = 1 sentence that defuses without being defensive.
5. **Escalation criteria** — when to escalate beyond CSM. Specific trigger conditions, not "if it gets worse".

### Cashfree-specific objection preempts

| Likely objection | Pre-empt response (rephrase per merchant context) |
|---|---|
| "Razorpay is cheaper on MDR" | "Domestic MDR delta is 0.05-0.10%; the cross-border + reconciliation hours saved usually offset by 4-6× — let's pull your last 90d numbers together." |
| "We need [feature X] which Cashfree doesn't have" | "Verify if it's actually missing or roadmap — bring SE for technical Q&A. Most 'missing' features are config-not-default." |
| "Onboarding has been slow — long support response times" | "Acknowledge specifically + escalate to dedicated CSM channel + offer named PM ownership for next 30 days." |
| "We're consolidating vendors / cutting costs" | "Bundle conversation: Payments + Payouts + Secure ID at single contract usually cuts total spend; let me model your scenario." |
| Competitor outreach offered them a discount | "Don't match-on-price; lead with reliability SLA + reference 1 peer-merchant who switched and came back." |

### Save tactics ranked by historical success (from save_history input)

In CSM Slack alert, surface the best-2 tactics from save_history that match this merchant's profile:

- **Pricing flex** — 1-quarter discount or pause on overage charges (CFO/CRO approval needed beyond 10%)
- **Dedicated PM ownership** — name a specific person from product team who owns their feedback for 90 days
- **Roadmap commitment** — share a specific upcoming release date that addresses their gap
- **Exec intervention** — Founder-to-Founder call (only for top-tier accounts, >₹50L/mo)
- **Bundle restructure** — re-architect their contract to cross-sell-then-discount overall
- **Reference call** — peer-merchant who solved the same problem on Cashfree
- **Feature whitelist** — give them early access to a beta feature relevant to their pain

### When to escalate

Populate `escalation_criteria` based on these triggers:

- `monthly_revenue_inr >= ₹50L AND severity = P0` → escalate to VP CS within 4h, Founder within 24h
- `competitor_mentioned_recent = razorpay AND renewal_date within 60 days` → VP Sales + Founder; this is a high-stakes save
- `support_escalations_30d >= 3` → engage VP Engineering on the technical side
- `transcript_evidence cites public-pattern complaint` (something they might post on G2/X) → VP Marketing + brand-protection workflow
- `tenure_days < 90 AND P0 severity` → onboarding failure; loop in VP Onboarding

### Tier-routing decision matrix

| Monthly revenue | Severity | Action |
|---|---|---|
| ≥ ₹50L | P0 | exec_intervention (Founder-led call) + CSM brief in parallel |
| ≥ ₹10L | P0/P1 | csm_slack_alert (same-day human touch) + MoEngage parallel for digital surround |
| ≥ ₹10L | P2 | csm_slack_alert (next-day) only |
| < ₹10L | P0/P1 | both (CSM gets the brief; auto-MoEngage save journey fires immediately) |
| < ₹10L | P2 | moengage_save_journey only (auto-send allowed) |

`auto_send_allowed = true` only when `monthly_revenue_inr < ₹10L`. High-value accounts always require CSM human approval before any merchant-facing send.

## Examples

### Good — P0 D2C high-value with competitor signal

**Input excerpt:**
- D2C cosmetics merchant, ₹47L/mo revenue, 18 months tenure
- Usage drop 14d: -55%, in-app session drop: -68%
- Support ticket sentiment 30d: negative; 4 tickets, 2 escalations
- NPS 3 days ago: 4/10 with text "Considering Razorpay; webhooks have been unreliable for 3 weeks"
- Transcript evidence (last call 5 days ago): "We've been talking to Razorpay" (verbatim from VP Eng)
- Renewal date: 47 days

**Output:**
```json
{
  "risk_severity": "P0",
  "save_brief": {
    "diagnosis": "Risk driven by webhook reliability complaints (NPS text 2026-04-22) + explicit Razorpay competitor mention (call transcript 2026-04-22); 14d usage -55%, session -68% suggests technical-frustration → switch consideration. Renewal in 47 days makes timing acute. Pattern matches 6 of 9 saved D2C accounts last year (rate 67%).",
    "top_3_talking_points": [
      "Open with: 'I saw the NPS feedback on webhooks — wanted to call before anything else; what's been happening on your end?' (no defense, just listening)",
      "Bring specific data: pull last 30d webhook delivery rate from our infra logs + offer named SE ownership for 30-day reliability sprint",
      "Acknowledge the Razorpay conversation directly: 'Heard you're talking to them — totally fair to evaluate; what we'd hate is for you to switch over a fixable issue.' Then ask what they need to see fixed in the next 30 days to stay."
    ],
    "draft_check_in_message": {
      "whatsapp": "Rohan — saw your NPS feedback on webhooks. I'd like to talk before anything else; can we do 20 min today or tomorrow? — Mothi, Cashfree",
      "email_subject": "Re: webhook reliability — quick call?",
      "email_body": "Rohan, saw the NPS feedback about webhook reliability over the last 3 weeks. Before anything else, want to understand what's been happening — and to share what I'm seeing on our infra side. 20 min today or tomorrow? Pulling the delivery-rate data on our end so the conversation is concrete. — Mothi"
    },
    "likely_objection_to_preempt": {
      "objection": "Razorpay-is-considering: 'We're already too far into Razorpay conversations'",
      "preempt_response": "Acknowledge their right to evaluate; offer a 30-day reliability sprint with named SE ownership + give them a specific reliability SLA we'll commit to in writing. Don't price-match."
    },
    "escalation_criteria": "If Rohan doesn't accept the call within 48h: escalate to VP CS for personal outreach. If renewal-discussion happens within 30d without resolution: loop in Founder for peer-to-peer call. If Razorpay sends formal proposal: VP Sales + Founder same day."
  },
  "recommended_action_per_tier": {
    "tier_specific_action": "exec_intervention",
    "auto_send_allowed": false
  },
  "expected_save_probability_pct": 55.0
}
```

### Good — P2 SMB auto-saved via MoEngage

**Input excerpt:**
- Small D2C merchant, ₹3L/mo, 8 months tenure
- Usage drop 14d: -22%, no support tickets, no NPS, no competitor mention
- Transcript evidence: empty

**Output:**
```json
{
  "risk_severity": "P2",
  "save_brief": {
    "diagnosis": "Mild usage drop -22% over 14d; no support escalations, no NPS signal, no competitor mention. Likely seasonal (D2C cosmetics dip) rather than churn intent. Pattern matches Q2 D2C SMB cyclical drop.",
    "top_3_talking_points": [
      "(SMB tier — no CSM outreach needed; MoEngage handles)",
      "(SMB tier — no CSM outreach needed; MoEngage handles)",
      "(SMB tier — no CSM outreach needed; MoEngage handles)"
    ],
    "draft_check_in_message": {
      "whatsapp": "Hi — noticed your transaction volume dipped a bit recently. Anything we can help with on our end? Reply STOP to opt out.",
      "email_subject": "Quick question — everything okay?",
      "email_body": "Hi — noticed your Cashfree transaction volume dipped a bit over the last 2 weeks. If there's anything on our end (reconciliation, settlement, dashboard) that's getting in the way, hit reply and we'll loop in support. Otherwise no action needed — just wanted to check in."
    },
    "likely_objection_to_preempt": {
      "objection": "No engagement — automated message ignored",
      "preempt_response": "Expected for SMB; if no response in 14 days, demote to long-term nurture and re-evaluate at next renewal."
    },
    "escalation_criteria": "Escalate to CSM only if usage drop deepens past -50% OR a support ticket gets opened in next 30d."
  },
  "recommended_action_per_tier": {
    "tier_specific_action": "moengage_save_journey",
    "auto_send_allowed": true
  },
  "expected_save_probability_pct": 35.0
}
```

## Anti-patterns to avoid

- ❌ Generic save brief without specific dates/quotes ("they seem unhappy")
- ❌ Auto-sending merchant-facing messages for high-value accounts (always CSM HITL)
- ❌ Defending the product in talking points instead of opening with a question
- ❌ Price-matching as a save tactic (race-to-bottom; talk reliability/value)
- ❌ Mentioning competitor name in the merchant-facing message ("we know you're talking to Razorpay" is presumptuous; let them bring it up)
- ❌ Recommending Founder intervention for sub-₹10L accounts (Founder time scarcity)
- ❌ Skipping escalation_criteria — always populate, even if it's "no escalation needed unless X"

## Composition rules

Always loaded with:
- `content-strategist` (voice for the draft message)
- `follow-up-email` (2-touch cap)
- `story-email-campaign` (when the save is best framed as "I've seen this story before, here's what happened")
- `psy-trigs` (Cialdini reciprocity for the save — give them something before asking for the renewal)
- `dpdp-compliance` (frequency caps, opt-out language)

Vertical-specific:
- `bfsi-competitive-landscape` (BFSI churns differently — usually compliance-related)
- `d2c-india-context` (D2C is most price-sensitive)
- `saas-india-context` (SaaS churns are usually integration-debt-related)

## Performance targets

- Latency: <8s (Opus required for save brief quality)
- Cost: <$0.05 per brief
- Save rate target on P0 cases: 35%+ (vs ~10% baseline without agent)
- Razorpay benchmark to beat: their retention uplift was +25% (MoEngage case study) — Cashfree target +28%
