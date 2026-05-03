---
description: Audit an existing AI product across harness, production-readiness, boring-stack opportunities, margin, and retention. Outputs a prioritized fix list.
argument-hint: "<your product description + current MRR + biggest concern>"
---

# /audit-product — Full product audit before scaling

Chains 5 skills to audit an existing AI product across the 5 dimensions that kill solo operators in months 6-18: harness moat, production reliability, unnecessary AI cost, margin, and retention.

## Use this when

- You have ≥ 5 paying customers and want to "go bigger"
- You're at $10K-50K MRR and feel something is off
- Before raising prices or running a paid acquisition campaign
- After an outage, churn spike, or cost surprise

## Workflow

### Step 1: Audit the harness moat

Activate [`harness-auditor`](../skills/harness-auditor/SKILL.md).

- Score the 5 layers (tools / skills / context engineering / guardrails / permissions) 1-10
- Apply the wrapper test: "If Anthropic ships this in their next release, do you die?"
- Identify the moat type (data / workflow / distribution / brand / integration / NONE)
- Output: 30-day moat sprint to lift the weakest layer

### Step 2: Audit production-readiness

Activate [`production-readiness-audit`](../skills/production-readiness-audit/SKILL.md).

- Check: eval-gated CI, canary rollouts, observability, cost control, incident loop
- Run the 7-question gate
- Output: SHIP / DELAY verdict + gap list with ETAs

### Step 3: Audit unnecessary AI use

Activate [`boring-stack-auditor`](../skills/boring-stack-auditor/SKILL.md).

- For each step: does this need an LLM, or could regex/parser/switch/template do it?
- Identify workflow-engine fit (Inngest / Temporal / n8n)
- Apply the 8 reliability primitives checklist
- Output: replacement plan + cost + reliability projection

### Step 4: Audit margin

Activate [`margin-auditor`](../skills/margin-auditor/SKILL.md).

- Compute current gross margin per customer (refuse to proceed without per-customer cost data)
- Apply the 5 cheapest fixes: model routing → prompt caching → semantic cache → token discipline → per-customer caps
- Output: target margin + action this week

### Step 5: Audit retention

Activate [`retention-cohort-analyzer`](../skills/retention-cohort-analyzer/SKILL.md).

- Pull cohort table (refuse without cohort data)
- Identify the M0→M1 cliff (the AI-product novelty cliff)
- Force 5 churn-customer interviews
- Diagnose dominant cause + prescribe retention mechanic
- Output: 30-day intervention playbook

## After this command

You'll have 5 prioritized fix lists across 5 dimensions. Pick the **single highest-leverage fix** (usually margin or retention for $10-50K MRR products) and run a 30-day sprint on just that one. Don't try to fix all 5 simultaneously.

## Refusal conditions

- No per-customer cost data → refuse margin audit; fix instrumentation first
- No cohort data → refuse retention audit; fix instrumentation first
- < 5 paying customers → refuse the full audit; too early to optimize, focus on customer acquisition (`/start-outbound`)
