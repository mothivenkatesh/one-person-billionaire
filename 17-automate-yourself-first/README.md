# Lesson 17: Automate Yourself First

## TL;DR

Before you build agents for paying customers, build them for **yourself**. Eat your own dog food. The agents you build to automate your own work will: (a) prove the technology to you, (b) free 10-20 hours/week, (c) become product features, (d) generate content for build-in-public. Most operators skip this and wonder why their agents don't actually work for users.

## Core idea

```
If you don't trust an agent to do YOUR work,
why are you charging customers to trust it with theirs?
```

The "automate yourself first" principle has 3 functions:
1. **Proof** — you've actually deployed agents in real work
2. **Leverage** — the freed time funds your business
3. **Authenticity** — your build-in-public is *real* (not theatre)

## How it works in practice

### Step 1: map your own week

Track your actual work for 5 days. Use any tool (RescueTime, Toggl, paper). Categorize:

| Category | What goes here |
|---|---|
| **Creative judgment** | Strategy, design, hard customer convos, hiring decisions |
| **Recurring boring work** | Email triage, status reports, expense categorization, scheduling |
| **Research** | Reading docs, comparing tools, summarizing articles |
| **Drafting** | First drafts of emails, posts, proposals |
| **Triage / routing** | Sorting inbound (DMs, tickets, alerts) into action queues |
| **Manual data work** | Reformatting spreadsheets, copy-paste between tools |
| **Meetings** | (Often automatable: prep + notes + follow-up) |

Most knowledge workers find:
- 30-40% creative judgment (NOT automatable yet)
- 60-70% in the bottom 6 categories (HIGHLY automatable in 2026)

### Step 2: agentify the highest-leverage 3

Don't try to automate everything at once. Pick the **3 tasks that consume the most time AND have clearest "good output"**.

For most operators, these end up being:

**1. Email triage**
- Agent reads inbox every 2 hours
- Categorizes: urgent / customer / sales prospect / newsletter / noise
- Drafts replies for the bottom 3 categories
- You approve/edit/send

Time saved: 5-10 hours/week.

**2. Weekly status / metrics report**
- Agent pulls from Stripe, Posthog, your support tool
- Synthesizes into a one-page summary
- Drafts the build-in-public post version
- You read in 5 minutes (vs. 90 min compiling)

Time saved: 1-2 hours/week. Plus you actually do it weekly now.

**3. Research / draft of one recurring deliverable**
- Cold outbound list research (the per-prospect signal hunt)
- Customer-facing newsletter first drafts
- Sales call prep (pull LinkedIn, recent posts, mutual connections)

Time saved: 3-8 hours/week, depending on volume.

Total time freed: 9-20 hours/week. That's a part-time job back.

### Step 3: build with your harness, not someone else's

Use the same stack you'd ship to customers:
- Anthropic SDK (or whatever model you're betting on)
- Your own skills + tools
- Real evals (graded by *you*, since you're the user)
- Real observability (so you see when it fails)

**Why:** the agents you build for yourself will surface 10× more bugs than the ones you build for "users." Because you're the user. You won't tolerate the mediocrity.

The bugs you find this way are the ones your customers would have found — except now you fix them before charging.

### Step 4: where agents actually earn their keep (vs. lose money)

| Task | Agent ROI | Reason |
|---|---|---|
| Inbox triage / drafting | High | Recurring, structured input, "good enough" works |
| Lead enrichment / research | High | Repeatable, parallelizable, time-intensive manually |
| Status reports / aggregation | High | Pull-and-summarize is what LLMs are best at |
| First drafts of recurring content | Medium-High | You edit; agent saves blank-page time |
| Customer support tier 1 | Medium | Saves time; risk of bad-experience escalation |
| Code review (for your own code) | Medium-High | You catch what you missed; agent catches what you did |
| Calendar / scheduling | Medium | Cal.com + agent works; pure agent risky |
| Creative strategy decisions | **Low / negative** | Don't outsource this |
| Hiring decisions | **Low / negative** | Same |
| Customer escalations / hard convos | **Low / negative** | Trust comes from human-to-human |

**The taste rule:** automate work where "80% right is fine." Don't automate work where "wrong is catastrophic."

### Step 5: the meta-pattern

After 6 months of this, you'll notice:
- Your most-used personal agents are *the products other people would pay for*
- Your skill library has the patterns your customers need
- Your evals have caught failures you'd otherwise have shipped
- Your build-in-public has actual proof, not vapor
- Your time freed up funds your sales / growth work

This is how most successful 1-person AI businesses started: the founder's own pain → automated solution → "wait, would others pay for this?" → product.

Examples:
- Linear — Karri Saarinen wanted his own issue tracker
- Tailwind — Adam Wathan wanted his own utility-first CSS
- Granola — founders wanted their own meeting tool
- Cursor — anysphere wanted their own AI IDE
- Many of the best AI tools in 2026 — same pattern

Your own pain is the most validated wedge available to you.

## Common traps

| Trap | Why |
|---|---|
| Building agents for "everyone" before yourself | You don't know what works |
| Using the agent twice and abandoning | Habit takes 30 days; commit |
| Automating what you should be deleting | Some work shouldn't exist; question it first |
| Agentifying creative work | You'll regret it; taste matters |
| Trusting outputs without spot-checks for the first month | Builds blind trust in bad outputs |
| Not measuring time saved | Without numbers, you can't justify continuing |

## The 3 numbers to track

For each personal agent you build:
1. **Time saved/week** (be honest; measure for 2 weeks)
2. **Quality of output** (1-10; have a friend grade randomly)
3. **Cost to run** (dollars/month; cheap is fine)

If time saved < 1 hr/week, kill it. If quality < 7/10, fix it before relying. If cost > $50/mo for personal use, optimize (Lesson 14).

## Exercise

**This week: automate 1 hour/week of your own work.**

Pick the task you find the most boring AND that has a clear "right answer." (Most often: email triage, weekly status, or recurring research.)

Build it with the stack from Lessons 01-04. Use it for 2 weeks. Track time saved.

If it works:
- Build the next one
- Consider whether you'd pay $99/mo for it
- If yes: that's your next product

If it doesn't:
- Diagnose: is it the wedge (wrong task)? the prompt? the tools? the model?
- Fix and retry, OR pick a different task

Most operators who do this exercise discover their first product idea by month 2.

## Further reading

- shareAI-lab, [`learn-claude-code`](https://github.com/shareAI-lab/learn-claude-code) — the harness for self-automation
- Anthropic, [Claude Code](https://www.anthropic.com/news/claude-code) — eat-your-own-dogfood example
- Pieter Levels, ["I built tools for myself"](https://levels.io/) — the canonical pattern
- Tony Dinh, [build-in-public archive](https://tonydinh.com/) — same pattern, different vertical

---

[← Lesson 16](../16-the-scaling-cliff/README.md) | [Next → Lesson 18: Hiring Agents Instead of Humans](../18-hiring-agents-not-humans/README.md)
