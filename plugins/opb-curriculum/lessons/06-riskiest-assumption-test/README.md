# Lesson 06: The Riskiest Assumption Test

## TL;DR

Don't build the wrong thing. Before writing code, identify the **single assumption that, if false, kills the business** — and design the cheapest possible test for it. Most "MVPs" test the wrong assumption (whether you can build it) instead of the right one (whether anyone will pay).

## Core idea

```
For every product idea, list 3-5 assumptions that must be true.
For each, score: How risky? (1-5) × How costly to test? (1-5)
The one with high risk + low test cost is what you do FIRST.
```

The 3 most common assumptions, ranked by how often they kill startups:

| # | Assumption | Kill rate |
|---|---|---|
| 1 | "People will pay money to solve this" | ~70% of failures |
| 2 | "I can reach the people who feel this pain" | ~20% of failures |
| 3 | "I can build it" | ~10% of failures |

Engineers default to testing #3. That's the safest one. Test #1 first.

## How it works in practice

### The assumption stack — score it

For your wedge from Lesson 05, list 5 assumptions and score:

| Assumption | Risk (1-5) | Test cost (1-5) | Priority |
|---|---|---|---|
| "Real estate agents will pay $99/mo for this" | 5 | 1 (just ask) | **Test first** |
| "I can find 1000 real estate agents on LinkedIn" | 3 | 1 (try Sales Nav) | Test second |
| "An LLM can extract MLS data accurately" | 3 | 2 (5-hour prototype) | Test third |
| "Stripe works for India-based seller" | 1 | 1 (read docs) | Don't bother |
| "I can build a Chrome extension" | 1 | 3 (1 day) | Don't bother |

The riskiest *and* cheapest-to-test goes first. Always.

### The 3 honest tests

**Test #1: Pre-sale Mom Test**

The Mom Test (Rob Fitzpatrick): don't ask "would you pay for this?" People lie. Instead ask:
- "Tell me about the last time you had to do X" (story, not opinion)
- "What did you try before? What did you spend?" (revealed willingness to pay)
- "Walk me through what you do when X happens" (workflow proof)

20 conversations with target customers, ~30 min each. Cost: 10 hours. Worth: keeps you from wasting 6 months.

**Test #2: Concierge MVP**

Before building software, deliver the outcome **manually**. Charge for it. If 5 people pay you $99 to do it by hand, you have product-market fit signal *before* writing one line of code.

Examples:
- "AI lease analysis" → you read the lease yourself with Claude in a chat window, send a PDF, charge $99
- "Automated content briefs" → you write the brief in Claude, send a Google Doc, charge $200/mo
- "AI bookkeeping" → you do the categorization in a spreadsheet, charge $300/mo

If you can't sell the **manual** version, the automated one won't sell either. The software just makes it cheaper *for you*, not more valuable *for them*.

**Test #3: The "$100 in 7 days" challenge**

Can you get 1 stranger to pay $100 for the outcome (not the software) within 7 days? If yes — you have signal. If no — your wedge is wrong, your channel is wrong, your pitch is wrong, or all three.

Don't build until you can hit this.

### The order of operations

```
Wedge identified (L05)
  ↓
20 customer conversations (Mom Test)
  ↓
"Would you pay $X for the outcome?" → 3 yeses? Continue. Else → new wedge.
  ↓
Concierge MVP — deliver outcome manually for paying customers
  ↓
3 paid customers using it for 30+ days?
  ↓
NOW build software. You know exactly what to build.
```

Most engineers reverse this. They build for 6 months, then look for customers. The honest version: **find customers first, build later.**

## Common traps

| Trap | Why |
|---|---|
| "I'll validate by launching on Product Hunt" | PH gives you traffic, not signal. Most upvoters never pay. |
| "I'll do free pilots to learn" | Free users teach you nothing about price; paid pilots are the only real signal |
| "I need a polished landing page first" | A Calendly link + a Notion doc converts as well as a $5K landing page at this stage |
| "My customer survey said 80% would pay" | Surveys lie. Charge them. |
| "I'll add the payment flow last" | Add it first. Until money changes hands, you don't know |
| Falling in love with the build | Engineers love building. Resist. |

## The 5 questions you must answer with YES before writing code

1. Can I name 5 specific people who feel this pain weekly?
2. Have I talked to at least 10 of them and heard them describe it without prompting?
3. Have I gotten 3 of them to say "I would pay $X for this outcome"?
4. Has at least 1 of them paid me money for the manual version?
5. Do I know the channel where I can reach 100 more of them in the next 90 days?

If any answer is no, do that work first.

## Exercise

Pick your wedge from Lesson 05. Set a 14-day timer. Goal: get **1 stranger** to pay you **$100** for the outcome — delivered manually.

Process:
- Day 1–3: Find 20 candidates in the channel
- Day 4–10: Reach out to all 20. Have conversations. Pitch the outcome (not the software).
- Day 11–14: Convert at least 1 to paying customer. Deliver it manually.

If you fail: your wedge is wrong, or your channel is wrong, or your pitch is wrong. Diagnose which, then redo Lesson 05. **Do not write code yet.**

If you succeed: you have the most valuable thing in startups — *one* person who voluntarily gave you money. Now you can build.

## Further reading

- Rob Fitzpatrick, *The Mom Test* — required, 100 pages, free PDF online
- Eric Ries, *The Lean Startup* — "build-measure-learn" loop
- Steve Blank, *The Four Steps to the Epiphany* — customer development
- Amy Hoy, [Sales Safari](https://stackingthebricks.com/) — finding pain in the wild

---

[← Lesson 05](../05-find-a-profitable-wedge/README.md) | [Next → Lesson 07: Wrapper, Product, or Platform](../07-wrapper-product-or-platform/README.md)
