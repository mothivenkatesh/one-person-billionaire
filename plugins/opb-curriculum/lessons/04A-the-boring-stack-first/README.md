# Lesson 04A (Interlude): The Boring Stack First — When NOT to Use AI

## TL;DR

The first 4 lessons taught you to build agents. This one teaches you to **not build them when you don't need to.** Most production "AI products" should be a **workflow engine + 1-2 LLM steps**, not an agent loop. Pieter Levels makes ~$3M ARR collective across ~10 products on **PHP + jQuery + a single $30 VPS**. That's not despite the boring stack — it's *because* of it. Reliability compounds. Complexity doesn't.

Read this before Part 2 or you'll over-engineer your wedge into the ground.

## Core idea

```
For every step of your "AI workflow," ask: does this need an LLM?

Stable categorization (5-20 buckets)?      → regex / decision tree     (10-100× cheaper, deterministic)
Field extraction from structured docs?     → parser library             (no hallucinations)
Routing on known signals?                  → switch statement           (debuggable)
Daily digest from a template?              → cron + Mustache            (no per-call cost)
Decide if a customer reply needs refund?   → LLM ✓                      (open-ended, judgment)
Generate personalized cold email body?     → LLM ✓                      (open-ended, fuzzy)
Decide which agent to escalate to?         → LLM ✓                      (judgment)

Use AI for the open-ended/fuzzy 20%. Use boring code for the structured 80%.
```

The "agent loop with 10 tools" framing makes you stuff every step into the LLM. That's why your bills are high, reliability is low, and you can't sleep.

## The Pieter Levels principle

Pieter Levels — NomadList, RemoteOK, PhotoAI, InteriorAI, +6 more — runs ~10 products generating ~$3M ARR with:

- **One VPS** ($30/mo on Hetzner)
- **PHP + jQuery + raw HTML** (no React, no SPA, no microservices)
- **MySQL** (no Postgres-vs-MySQL holy war)
- **Cron jobs** for everything (no Kafka, no Temporal)
- **Stripe + Postmark** (no analytics SaaS sprawl)
- **AI added only where needed** (Replicate API for PhotoAI; OpenAI for one InteriorAI step)

His uptime is 99.9%+ at near-zero engineering cost because there's nothing to break. Compare to the typical 2026 "AI startup" running Kubernetes + a vector DB + 4 microservices + LangChain + a serverless function fleet → 95% uptime, $5K/mo infra, weekly firefighting.

The honest takeaway: **complexity doesn't compound; reliability does.** Every framework you skip is one less thing that can fail at 3am.

## When NOT to use AI

| Task | Use this | Don't use AI because |
|---|---|---|
| Stable categorization (5-20 fixed buckets) | Regex / keyword / decision tree | Deterministic, 10-100× cheaper, debuggable |
| Field extraction from structured docs (invoices, JSON, XML) | Parser library | AI hallucinates fields; parsers don't |
| Routing on known signals (sender, URL, user ID) | switch / dispatch table | Don't need fuzzy match |
| Generating boilerplate from templates | Mustache / Jinja / handlebars | Predictable output is the goal |
| Date / number / currency parsing | `dateutil` / `decimal` / `currency.js` | LLMs misformat dates surprisingly often |
| Translating between known data formats (CSV → JSON) | Schema-driven mapper | Same |
| Repetitive tasks where past answer is right | Cache the answer | Pay once, not per call |
| Anything regulatory / auditable | Deterministic code | "The LLM said so" doesn't survive audit |
| Boolean logic on extracted fields | `if/else` | LLMs flip outputs across runs |
| SQL generation against a known schema | Pre-built queries / ORM | Determinism + perf |

When TO use AI:
- Open-ended generation (drafts, summaries, copy)
- Fuzzy matching humans would do "by feel" (intent classification, sentiment)
- Reasoning across unstructured inputs (PDFs, emails, transcripts)
- Tool selection from a wide / changing catalog
- Anything that previously required a human's judgment

