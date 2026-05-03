---
name: agent-role-designer
description: >
  Use this skill whenever the user wants to design an agent that fills a specific
  business role (SDR, content drafter, support tier 1, researcher, ops). Trigger
  when the user mentions phrases like "agent for X role", "agentify my SDR",
  "replace my VA with an agent", "agent KPIs", "give the agent a job
  description", or "should I hire or agentify?". Also trigger when the user is
  scoping an agentified team or comparing agent vs human FTE costs. Always use
  this skill before deploying an agent to do recurring real-money or
  customer-facing work — it enforces KPIs, approval gates, and kill criteria.
---

# Agent Role Designer Skill

This skill defines the workflow for designing a **specific agent "role"** that fills a business function — like hiring an employee, but for an AI agent. The output is a complete role spec the user can hand to Claude Code / Inngest / their stack of choice to build.

The skill enforces:
- **Job description with measurable KPIs** (no vague "do X")
- **Explicit approval gates** for irreversible actions
- **Eval suite** before deployment
- **Weekly human review cadence**
- **Kill criteria** with concrete thresholds

---

## Hard Constraints (Check First)

### Constraint 1 — Role Must Be Recurring, Not One-Off

Agentification only earns its keep on **recurring** work. If the user wants an agent for a one-off project, push back: "Hire a contractor for one-offs; agents are for recurring jobs."

### Constraint 2 — Required Input Fields

Before designing, confirm the user has provided:
- **Role name** (e.g., "Outbound SDR Agent")
- **Job-to-be-done** (1 sentence)
- **Volume / frequency** (per day / per week)
- **Customer-facing or internal?**
- **Reversibility of mistakes** (high / low)
- **Existing human equivalent cost** (if any)

If any are missing, ask before designing.

### Constraint 3 — Reject Veto-Listed Roles

Some roles should NOT be agentified in 2026 — refuse and explain:

| Veto'd role | Why |
|-------------|-----|
| Strategy / direction | This is the founder's job; outsourcing destroys the business |
| Customer escalations | Trust comes from human empathy |
| Hiring / firing | Catastrophic if wrong |
| Crisis comms | One bad bot response = brand damage |
| Tax / legal / regulatory | Keep professionals |
| Sales of $10K+ deals | Buyers want to talk to a human |

If the user proposes one of these, refuse. Suggest a fractional human instead.

---

## Workflow Overview

```
Step 1: Confirm role + reject veto-list roles
Step 2: Define job-to-be-done + KPIs (3 measurable)
Step 3: Map tools, data access, and constraints
Step 4: Define guardrails and approval gates
Step 5: Build the eval suite (pre-deployment)
Step 6: Set weekly human review cadence
Step 7: Define kill criteria
Step 8: Output the complete role spec
```

---

## Step 1 — Confirm the Role

Restate the role in your own words back to the user. Confirm:
- Is this *recurring* (≥ weekly)?
- Is this *measurable* (we can score quality)?
- Is this *reversible* (mistakes are cheap to fix)?
- Is this NOT on the veto list?

If any answer is NO, stop and discuss with the user before continuing.

---

## Step 2 — Define Job-to-be-Done + 3 KPIs

The job-to-be-done is one sentence. KPIs must be:
- **Measurable** (a number you can compute weekly)
- **Targeted** (specific threshold)
- **Outcome-aligned** (not "did the work" but "produced result")

### Example — SDR Agent

**Job-to-be-done:** "Research 50 prospects per week and draft personalized cold outbound messages, queue for human review."

**KPIs:**
1. **Volume:** ≥ 50 drafts per week
2. **Quality:** ≥ 70% of drafts sent without major edit (user-rated weekly sample of 10)
3. **Outcome:** ≥ 8% reply rate on sent messages (rolling 30-day)

Force the user to define ALL THREE. Don't proceed with vague "do good cold outreach."

---

## Step 3 — Map Tools, Data, and Constraints

For the role, list:

### Tools the agent can call
- Name
- Description (when to use it)
- Input schema
- Whether the call is reversible

