---
description: Find a profitable wedge end-to-end — score candidates, identify ICP/TAM, validate the riskiest assumption. Outputs a recommended wedge ready for offer construction.
argument-hint: "<your situation: industry interest, past job, unfair access, OR list of candidate wedges>"
---

# /find-wedge — Discover a profitable wedge end-to-end

Chains 3 skills into one workflow that takes you from "what should I build?" to "validated wedge with one paying customer."

## Workflow

### Step 1: Score the candidates

Activate the [`wedge-finder`](../skills/wedge-finder/SKILL.md) skill.

- Force the user to provide 1-5 candidates (kills "AI for everyone" framing)
- Apply anti-wedge filter (kills veto-list candidates)
- Score on internal 7-attribute matrix + Hormozi's 4-attribute Starving Crowd
- Apply 100-customer reachability check
- Output: ONE recommended wedge

### Step 2: Identify ICP + size the market

If the user confirms the recommended wedge, activate [`icp-tam-research`](../skills/icp-tam-research/SKILL.md):

- Build the Ideal Customer Profile (industries + sub-industries + company size + geographies)
- Get user confirmation on ICP (mandatory gate — never skip)
- Calculate TAM via Apollo (credit-safe — read-only company counts only)
- Output: ICP + TAM in segments

### Step 3: Test the riskiest assumption

If the ICP is confirmed, activate [`riskiest-assumption-tester`](../skills/riskiest-assumption-tester/SKILL.md):

- List 5 assumptions; score risk × test cost
- Force the willingness-to-pay test (Mom-Test interviews + concierge MVP)
- Apply the "$100 in 7 days" gate
- Apply the 5-question gate before code-writing
- Output: BUILD / VALIDATE FIRST verdict + concrete next test

## After this command

Once the wedge is validated and you have ≥ 1 paying customer for the manual version:

- `/build-offer` — construct the Grand Slam offer (Hormozi-style)
- `/start-outbound` — get to first 10 customers via cold outbound
- Then **Lesson 08** — ship the smallest paid software thing

## Refusal conditions

- If the user has < 5 candidate wedges and won't generate more → push back, don't proceed
- If all candidates are killed by veto rules → loop back to Step 1, don't recommend a weak wedge
- If TAM ICP is rejected by user → loop back to wedge-finder, don't proceed to riskiest-assumption
- If validation fails (no $100 paying concierge customer) → loop back; do NOT bless code-writing
