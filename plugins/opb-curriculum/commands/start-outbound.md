---
description: Run a 100-prospect cold outbound campaign end-to-end. Chains buying-triggers-signals + email-waterfall-enrichment + cold-outbound-drafter + one-to-one-email-writing.
argument-hint: "<seller company X + ICP segment + wedge>"
---

# /start-outbound — Plan + draft a 100-prospect cold campaign

Chains 4 skills into a complete cold outbound campaign — from finding signals to sending hand-crafted messages.

## Prerequisites

- A Grand Slam offer (from `/build-offer`)
- Defined ICP (from `/find-wedge`)
- A warm send-from email (≥ 14 days warming)

## Workflow

### Step 1: Find the buying signals

Activate [`buying-triggers-signals`](../skills/buying-triggers-signals/SKILL.md).

- Ingest company X (the seller) context
- Run ICP skill (industries + countries — skip TAM)
- Research signals across 10 categories: People, Company, Industry, Strategic, Competitor, Engagement, Technographic, Hiring, Event-based, Financial
- Validate every signal is relevant to THIS company
- Output: 10-15 row signal table

### Step 2: Build the prospect list (max 100)

Use the signals from Step 1 to identify 100 prospects matching the ICP. Tools:
- Clay (gold standard for ICP enrichment)
- LinkedIn Sales Navigator
- Apollo
- The user's own scrapers (tweet-harvest, reddit-scraper, peerlist)

Each prospect needs: name + title + company + LinkedIn + ONE specific signal + signal source URL.

### Step 3: Enrich emails via waterfall

Activate [`email-waterfall-enrichment`](../skills/email-waterfall-enrichment/SKILL.md).

- Hard constraint: max 10 contacts per waterfall run (run multiple batches if needed)
- Sequence: Apollo → Prospeo → Icypeas → Leadmagic, with Reoon validation between each
- Enrichley safe-to-send check on Leadmagic catch-alls
- Output: verified emails for all 100 (target ≥ 80% find rate)

### Step 4: Plan the campaign

Activate [`cold-outbound-drafter`](../skills/cold-outbound-drafter/SKILL.md).

- Design the 4-touch cadence (Day 0 / 4 / 11 / 25)
- Pick the channel (email + LinkedIn DM)
- Confirm CTA style with user (Soft on T1-T2, Hard on T3-T4 default)
- Plan send schedule (Tue-Thu 9-11am, max 25/day)
- Output: tracking spreadsheet template

### Step 5: Draft each message

For each prospect, activate [`one-to-one-email-writing`](../skills/one-to-one-email-writing/SKILL.md).

- 100-word body cap; hook ≤ 20 words; value prop ≤ 30 words
- Use the signal from Step 1 as the hook
- Find competitor-of-prospect that's a customer of seller (real social proof)
- CTA per the style picked in Step 4
- Output: subject + body per prospect, ready to send

## After this command

- Send T1 over Tue-Thu (3 days, ~33 messages/day)
- Wait, send T2-T4 per cadence
- After 14 days, review reply rate vs benchmarks (target 5-15%)
- If reply rate ≥ 5% → run again next month with 100 more
- If reply rate < 3% → don't blame outbound; diagnose hook quality first

## Refusal conditions

- > 100 prospects per campaign → refuse; quality drops past 100
- AI-generated mass-personalization templates → refuse
- One-and-done sends → refuse; 4-touch minimum
- No verified email per prospect → refuse to send (bounce rate kills sender reputation)
- "Quick question" subject lines → refuse
