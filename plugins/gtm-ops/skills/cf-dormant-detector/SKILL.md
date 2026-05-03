---
name: cf-dormant-detector
description: Re-engagement skill for accounts/merchants gone silent. Generates ONE specific reason to re-open the conversation (citing a change signal — funding/traffic/hiring), then drafts tier-aware win-back sequences (AE-grade for >₹50L accounts; MoEngage lifecycle for SMB). 30/60/90-day window-aware.
version: 0.1.0
owner: pmm@cashfree.com
status: draft
depends_on: [content-strategist, follow-up-email, story-email-campaign, psy-trigs, dpdp-compliance]
tested_with: claude-opus-4-7
loads_for_agents: [cf-dormant-detector]
---

# cf-dormant-detector — Re-engagement reason + win-back drafter

## When to use this skill

Load when the Dormant-Detector agent (weekly Tuesday 6am cron) needs to:
- Identify ONE specific reason worth re-opening the door for an account that's gone silent 30/60/90+ days
- Draft tier-aware win-back: AE-grade 1:1 email for ₹50L+ accounts, MoEngage lifecycle copy for SMB
- Decide channel and tone based on dormancy window + tier + change signal strength

Invoked by:
- `cf-dormant-detector` agent (weekly Tuesday 6am)

The principle: generic "just checking in" kills credibility. Specific "I saw X happened at your company and thought of Y" works. **No change signal = don't re-engage.**

## Inputs expected

```json
{
  "account": {
    "id": "string",
    "name": "string",
    "vertical": "bfsi | d2c | saas | marketplace",
    "tier": "A | B | C | plg",
    "monthly_potential_arr_inr": 0,
    "previous_deal_amount_inr": 0,
    "previous_deal_outcome": "lost | churned | never_closed | open_paused"
  },
  "primary_contact": {
    "name": "string",
    "title": "string",
    "persona": "cfo | cto | founder | head_of_payments | other",
    "still_at_company": true
  },
  "dormancy_window": "30_60 | 60_90 | 90_plus",
  "last_meaningful_touch": {
    "date": "ISO8601",
    "type": "demo | email_reply | meeting | proposal_sent",
    "summary": "1-line context — what was the last real engagement?",
    "outcome_at_time": "still_evaluating | objection_pricing | objection_capability | ghosted_post_demo | closed_lost"
  },
  "change_signals": [
    {
      "signal_type": "funding | traffic_spike | hiring | exec_change | product_launch | competitor_problem | regulatory",
      "observed_at": "ISO8601",
      "details": "string",
      "source": "ahrefs | crunchbase | linkedin | similarweb | g2 | news | tracxn"
    }
  ],
  "save_history": {
    "similar_dormant_revivals": "int (count of similar tier×vertical accounts revived in last 365d)",
    "best_revival_hooks": ["array of phrasings that worked"]
  }
}
```

## Outputs expected

```json
{
  "should_reengage": true,
  "skip_reason": "string | null (when should_reengage = false)",
  "reengagement_reason": {
    "primary_signal_cited": "string (which change_signal is the hook)",
    "one_sentence_reason": "string ≤200 chars"
  },
  "tier_aware_drafts": {
    "ae_email": {"subject": "string ≤55 chars", "body": "string ≤120 words", "cta": "string"} ,
    "ae_linkedin_inmail": {"subject": "string ≤55 chars", "body": "string ≤90 words"},
    "moengage_email": {"subject": "string ≤35 chars", "body": "string ≤60 words", "cta": "string"},
    "moengage_in_app_banner": "string ≤20 words",
    "moengage_whatsapp": "string ≤160 chars"
  },
  "recommended_channel": "ae_slack_alert | moengage_winback_journey | both",
  "next_signal_to_watch": "string (if no change signal worth acting on now, what should trigger next attempt?)"
}
```

## Body — re-engagement decision logic

### When to skip re-engagement (return should_reengage: false)

