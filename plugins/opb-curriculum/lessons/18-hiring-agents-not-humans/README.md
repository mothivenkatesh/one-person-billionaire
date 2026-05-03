# Lesson 18: Hiring Agents Instead of Humans

## TL;DR

The "1-person company" only works if you replace the org chart with an **agent chart**. Each agent fills a role: SDR, researcher, content drafter, support tier 1, ops coordinator. Each has specific KPIs, oversight, and failure modes. Doing this badly = chaos. Doing this well = a $5M/yr operation with you and 0-2 humans. This lesson covers what actually works in 2026.

## Core idea

```
The traditional org chart:
  CEO  →  VP Sales  →  SDRs (5)
       →  VP Marketing → Content (3) + Demand gen (2)
       →  VP Ops    →  CS (4) + Bookkeeping (1)
       →  VP Eng    →  PMs (2) + Engineers (8)

The agent chart for a 1-person operation in 2026:
  YOU  →  SDR Agent (researches + drafts cold outbound for your review)
       →  Content Agent (drafts posts, you edit/approve)
       →  Support Tier-1 Agent (handles 60% of tickets autonomously)
       →  Ops Agent (bookkeeping, scheduling, recurring reports)
       →  Eng Agents (Claude Code / Cursor doing the actual coding)

Plus: 1-2 contracted humans (CPA, lawyer, fractional CMO if needed)
```

## How it works in practice

### The roles you can agentify in 2026

**1. SDR (Sales Development Representative)**
- Researches prospects (LinkedIn, news, signals)
- Drafts personalized cold messages (75-120 words, signal-first)
- Tracks responses, schedules follow-ups
- Hands warm leads to you for the call

KPIs: messages sent/week, reply rate, demo-booked rate.
Human oversight: review/approve every send for first 90 days; spot-check after.
Cost: $50-150/mo in LLM + tooling.
Replaces: ~$60K-100K/yr human SDR.

**2. Content drafter**
- Pulls from your idea library, customer convos, recent metrics
- Drafts 5 posts/week in your voice
- You edit and approve
- Schedules to Typefully/Buffer

KPIs: drafts produced/week, your edit ratio (lower = better calibration), post engagement.
Human oversight: 100% approval gate (your voice, your reputation).
Cost: $20-80/mo.
Replaces: ~$40K-80K/yr junior content marketer.

**3. Support tier 1**
- Reads incoming ticket
- Classifies: known issue (auto-resolve) vs. escalate
- Drafts replies for known issues
- For unknowns: gathers context, drafts the question for you

KPIs: % auto-resolved, customer CSAT on auto-resolved tickets, escalation accuracy.
Human oversight: review escalations daily; audit auto-resolved random sample weekly.
Cost: $50-200/mo depending on volume.
Replaces: ~$40K-70K/yr CS person.

**4. Researcher / analyst**
- Pulls data from your sources (Stripe, Posthog, Google Analytics, etc.)
- Generates weekly/monthly reports
- Surfaces anomalies for you to investigate
- Drafts presentation-ready summaries

KPIs: report timeliness, accuracy spot-checks.
Human oversight: weekly review; quarterly accuracy audit.
Cost: $30-100/mo.
Replaces: ~$60K-90K/yr analyst.

**5. Bookkeeping / ops coordinator**
- Categorizes transactions
- Reconciles accounts
- Drafts invoices, processes refunds
- Schedules meetings, manages calendar

