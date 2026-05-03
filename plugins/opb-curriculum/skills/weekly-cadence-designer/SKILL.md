---
name: weekly-cadence-designer
description: >
  Use this skill whenever the user wants to design or audit their weekly
  operating cadence as a solo / near-solo operator. Trigger when the user
  mentions phrases like "design my week", "calendar audit", "weekly cadence",
  "operator OS", "4-day work week", "I'm drowning in meetings", "no time to
  build", or "Friday review process". Also trigger when the user is feeling
  reactive (calendar full of other people's needs) or is at a transition
  ($10K MRR, $100K MRR, hiring, etc.). Always use this skill before
  scheduling another recurring meeting — it forces ruthless prioritization
  and the constraint-driven 4-day week.
---

# Weekly Cadence Designer Skill

This skill defines the workflow for designing a solo operator's weekly cadence — calendar blocks, meeting policy, forcing functions, and the Friday review. Based on Lesson 19's principle: *the constraint creates the priorities.*

The skill enforces:
- **4-day work week** (Mon-Thu) by default
- **Public deadlines** (Friday post / weekly metrics) as forcing functions
- **Default-no** policy on meeting requests
- **Sunday redesign** ritual (1 hour to plan the week)

---

## Hard Constraints (Check First)

### Constraint 1 — Required Input

Before designing, the user must share:
- **Current calendar** for last 7 days (anonymized OK; just block types and durations)
- **Top 3 outcomes** for this quarter (1 line each)
- **Time spent on customer support / fires last week** (hours)
- **MRR / size of business** (informs cadence intensity)

If any are missing, ask before continuing.

### Constraint 2 — No Coaching, Only Cadence

This skill is operational, not therapeutic. If the user wants to talk through career anxiety / burnout / strategy, redirect to a coach. This skill only outputs a calendar.

### Constraint 3 — Reject 7-Day Work Weeks

If the user proposes a 7-day work week, push back hard:

> "7 days of work for 18 months = burnout. Quality drops in month 6 before you notice. Take weekends. The compound depends on it. If you genuinely can't take weekends, your wedge is wrong (Lesson 16, scaling cliff)."

Refuse to design a 7-day cadence.

---

## Workflow Overview

```
Step 1: Audit last week's calendar — categorize every block
Step 2: Identify the time leaks (>20% in non-outcome work)
Step 3: Block the 4-day deep-work template
Step 4: Set the meeting policy (default-no rules)
Step 5: Wire the forcing functions (public deadlines)
Step 6: Design the Friday review process
Step 7: Schedule the Sunday redesign ritual
Step 8: Output the calendar + policy doc
```

---

## Step 1 — Calendar Audit

For the user's last 7 days, categorize every calendar block:

| Category | Examples | Should be % | Was % |
|----------|----------|-------------|-------|
| **Deep work on top 3 outcomes** | Building, writing, designing | 50%+ | __ |
| **Customer time** | Sales calls, customer interviews, support fires | 15-25% | __ |
| **Distribution** | Cold outbound, content production, community | 10-20% | __ |
| **Operations** | Bookkeeping, recruiting, internal admin | 5-10% | __ |
| **Other people's priorities** | "Pick your brain", coffee chats, networking, podcasts | < 5% | __ |
| **Reactive / unplanned** | Email, fire-fighting, drop-ins | < 10% | __ |

If "Other people's priorities" + "Reactive" > 30% → critical leak. Address first.

---

## Step 2 — Identify the Leaks

For the leaks (categories at > target %):

| Leak | Hours/week | Source |
|------|-----------|--------|
| | | |

For each, identify:
- **Source** — who/what is generating this work
- **Removable?** (Y/N) — can it be canceled?
- **Replaceable by async?** (Y/N) — Slack / Loom / doc instead of meeting?
- **Delegatable?** (Y/N) — VA, agent, or contractor?

Aim to remove or convert ≥ 50% of leak time.

---

## Step 3 — Block the 4-Day Template

### The default 4-day template

```
                 Mon          Tue          Wed          Thu          Fri          Sat-Sun
8:00–12:00       DEEP WORK    DEEP WORK    DEEP WORK    DEEP WORK    REVIEW       OFF
                 (Outcome 1)  (Outcome 2)  (Outcome 1)  (Outcome 2)  Plan + post
12:00–13:00      Lunch        Lunch        Lunch        Lunch        Buffer       OFF
13:00–15:00      SHALLOW      SHALLOW      SHALLOW      SHALLOW      Open block   OFF
                 (Email,      (Email,      (Email,      (Email,      Customer
                 support)     support)     support)     support)     calls / catch-up)
15:00–16:00      Customer     Customer     Customer     Customer     Free         OFF
                 calls (1)    calls (1)    calls (1)    calls (1)
16:00–17:00      LEARNING     LEARNING     LEARNING     LEARNING     Free         OFF
                 / reading    / reading    / reading    / reading
```

Key rules:
- **Mornings = deep work** on the top 3 quarterly outcomes (no meetings)
- **Afternoons = shallow** (email, fires, support, customer calls)
- **End of day = learning** (1 hour reading, no exceptions)
- **Friday = review + plan + ship the build-in-public post**
- **Weekends = off** (yes, really)

### Customize for size

| Stage | Modification |
|-------|--------------|
| < $10K MRR | Reduce customer call slots; more deep work |
| $10K-100K | Standard template |
| $100K-1M | More customer calls (one daily); add team/contractor slot |
| $1M+ | Switch to bi-weekly deep work blocks; more strategy time |

---

## Step 4 — Meeting Policy (Default-No)

Output the user's meeting policy as a one-pager they can share publicly:

### Required Output Format

```
📅 [Name]'s Meeting Policy

DEFAULT: No.

I take meetings only for:
1. Direct customer feedback (paying customers)
2. Active prospects (with budget + timeline)
3. Specific exchange-of-value (defined ask + return)
4. Tier-1 press (relevant audience to my ICP)

I do NOT take meetings for:
- "Pick your brain"
- Coffee chats
- General networking
- Investor calls (not actively raising)
- Podcasts / interviews (unless audience overlaps ICP)
- Re-introduce existing tool (just send the link)

If you DM with a request:
- Be specific about what you want
- Explain the value to me
- Propose a 15-min slot, async-first
- Expect a polite no by default

Available slots: [day + time blocks per week]
Booking: [link]
```

### How to enforce

- Publish this on Twitter bio / LinkedIn / personal site
- Reply to all "let's chat" DMs with the link
- Auto-decline calendar invites without context

---

## Step 5 — Forcing Functions

Public deadlines force the cadence. The four mandatory ones:

| Function | Cadence | Format | Why |
|----------|---------|--------|-----|
| **Build-in-public post** | Weekly (Friday) | X / LinkedIn | Forces honest measurement |
| **Customer call** | Weekly (one minimum) | 30 min | Forces customer contact |
| **Metrics post** | Monthly (1st) | X / LinkedIn | Forces honest measurement |
| **Quarterly retro** | Quarterly | Public post / blog | Forces strategic review |

If a deadline is private, it slips. If it's public, it doesn't.

---

## Step 6 — The Friday Review Process

```
Friday morning (3 hours):

08:00–08:30   Pull metrics dashboard
              - MRR, customers, churn
              - Cost per customer, gross margin
              - Top 3 outcome progress (qualitative)

08:30–09:30   Customer interview review
              - Patterns from this week's customer calls
              - 1-2 specific changes to make next week

09:30–10:30   Plan next week's 3 outcomes
              - Draft 3 outcomes (must roll into quarterly goals)
              - Block the calendar for next week
              - Cancel any meetings that don't roll up to outcomes

10:30–11:00   Write Friday post
              - Specific number / story / lesson
              - Schedule for 1pm (peak engagement)

11:00         Done. Rest of Friday is open.
```

Force this every Friday. The review is non-negotiable; without it, the user optimizes for activity, not outcome.

---

## Step 7 — Sunday Redesign Ritual

Sunday afternoon (60 min):

```
1. Audit next week's calendar
   - Top 3 outcomes blocked? ☐
   - Deep work mornings protected? ☐
   - Friday review on calendar? ☐

2. Cancel one meeting that doesn't move outcomes. (Yes, every Sunday — there's always one.)

3. Pre-write skeleton of Friday's post (saves Friday brain).

4. Pull last week's metrics: did they move? Why / why not?

5. Set ONE word for the week. (Example: "Ship". "Talk-to-customers". "Distribution".)
```

This ritual lifts the operator out of reactive mode for the next 7 days.

---

## Step 8 — Output the Complete Cadence

### Required Output Format

```
### 🗓️ [User]'s Weekly Cadence — Quarter [X]

**Top 3 outcomes this quarter:**
1.
2.
3.

**Calendar template (recurring):**
Mon morning:    Deep work on Outcome ___
Tue morning:    Deep work on Outcome ___
Wed morning:    Deep work on Outcome ___
Thu morning:    Deep work on Outcome ___
Fri morning:    Review + plan + post

Daily afternoons:
13:00–15:00     Email + support (max 2h)
15:00–16:00     One customer call (or buffer)
16:00–17:00     Learning / reading

**Meeting policy:** [link or attached doc]

**Forcing functions:**
- Friday post: [day, time]
- Weekly customer call: [day, time]
- Monthly metrics post: 1st of month
- Quarterly retro: [date]

**Sunday redesign:** [time]

**Week 1 trial:**
- Cancel: [list of meetings to drop]
- Add: [list of new blocks]
- Outcome to hit: [specific MRR / customer count / shipping milestone]

**Day-30 check-in:**
- Date: [date]
- Question: "Did I work 4 days, save Sun-Sat, and ship the top 3 outcomes?"
```

---

## Worked Example — Solo SaaS Operator at $30K MRR

**Last week's audit:**
| Category | Was % |
|----------|-------|
| Deep work | 25% (target 50%) |
| Customer time | 20% |
| Distribution | 15% |
| Operations | 10% |
| Other people's priorities | 20% (LEAK) |
| Reactive | 10% |

**Leaks:**
- Pick-your-brain calls: 6 hrs/week → cancel all + publish meeting policy
- Investor pings: 2 hrs/week → "not raising" reply template
- Re-introducing tool to PMs: 3 hrs/week → Loom video + auto-reply

**New template:**
Mon-Thu mornings: deep work on (1) new feature for top customer ask, (2) Q3 pricing redesign.
Fri morning: review + plan + Friday post.
Daily 13-15: email + support.
Daily 15-16: one customer call.
Daily 16-17: reading.

**Forcing functions:**
- Friday MRR + lessons post on X (1pm)
- Tuesday customer call (recurring)
- 1st of month: monthly metrics post

**Day-30 check-in:** Did deep work hit 50%? Did 4-day week hold? Did Friday post ship every week?

---

## Common Mistakes to Avoid

- **Do not skip the Friday review.** Without it, you optimize for activity, not outcome.
- **Do not let meetings touch deep-work mornings.** Mornings are sacred.
- **Do not commit to a 7-day work week.** Burnout in 18 months.
- **Do not optimize the calendar in private.** Public deadlines are what work.
- **Do not skip the Sunday redesign.** 1 hour of planning saves 5 hours of reactive thrash.
- **Do not say yes to "just 15 minutes."** Default no.
- **Do not move customer calls if you can avoid it.** Stable times = reliable customer flow.
- **Do not forget the learning hour.** Reading 1 hr/day compounds harder than any productivity hack.

---

## Notes on Tools

| Tool | Use |
|------|-----|
| Calendar | Google Calendar / Cal.com (Cal.com lets you publish meeting policy + auto-restrict) |
| Meeting policy | Pin to Twitter bio / LinkedIn / personal site |
| Friday review | Notion or paper journal |
| Public posts | Buffer / Typefully (queue Friday post Sunday night) |
| Async replacement for meetings | Loom (record once, reuse forever) |
| Investor / press templates | Saved replies in Gmail / Superhuman |

---

## Quick Reference — The Default No List

Default-no responses to common asks:

| Request | Default reply |
|---------|---------------|
| "Pick your brain?" | "Sorry, default no on calls. If you have a specific question, happy to answer in DM." |
| "Quick coffee?" | Same as above |
| "Investor intro?" | "Not raising right now. If that changes, I'll reach out." |
| "Re-intro your tool?" | "Here's a 5-min Loom: [link]. Happy to follow up with specific questions." |
| "Speaking opportunity?" | "What's the audience? If they're [my ICP], let's talk." |
| "Press / podcast?" | "What's the audience overlap with [my ICP]? If high, yes." |

---

## Source

Lesson 19: [The 1-Person Operating System](../../19-the-one-person-operating-system/README.md)
