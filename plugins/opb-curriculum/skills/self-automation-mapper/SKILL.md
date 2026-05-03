---
name: self-automation-mapper
description: >
  Use this skill whenever the user wants to identify the highest-ROI tasks in
  their own work to automate first — before building agents for paying
  customers. Trigger when the user mentions phrases like "what should I
  automate?", "automate myself first", "free up my time", "agent for my
  workflow", "where am I bottlenecked?", or shares a calendar / task list
  and asks for automation prioritization. Also trigger when the user is
  evaluating whether a personal pain is product-worthy. Always use this
  skill before drafting a personal agent — it enforces measurement,
  scoring, and the "build only top-3" rule.
---

# Self-Automation Mapper Skill

This skill defines the end-to-end workflow for mapping a user's own week, identifying the **3 highest-ROI tasks to automate**, and turning those into specs for personal agents. The principle from Lesson 17: *"if you don't trust an agent to do YOUR work, why are you charging customers to trust it with theirs?"*

The skill enforces:
- **Hard cap of 3 automations** at a time (so they actually ship)
- **Measurement-first** discipline — no automation without baseline time data
- **Taste rules** for what to automate vs what to keep human
- **30-day re-audit** with concrete kill criteria

---

## Hard Constraints (Check First)

### Constraint 1 — Baseline Time Data Required

Before recommending any automation, confirm the user has either:
- Logged 5 days of actual time spent per task (RescueTime / Toggl / paper), OR
- Reflective log of last week's typical day with hours per task

If neither exists, stop and say:

> "⚠️ Before I can recommend automations, I need 5 days of time data — or a reflective log of last week with hours per task. Without that, we're guessing. Want me to send a tracking template?"

### Constraint 2 — Maximum 3 Automations

Cap recommendations at 3 candidates per cycle. More than 3 = none get shipped. Make this explicit to the user up front.

### Constraint 3 — Required Input Fields

Each task must have at minimum:
- Task name (1 line)
- Hours/week spent
- Pleasant / Neutral / Boring rating
- Whether the output is "right answer is knowable" or "judgment call"

If any of the above are missing, ask the user to fill them in before scoring.

---

## Workflow Overview

```
Step 1: Audit the week — categorize all tasks
Step 2: Score each task on the 5-criterion automation matrix
Step 3: Apply the taste filter — what NOT to automate
Step 4: Pick top 3 candidates by combined score
Step 5: Spec each automation (input → process → output → KPI)
Step 6: Set the 30-day kill criteria
```

---

## Step 1 — Categorize the Week

Take the user's task list and bucket each task into one of these categories:

| Category | Examples |
|----------|----------|
| **Creative judgment** | Strategy decisions, hard customer conversations, hiring, design choices |
| **Recurring boring work** | Email triage, status reports, expense categorization, scheduling |
| **Research** | Reading docs, summarizing articles, comparing tools |
| **Drafting** | First drafts of emails, posts, proposals, briefs |
| **Triage / routing** | Sorting inbound (DMs, tickets, alerts) into action queues |
| **Manual data work** | Reformatting spreadsheets, copy-paste between tools |
| **Meetings** | Sales calls, internal sync, customer interviews |

For each task, also note:
- Hours/week
- Pleasant / Neutral / Boring (P / N / B)
- "Right answer knowable?" (Y / N)

Output the table back to the user before scoring, so they can correct any miscategorization.

---

## Step 2 — Score the 5-Criterion Automation Matrix

For each task, score 1-5 on:

| Criterion | 1 (low) | 5 (high) |
|-----------|---------|----------|
| **Frequency** | Once a quarter | Multiple times per day |
| **Time cost** | < 30 min/week | > 5 hours/week |
| **Boredom** | Pleasant work | Pure drudgery |
| **Right-answer knowability** | Pure judgment | Clear correct output exists |
| **Reversibility of mistakes** | Catastrophic if wrong | Cheap to undo |

**Combined automation score = sum (max 25).**

Tasks scoring ≥ 18 → strong automation candidates.
Tasks scoring 12-17 → marginal; fix manually first.
Tasks scoring < 12 → keep human.

---

## Step 3 — Apply the Taste Filter

Even high-scoring tasks can be wrong to automate. Apply these veto rules:

| Veto rule | Why |
|-----------|-----|
| **Creative strategy** (positioning, pricing, hiring) | Outsourcing the *why* destroys the business |
| **Customer escalations** | Trust comes from human empathy |
| **Hiring & firing** | Catastrophic if wrong |
| **First contact with a key customer** | Reputation cost too high |
| **Crisis comms** | One bad bot response = brand damage |
| **Tax / legal / regulatory** | Keep human professionals |

If a task triggers any veto rule, drop it from the candidate list — even if the score was high.

---

## Step 4 — Pick the Top 3

From the surviving high-scorers, pick the 3 with the highest combined automation score. Display as:

```
✅ TOP 3 AUTOMATION CANDIDATES

Rank   Task                          Hrs/wk    Score    Why this one
1      [task]                        __        __/25    [1 sentence]
2      [task]                        __        __/25    [1 sentence]
3      [task]                        __        __/25    [1 sentence]

DROPPED (despite high scores):
- [task] — Veto: [which rule]
- [task] — Veto: [which rule]
```