KPIs: categorization accuracy, on-time invoicing, calendar conflict rate.
Human oversight: monthly CPA review (don't fire the human CPA).
Cost: $30-80/mo.
Replaces: ~$40K-60K/yr bookkeeper.

### Roles you should NOT agentify (yet)

| Role | Why not |
|---|---|
| **Strategy / direction** | You. This is your job. |
| **Hiring (when you do hire)** | High-stakes, hard to undo |
| **Customer escalations** | Trust comes from human empathy |
| **Sales of $10K+ deals** | Buyers want to talk to a human |
| **Crisis comms** | One bad bot response = brand damage |
| **Legal / regulatory** | Get a human lawyer on retainer |
| **Tax / compliance** | Get a human CPA |

The pattern: anything where being wrong is **expensive and hard to reverse** keeps a human. Anything where 80% right + supervision is fine, agentify.

### The "agent role design" template

For each role, document:

```
ROLE NAME:                       (e.g., "Cold Outbound SDR")
JOB-TO-BE-DONE:                  (one sentence)
KPIs:                            (3 measurable outcomes)
TOOLS / DATA ACCESS:             (which tools, which DBs, which docs)
GUARDRAILS:                      (what it must never do)
ESCALATION TRIGGERS:             (when to surface to human)
APPROVAL GATES:                  (which actions need human sign-off)
EVAL SUITE:                      (test cases that prove it's working)
WEEKLY HUMAN REVIEW:             (what you check, how long it takes)
COST BUDGET:                     ($ / month max)
KILL CRITERIA:                   (when do we shut this agent down?)
```

This forces you to treat the agent like an employee with clear scope. Most people skip this and end up with vague agents that nobody can audit.

### Annual cost comparison

Hypothetical $500K ARR business:

| Function | Traditional team cost | Agent team cost |
|---|---|---|
| SDR (1 FTE) | $80K | $1.5K |
| Content (1 FTE) | $60K | $1K |
| Support tier 1 (1 FTE) | $50K | $2K |
| Ops/Bookkeep (0.5 FTE) | $30K | $1K |
| Researcher (0.5 FTE) | $35K | $1K |
| **TOTAL** | **$255K/yr** | **$6.5K/yr** |

Plus humans you keep:
- You ($0 — you take dividends)
- CPA (~$5K/yr fractional)
- Lawyer (~$3K/yr on retainer)
- Maybe a fractional CMO ($30K/yr)

Total operating cost: ~$45K/yr vs. $255K/yr.
Margin difference at $500K ARR: 91% vs. 49% gross margin.

This is *the* unlock for solo operations crossing $1M ARR. The agentified version stays solo; the traditional version requires investors and team.

### When to swap an agent for a human

Some signals that an agent role isn't working:
- KPIs declining over 60+ days despite tuning
- Quality complaints from customers
- You spending more time supervising the agent than the work itself
- The role's complexity has outgrown what current models do well

When this happens: fractional human first (10-20 hrs/week, contractor). Don't jump to FTE. Most "agent failed; need to hire FTE" cases were actually "agent was fine; needed a fractional human in parallel for the 20% of cases agent couldn't handle."

## Common traps

| Trap | Why |
|---|---|
| Agentifying without KPIs | You can't tell if it's working |
| No approval gate on customer-facing output | One bad reply = trust damage |
| One agent doing 5 jobs | Generalist agents do all 5 mediocrely |
| Skipping the eval suite | You ship regressions silently |
| Treating agents as "set and forget" | They drift; weekly review required |
| Not tracking what gets escalated | The escalation pile is your roadmap |
| Replacing humans before agents are ready | Trust gap = customer frustration |
| Keeping humans for ego, not function | Be honest: would the agent do this 80% as well? |

## The 90-day agent-team buildout

```
Month 1:  Pick ONE role to agentify (highest time-cost)
          Build it. KPIs. Approval gates. Run for 30 days.
Month 2:  Iterate based on month-1 data.
          Add SECOND role.
Month 3:  Add third role. Audit all three.
          Document what works; kill what doesn't.

End of 90 days: 3 agents doing real work; ~15-25 hours/week of human work replaced.
```

By month 12, you should have 5-7 agent "roles" running and a clear sense of which ones are critical.

## Exercise

**Pick ONE role to agentify this month.**

Document it using the template above. Constraint: it must have:
- Clear KPIs (3, measurable, weekly)
- Defined approval gates (where humans review)
- An eval suite (10+ cases)
- A budget cap

Run it for 30 days. At day 30, calculate:
- Hours/week of your work it replaced
- Cost to run
- Quality (KPI numbers + qualitative spot-check)

If positive ROI: build the second one. If not: diagnose why.

## Further reading

- Anthropic, [Building agent teams](https://www.anthropic.com/research) — the multi-agent patterns
- Bret Taylor / Sierra, [The agentic enterprise](https://sierra.ai/) — the enterprise playbook (adapt for solo)
- Box, "Agent KPI design" — the operational framework

---

[← Lesson 17](../17-automate-yourself-first/README.md) | [Next → Lesson 19: The 1-Person OS](../19-the-one-person-operating-system/README.md)
