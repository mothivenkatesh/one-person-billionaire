---
name: production-readiness-audit
description: >
  Runs the production-readiness checklist before an agent product accepts a paying
  customer. Covers eval-gated CI, canary rollouts, observability, cost control,
  and the incident loop. Use when shipping v1, after a near-miss outage, or when
  the user says "are we ready to take real users?"
license: MIT
metadata:
  source-lesson: 04
---

# Production Readiness Audit

You audit the agent's production readiness across 5 non-negotiables. You refuse to bless a launch if any are missing.

## When to activate
- "Ready to ship to paying customers?"
- "We had an outage — what should we add?"
- Pre-launch review
- After Lesson 01-04 implementation

## The workflow

### Step 1: Eval-gated CI/CD

Check:
- [ ] Eval suite exists with ≥ 20 cases
- [ ] Evals run on every PR
- [ ] Failures block merge
- [ ] Safety category has a 100% hard gate
- [ ] Functional / latency / cost categories have soft thresholds

Gap → assign to fix BEFORE launch.

### Step 2: Canary + rollback

- [ ] Can deploy v2 alongside v1
- [ ] Can route a % of traffic to v2 (5/25/50/100)
- [ ] Can rollback in < 60 seconds
- [ ] Feature flag system in place

### Step 3: Observability

- [ ] Structured JSON logs on every LLM call + tool call
- [ ] Distributed tracing (OpenTelemetry → Langfuse / Helicone)
- [ ] Dashboard with: completion rate, P95 latency, cost/session, escalation rate, safety incident rate, tool error rate
- [ ] Alerts on each metric

### Step 4: Cost control

- [ ] Per-session token budget enforced (hard cap)
- [ ] Model routing (cheap model for easy steps)
- [ ] Prompt caching enabled for stable prefixes
- [ ] Per-customer cost tracking in place

### Step 5: Incident loop

- [ ] /health endpoint with 3 smoke tests
- [ ] External monitor (UptimeRobot / BetterStack) hits it every 60s
- [ ] Pager (PagerDuty / SMS) on failure
- [ ] Runbooks for: payment failed, refund, downgrade, agent timeout, LLM provider outage

## Step 6: The 7-question gate

Before ship, all 7 must be YES:
1. Have I run the full eval suite this week?
2. Can I rollback in < 60 seconds?
3. Do I see every LLM/tool call in tracing?
4. Is per-customer cost tracked?
5. Have I tested with 1 adversarial input today?
6. Is there a clear "stop" if cost runs away?
7. Do I have one human-in-loop checkpoint for irreversible actions?

If any NO → not ready. Fix and re-audit.

## Output

```
PRODUCTION READINESS AUDIT — [Product]
Date: [today]

Layer            Pass?     Gap
Evals            [Y/N]    [...]
Canary           [Y/N]    [...]
Observability    [Y/N]    [...]
Cost control     [Y/N]    [...]
Incident loop    [Y/N]    [...]

Verdict:         [SHIP / DELAY — fix gaps first]
ETA to ready:    [N days]
```

## Hard rules
- ❌ Don't bless a launch with NO evals. Period.
- ❌ Don't bless a launch with no rollback path.
- ❌ "We'll add observability after launch" → reject. After is too late.

## Source
[Lesson 04: Production-Ready](../../04-production-ready/README.md)
