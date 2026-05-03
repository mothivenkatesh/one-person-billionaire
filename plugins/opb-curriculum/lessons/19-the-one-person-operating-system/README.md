# Lesson 19: The 1-Person Operating System

## TL;DR

A solo operation is a *system*, not a stack of tools. Without an operating system — daily/weekly/monthly cadences, workflow infrastructure, tool stack, and forcing functions — you'll drown in work that doesn't compound. This lesson lays out the tested OS for running a $100K-$10M MRR business as one person + agents.

## Core idea

```
1-PERSON OS = Cadence + Tools + Documentation + Boundaries

CADENCE       = the rhythm of when things happen
TOOLS         = the stack that runs the operation
DOCUMENTATION = your future self's onboarding
BOUNDARIES    = what you do, what you don't, what you delegate
```

Without all four, you're not running a business — you're firefighting a side project.

## How it works in practice

### Daily cadence (4 days/week)

Force a 4-day work week from the start. It will feel impossible. Do it anyway. The constraint forces the priorities.

```
Mon-Thu: 4-hour deep work block + 2-hour shallow block + 1-hour learning

Morning (4 hrs):    one big problem (product, sales, or strategy)
Afternoon (2 hrs):  inbox, customer support, agent supervision
End of day (1 hr):  reading / learning (this curriculum, books, signals)

Friday: open / catch-up / personal / experiments
Sat-Sun: off (yes, really; the compound depends on it)
```

Why 4 days: forces ruthless prioritization. The 5th day is for what got dropped. The weekend is for compounding.

### Weekly cadence

```
Monday morning:     Week plan (top 3 outcomes; nothing else)
Monday-Thursday:    Execute the 3 outcomes
Friday morning:     Week review + metrics + agent audit
Friday afternoon:   Plan next week + ship the build-in-public post
```

The Friday review is non-negotiable. Without it, you optimize for activity, not outcome.

### Monthly cadence

```
1st of month:       Full metrics review (cohort retention, MRR, margin, CAC)
                    Compare to last month + 3 months ago
                    Identify the one thing to fix this month
1st week:           Customer interviews (3-5 calls with paying customers)
2nd week:           Product/eng work toward the "one thing"
3rd week:           Distribution work (whichever channel needs investment)
4th week:           Ship + content + plan next month
```

### Quarterly cadence

```
Pre-quarter (last week of prior):  Strategic review
                                    Are we on the right wedge? Pricing? Channels?
                                    Set 3 goals for the quarter (no more)

End of quarter:                    Brutally honest scorecard
                                    Did we hit the goals? Why/why not?
                                    What did we learn? What changes?
```

### The 7-tool stack (everything you need)

Resist the urge to optimize tool choice forever. These work:

| Function | Tool | Why |
|---|---|---|
| **Code editor** | Cursor / Claude Code | Best AI integration |
| **Code repo** | GitHub | Industry default |
| **Hosting** | Vercel / Cloudflare / Modal | Agent-friendly |
| **DB** | Postgres on Neon / Supabase | Boring, scales |
| **Payments** | Stripe (mandatory) | Universal, well-trusted |
| **Auth** | Clerk or magic-link | Skip building this |
| **Email (transactional)** | Resend or Postmark | Don't roll your own |
| **CRM** | Notion or Airtable until $50K MRR; HubSpot Free after | Cheap until you need workflow |
| **Analytics** | Posthog (self-host on Hetzner: $5/mo) | Privacy + cost |
| **Observability** | Langfuse free tier | Agent-aware |
| **Project management** | Linear personal or Notion | Don't use Jira |
| **Bookkeeping** | Xero or QuickBooks Online + your CPA | Don't roll your own |
| **Help center** | Intercom Articles or Crisp | Self-serve docs |

That's it. Don't add tools "to try." Add only when a real friction point demands.

### Documentation (your future self's onboarding)

Document everything in your second brain:

```
/me              ← who you are, what you optimize for
/strategy        ← strategic context, current quarter goals
/playbooks       ← how to do recurring tasks
/runbooks        ← what to do when X happens
/customers       ← customer interview notes
/decisions       ← ADRs (architecture decision records)
/wiki            ← domain knowledge, library of frameworks
/log             ← daily/weekly journal
```

Why: your business is in your head. If you get hit by a bus (or just take a vacation), nothing happens unless this is documented. **More importantly: it lets agents do work for you** because they can read these docs.

You're already most of the way there with your second-brain setup. Use it.

### Boundaries (what you say no to)

The biggest threat to solo operations is *opportunity overflow*. Every week you'll be offered:
- Calls with potential partners
- Speaking opportunities
- "Just 15 minutes" of someone's time
- New product ideas you didn't ask for
- Investor intros
- Press requests

The default answer is **no**. Specifically:

| Request | Default answer | Exception |
|---|---|---|
| Coffee chat / pick your brain | No | Direct customer feedback |
| Speaking gigs | No | Audience is your exact ICP |
| Investor calls | No | You're actively raising |
| Partnership discussions | No | Specific exchange proposed |
| Press / media | No | Tier-1 publication relevant to ICP |
| New product idea you had | No | Aligned with current strategy |

The default-no is what creates the time to compound. Most operators say yes too often.

### Forcing functions

Build *external* commitments that force the cadence:

- **Friday public update post** — accountability via build-in-public
- **Weekly customer call** — forces customer contact
- **Monthly metrics post** — forces honest measurement
- **Quarterly retro post** — forces strategic review

If a deadline is private, it slips. If it's public, it doesn't.

## Common traps

| Trap | Why |
|---|---|
| 7-day work weeks | Burnout in 18 months; quality drops before the burnout |
| Tool-shopping as procrastination | Stop. Use the boring stack. |
| No documentation | Future you will hate present you |
| No boundaries | Your week becomes other people's priorities |
| All cadences private | They slip silently |
| Skipping Friday review | You optimize for activity, not outcome |
| Reactive scheduling | Calendar fills with other people's needs; nothing of yours ships |

## The "weekend redesign" exercise

Sunday afternoon, 1 hour:
1. Calendar audit of last week — what % of time was on your top 3 outcomes?
2. Pull next week's calendar — block deep work first, meetings around it
3. Send 1 email to cancel a meeting that doesn't move outcomes
4. Pick the 3 outcomes for the coming week (write them down)
5. Pre-write Friday's build-in-public post (skeleton)

Do this every Sunday for 8 weeks. Compare week-1 calendar to week-8 calendar. The shift will be dramatic — and your MRR will reflect it.

## Exercise

**Design your week.**

Open a calendar. Block:
- 4 deep-work mornings (4 hours each)
- 4 shallow afternoons (2 hours each)
- 4 learning hours (1 hour, EOD)
- Friday review + planning + post (3 hours)
- Customer call (1 weekly, recurring)
- Metrics review (1st of month, 2 hours)

Send all current recurring meetings to:
- Keep (essential)
- Move (consolidate to one block)
- Cancel (most of them)

Within 2 weeks, your calendar should look like a builder's, not a manager's. If it doesn't, you haven't said no enough times.

## Further reading

- Cal Newport, *Deep Work* + *Slow Productivity* — the cadence framework
- David Allen, *Getting Things Done* — the OS for processing inputs
- Sam Carpenter, *Work the System* — the systems mindset for solo operators
- Tiago Forte, *Building a Second Brain* — the documentation framework

---

[← Lesson 18](../18-hiring-agents-not-humans/README.md) | [Next → Lesson 20: The 10-Year Compound](../20-the-10-year-compound/README.md)