The simple rule: **if a junior could write a function for it in 30 minutes, write the function. If they'd say "it depends," use AI.**

## Workflow engines — the missing piece in most "AI agent" stacks

Most "AI products" should be **workflow + AI step**, not "agent loop + tools." A workflow engine gives you, for free:

- **Durable execution** — workflow survives server restart mid-run
- **Idempotent retries** — automatic, no double-charging
- **Branching / parallel / loops** — without writing your own state machine
- **Observability** — every step logged, traceable, replayable
- **Human-in-loop checkpoints** — pause at approval gates
- **Scheduled triggers** — cron, but managed
- **Dead-letter handling** — failed runs go somewhere, not vanish

### The 2026 workflow engine landscape

| Tool | Type | Best for | Cost |
|---|---|---|---|
| **Inngest** | Event-driven, agent-aware | Solo + small-team AI products; first-class LLM step type | Generous free tier; $20-200/mo at scale |
| **Trigger.dev** | TypeScript-first workflow | Product engineers in the Next.js stack | Free tier; usage-based |
| **Temporal** | Durable execution at scale | Mission-critical, transactional, "must not lose money" workflows | Self-host or Temporal Cloud ($$) |
| **n8n** | Self-hostable visual workflow | Internal automation, ETL, integrations | Free self-host; $20+/mo cloud |
| **ActivePieces** | Open-source Zapier alternative | Customer-facing automation if you want to white-label | Free self-host |
| **Orkes** (Netflix Conductor) | Enterprise durable orchestration | Larger systems, polyglot stacks, regulated industries | Enterprise pricing |
| **AWS Step Functions** | Cloud-native state machine | If you're all-in on AWS | Pay-per-transition |
| **Cloudflare Workflows** | Edge-native durable execution | If you're already on CF Workers | Free tier on Workers |
| **Zapier / Make** | No-code visual | Non-engineers; v0 prototypes; customer-facing self-serve | Per-task pricing |
| **Just cron + Postgres** | DIY | Truly small projects, < 100 events/day | $0 |

For a solo agent operator in 2026, the **default first pick is Inngest** — it's agent-aware (knows about LLM step types), has a real free tier, and handles retries/durability without ceremony. Drop down to **Cloudflare Workflows** if you're already on CF; up to **Temporal** if you're moving real money or have multi-day workflows.

For non-engineering use cases (internal automation, customer-facing simple flows), **n8n** (self-hosted) or **ActivePieces** (white-label) win on cost.

### The hybrid pattern (the one you should default to)

```
[Trigger: cron every 4 hours, OR webhook]
        ↓
[Workflow engine: process_unread_emails]
        ↓
[Step 1: fetch unread emails]                  ← plain code (IMAP API)
        ↓
[Step 2: filter by sender domain (priority)]   ← switch statement, NOT LLM
        ↓
[Step 3: dedupe against DB]                     ← SQL query, NOT LLM
        ↓
[Step 4: for each, classify intent]             ← LLM (open-ended) ✓
        ↓
[Step 5: route by intent]                       ← switch statement
   ├── refund_req  → [draft reply with LLM] ✓     ← LLM
   │                  → [queue for human approval]  ← workflow pause
   ├── tech_issue  → [create Linear ticket]         ← API call, no LLM
   └── spam        → [archive]                       ← API call, no LLM
```

LLM calls per email: ~1.2 (classify always; draft only for refunds).
Plain code calls per email: 4-5.

