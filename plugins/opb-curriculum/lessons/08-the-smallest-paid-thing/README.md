# Lesson 08: The Smallest Paid Thing

## TL;DR

Your goal is **first $1K MRR**, not first 1M users. Ship the smallest possible thing that one specific human will pay money for. Charge from day one. Free users teach you nothing; paying users teach you everything. The path from $0 → $1K MRR is the hardest jump; everything after compounds.

## Core idea

```
$0 → $1K MRR    = the hardest jump (90% give up here)
$1K → $10K MRR  = product-market fit work (mostly retention)
$10K → $100K MRR = distribution work (Lesson 16)
$100K → $1M MRR = team / leverage work (Part 5)
```

You earn the right to think about $1M MRR by first earning $1K. Stop skipping this.

## How it works in practice

### What "smallest paid thing" actually means

It is not:
- A polished landing page
- A clever brand
- A free trial
- A "freemium" tier
- A waitlist
- A Product Hunt launch

It IS:
- One workflow that solves one specific pain
- Delivered however ugly
- For 1 specific buyer persona
- Priced at $50–$500/month
- With a Stripe link and a way to cancel

### The "v0 in a week" recipe

```
Day 1: Pick the ONE workflow (from Lesson 06 validation)
Day 2: Sketch the input/output. No UI yet.
Day 3-4: Build the agent (Lesson 01-02 stack)
Day 5: Wrap it in a single Next.js page or Streamlit app
Day 6: Stripe payment link + Calendly for onboarding
Day 7: Send to your 3 paying concierge customers from Lesson 06
```

Total stack:
- Frontend: Next.js or Streamlit (don't build a SPA)
- Backend: Python or Node, single file is fine
- DB: Postgres on Neon, $0/mo
- Auth: Clerk free tier or magic links
- Payments: Stripe Payment Link (no checkout custom code)
- Hosting: Vercel free tier or Modal
- LLM: Claude Sonnet API

Cost to operate at v0: **$0–$25/mo**. Stop overspending here.

### Pricing for v0 (charge more than feels comfortable)

For B2B AI products in 2026, the floor is **$99/mo per seat**. Below that:
- You attract bad customers (high support, low retention)
- Customers don't take it seriously
- Your unit economics break before scale

Pricing tiers that work for v0:

| Tier | Price | What it includes |
|---|---|---|
| Starter | $99/mo | One workflow, one user, fair use |
| Pro | $299/mo | Multiple workflows, integrations, 5 users |
| Team | $999/mo | Custom integrations, priority support |

**You don't need all 3 tiers at v0.** Pick one. The Pro tier ($299) is usually the right opening price for B2B.

If your buyer says "$299 is too expensive" — your wedge is wrong (their pain is too small) OR your pitch is wrong (you're not articulating value). Don't lower the price; fix one of those.

### The first 10 customers

You will know each of them by name. You will:
- Personally onboard each one over Zoom
- Add them to a private Slack/WhatsApp
- Email them weekly to ask "what would make this 10× more useful?"
- Fix their bugs within 24 hours
- Send them handwritten thank-you cards (no, really)

This is **not scalable**. That's the point. The unscalable phase is where you learn what to scale.

The first 10 customers will tell you:
- The 3 features you're missing that everyone needs
- The pricing that works (some will say "I'd pay 3× this")
- The next adjacent workflow they want
- The community / channel where 100 more of them live
- The specific words they use (your future marketing copy)

### The launch script

Don't "launch." Just sell.

Week 1:
- Day 1: Email your 3 paying concierge customers. Onboard them.
- Day 2-3: List 30 more candidates from Lesson 06's research.
- Day 4-7: Email 30 candidates with: (a) what it does in one sentence, (b) the specific pain it removes, (c) a Calendly link for a 15-min demo, (d) the price.

Expected outcomes after week 1:
- 5–8 demo calls
- 1–3 new paying customers
- $300–$900 MRR

This is the slowest growth you'll ever see. It's also the most important. **It is the proof your business exists.**

## Common traps

| Trap | Why |
|---|---|
| Free trial / freemium for v0 | Free users don't tell you anything; they consume support; they don't convert at the rate you hope |
| "I'll launch when it's ready" | Never. Launch when 1 person can use it without you. |
| Spending 2 weeks on the landing page | A Notion doc + Stripe link converts as well at this stage |
| Building features instead of selling | The first 10 customers don't need more features; they need you to deliver |
| Competing on price | Race to the bottom. Compete on outcome quality. |
| Hiring before $10K MRR | You're hiring to delay learning. Don't. |

## The math: how long to $1K MRR

```
At $99/seat:   10 customers  →  $990 MRR
At $299/seat:  4 customers   →  $1,200 MRR
At $999/seat:  1 customer    →  $999 MRR
```

If you can't get 4 paying customers in 90 days, your wedge is wrong (Lesson 05) or your offer is wrong (Lesson 06). Don't push harder; diagnose.

If you can: congratulations, you're now in the top ~5% of indie hacker attempts. Most never reach $1K MRR.

## Exercise

Set a 30-day timer. Two goals:

1. **$1K MRR by day 30.** No exceptions, no excuses, no "next month."
2. **Daily journal**: 100 words on what you learned each day.

If you miss the goal, the journal tells you why. If you hit it, the journal becomes your case-study material for Lesson 09 (build in public).

Most readers will not do this exercise. They will rationalize: *"I need to plan more,"* *"I need to learn more first,"* *"I need to redesign the brand."* These are all forms of the same fear. Push through.

## Further reading

- Amy Hoy, [Just Fucking Ship](https://book.stackingthebricks.com/) — the launch mindset
- Pieter Levels, [MAKE](https://makebook.io/) — solo SaaS playbook
- Patrick McKenzie, ["Bingo Card Creator" series](https://www.kalzumeus.com/) — the patron saint of single-file SaaS
- Jason Cohen, [WPEngine origin story](https://blog.asmartbear.com/) — first 10 customers, hand-built

---

[← Lesson 07](../07-wrapper-product-or-platform/README.md) | [Next → Lesson 08A: The Grand Slam Offer](../08A-the-grand-slam-offer/README.md) (mandatory interlude before Part 3)
