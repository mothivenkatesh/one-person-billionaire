# One Person Billion

**An honest 20-lesson curriculum for engineers who want to build, ship, and monetize agent-powered products as a solo (or near-solo) operator.**

Synthesizes:
- **Addy Osmani's [`agent-engineer`](https://github.com/addyosmani/agent-engineer)** for breadth (model, tools, RAG, MCP, multi-agent, evals, production)
- **shareAI-lab's [`learn-claude-code`](https://github.com/shareAI-lab/learn-claude-code)** for depth on harness mechanics (loop, subagents, skill loading, context compression, task graphs, worktree isolation)
- **Anthropic's "Building Effective Agents"** for the prompt-craft and reasoning-pattern layer
- **The GTM, distribution, and monetization layers** that engineering courses always skip

---

## Read this first

The phrase **"one-person billionaire"** is mostly fan-fiction in 2026. Zero have been confirmed. The honest ladder:

| Stage | ARR | Solo? | Known cases |
|---|---|---|---|
| Side project | $0 – $10K | ✅ | Most attempts |
| Ramen profitable | $10K – $100K | ✅ | Thousands of indie hackers |
| Sustainable solo | $100K – $1M | ✅ | Hundreds globally |
| Mid solo | $1M – $10M | ✅ with agents | ~50–200 globally |
| Outlier solo | $10M – $100M | Possible with agents + automation | ~5–20 globally |
| Solo $100M+ ARR | $100M+ | Hypothetically possible 2030+ | None proven |
| Solo $1B exit / $1B founder net worth | — | Possible at high multiples + held equity | None proven *as solo* |

This curriculum trains you for the realistic ladder. **Read [Lesson 00](./00-the-honest-premise/README.md) before anything else** — it does the math so you don't quit when the math hits.

---

## What this is — and is not

| ✅ This is | ❌ This is not |
|---|---|
| A 20-lesson opinionated path from `while True:` to monetized agent product | A get-rich-quick framework |
| Honest about distribution being the harder half | A "just code well" engineering deep-dive (read Addy's repo for that) |
| Calibrated for 2026: post-MCP, post-Claude 4.7, post-Skills spec | A theoretical AI textbook |
| Each lesson ends with one concrete exercise | A motivational manifesto |
| Built to compound — short reads, durable principles | A library you'll reference once and forget |

---

## Who this is for

- You can already code (Python or TypeScript)
- You've shipped at least one thing to real users (or you're about to)
- You've used Claude Code / Cursor / Codex enough to feel what an agent *is*
- You don't need hand-holding on `git`
- You're tempted by the indie-hacker leg but realize engineering alone won't get you there

If you're an absolute beginner, do [Addy's `agent-engineer`](https://github.com/addyosmani/agent-engineer) first, then come back.

---

## The 5 Parts

```
PART 1   ENGINEERING       L01 → L04   The 100x agent engineer (compressed)
[INTERLUDE]                L04A        The boring stack first — when NOT to use AI
PART 2   PRODUCTIZING      L05 → L08   Engineering chops → a thing people pay for
PART 3   DISTRIBUTION      L09 → L12   The half engineers always skip
PART 4   MONETIZATION      L13 → L16   Pricing, margin, retention, scaling
PART 5   LEVERAGE          L17 → L20   Compounding into outlier outcomes
```

---

## Lessons

### Part 0 — Premise
- **00** [The Honest Premise](./00-the-honest-premise/README.md) — Read first. The math behind the meme.

### Part 1 — Engineering
- **01** [The Minimum Viable Agent](./01-the-minimum-viable-agent/README.md)
- **02** [The Harness Is the Moat](./02-the-harness-is-the-moat/README.md)
- **03** [Multi-Agent and When to Actually Use It](./03-multi-agent-when-to-use-it/README.md)
- **04** [Production-Ready](./04-production-ready/README.md)

### Interlude (mandatory before Part 2)
- **04A** [The Boring Stack First — When NOT to Use AI](./04A-the-boring-stack-first/README.md) — workflow engines (Inngest, Temporal, n8n, ActivePieces, Orkes), reliability primitives (idempotency, DLQs, sagas, circuit breakers), and the Pieter Levels principle. Most "AI products" should be a workflow + 1-2 LLM steps, not an agent loop.

### Part 2 — Productizing
- **05** [Find a Profitable Wedge](./05-find-a-profitable-wedge/README.md)
- **06** [The Riskiest Assumption Test](./06-riskiest-assumption-test/README.md)
- **07** [Wrapper, Product, or Platform](./07-wrapper-product-or-platform/README.md)
- **08** [The Smallest Paid Thing](./08-the-smallest-paid-thing/README.md)

### Part 3 — Distribution
- **09** [Build in Public as Distribution](./09-build-in-public/README.md)
- **10** [Cold Outbound for AI Products](./10-cold-outbound/README.md)
- **11** [Content That Compounds in the AI-Search Era](./11-content-that-compounds/README.md)
- **12** [Communities, Partnerships, and Affiliates](./12-communities-and-affiliates/README.md)

### Part 4 — Monetization
- **13** [Pricing AI Products](./13-pricing-ai-products/README.md)
- **14** [Margin Engineering](./14-margin-engineering/README.md)
- **15** [The Retention Problem Unique to AI Products](./15-the-retention-problem/README.md)
- **16** [The Scaling Cliff](./16-the-scaling-cliff/README.md)

### Part 5 — Leverage
- **17** [Automate Yourself First](./17-automate-yourself-first/README.md)
- **18** [Hiring Agents Instead of Humans](./18-hiring-agents-not-humans/README.md)
- **19** [The 1-Person Operating System](./19-the-one-person-operating-system/README.md)
- **20** [The 10-Year Compound](./20-the-10-year-compound/README.md)

---

## How to use

- **Read in order** if you're new to either side
- **Skip Part 1** if you've already done Addy's `agent-engineer`
- **Skip Parts 1–2** if you're a senior PM/founder who just needs the engineer's mental model
- **Each lesson** = ~15-min read + 1 actionable exercise. Most exercises are *"stop reading, go do this for an hour, come back"*

---

## The 8 Principles

1. **Distribution is the harder half.** Engineering excellence is necessary but not sufficient. Most failed indie attempts had the better product.
2. **Margin is destiny.** Per-token pricing kills you. Value-based pricing on durable problems wins.
3. **Compound or die.** One-time wins make great Twitter posts. Recurring wins make great businesses.
4. **The boring stack ships.** SDK + `while` loop + Postgres + Stripe will outship CrewAI + LangGraph + Pinecone + Stripe Atlas every time.
5. **The model is not the moat.** Your moat is data, distribution, retention, and trust.
6. **Honest >> impressive.** Lying to yourself about your numbers is the most expensive thing you'll do.
7. **Time-in-market beats market-timing.** The 5-year operator beats the 12-month sprinter every time.
8. **AI is not always the answer.** Most production "AI products" are a workflow engine + 1-2 LLM steps. The agent loop is for the fuzzy 20%, not the structured 80%. (See [Lesson 04A](./04A-the-boring-stack-first/README.md).)

---

## License

MIT. Fork it, ship it, sell it. If you make money, you don't owe me anything. If you become the first solo billionaire, buy me a coffee.

---

## Credits

- Addy Osmani's [`agent-engineer`](https://github.com/addyosmani/agent-engineer) — the breadth template
- shareAI-lab's [`learn-claude-code`](https://github.com/shareAI-lab/learn-claude-code) — the depth template
- Patrick McKenzie, Jason Cohen, Tyler Tringas, Rob Walling — for two decades of indie/bootstrap honesty
- Sam Altman — for the meme that named this repo
