# Acknowledgments

This curriculum stands on the shoulders of operators, authors, and open-source communities who published their patterns, frameworks, and code in the open. The synthesis is original; the underlying ideas are not invented here. Specific debts:

## Books and authors

| Source | What I learned from it | Where it shows up |
|---|---|---|
| Alex Hormozi, *$100M Offers* | Value Equation, Grand Slam offer construction, 4 guarantee types, MAGIC naming, Starving Crowd hierarchy | Lesson 08A; `grand-slam-offer` skill; templates/grand-slam-offer-canvas.md |
| Alex Hormozi, *$100M Leads* | Multi-touch lead generation, the cold outbound "earn the right to ask" mechanics | Lessons 09-12; `cold-outbound-drafter` skill |
| Rob Fitzpatrick, *The Mom Test* | Past-behavior questions vs survey-style "would you pay?", the 3-question interview | Lesson 06; `riskiest-assumption-tester` skill |
| Patrick McKenzie, "Don't Call Yourself a Programmer" + Kalzumeus blog | Wedge mindset, pricing courage, cold email mechanics, SEO for software people | Lessons 05, 10, 11, 13 |
| Jason Cohen, *A Smart Bear* | Bootstrapped SaaS economics, pricing, retention math | Lessons 13, 14, 15 |
| Tyler Tringas, *Calm Company Fund* writings | The bootstrapped alternative to VC; "boring bets" thesis | Lesson 00 (Premise); Lesson 16 |
| Madhavan Ramanujam, *Monetizing Innovation* | Pricing-as-product; willingness-to-pay research | Lesson 13; `pricing-tripler` skill |
| Eric Ries, *The Lean Startup* | Build-measure-learn, validated learning, riskiest assumption | Lesson 06; `riskiest-assumption-tester` |
| Steve Blank, *The Four Steps to the Epiphany* | Customer development model | Lesson 06 |
| Cal Newport, *Deep Work* + *Slow Productivity* | The 4-day work week as forcing function; deep-work calendar template | Lesson 19; `weekly-cadence-designer` |
| David Allen, *Getting Things Done* | OS for processing inputs | Lesson 19 |
| Tiago Forte, *Building a Second Brain* | Documentation-as-onboarding-for-future-self | Lesson 19; AGENTS.md pattern |
| Sahil Lavingia, *The Minimalist Entrepreneur* | Audience-building as a precursor to product | Lesson 09 |
| Naval Ravikant, *The Almanack* | The long-game philosophy; specific knowledge | Lesson 20 |
| Morgan Housel, *Same as Ever* | Historical patterns of compounding | Lesson 20 |
| Reid Hoffman, *The Start-Up of You* | Career as compounding asset | Lesson 20 |
| Eugene Schwartz, *Breakthrough Advertising* | The original "starving crowd" essay | Lesson 05; `wedge-finder` |
| Ben Thompson, Stratechery — *Aggregation Theory* | Why distribution + aggregation compound | Lesson 02 (3-layer harness) |

## Operators / blogs (specific case studies referenced)

| Operator | Example referenced |
|---|---|
| Pieter Levels (levels.io) | The "boring stack" archetype: ~$3M ARR / ~10 products / single VPS / PHP+jQuery — Lesson 04A |
| Markus Frind (Plenty of Fish) | Solo operator at $75M/yr ad revenue with 1 employee — Lesson 00 (Premise) |
| Various indie hackers | The honest ladder of $0 → $1M → $10M → $100M ARR survival rates — Lesson 00, Lesson 20 |
| Linear / Tailwind / Granola / Cursor founders | "Build for yourself first" as a pattern — Lesson 17 |

## Open patterns and frameworks

The following ideas appear in the repo because they're the standard operating patterns of agent engineering / GTM / SaaS in 2026. Not invented here; synthesized for solo operators:

- **The agent loop pattern** (think → act → observe) — community standard
- **The 3-layer harness model** (personal builder stack vs production runtime vs product moat) — synthesized from open-source agent-harness research and SaaS strategy literature
- **Progressive disclosure for skills** (metadata → instructions → references) — Anthropic Skills specification
- **Grand Slam offer construction** — Hormozi's framework, applied to AI products
- **Multi-touch attribution models** (first-touch, last-touch, W-shaped, U-shaped, time-decay) — standard SaaS GTM analytics
- **Cohort retention analysis** (M0/M1/M3/M6/M12, NDR vs GDR) — standard SaaS analytics
- **The 4 guarantee types** (unconditional / conditional / anti / outcome) — Hormozi's taxonomy
- **The Mom Test interview structure** — Rob Fitzpatrick's framework
- **The 5 reliability primitives** (idempotency, retries, DLQs, sagas, circuit breakers) — standard SRE patterns
- **The 3 pricing models** (per-seat, capped usage, value-based) — standard SaaS pricing taxonomy
- **GTM analytics prompt patterns** (campaign ROI, churn risk, retention cohorts, etc.) — synthesized from publicly-available enterprise GTM analytics prompt libraries

## Tools and infrastructure named in the curriculum

These are named for what they do, not as endorsements:

| Category | Tools named |
|---|---|
| LLM providers | Anthropic Claude (Sonnet, Haiku, Opus); OpenAI; Google Gemini |
| Workflow engines | Inngest, Temporal, Cloudflare Workflows, AWS Step Functions, n8n |
| Observability | Langfuse, Helicone, Phoenix, OpenTelemetry |
| Eval frameworks | Promptfoo, Inspect, Braintrust |
| CRM | Salesforce, HubSpot |
| Payments | Stripe (mandatory) |
| Auth | Clerk, WorkOS |
| Hosting | Vercel, Cloudflare Workers, Modal, Fly.io |
| Database | Postgres on Neon, Supabase |
| Outbound | Clay, Apollo, Hunter, Smartlead |
| Build-in-public | X / Twitter, LinkedIn, Substack, Typefully |

## What's original to this synthesis

The following framing decisions and structural choices are this repo's own:

- **The honest premise** (Lesson 00) — the math behind realistic solo-operator outcomes; the honest ladder
- **The 5-Part curriculum structure** (Engineering → Productizing → Distribution → Monetization → Leverage) calibrated for solo agent operators
- **The 8 Principles** (distribution is harder, margin is destiny, compound or die, etc.)
- **The 7 chained slash commands** that compose skills into end-to-end workflows
- **The 14 v2 skill structure standard** (hard constraints first → workflow → output format → worked example → common mistakes → tooling → quick reference)
- **The v1 / v1.5 / v2 tier system** with explicit deepening checklist
- **The 3-layer harness model applied as time-allocation targets** (Year 1: 40/30/30 → Year 3+: 10/20/70)

## License

Original synthesis: MIT (see [LICENSE](./LICENSE)).
Underlying frameworks and patterns: belong to their respective authors and communities.
Quoted excerpts: fair use under educational citation.

If you've authored work referenced here and would like a different attribution (or removal), open an issue.
