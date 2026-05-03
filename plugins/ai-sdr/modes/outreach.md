# Mode: Outreach Generation

> Triggered after prospect research completes with quality >= Medium.
> Requires: `_shared.md` + `_config.md` + research output loaded in context.

---

## Inputs
- Full prospect research output (from `research.md`)
- ICP vertical and classification
- Pain points (3)
- Research quality score

## Process

### Step 1: Vertical-Adapted Framing

Before writing any copy, select the framing based on vertical + classification:

| Vertical | Decision Maker Frame | Influencer Frame | Manager Frame |
|----------|---------------------|-----------------|--------------|
| HR | ROI of engagement → retention savings | Consolidating fragmented feedback tools | Saving 10+ hrs/week on manual survey admin |
| Education | Accreditation + enrollment impact | Single platform replacing 3-4 tools | Student feedback without survey fatigue |
| Technology | Churn reduction → revenue impact | Product feedback loop acceleration | CX measurement without engineering lift |
| Travel | NPS → loyalty program revenue | Unified passenger experience data | Crew feedback without paper forms |
| Hospitality | Brand consistency → RevPAR impact | Cross-property benchmarking | Guest feedback that's actually actionable |
| Fitness | Member retention → LTV increase | Replacing spreadsheet tracking | Class/trainer feedback in 2 minutes |
| Restaurants | Location consistency → brand protection | Multi-location quality dashboards | Customer feedback without slowing service |
| Banking | Trust measurement → deposit retention | Compliance reporting automation | Digital experience feedback integration |

### Step 2: Generate Email Variants

**Email 1: Recent Activity Hook**

```
Subject: [Reference specific event/post/achievement — max 60 chars]

[Opening: 2-3 sentences connecting their specific recent activity to a broader insight.
 Must reference: event name, post topic, or achievement with approximate date.
 If no recent activity: use career milestone (promotion, company move, expansion)]

[Body: 2-3 sentences bridging their activity/situation to Sogolytics capability.
 Must include: one specific metric or proof point from _config.md custom_proof_points.
 Must name: their company, their vertical, a specific Sogolytics feature.]

[CTA: 1-2 sentences. Time-boxed ask ("15-minute walkthrough", "quick demo").
 Must connect to: their current initiative or challenge, not generic "let's chat".]
```

**Email 2: Company/Industry Hook**

```
Subject: [Company news or industry trend — max 60 chars]

[Opening: 2-3 sentences about a specific company event or industry trend.
 Must reference: their company name + a verifiable fact from research.
 Expansion, funding, new hire, market shift, regulatory change — anything concrete.]

[Body: 2-3 sentences aligning their vertical's pain points to Sogolytics.
 Must include: at least one pain point from the research.
 Must name: a specific Sogolytics product (SogoCX/SogoEX/SogoCore) matching their vertical.]

[CTA: 1-2 sentences. Propose showing industry-specific solution.
 Reference: their specific setup (tech stack, company size, property count, etc.)]
```

**Email 3: Peer/Competitive Hook**

```
Subject: [Industry benchmark or peer comparison — max 60 chars]

[Opening: 2-3 sentences with a relevant industry stat or peer success pattern.
 Must include: a specific number/benchmark relevant to their vertical.
 Source it from web research or Sogolytics case studies in _config.md.]

[Body: 2-3 sentences positioning Sogolytics against their specific challenge.
 Framing: "Companies at your stage" or "Teams in [vertical] are solving this by..."
 Avoid: direct competitor bashing. Focus on capability gaps they likely have.]

[CTA: 1-2 sentences focusing on competitive advantage.
 Frame as: "See how this compares to your current approach".]
```

### Step 3: Generate LinkedIn Messages

**Connection Request** (1 paragraph, max 300 chars for LinkedIn limit):
- Reference ONE specific thing: recent post, shared event, mutual connection, company news
- NO pitch. NO mention of Sogolytics. Pure relationship-building.

**Follow-up Message** (1 paragraph, max 500 chars):
- Reference the connection context
- Bridge naturally to Sogolytics
- Soft CTA: "happy to share" or "thought this might be relevant"

### Step 4: Quality Checklist

Before outputting, verify:

- [ ] No "Dear" or "Hi [Name]" openings
- [ ] No closing signatures
- [ ] Each email has exactly 3 paragraphs
- [ ] No banned phrases (see NEVER rules in `_shared.md`)
- [ ] Company name is spelled correctly
- [ ] Job title matches research
- [ ] At least one specific fact per email (not generic)
- [ ] Subject lines under 60 characters
- [ ] LinkedIn connection request under 300 characters
- [ ] Pain points referenced are from research, not generic list

### Step 5: Output

Append to the prospect's staging TSV:

```
email_1_subject	email_1_body	email_2_subject	email_2_body	email_3_subject	email_3_body	linkedin_connection	linkedin_followup
```

---

## Adaptation Rules

### When research quality is Low
- Email 1: Use career milestone hook instead of activity hook
- Email 2: Use industry trend instead of company news
- Email 3: Keep as-is (peer/competitive works with generic data)
- LinkedIn: Reference industry/vertical, not personal activity
- Flag all emails with `[LOW_RESEARCH]` tag in staging file

### When prospect has left the company
- Do NOT generate outreach
- Log: "Prospect appears to have left {company}"
- Return empty outreach fields
