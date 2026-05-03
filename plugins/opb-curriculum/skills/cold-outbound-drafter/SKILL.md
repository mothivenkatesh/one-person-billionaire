---
name: cold-outbound-drafter
description: >
  Use this skill whenever the user wants to plan a cold outbound campaign,
  build a target list, or draft 10-100 hand-crafted cold outreach messages.
  Trigger when the user mentions phrases like "cold outbound campaign",
  "build my outbound list", "find prospects in X", "10 cold emails", "outreach
  sequence", or shares an ICP and wants prospects identified. Also trigger
  when the user has finished wedge validation and needs to start direct
  customer acquisition. Use this skill alongside [`one-to-one-email-writing`](../one-to-one-email-writing/SKILL.md)
  (which handles the message construction itself) — this skill handles the
  campaign-level work: list, sequence, channels, cadence, anti-spam discipline.
---

# Cold Outbound Drafter Skill

This skill defines the workflow for **cold outbound campaign planning** — list-building, channel selection, sequence design, and anti-spam discipline. It is the *operational wrapper* around [`one-to-one-email-writing`](../one-to-one-email-writing/SKILL.md) (which handles the per-message construction) and uses [`buying-triggers-signals`](../buying-triggers-signals/SKILL.md) to surface signals.

The skill enforces:
- **Hand-crafted only** — refuses AI-mass-generated patterns
- **Hard cap of 100 prospects** per campaign (quality over volume)
- **Multi-touch cadence** (one-and-done sends are rejected)
- **Per-prospect signal extraction** before any message
- **Anti-spam discipline** (subject lines, send timing, follow-up rules)

---

## Hard Constraints (Check First)

### Constraint 1 — Maximum 100 Prospects Per Campaign

If the user wants to send to more than 100, stop and say:

> "⚠️ More than 100 hand-crafted messages = quality drops. Either pick top 100 by ICP fit, or split into multiple campaigns. The math: 100 well-crafted at 8% reply > 1,000 templated at 0.5%."

If the user insists on volume, redirect to a sales engagement platform (Outreach.io, Salesloft, Apollo Sequences) — but warn that those collapse to 0.5-2% reply rates.

### Constraint 2 — Required Inputs

Before starting, confirm the user has:
- **Company X** (the seller — whose product is being pitched)
- **Wedge / ICP** (industry + role + company size — from [`wedge-finder`](../wedge-finder/SKILL.md))
- **Buying triggers** for the segment (from [`buying-triggers-signals`](../buying-triggers-signals/SKILL.md) — at minimum a category list)
- **Existing customer logos / case studies** (for social proof in messages)
- **Send-from email** (deliverability-warmed, not their main inbox)

If any are missing, ask before designing the campaign.

### Constraint 3 — Reject AI-Mass-Generation

If the user wants to bulk-generate "personalized" messages with token replacement (`{first_name}`, `{company}`), refuse:

> "Token-replaced templates have collapsed to < 0.5% reply rate in 2026 (spam classifiers caught up). The math doesn't work. We do hand-crafted + signal-led, capped at 100/campaign."

---

## Workflow Overview

```
Step 1: Define the campaign (segment + offer + goal)
Step 2: Build the list (max 100, with per-prospect signal)
Step 3: Pick the channel (email / LinkedIn / X / phone)
Step 4: Design the cadence (4-touch sequence)
Step 5: Confirm CTA style with the user (Soft / Hard)
Step 6: Hand off message construction to one-to-one-email-writing skill
Step 7: Set the send schedule + tracking spreadsheet
Step 8: Review reply rates after 14 days; iterate
```

---

## Step 1 — Define the Campaign

### Required Output Format

```
CAMPAIGN BRIEF

Name:               [internal name]
Segment:            [ICP — industry + role + size]
Goal:               [N booked demos / N replies / N closed deals]
Offer to lead with: [Grand Slam offer headline]
Differentiator:     [why us, in 1 sentence]
Trigger category:   [from buying-triggers-signals]
Time horizon:       [4 weeks default]
Send-from:          [domain + warming status]
Budget:             [list build cost + tools]
```

If any field is unclear, push back before continuing.

---

## Step 2 — Build the Target List (Max 100)

### List quality criteria

For each prospect, the row must include:
- **Name** (first + last)
- **Title** (current, verified within last 30 days)
- **Company** + domain
- **LinkedIn URL**
- **Verified email** (from [`email-waterfall-enrichment`](../email-waterfall-enrichment/SKILL.md))
- **One specific signal** (from [`buying-triggers-signals`](../buying-triggers-signals/SKILL.md))
- **Signal source URL** (proof — for the message hook)
- **Disqualified?** (Y/N — fits ICP, not a competitor, etc.)

Bad list = no message will save you. Tools (in priority order):