| Condition | Why skip |
|---|---|
| `previous_deal_outcome = closed_lost` AND `last_meaningful_touch.summary` cites a hard-no | Burnt bridge — wait at least 12 months |
| `primary_contact.still_at_company = false` | Champion left — re-engage at champion's NEW company instead (Champion-Tracker handles); don't re-engage this account through the wrong contact |
| `change_signals` is empty OR all signals are >180 days old | No fresh hook — don't waste cycles |
| Account explicitly unsubscribed from outbound (DPDP audit trail) | Legal — never re-engage |
| Recent `dpdp_concern` or `compliance_issue` extracted_property | Wait for resolution before resuming |

### Change-signal weight ranking

When multiple signals are present, lead with the strongest:

| Signal type | Weight | Why |
|---|---|---|
| **Funding round (Series B+)** | 5 (highest) | Fresh budget + 6-12mo decision window |
| **Exec change** (new VP / CFO / CTO at the function we sell to) | 5 | Re-evaluation cycle starts |
| **Regulatory event** (DPDP-related news, RBI circular hitting their vertical) | 4 | Compliance urgency creates a concrete hook |
| **Competitor problem** (competitor outage, security breach, public negative G2) | 4 | "Switching window" is open |
| **Hiring** (Head of Payments / Head of Risk / etc.) | 3 | Indicates budget + team-build = vendor evaluation |
| **Traffic spike** (>30% MoM Ahrefs) | 3 | They're scaling — payment infra strain likely |
| **Product launch** (their own — new vertical / new geo / new product) | 2 | Possible but less direct |

If TOP signal weight is < 3, consider not re-engaging this cycle (return `next_signal_to_watch` instead).

### Tier-aware drafting rules

| Tier | Window | Approach |
|---|---|---|
| **A (₹2Cr+ ARR potential)** | 30-60d | AE-grade peer-to-peer email + LinkedIn InMail. Reference signal directly. Calendar-direct CTA. |
| A | 60-90d | Same as above + offer of new deliverable (case study from peer who switched, exec roundtable invite) |
| A | 90+d | Exec-intro from VP Sales; treat as net-new lead with prior-context advantage |
| **B (₹50L-2Cr)** | 30-60d | AE-grade email; MoEngage parallel for top-of-mind |
| B | 60-90d | AE-grade email + LinkedIn InMail; pause auto-MoEngage |
| B | 90+d | Single AE attempt referencing the strongest signal; if no reply in 7 days, archive to long-term nurture |
| **C (₹5L-50L)** | All windows | MoEngage lifecycle (4-touch automated journey); no AE involvement |
| **plg (<₹5L)** | All windows | Single MoEngage win-back email; if no engagement, archive |

### The one-sentence-reason formula

The `one_sentence_reason` is the ONE line that goes into the AE Slack alert and the email opener. It must:

1. **Cite the signal** with specifics ("HDFC just hired 2 Senior Onboarding PMs — usually a stack-eval signal")
2. **Be tied to the previous conversation** ("...and our last conversation in February stalled on Karza POC bandwidth")
3. **Imply the why-now action** ("...might be worth a 15-min revisit")

### Cashfree-specific re-engagement hooks per vertical

**BFSI:**
- "RBI just clarified [DPDP-related X] — affects how Karza/HyperVerge can use bureau data"
- "Your bank just posted Senior PM Onboarding roles — that's usually a V-CIP stack re-eval signal"
- "Saw your Q3 earnings call mentioned NTC — Mobile360 has 190M coverage there"

**D2C:**
- "Your traffic spike of [X%] usually triggers a payments-infra review at this size"
- "Saw [Competitor] had an outage Tuesday — wanted to share our peer-merchant uptime SLA"
- "You just launched [international shipping / subscription product] — worth a quick chat on cross-border MDR"

**SaaS:**
- "Series B closed last month — congrats; usually a billing-stack moment too"
- "Your G2 reviews mentioned dunning — AutoPay's recovery engine might be relevant"

**Marketplace:**
- "Saw your vendor count crossed [N] — our Payouts API runs T+0 at that volume"
- "RBI's KYB clarification just dropped — Secure ID has the workflow built in"

## Examples

### Good — Tier A BFSI 60d dormant with strong hiring signal

