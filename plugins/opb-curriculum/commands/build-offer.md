---
description: Construct a Grand Slam offer Hormozi-style and price it for max margin. Chains grand-slam-offer + pricing-tripler.
argument-hint: "<your validated wedge + customer pain + current pitch>"
---

# /build-offer — Build the Hormozi Grand Slam offer + price it

Chains 2 skills to take a validated wedge and produce an offer so good prospects "feel stupid saying no" — at the right price.

## Prerequisites

- Validated wedge from `/find-wedge` (or otherwise)
- ≥ 1 paying customer for the manual / concierge version (proves willingness-to-pay)

## Workflow

### Step 1: Construct the Grand Slam offer

Activate the [`grand-slam-offer`](../skills/grand-slam-offer/SKILL.md) skill.

- Audit the crowd before the offer (confirm Starving Crowd score ≥ 25/40)
- Extract the Dream Outcome (in customer's voice, not yours)
- Score the current Value Equation
- List 10 problems → convert to 10 solutions
- Stack into ONE offer
- Build the bonus stack (5-10× perceived value of price)
- Pick the right guarantee (Conditional + Outcome combo for AI products)
- Name it using MAGIC formula
- Output: filled offer canvas + Value Equation re-score

### Step 2: Price it

Activate the [`pricing-tripler`](../skills/pricing-tripler/SKILL.md) skill.

- Apply the death-trap test (reject per-token / free-trial-no-CC / free-forever)
- Pick the right pricing model (per-seat / capped usage / value-based)
- Apply the 5-question test → recommend a 2-3× raise if applicable
- Set the new price with annual discount
- Plan the test: quote new price to next 5 prospects

## After this command

- `/start-outbound` — get the offer in front of prospects
- Track: did close rate improve 2-5× as Hormozi predicts?
- After 14 days, run the [`value-equation-worksheet`](../templates/value-equation-worksheet.md) weekly

## Refusal conditions

- Crowd score < 25/40 → refuse to build offer; send user back to `/find-wedge`
- Bonus stack value < 5× price → loop back; force more bonuses
- "AI [thing]" as offer name → refuse; force MAGIC naming
- Price below manual workaround cost → refuse; raise