### Data sources
- Read access: which DBs, APIs, files
- Write access: which DBs, APIs, files (write access is ALWAYS scoped + approval-gated)

### Constraints
- Maximum tool calls per task
- Token budget per session
- Per-customer rate limit
- "Never do X" hard rules

---

## Step 4 — Guardrails + Approval Gates

For every potentially-irreversible action, define an approval gate.

### Required Output Format

| Action | Reversibility | Approval gate |
|--------|---------------|---------------|
| Draft cold email | Reversible | None — human reviews before send |
| Send cold email | Irreversible | Human click required |
| Update CRM with new contact | Reversible | None |
| Spend > $X on LLM tokens in one session | Hard cap | Auto-halt |
| Hit rate-limit on third-party API | Reversible | Auto-backoff |

Cover at minimum:
- Customer-facing communication (always gated)
- Money movement (always gated)
- Data write to systems of record (always gated)
- Cost spikes (auto-halt)

---

## Step 5 — Eval Suite (Pre-Deployment)

The agent does not deploy without passing 20+ evals. Build them:

### Categories

| Category | Cases | Pass criteria |
|----------|-------|---------------|
| **Functional correctness** | 10 happy paths | ≥ 90% correct |
| **Tool selection** | 5 tool-routing cases | ≥ 95% correct tool |
| **Edge cases** | 3 known weird inputs | Reasonable output (no crash) |
| **Adversarial** | 2 prompt injection / jailbreak | 100% refused |

Provide the eval list as a YAML or table. Refuse to bless deployment without these.

---

## Step 6 — Weekly Human Review Cadence

For the first 90 days, mandatory weekly review (~30 min):

```
Monday morning checklist:
☐ Review last week's KPIs (3 numbers)
☐ Spot-check 5 random outputs (grade quality 1-10)
☐ Audit any escalations / approval-gate denials
☐ Review cost spend
☐ Update prompts / tools if needed
☐ Add any new failure modes to eval suite
```

After 90 days, can drop to bi-weekly *only if* KPIs are stable and quality > 8/10.

---

## Step 7 — Kill Criteria

When to shut the agent down:

| Trigger | Action |
|---------|--------|
| KPI declines for 2 consecutive weeks despite tuning | Pause; investigate |
| Quality < 7/10 in spot-checks for 2 weeks | Pause; rebuild eval suite |
| Customer complaint about output quality | Investigate within 24h |
| Cost > 2× projected for 2 weeks | Throttle or kill |
| Adversarial input bypassed guardrails | Kill immediately; rebuild |

Force the user to commit to these thresholds in writing. "We'll see how it goes" = the agent runs indefinitely with degrading quality.

---

## Step 8 — Output the Complete Role Spec

### Required Output Format

```
### 🤖 Agent Role: [Name]

**Job-to-be-done:**
[1 sentence]

**KPIs (weekly):**
| Metric | Target | Source |
|--------|--------|--------|
| 1.     |        |        |
| 2.     |        |        |
| 3.     |        |        |

**Tools:**
| Tool | When to use | Reversibility |
|------|-------------|---------------|
|      |             |               |

**Data access:**
- Read: [list]
- Write: [list, with approval gates]

**Guardrails:**
- [list]

**Approval gates:**
| Action | Gate type | Approver |
|--------|-----------|----------|
|        |           |          |

**Eval suite (≥ 20 cases):**
[YAML or table]

**Weekly review:**
- Day: [Monday]
- Time: [30 min]
- Checklist: [as above]

**Kill criteria:**
| Trigger | Action |
|---------|--------|
|         |        |

**Cost budget:** $___/month
**Replaces:** [human role + cost OR specific user time saved]

**Stack:**
- Trigger: [event/cron]
- Workflow: [Inngest / Temporal / cron+queue]
- LLM(s): [Sonnet / Haiku per step]
- Persistence: [Postgres / Notion / file]

**Deployment readiness:**
- [ ] Evals passing
- [ ] Approval gates wired
- [ ] Cost cap configured
- [ ] Weekly review on calendar
- [ ] Kill criteria documented
```