Most "agent" architectures call the LLM at every step. **Hybrid: 1.2 LLM calls vs naive agent: 5-7.** Same outcome. ~5× cheaper. ~3× faster. ~10× more reliable (because the deterministic steps don't fail).

## Reliability primitives every AI product needs

These are non-negotiable. Most "AI startups" missing these are one outage from death. Lesson 04 (Production-Ready) hinted at observability and rollouts; this is the lower-level layer.

### 1. Idempotency keys

Every state-changing operation must accept an idempotency key. If the same key is seen twice, return the cached result; don't re-execute.

```python
def send_payment(idempotency_key, amount, recipient):
    if existing := find_by_key(idempotency_key):
        return existing.result   # already done; don't double-charge
    result = stripe.create_payment(amount, recipient)
    store_result(idempotency_key, result)
    return result
```

Without this, retries = double-charges, double-emails, double-sends. Don't ship a paid product without idempotency.

### 2. Retries with exponential backoff + jitter

Network calls fail. LLMs fail. APIs rate-limit. Retry intelligently:
- Try at 1s, 2s, 4s, 8s, 16s
- Add **random jitter (0-50%)** to avoid thundering herd
- Cap total attempts (5-10)
- After cap: dead-letter, alert, move on

Don't retry forever. Don't retry without backoff. Don't retry at fixed intervals (causes herd problems on shared downstreams).

### 3. Timeouts everywhere

Every external call must have a timeout. Default *short* (5-30s for sync, longer only for batch).

The hidden killer: a single slow LLM call holds up your queue → cascading backlog → outage. Timeouts force quick failure → retry → success.

### 4. Circuit breakers

When a downstream service is failing, stop hammering it. Open the circuit (deny requests) for a cool-off period. Let one request through to test. If it succeeds, close the circuit. Libraries: `pybreaker` (Python), `opossum` (Node), or built into most workflow engines.

### 5. Dead-letter queues (DLQs)

Things that fail beyond retry must go *somewhere* (not vanish). DLQ = a queue of failed items you can inspect, fix, and re-process.

Without DLQs:
- "We don't know what failed last week"
- Customer: "I sent X but never got Y"
- You: 4 hours of `grep` to find the lost item

With DLQs: 1 dashboard, 30 seconds.

### 6. Bulkhead isolation

Don't let one customer's heavy use take down the system for everyone else.
- Per-customer connection pools
- Per-customer queue partitions
- Per-customer rate limits

One enterprise customer running 10K agent sessions in a minute should not slow down 100 starter-tier customers.

### 7. Compensating actions (sagas)

For multi-step workflows where some steps can't be transactionally rolled back, define an explicit compensating action for each.

```
Step 1: charge customer    →  compensate: refund
Step 2: provision account  →  compensate: deprovision
Step 3: send welcome email →  compensate: send "ignore previous email"
```

If step 3 fails, you don't leave the customer with a charge and an account but no email. You execute the compensations for steps 2 and 1. Workflow engines (Temporal, Inngest, Step Functions) handle this natively.

### 8. Health checks + alerts

- `/health` endpoint that runs 3 smoke tests (DB connect, LLM ping, queue ping)
- External monitoring (UptimeRobot free tier / BetterStack) hits it every minute
- Pager (PagerDuty / OpsGenie / just SMS) on failure

Without this: you find out from an angry customer.

## When AI breaks reliability (and how to fix)

| Failure mode | Fix |
|---|---|
| LLM API hard fail | Retry with backoff; fallback to cheaper model; serve from cache if hit |
| LLM gives wrong tool call | Validate before executing; retry once; escalate to human |
| LLM hallucinates a field | Schema-validate output (Pydantic / Zod); retry on parse failure |
| LLM exceeds context window | Summarize-and-replace older history |
| LLM goes off-task | Max-iteration cap on the agent loop |
| Tool returns prompt-injection text | Strip / sanitize / re-prompt with system reminder |
| Flaky tool fails 5% of time | Retries + circuit breaker around the tool |
| Cost runaway from infinite loop | Per-session token budget with hard cutoff |

Each of these has a non-AI fix. The agent loop alone gives you none of them.

## The "is AI even needed" decision tree

```
Is this step fuzzy / open-ended / judgment-based?
├── No  → Write the function. Don't use AI. (You'll save 90% on this step's cost.)
└── Yes → Is the input/output structured?
          ├── Yes → One LLM call + schema-validate the response.
          │         No agent loop needed.
          └── No  → LLM step inside a workflow engine.
                    Add: idempotency, retry, timeout, DLQ.
                    Decide: pre-planned workflow or true agent loop?
                    ├── Pre-planned (most cases) → Workflow engine + LLM steps
                    └── Reactive / open-ended (rare) → Agent loop with hard bounds
```

**Default to the boring stack.** Reach for the agent loop only when the boring stack has been tried and proven inadequate.

## What this means for the rest of the curriculum

When Lesson 05 says "find a wedge," it's not "find a wedge for an agent." Most of the wedges that hit $1M ARR are **workflow products with one fuzzy step**, not "AI agents." Examples:

- **Receipt categorizer for accountants**: 90% rules-based, 10% LLM for ambiguous categories
- **Cold-outbound list builder**: 95% scraping + filtering, 5% LLM for personalization
- **Lease analyzer**: 70% structured extraction + clause detection, 30% LLM for the "is this clause unusual?" call
- **Customer support tier 1**: 80% intent → routing → templated reply, 20% LLM for the fuzzy ones

The "AI" framing is marketing. The "workflow engine + LLM step" framing is engineering. Both are true. Sell the first; build the second.

## Common traps

| Trap | Why |
|---|---|
| "Everything must be an agent" | Agent paradigm is great for fuzzy reasoning; terrible for reliability primitives |
| Skipping the workflow engine | You'll rebuild durable execution badly, in your own code, over 6 months |
| Microservices + Kubernetes for v0 | Pieter Levels makes more on a $30 VPS than your $5K AWS bill |
| Trusting the LLM to retry / dedupe | LLMs aren't reliable; the workflow around them must be |
| No DLQ | The first lost customer payment teaches you |
| Single point of failure on LLM provider | Have a fallback model; outages happen (Anthropic, OpenAI, Google all have multi-hour outages annually) |
| Per-token billing on a low-margin tier | One bug = one bankruptcy story |
| LangChain / "agent framework" by default | Wraps simple primitives in 10× more code; debugging hell |
| "We'll add reliability later" | The first outage at $50K MRR teaches you what later costs |

## Exercise

For your current product (or your wedge from Lesson 05), map every step of the user-facing workflow:

| Step | Currently uses AI? | Could use boring tech? | Should use boring tech? |
|---|---|---|---|
| | | | |

For each AI step, ask:
- Is the input structured? (If yes, do you really need a fuzzy model?)
- Is the output one of N known categories? (If yes, regex first.)
- Would a human write `if/else` for this? (If yes, you should too.)

Replace **1 step** with a non-AI implementation. Measure over 14 days:
- Cost change
- Latency change  
- Reliability change (failure rate)

Most operators find **30-60% of their AI calls were unnecessary**. The savings fund the next 6 months of work — and the reliability improvement compounds forever.

## Further reading

- Pieter Levels, [`@levelsio` Twitter](https://twitter.com/levelsio) + [levels.io](https://levels.io/) — the canonical "boring works" operator
- Temporal, [Workflow patterns](https://learn.temporal.io/courses/) — the durable execution bible
- Inngest, [Reliable AI workflow patterns](https://www.inngest.com/blog) — agent-aware workflows
- Adrian Cockcroft, [Microservices patterns](https://adrianco.medium.com/) — the SRE classic, still relevant
- Hyrum Wright, [Hyrum's Law](https://www.hyrumslaw.com/) — why every external call eventually fails
- Dan Luu, [Computers can be understood](https://danluu.com/) — the "boring tech wins" essays

---

[← Lesson 04: Production-Ready](../04-production-ready/README.md) | [Next → Part 2: Lesson 05 — Find a Profitable Wedge](../05-find-a-profitable-wedge/README.md)
