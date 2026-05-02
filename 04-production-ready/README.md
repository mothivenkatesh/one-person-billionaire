# Lesson 04: Production-Ready

## TL;DR

The gap from "works on my laptop" to "works for paying customers 24/7" is **80% of the total work**. You can either plan for it from day 1 or learn it the hard way over the next 18 months. The five non-negotiables: eval-gated CI, canary rollouts, observability, cost control, and a working incident loop.

## Core idea

```
Demo  →  Eval gate  →  Canary  →  Full rollout  →  Observe  →  Improve
                      (5%)      (100%)              ↑           ↓
                                                    └──── feedback loop ────┘
```

Production isn't a launch. It's a **loop** you run forever.

## How it works in practice

### 1. Eval-gated CI/CD

The single most important production practice. **No agent change ships without passing evals.**

```yaml
# .github/workflows/agent-ci.yml
on: [pull_request]
jobs:
  evals:
    steps:
      - run: promptfoo eval --config evals.yaml
      - if: failure()
        run: exit 1  # block merge
```

Categories your eval suite must cover:

| Category | What | Pass criteria |
|---|---|---|
| Functional | Does it produce correct answers? | ≥ 90% on accuracy set |
| Tool use | Right tool, right args? | ≥ 95% tool-correct |
| Safety | Refuses bad requests, no PII leak | **100%** — hard gate |
| Latency | P95 response time | < target |
| Cost | Tokens per session | < budget |
| Regression | Old passing cases still pass | 0 regressions |

Safety = hard gate. Everything else can have soft thresholds.

### 2. Canary rollouts

```
Traffic →  Load Balancer  →  v1 (95%)  +  v2 canary (5%)
```

Process:
1. Deploy v2 alongside v1
2. Route 5% of traffic to v2
3. Watch error rate, latency, satisfaction, safety incidents for 24 hours
4. If healthy: 25% → 50% → 100%
5. If any metric degrades: instant rollback

**Why this matters for solo operators:** you don't have a QA team. The canary *is* your QA team.

### 3. Observability

Three pillars, all required:

**Logs** (structured JSON, every event):
```json
{
  "ts": "2026-05-01T14:23:45Z",
  "session_id": "sess_abc",
  "event": "tool_call",
  "tool": "search_web",
  "tokens_in": 1250,
  "tokens_out": 380,
  "latency_ms": 234,
  "cost_usd": 0.0034
}
```

**Traces** (one trace per request, showing every LLM call + tool call):
- Use OpenTelemetry — industry standard
- Cheap option: **Langfuse** (free tier, hosted)
- Self-hosted: Phoenix or Helicone

**Metrics** (the dashboard you check daily):

| Metric | Alert when |
|---|---|
| Task completion rate | drops below 85% |
| P95 latency | exceeds 5s |
| Cost per session | exceeds $0.10 |
| Escalation rate | exceeds 20% |
| Safety incident rate | any increase above baseline |
| Tool error rate | exceeds 5% |
| User satisfaction (👍/👎) | below 4.0/5.0 |

### 4. Cost control

LLM bills surprise founders weekly. Build cost discipline in from day 1:

**Model routing** — cheapest model that passes evals for each step:
```
intent classification  →  Haiku    ($)
information retrieval  →  Sonnet   ($$)
complex reasoning      →  Opus     ($$$)
```

**Caching:**
- **Prompt caching** — Anthropic charges 10% for cached prefixes; if your system prompt is 10K tokens, this saves 90% on every call
- **Semantic cache** — for FAQ-style queries, cache by meaning, not exact match
- **Tool result cache** — product catalogs, prices, schemas don't change every second

**Per-session token budget:**
```python
class TokenBudget:
    def __init__(self, max_tokens=50000):
        self.used = 0
        self.max = max_tokens
    def check(self, estimated):
        return self.used + estimated <= self.max
```

When budget exceeded → polite cutoff: *"I've reached my limit for this session. Here's what I have so far..."*

### 5. The Observe → Act → Evolve loop

```
Observe → metrics, logs, user feedback, support tickets
   ↓
Act     → identify the failing pattern, prioritize
   ↓
Evolve  → add eval, fix prompt/tool/skill, re-deploy via CI
   ↓
[loop back]
```

Every production bug becomes a new eval. Your suite gets stronger forever. After 12 months you have hundreds of eval cases that capture every weird thing real users have done — and your competitors don't.

## Common traps

| Trap | Why |
|---|---|
| "I'll add evals after launch" | You won't. Add them before you have your first paying user. |
| Trusting demo results | Demos use curated inputs; real users break things you never imagined |
| Logging plain text | You'll never find what you need. JSON or nothing. |
| No rollback button | First incident teaches you. Build it now. |
| Per-token billing without margin math | You'll discover the negative gross margin at scale |
| Skipping the canary | "It's a small change" is what every outage starts with |

## The 2026 production stack (opinionated)

```
Tracing      →  Langfuse (free) or Helicone
Evals        →  Promptfoo (start here) or Inspect
CI           →  GitHub Actions
Hosting      →  Cloudflare Workers / Modal / Fly.io
Database     →  Postgres on Neon or Supabase
Queue        →  Inngest (agent-aware) or Cloudflare Queues
Payments     →  Stripe (no exceptions)
Auth         →  Clerk or WorkOS
Feature flags →  GrowthBook or Unleash
```

Cost for a solo operator running a $10K MRR product: **$50–$200/mo total infra**. Don't overspend here.

## Exercise

Take your Lesson 02 agent (with the skill). Add:
1. **Promptfoo evals** — 20 test cases, run on every commit
2. **Langfuse tracing** — see every LLM call, every tool call, every cost
3. **A `/health` endpoint** that runs 3 smoke tests

Total time: ~3 hours. You now have more production discipline than 80% of "AI startups" you'll see on Twitter.

## Further reading

- Addy Osmani, [`agent-engineer` Lesson 11](https://github.com/addyosmani/agent-engineer/tree/main/11-from-prototype-to-production)
- Hamel Husain, [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — the eval bible
- Eugene Yan, [LLM Patterns](https://eugeneyan.com/writing/llm-patterns/) — the production patterns reference

---

[← Lesson 03](../03-multi-agent-when-to-use-it/README.md) | [Next → Lesson 04A: The Boring Stack First](../04A-the-boring-stack-first/README.md) (mandatory interlude before Part 2)