**Input excerpt:**
- HDFC Bank, BFSI Tier A, dormant 67 days
- Last touch: Karza POC stalled per Anita Sharma (Head of Payments) "Karza is doing 1-week POC turnaround"
- Change signals: Hiring 2 Senior Onboarding PMs (LinkedIn, 12d ago, weight 3); RBI clarification on V-CIP residency rules (news, 5d ago, weight 4)
- save_history: 6 similar BFSI revivals last year, best hook = "regulatory + capacity"

**Output:**
```json
{
  "should_reengage": true,
  "skip_reason": null,
  "reengagement_reason": {
    "primary_signal_cited": "RBI V-CIP residency clarification + 2 Senior Onboarding PM hires",
    "one_sentence_reason": "RBI's V-CIP clarification + your two new Senior PM hires usually means stack re-eval — and our Mobile360 + Cashfree-managed POC removes the bandwidth blocker that stalled us in Feb."
  },
  "tier_aware_drafts": {
    "ae_email": {
      "subject": "RBI V-CIP clarification + your PM hires",
      "body": "Anita, RBI's V-CIP residency clarification last week + your two new Senior Onboarding PM hires usually point to one thing — V-CIP stack re-evaluation cycle starting. Our Feb conversation stalled on Karza POC bandwidth; we've since formalized a Cashfree-managed POC (our SE runs your sample file, delivers benchmark deck in 5 days, zero load on your team). Worth 20 min next week to compare against your current numbers? Tuesday 4pm or Thursday 2pm IST work my end.",
      "cta": "Tuesday 4pm or Thursday 2pm IST?"
    },
    "ae_linkedin_inmail": {
      "subject": "V-CIP + your PM hires",
      "body": "Anita — RBI V-CIP clarification + your 2 Senior Onboarding PM hires = usually a stack re-eval signal. Our Cashfree-managed POC runs in 5 days, zero engineering load. 20 min worth it?"
    },
    "moengage_email": null,
    "moengage_in_app_banner": null,
    "moengage_whatsapp": null
  },
  "recommended_channel": "ae_slack_alert",
  "next_signal_to_watch": "If no reply in 14 days, watch for Karza renewal date OR additional Onboarding-team hire as escalation triggers"
}
```

### Good — should skip (champion left)

**Input excerpt:**
- D2C Tier B, dormant 110 days
- Primary contact: Rohan Sharma, VP Engineering — `still_at_company: false` (left for new role per LinkedIn)

**Output:**
```json
{
  "should_reengage": false,
  "skip_reason": "Primary contact (champion) left the company. Re-engaging the account through the wrong contact will fail. Champion-Tracker should pick up Rohan at his new company instead.",
  "reengagement_reason": null,
  "tier_aware_drafts": {},
  "recommended_channel": "skip",
  "next_signal_to_watch": "When a new VP Engineering / Head of Payments is named at this account, restart with fresh discovery — don't reference the prior dead conversation."
}
```

## Anti-patterns to avoid

- ❌ Sending a re-engagement email with no specific signal cited ("just checking in" / "circling back")
- ❌ Referencing a 6-month-old change signal as if it just happened
- ❌ AE-grade email to a Tier C account (capacity overspend)
- ❌ MoEngage automated copy to a Tier A account (impersonal — they'll spot it)
- ❌ Re-engaging within 14 days of a hard "stop emailing" (DPDP risk)
- ❌ Mentioning a competitor's outage in a way that sounds gleeful (brand risk)
- ❌ Crossing more than 4 touches in a quarter (frequency cap)

## Composition rules

Always loaded with:
- `content-strategist` (voice consistency)
- `follow-up-email` (2-touch cap, nudge-not-pushy)
- `story-email-campaign` (use a story when the change signal is human-relatable, e.g., a peer's win)
- `psy-trigs` (Cialdini reciprocity / social proof for win-back)
- `dpdp-compliance` (consent/unsubscribe respect)

Vertical add-ons same as cf-cross-sell-detector.

## Performance targets

- Latency: <5s (Opus for AE-tier; Haiku for SMB MoEngage copy)
- Cost: <$0.03 average
- Revival rate: 12%+ on Tier A/B accounts with strong signals (vs 3% baseline for generic re-engagement)
- Razorpay public benchmark to beat: +19% re-engagement (MoEngage case study) — Cashfree target +22%