| Tool | Use |
|------|-----|
| **Clay** | ICP enrichment + waterfall + signal scraping (~$100-300/mo, gold standard) |
| **Apollo** | Cheaper / broader; pair with separate enrichment |
| **LinkedIn Sales Navigator** | High-quality search + saved lists |
| **Hunter.io** | Email finder for individual contacts |
| **PhantomBuster** | LinkedIn scraping for engagement signals |
| **Reddit / X scraping** | Buying-signal lists (the user's own scrapers) |
| **Pre-built lists** (via partners) | Quick start; lower quality |

### List output format

```
| # | Name | Title | Company | Domain | LinkedIn | Email | Signal | Source URL | DQ? |
|---|------|-------|---------|--------|----------|-------|--------|------------|-----|
| 1 |      |       |         |        |          |       |        |            |     |
```

Validate: bounce rate target < 2%. If your enrichment data is uncertain, run [`email-waterfall-enrichment`](../email-waterfall-enrichment/SKILL.md) first.

---

## Step 3 — Pick the Channel

| Channel | When | Reply rate (typical) | Notes |
|---------|------|---------------------|-------|
| **Personalized email** | B2B, $100+ ACV | 5-15% | Default for B2B SaaS |
| **LinkedIn DM** (Premium / Sales Nav) | Mid-market B2B | 8-20% | Better for senior buyers |
| **Twitter/X DM** (after light engagement) | Founders, indie operators | 15-30% | Warm before DM |
| **Reddit DM** (after providing value first) | Niche B2C, prosumer | 10-25% | Community-context required |
| **Cold call** | Enterprise, $10K+ ACV | 2-5% answer; 30-50% close on answer | High-friction, high-payoff |
| **Direct mail** (physical) | C-suite, very specific niche | 5-10% with clever package | Premium positioning |

For most solo agent operators at $99-999 ACV: **email + LinkedIn DM is the right starting stack.**

---

## Step 4 — Design the 4-Touch Cadence

Refuse one-and-done sends. ~50% of replies come from messages 2-4.

### Default cadence (email channel)

```
Day 0:    Initial message (signal-led; CTA: low friction ask)
Day 4:    Bump (forward original; "any thoughts?")
Day 11:   New angle (different value prop or social proof)
Day 25:   Final ("closing the loop, last note")
Day 90:   Re-engage if context changes (new round, new role, new tool adoption)
```

### Cadence for LinkedIn

```
Day 0:    Connection request with personalized note (max 200 chars)
Day 3:    First message after connection accepted
Day 10:   Second message with case study / social proof
Day 25:   Third message — direct ask
Day 60:   Re-engage if they posted relevant content
```

### Anti-spam rules

- No sends Friday afternoon → Monday morning (replies tank ~50%)
- No sends US holidays / common cultural holidays for the target market
- Vary subject lines across the cadence (don't repeat)
- Use a real person's email signature; never "no-reply"
- Keep each touch under 150 words (fall-off above)

---

## Step 5 — Confirm CTA Style

Ask the user (one question, applies to whole campaign):

> "Should the CTA across this campaign be **Soft** or **Hard**?
> • **Soft CTA** — low-friction ask, e.g., 'Mind if I share a 1-min Loom?'
> • **Hard CTA** — direct meeting ask, e.g., 'What time next Wednesday for a 15-min chat?'"

Apply consistently across the entire campaign unless the user explicitly varies.

Default for solo operators in cold outbound: **Soft on first 2 touches, Hard on touch 3+.**

---

## Step 6 — Hand Off Message Construction

For each prospect, hand off to [`one-to-one-email-writing`](../one-to-one-email-writing/SKILL.md). That skill enforces:
- 100-word body cap
- Hook ≤ 20 words
- Value prop ≤ 30 words
- Social proof = 1 sentence (real customer name)
- CTA = 1 sentence (style picked in Step 5)

Per prospect, output: subject line + body, formatted to copy-paste into Gmail / LinkedIn.

---

## Step 7 — Send Schedule + Tracking

### Required Output Format

```
SEND SCHEDULE

Week 1: Day 0 (Touch 1)
   Send window:   Tue-Thu, 9-11am [recipient timezone]
   Volume:        25 messages/day max (warmth limit)
   Day 1-3:       Send 75 messages spread across 3 days

Week 1-2: Day 4 (Touch 2 — bumps)
   Triggered:     4 days after Touch 1, no reply
   Send window:   Same as Touch 1 + 4 days

Week 2-3: Day 11 (Touch 3 — new angle)
   Triggered:     11 days after Touch 1, no reply
   Send window:   Same

Week 4: Day 25 (Touch 4 — close)
   Triggered:     25 days after Touch 1, no reply
   Send window:   Same

Day 90+: Re-engage
   Triggered:     Specific signal change (job change, funding, tool adoption)
```

### Tracking columns

```
| # | Name | Sent T1 | Replied T1 | Sent T2 | Replied T2 | Sent T3 | Replied T3 | Sent T4 | Replied T4 | Outcome |
|---|------|---------|-----------|---------|-----------|---------|-----------|---------|-----------|---------|
```

Outcomes: Booked / Not interested / No reply / Bounced / Out of office / Unsubscribed

---

## Step 8 — 14-Day Review + Iterate

After 14 days, compute:

| Metric | Your number | Benchmark |
|--------|-------------|-----------|
| Send-to-reply rate (overall) | __% | 5-15% |
| Send-to-positive-reply rate | __% | 2-7% |
| Reply-to-meeting rate | __% | 30-60% |
| Meeting-to-close rate | __% | 10-30% |
| Bounces | __% | < 2% |
| Spam complaints | __% | 0 |

Diagnose:
- Bounces > 2% → list quality problem (re-run [`email-waterfall-enrichment`](../email-waterfall-enrichment/SKILL.md))
- Reply rate < 3% → message problem (revisit [`one-to-one-email-writing`](../one-to-one-email-writing/SKILL.md) — likely hook is weak)
- Reply rate 3-5% → marginal; tune the hook + value prop
- Reply rate 5-15% → working; scale next campaign
- Reply rate > 15% → great; could you 2x volume?
- Meeting-to-close < 10% → wedge / pricing problem (NOT outbound problem)

---

## Worked Example

**Campaign:** Cold outbound for "AI bookkeeping for $1M+ Shopify sellers"

**Brief:**
- Segment: Founders / CFOs at Shopify Plus stores doing $1-10M GMV
- Goal: 5 booked demos in 4 weeks
- Offer headline: "The Audit-Proof Monthly Books Service for $1M+ E-com Brands"
- Differentiator: CPA-reviewed + 100% audit-defense guarantee
- Trigger category: Funding round + headcount growth + recent CFO hire

**List (built via Clay):**
- 78 prospects matching ICP
- All with verified email (waterfall through Apollo → Prospeo → Icypeas)
- Each with one signal: 23 just hired CFO, 18 raised in last 90 days, 37 grew headcount > 30% YoY

**Channel:** Email (founders / CFOs read email; LinkedIn slower for this segment)

**Cadence:** Default 4-touch.

**CTA style:** Soft on T1-T2, Hard on T3-T4.

**Send schedule:** Tue-Thu 9-11am Eastern. 25/day for first 3 days.

**14-day review:**
- 78 sent, 6 bounced, 9 replied (12.5% reply rate — strong)
- 5 booked demos, 2 not interested, 2 "next quarter"
- Bookings → expected 1-2 closes at $999/mo = $999-1,998 MRR new

**Iterate:** Reply rate strong; double down — 100-prospect campaign next month focused on the "just hired CFO" signal.

---

## Common Mistakes to Avoid

- **Do not send templated mass messages.** 0.5% reply rate kills CAC.
- **Do not skip the signal per prospect.** Generic = ignored.
- **Do not send one-and-done.** Half your replies come from follow-ups.
- **Do not exceed 100 hand-crafted messages per campaign.** Quality drops past 100.
- **Do not send Friday-Sunday.** Reply rate halves.
- **Do not use "Quick question" subject lines.** Universal spam trigger now.
- **Do not ask for 30-min meeting in cold message.** Too high friction.
- **Do not send from a non-warmed domain.** Goes to spam.
- **Do not skip the 14-day review.** Without iteration, the campaign degrades.
- **Do not blame "cold outbound doesn't work" if you skipped any of the above.** It works at 5-15% reply when done right.

---

## Notes on Tooling

| Need | Recommended |
|------|-------------|
| List enrichment | Clay (gold standard) |
| Email finder | Hunter / Apollo / Prospeo |
| Email validator | Reoon / NeverBounce |
| Send + tracking | Smartlead / Instantly / Lemlist / Outreach |
| LinkedIn outreach | Sales Nav + LinkedHelper / Expandi (cautiously) |
| Domain warming | Smartlead / Instantly built-in |
| CRM | HubSpot Free until $50K MRR; then upgrade |

Default solo-operator stack: Clay + Smartlead + Hunter + Sales Nav. ~$200-400/mo total.

---

## Notes on Deliverability

Don't skip these or your campaign won't even land:

- [ ] SPF, DKIM, DMARC configured for the send-from domain
- [ ] Domain has been warming for ≥ 14 days before mass send
- [ ] Send volume ramps gradually (10 → 25 → 50/day)
- [ ] Spam tested via Mail-tester.com (target score > 9)
- [ ] Unsubscribe link present (CAN-SPAM / GDPR compliance)
- [ ] Send from a separate domain from your main (in case it gets flagged)

---

## Quick Reference — Reply Rate Targets

| Channel + execution | Bad | Acceptable | Strong |
|---------------------|-----|------------|--------|
| Cold email, hand-crafted | < 2% | 5-8% | 10-15% |
| LinkedIn DM, Sales Nav | < 5% | 8-15% | 20%+ |
| Twitter DM, after engagement | < 10% | 15-25% | 30%+ |
| Reddit DM, after value | < 8% | 10-20% | 25%+ |
| Cold call (answered → close) | < 5% | 15-25% | 35%+ |

If your numbers are below "Bad" — diagnose the campaign before scaling.

---

## Source

Lesson 10: [Cold Outbound for AI Products](../../10-cold-outbound/README.md)
