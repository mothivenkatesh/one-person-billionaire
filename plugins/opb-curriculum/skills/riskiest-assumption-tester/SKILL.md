---
name: riskiest-assumption-tester
description: >
  Use this skill whenever the user has a wedge (or product idea) and wants to
  validate it before writing code. Trigger when the user mentions phrases like
  "should I build this?", "validate this idea", "what's my MVP?", "how do I
  know people will pay?", "Mom Test", "concierge MVP", "willingness to pay",
  or has just finished wedge-finder and is unsure whether to build. Always
  use this skill BEFORE first-paid-thing-planner — it enforces the
  willingness-to-pay test, refuses to bless code-writing without 5 paying
  conversations, and forces the manual concierge MVP path.
---

# Riskiest Assumption Tester Skill

This skill defines the workflow for **identifying and testing the single assumption that, if false, kills the business** — and refuses to let the user write code before validating willingness-to-pay. Engineers default to testing the safest assumption ("can I build it?"); this skill forces the riskiest one ("will anyone pay?").

The skill enforces:
- **Risk × Test-cost prioritization** — highest risk + lowest test cost goes first
- **Mom Test discipline** — refuses survey-based "would you pay?" questions
- **Concierge MVP requirement** — manual delivery for $$ before software
- **The "$100 in 7 days" gate** — 1 stranger, real money, fast
- **The 5-question pre-code gate** — all must be YES before writing code

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

Before testing, confirm the user has provided:
- **Wedge** (specific buyer + specific pain workflow + specific channel — from [`wedge-finder`](../wedge-finder/SKILL.md))
- **List of ≥ 3 candidate customers** they could reach this week (named, not "I'd email LinkedIn")
- **Hypothesized price** they'd charge ($)
- **Time available for validation** (typically 14-30 days)

If any are missing, ask before proceeding.

### Constraint 2 — Reject "Survey-First" Validation

If the user says "I'll send a survey" or "ask if they'd pay," refuse:

> "Surveys lie. People say they'd pay, then don't. The only valid willingness-to-pay test is **someone giving you actual money**. We'll use the Mom Test for conversations and a concierge MVP for the payment test. Never both as 'paid surveys.'"

### Constraint 3 — Refuse to Bless Code-Writing Without the 5-Question Gate

The user MUST pass all 5 gates before writing code:
1. Can name 5 specific people who feel this pain weekly
2. Talked to ≥ 10 of them; heard the pain unprompted
3. ≥ 3 said "I would pay $X for this outcome"
4. ≥ 1 paid for the manual version
5. Can name a channel to reach 100 more in 90 days

Any NO → refuse code-writing. Send the user back to fix that gate.

### Constraint 4 — Engineers' Default Trap

If the user wants to "test by building a prototype," push back hard:

> "You want to test 'can I build it?' — the safest assumption with the highest test cost. The actual riskiest assumption is 'will they pay?' That's tested by talking to 20 people and getting 1 to give you money for the manual outcome. Building the software comes AFTER that proves out."

---

## Workflow Overview

```
Step 1: List 5 assumptions (force the user — don't accept fewer)
Step 2: Score each on Risk (1-5) × Test Cost (1-5) → priority
Step 3: Design the test for the top assumption
        (Almost always: "will they pay?" — Mom Test interviews)
Step 4: Run 20 Mom-Test interviews
Step 5: Concierge MVP — deliver outcome manually for paying customers
Step 6: The "$100 in 7 days" gate
Step 7: 5-question pre-code gate
Step 8: BUILD or VALIDATE FIRST verdict
```

---

## Step 1 — List 5 Assumptions

Force the user to write down 5 things that must be true for this business to work. Common ones:

| # | Assumption | Typical kill rate |
|---|------------|-------------------|
| 1 | "People in [wedge] will pay $X for this outcome" | **70% of failures** |
| 2 | "I can find Y of them on channel Z" | 20% |
| 3 | "An LLM can do the core task accurately" | 5% |
| 4 | "Stripe / payments work in my region" | 3% |
| 5 | "I can build it in N weeks" | 2% |