Do **NOT** recommend automating more than 3 at a time. If the user pushes back, hold the line: "More than 3 = none shipped."

---

## Step 5 — Spec Each Automation

For each of the top 3, output a spec the user can hand to Claude Code or Cursor:

### Required Output Format

```
### 🤖 Automation [N]: [Task Name]

**Job-to-be-done:**
[1 sentence — what the agent must accomplish]

**Inputs:**
- [Input 1: source, schema]
- [Input 2: source, schema]

**Process:**
[3-5 numbered steps the agent takes]

**Outputs:**
- [Output 1: format, destination]

**KPIs (3 measurable):**
- KPI 1: [metric, target]
- KPI 2: [metric, target]
- KPI 3: [metric, target]

**Approval gates:**
- [What requires human approval before execution]

**Cost budget:**
- $___/month max (LLM + tools)

**Stack recommendation:**
- Trigger: [cron / webhook / event]
- Workflow engine: [Inngest / Cloudflare Workflows / plain script]
- LLM: [Sonnet / Haiku]
- Persistence: [Postgres / file / Notion]
```

---

## Step 6 — 30-Day Kill Criteria

For each automation, define the conditions under which to KILL it:

| Failure mode | Kill threshold |
|--------------|----------------|
| Hours saved < 1/week | Kill at day 30 |
| Quality score < 7/10 (user-graded) | Fix or kill at day 30 |
| Cost > recovered value | Kill immediately |
| User finds it stressful / no trust | Kill |

Force the user to commit to these thresholds in writing.

---

## Worked Example

**User's week (top 5 tasks by hours):**

| Task | Hrs/wk | Pleasant? | Right answer knowable? |
|------|--------|-----------|------------------------|
| Customer email triage | 6 | Boring | Yes |
| Weekly metrics report | 2 | Neutral | Yes |
| Strategy deep work | 8 | Pleasant | No |
| Cold outreach research | 4 | Boring | Yes |
| Sales calls | 5 | Pleasant | No |

**Scoring:**

| Task | Freq | Time | Boredom | Knowable | Reversibility | Total | Veto? |
|------|------|------|---------|----------|---------------|-------|-------|
| Email triage | 5 | 5 | 5 | 4 | 5 | **24** | None |
| Metrics report | 4 | 2 | 3 | 5 | 5 | **19** | None |
| Strategy work | 3 | 5 | 1 | 1 | 1 | 11 | **VETO** |
| Outreach research | 4 | 4 | 5 | 4 | 5 | **22** | None |
| Sales calls | 4 | 4 | 1 | 1 | 1 | 11 | **VETO** |

**Top 3:** Email triage (24), Outreach research (22), Metrics report (19).

**Spec for #1 (Email triage):**
- Inputs: Gmail inbox (last 24h)
- Process: classify by intent (5 categories) → draft replies for known categories → escalate unknowns
- Outputs: drafts in Gmail "Drafts," summary in Slack
- KPIs: % auto-classified, % drafts user sends without edit, hours saved/week
- Approval: every draft requires user click before send
- Cost budget: $30/month
- Stack: cron 4×/day → Inngest workflow → Sonnet for classify, Haiku for draft, Gmail API

**30-day kill criteria:**
- < 3 hrs/week saved → kill
- < 60% drafts sent without major edit → fix or kill
- > $50/month cost → fix

---

## Common Mistakes to Avoid

- **Do not skip the time-data baseline.** Without it, every recommendation is a guess.
- **Do not recommend more than 3 automations.** More = none ship.
- **Do not automate creative judgment.** Vetoes exist for a reason.
- **Do not skip the kill criteria.** "We'll see how it goes" = it goes forever.
- **Do not automate something the user hates as the *only* metric** — also check frequency and time. Hating a 30-min weekly task is not enough.
- **Do not score blind to reversibility.** A high-frequency, knowable, boring task that destroys trust if wrong is still a veto.
- **Do not forget cost budget.** Some "automations" cost more in LLM than they save in time.
- **Do not skip the 30-day re-audit.** This is the difference between automating once and automating forever.

---

## Notes on Tooling

When recommending the stack for each automation:

| Need | Recommended tool |
|------|------------------|
| Cron triggers | Cloudflare Cron / GitHub Actions cron |
| Workflow durability | Inngest (default) / Temporal (high-stakes) |
| LLM (default) | Claude Sonnet 4.6 |
| LLM (cheap classifier) | Claude Haiku 4.5 |
| Persistence | Postgres (Neon / Supabase) |
| Visual review queue | Notion / Linear / Slack |
| Self-host workflow visual | n8n |
| Gmail / Slack / Notion access | Native APIs (skip MCP unless multi-user) |

Default: cron + Inngest + Sonnet + Postgres. Justify deviations.

---

## Quick Reference — Veto Rules

Tasks to KEEP HUMAN regardless of score:
- Strategy / direction / positioning
- Pricing decisions
- Hiring / firing
- Customer escalations
- First contact with key customers
- Crisis comms
- Tax / legal / regulatory
- Hard product decisions (what to build)

When in doubt: keep it human for one more cycle and re-evaluate.

---

## Source

Lesson 17: [Automate Yourself First](../../17-automate-yourself-first/README.md)