---

## Worked Example — Outbound SDR Agent

**Job:** Research 50 B2B SaaS founder prospects/week, draft personalized cold emails, queue for human review.

**KPIs:**
1. Volume: ≥ 50 drafts/week
2. Quality: ≥ 70% sent without major edit
3. Outcome: ≥ 8% reply rate on sent

**Tools:**
| Tool | When | Reversibility |
|------|------|---------------|
| `linkedin_search(query)` | Find prospects matching ICP | Reversible |
| `fetch_recent_posts(profile_url)` | Get signal for hook | Reversible |
| `draft_email(prospect, template)` | Generate email | Reversible (draft, not send) |
| `enqueue_for_review(draft)` | Send to user's review queue | Reversible |

**Data:**
- Read: LinkedIn API, recent posts, company website, CRM (read-only)
- Write: NONE (drafts only — human sends)

**Approval gates:**
| Action | Gate | Approver |
|--------|------|----------|
| Send email | Click required | User |
| Add to CRM as new contact | Auto-approve | None (reversible) |

**Evals (20):**
- 15 happy paths (different ICPs / signals)
- 3 edge cases (no recent post, no LinkedIn, dead account)
- 2 adversarial (prompt injection in profile bio)

**Weekly review:** Monday 9am, 30 min.

**Kill criteria:**
| Trigger | Action |
|---------|--------|
| Reply rate < 3% for 2 weeks | Pause; revisit hook strategy |
| Quality < 7/10 | Pause; rebuild eval set |
| Cost > $200/month | Throttle to 25 prospects/week |

**Cost budget:** $150/month
**Replaces:** ~$60K/yr SDR
**Stack:** Cron Mon-Fri 8am → Inngest workflow → Sonnet (drafts) + Haiku (classification) → Postgres + Slack review queue

---

## Common Mistakes to Avoid

- **Do not deploy without an eval suite.** "We'll add evals later" = silent regressions.
- **Do not skip approval gates on customer-facing actions.** One bad bot reply destroys trust permanently.
- **Do not give an agent write access to systems of record without gates.** Reversible writes only.
- **Do not skip the weekly review.** Agents drift. They need supervision.
- **Do not commit to "we'll figure out KPIs."** Without 3 measurable KPIs, you can't tell if it's working.
- **Do not hide the cost budget.** Surprise LLM bills are how startups die.
- **Do not put humans on the veto list inside the agent's scope.** Strategy / hiring / crisis = always human.
- **Do not deploy an agent that exceeds the human FTE cost it replaces** (rare but happens with cheap agents that need lots of LLM calls).

---

## Notes on Cost Math

When recommending agent vs human:

| Function | Human FTE/yr | Agent ($/year, LLM + tools) | Agent's KPI watch |
|----------|--------------|----------------------------|-------------------|
| SDR | $60-100K | $1.5-3K | Reply rate, drafts/week |
| Content drafter | $40-80K | $1-2K | Drafts/week, edit ratio |
| Support tier 1 | $40-70K | $2-5K | % auto-resolved, CSAT |
| Researcher / analyst | $60-90K | $1-2K | Report timeliness, accuracy |
| Bookkeeping / ops | $40-60K | $1-2K | Categorization accuracy |

Always include the comparison so the user sees the leverage.

---

## Quick Reference — Roles That Work / Don't (2026)

**✅ Works well:**
- SDR / outbound research
- Content drafting (your edit required)
- Support tier 1 (FAQ-style)
- Analyst / weekly reporting
- Bookkeeping / categorization
- Triage / routing

**❌ Don't (yet):**
- Strategy / direction
- Hiring / firing
- Customer escalations
- Crisis comms
- High-stakes legal / tax / compliance
- $10K+ ACV sales conversations
- Hard creative judgment

---

## Source

Lesson 18: [Hiring Agents Instead of Humans](../../18-hiring-agents-not-humans/README.md)