Push back if user can't articulate 5. "I don't know the assumptions" = the project isn't ready for validation.

---

## Step 2 — Score Risk × Test Cost

For each assumption, score 1-5:

| Assumption | Risk if false (1-5) | Cost to test (1-5) | Priority (R × inverse-C) |
|------------|---------------------|---------------------|---------------------------|
| | | | |

**Highest Risk × LOWEST Test Cost = test first.**

The kill rates above mean #1 (willingness-to-pay) is almost always priority #1 — and it's also the cheapest test (20 conversations + 1 paid concierge).

**Engineers' trap:** they default to testing #5 (can I build it?) because it's safest. Push them back to #1.

---

## Step 3 — Design the Willingness-to-Pay Test

The Mom Test (Rob Fitzpatrick): **don't ask "would you pay for this?" — people lie**. Instead ask about the past:

| Don't ask | Ask instead |
|-----------|-------------|
| "Would you pay $X for this?" | "Tell me about the last time you had to do X." |
| "Do you like this idea?" | "What did you try before? What did it cost you?" |
| "Would this be useful?" | "Walk me through what you do when X happens." |
| "Is the price reasonable?" | "What was the worst part of your last [task]?" |

The principle: **specific past behavior > opinions about the future.** Past behavior is data; opinions are noise.

Set the bar: 20 conversations, ~30 min each. Total time: 10 hours over 2 weeks. This is the cheapest, highest-leverage validation possible.

---

## Step 4 — Run the 20 Conversations

For each conversation, capture:
- Date + name + role
- Direct quote describing the pain (verbatim — for future copywriting)
- What they tried before (revealed willingness to pay)
- What it cost them (time + money)
- Did they ask "how do I get this?" (real intent signal)
- Closing: "If I built this, can I email you when it's ready?"

After 10 conversations, pause and assess:
- Did the same pain show up unprompted ≥ 3 times? (Pattern signal)
- Did anyone ask "is there something like this?" (Pull signal)
- Did anyone offer to pay for early access? (Money signal — strongest)

If 0 of these → wedge is wrong. Stop. Re-do `wedge-finder`.

If ≥ 1 → continue to Step 5.

---

## Step 5 — Concierge MVP

Before software, deliver the OUTCOME manually for paying customers. Examples:

| Wedge | Concierge MVP |
|-------|---------------|
| AI lease analyzer | You read the lease yourself in Claude chat; send PDF; charge $99 |
| AI content briefs | Write briefs in Claude; send Google Doc; charge $200/mo |
| AI bookkeeping | Categorize manually in spreadsheet; send weekly P&L; charge $300/mo |
| AI cold outbound | Hand-craft messages in Notion; send via your Gmail; charge $400/mo |
| AI lead enrichment | Look up each lead manually in Apollo + LinkedIn; deliver CSV; charge $5/lead |

Refuse "but it would be easier to build the software first":

> "Easier for YOU. The point isn't ease; it's testing whether anyone will pay. If you can't sell the manual version, the software won't sell either. The software just makes it cheaper for you, not more valuable for them."

---

## Step 6 — The "$100 in 7 Days" Gate

Can the user get **1 stranger** (not a friend, not a colleague) to pay **$100** for the outcome (not the software) within **7 days**?

If yes → strong signal. Continue.
If no → diagnose:
- Wedge wrong (they don't have the pain you think they do) → re-do `wedge-finder`
- Channel wrong (you can't reach the right people) → revisit channel in `wedge-finder`
- Pitch wrong (you reach them but the offer doesn't land) → run [`grand-slam-offer`](../grand-slam-offer/SKILL.md)

Don't push harder; diagnose which.

---

## Step 7 — The 5-Question Pre-Code Gate

ALL must be YES before writing code:

```
1. Can I name 5 specific people who feel this pain weekly?       ☐ Y / ☐ N
2. Have I talked to ≥ 10 and heard the pain unprompted?           ☐ Y / ☐ N
3. Have ≥ 3 said "I would pay $X for this outcome"?               ☐ Y / ☐ N
4. Has ≥ 1 actually paid for the manual concierge version?        ☐ Y / ☐ N
5. Do I know the channel to reach 100 more in 90 days?            ☐ Y / ☐ N
```

Any N → refuse to bless code-writing. Send back to fix that gate.

5/5 Y → BUILD. The code-writing is justified; you've earned it.

---

## Required Output Format

```
### 🎯 Riskiest Assumption Test — [Wedge]
**Date:** [today]

### Step 1: Assumption Inventory

| # | Assumption | Risk (1-5) | Test cost (1-5) | Priority |
|---|------------|------------|-----------------|----------|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |
| 4 | | | | |
| 5 | | | | |

**Top assumption to test:** [name + reasoning]

### Step 2: Test Design

**Test type:** [Mom Test interviews / Concierge MVP / List + outreach]
**Test budget:** [X hours + $Y]
**Test window:** [start date — end date]
**Pass criteria:** [specific number — e.g., "≥ 3 of 20 say they would pay $X"]
**Fail criteria:** [specific number — e.g., "≤ 1 of 20 mentions the pain unprompted"]

### Step 3: Mom Test Interview Plan

Target: 20 conversations in 14 days
Channel: [where you'll find them]
Ask script:
1. "Tell me about the last time you had to [pain workflow]."
2. "What did you try before? What did that cost you?"
3. "Walk me through what you do when [trigger event] happens."
4. "What's the worst part of [related task]?"

### Step 4: Concierge MVP Spec (post-conversations)

Outcome you'll deliver manually: [1 sentence]
Price: $___
Delivery method: [email / Google Doc / Notion / etc.]
Time to deliver per customer: [N hours]
Target paying concierge customers: [≥ 1 in 7 days]

### Step 5: 5-Question Pre-Code Gate

| # | Gate | Status |
|---|------|--------|
| 1 | 5 specific people named | ☐ |
| 2 | ≥ 10 conversations, pain unprompted | ☐ |
| 3 | ≥ 3 said they'd pay $X | ☐ |
| 4 | ≥ 1 paid concierge version | ☐ |
| 5 | Channel to reach 100 more in 90 days | ☐ |

**Verdict:** [BUILD / VALIDATE FIRST] — based on gate count
```

---

## Worked Example

**User input:**
- Wedge: AI lease analyzer for FL real estate paralegals
- 3 candidate customers: paralegal at Hartman Title; paralegal at Berkshire Real Estate; paralegal at FL Title Co (all from user's prior internship network)
- Hypothesized price: $99/lease
- Time: 21 days

**Step 1 — Assumptions:**
| # | Assumption | Risk | Test cost | Priority |
|---|------------|------|-----------|----------|
| 1 | FL paralegals will pay $99/lease for clause analysis | 5 | 1 (just ask) | **Test first** |
| 2 | I can find 100 FL paralegals on FL Bar Slack + LinkedIn | 3 | 1 (try this week) | Test second |
| 3 | An LLM can identify "unusual clauses" accurately | 3 | 2 (4-hour spike) | Test third |
| 4 | Stripe works for FL service businesses | 1 | 1 (read docs) | Don't bother |
| 5 | I can build a Streamlit app in 2 weeks | 1 | 5 (huge effort) | Don't bother |

**Top assumption:** #1, willingness-to-pay.

**Step 2 — Test Design:**
- Type: Mom Test interviews + Concierge MVP
- Budget: 12 hours of conversations + 4 hours of concierge delivery
- Window: 21 days
- Pass: ≥ 3 of 20 say they'd pay $99/lease + ≥ 1 actually pays for manual concierge
- Fail: < 3 mentions of clause-checking pain unprompted

**Step 3 — Mom Test Plan:**
- Target: 20 paralegals in 14 days
- Channel: FL Bar Slack DM + LinkedIn from internship network
- Script (above)

**Step 4 — Concierge MVP:**
- Outcome: "I'll review your next lease in Claude and send you a PDF flagging the 3 most unusual clauses with risk explanation"
- Price: $99/lease (one-off)
- Delivery: PDF emailed within 24 hours
- Time per: 1 hour (Claude does most work; user writes summary)

**Step 5 — Pre-Code Gate (Day 21):**
| # | Gate | Status |
|---|------|--------|
| 1 | 5 named people | ✅ (12 named after outreach) |
| 2 | ≥ 10 convos | ✅ (18 conversations done) |
| 3 | ≥ 3 said pay $X | ✅ (7 said yes) |
| 4 | ≥ 1 paid concierge | ✅ (3 paid for manual review) |
| 5 | Channel to reach 100 | ✅ (FL Bar Slack = 1,200 members) |

**Verdict: BUILD.** All 5 gates passed. Now proceed to [`first-paid-thing-planner`](../first-paid-thing-planner/SKILL.md).

---

## Common Mistakes to Avoid

- **Surveys instead of conversations.** People lie on surveys. Talk to humans.
- **Asking "would you pay?"** Force past behavior questions instead.
- **Concierge with friends/colleagues.** Friends pay out of pity. Need strangers.
- **Building a prototype to "validate."** That tests "can I build" not "will they pay."
- **Skipping the gate.** Most failed projects skipped the 5-question gate; the founder convinced themselves it was OK.
- **Calling 5 conversations "enough."** 20 is the floor. 5 = noise.
- **Free trial as proxy for paying.** Free users teach you nothing about price.
- **Letting the timeline slip.** 14-30 days. If it takes 3 months, you're avoiding.
- **Over-validating.** After 5/5 gates passed, BUILD. Don't keep validating; build.
- **"My friend says it's a great idea" as signal.** Friend opinions aren't signal.

---

## Notes on Tooling

| Need | Tool |
|------|------|
| Conversations | Calendly + Zoom + Loom (record with permission) |
| Note-taking | Grain (auto-record + transcribe) or Notion / paper |
| Quote capture | Tag + clip in your note tool — direct quotes are gold for marketing copy later |
| Reach the channel | Sales Navigator / industry Slack / Reddit DM (with value-first comments) |
| Concierge MVP | Stripe Payment Link (zero code) + Google Docs / PDF for delivery |
| Tracking | Single Notion table: Name / Date / Pain quote / Asked-to-pay-Y/N / Paid-Y/N |

---

## The Mom Test Quick Reference

The 3 rules (Rob Fitzpatrick):
1. **Talk about their life, not your idea.** Past behavior, not future opinions.
2. **Ask about specifics in the past, not generics in the future.** "Last time you did X" beats "would you do X?"
3. **Talk less, listen more.** They should do 80% of talking.

Bad questions (almost always lie):
- "Would you pay for X?"
- "Do you like this?"
- "Is this useful?"
- "What do you think of this idea?"

Good questions (capture truth):
- "Tell me about the last time you [task]."
- "What did you try before? What did that cost you?"
- "Walk me through what happens when [trigger]."
- "What's the worst part of [related task]?"
- "What other options have you considered?"

---

## Quick Reference — The 5-Question Pre-Code Gate

You may NOT write code until ALL 5 are YES:

1. ☐ 5 specific people named (who feel this pain weekly)
2. ☐ 10+ conversations completed (heard pain unprompted)
3. ☐ 3+ said "I'd pay $X for this outcome"
4. ☐ 1+ paid for the manual / concierge version
5. ☐ Channel to reach 100+ more in 90 days

Any NO → loop back; do that work first.

---

## Source

Lesson 06: [The Riskiest Assumption Test](../../06-riskiest-assumption-test/README.md)

Pairs with:
- [`wedge-finder`](../wedge-finder/SKILL.md) — find the wedge before testing
- [`first-paid-thing-planner`](../first-paid-thing-planner/SKILL.md) — only AFTER 5/5 gates pass
- [`grand-slam-offer`](../grand-slam-offer/SKILL.md) — use if "will they pay?" fails on weak offer
- [`buying-triggers-signals`](../buying-triggers-signals/SKILL.md) — for the validation outreach
