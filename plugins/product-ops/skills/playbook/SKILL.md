---
name: playbook
description: Lightweight product operations SOP for small teams (1-2 PMs, 3-4 devs). Six-stage execution lifecycle (Discovery → Definition → Design → Build → Release → Learn) with templates, gates, and weekly cadence. Use when planning product execution rituals, writing PRDs, or designing release checklists.
---

# Product Operations Playbook
_A lightweight SOP for running product execution in a small team (1-2 PMs, 3-4 devs)._

> This draws from how we run product at Scrut (B2B GRC). Context is different — your fintech community app is consumer/social with compliance overtones — but the execution muscle is the same. Take what fits, drop what doesn't.

---

## 1. Principles before process

Four things to internalize before you touch any template:

1. **Ship small, ship often.** A PRD that ships in 2 weeks beats a perfect one that ships in 8.
2. **Admin/governance controls ship _before_ the user-facing feature they govern.** Our biggest incident (see §9) was shipping user notifications before the admin panel to configure them existed.
3. **Specs are stakeholder contracts, not docs.** A story isn't "ready" until CS, Design, Eng, and (where relevant) Legal/Compliance have signed off.
4. **Every feature has a measurement plan.** If you can't say how you'll know it worked, don't build it.

---

## 2. The execution lifecycle

Six stages. A feature passes through all of them. Each stage has a gate (artifact + sign-off) before the next.

```
Discovery → Definition → Design → Build → Release → Learn
   (PM)      (PM+Eng)    (Design)  (Eng)   (PM+CS)   (PM)
```

| Stage      | Purpose                       | Exit artifact                                 | Who signs off           |
| ---------- | ----------------------------- | --------------------------------------------- | ----------------------- |
| Discovery  | Is this worth doing?          | Problem brief (§T1)                           | PM lead                 |
| Definition | What exactly are we building? | User Story / PRD (§T2)                        | PM + Eng lead + Design  |
| Design     | How will it look & feel?      | Figma + prototype review notes                | Design + PM             |
| Build      | How do we build & ship it?    | Sprint plan + story-ready checklist (§T3)     | Eng lead                |
| Release    | How do we roll it out safely? | Release checklist (§T4) + release notes (§T5) | PM + Eng + support lead |
| Learn      | Did it work?                  | Metrics review + postmortem if needed (§T6)   | PM                      |

### At Scrut
- Discovery is mostly CS-led (we hear pain from CSMs). For a consumer app, discovery is **your user interviews + in-app feedback + community DMs** — you're the CS.
- Definition uses a 12-section template (§T2) that makes it impossible to forget RBAC, audit, analytics, notifications. The sections will be different for you, but the _principle_ — a template that makes gaps visible — is the single highest-leverage thing in this doc.
- Release gates caused our biggest incident. We now require admin controls to be live before any user-facing behaviour ships.

---

## 3. Weekly cadence (suggested for your team size)

| Meeting | Who | Duration | Purpose |
|---|---|---|---|
| Mon — Sprint planning | PM + all devs | 45 min | Pull stories from ready queue into sprint |
| Wed — Design review | PM + designer + 1 dev | 30 min | Review WIP designs, catch issues early |
| Thu — Spec review | PM + eng lead | 30 min | Walk through new specs before handoff |
| Fri — Demo + retro | Everyone | 45 min | Show what shipped, capture learnings |

Skip any of these if you don't need them _this week_. But keep spec review and demo non-negotiable.

### Cross-cutting syncs at Scrut
- Bi-weekly Product ↔ CS sync — catches customer-facing issues early
- Ad-hoc validation meetings with individual stakeholders (e.g. I validate every P0 spec with the CS owner before sprint)

For your app, equivalents might be: monthly sync with moderation/community manager, quarterly with compliance.

---

## 4. Central sheets (cross-cutting registers)

These are your "single source of truth" sheets. They prevent 10 specs from reinventing the same decision.

| Register                | Why it exists                                                 | Scrut equivalent             |
| ----------------------- | ------------------------------------------------------------- | ---------------------------- |
| **Analytics events**    | One canonical list of events + props so analytics doesn't rot | Mixpanel Events master sheet |
| **Notifications**       | Every push/email, trigger, copy, opt-out control              | Notifications master sheet   |
| **Audit logs**          | Every admin/user action that's logged, retention, visibility  | Audit Logs master sheet      |
| **Roles & permissions** | Who can do what (RBAC)                                        | Pricing Plan + RBAC matrix   |
| **Pricing/plan matrix** | What features are free/paid if you monetize                   | Pricing Plan Master          |

Maintain these as Google Sheets. Every new spec must update the relevant sheet, not just reference it.

**For a fintech community app, add:**
- Moderation actions register (report, hide, ban, warn — who can, logs, appeal flow)
- Compliance register (KYC, data retention, jurisdictions) — even if light, have it written down
- Content policy + escalation matrix

---

## 5. Prioritization

Keep this dumb. Two axes, four buckets:

| | High impact | Low impact |
|---|---|---|
| **Low effort** | Do now (P0) | Backlog (P2) |
| **High effort** | Plan + scope (P1) | Don't do (P3) |

- P0 = this sprint
- P1 = next 1-2 sprints, needs a spec
- P2 = quarter backlog, revisit monthly
- P3 = archived, kill it

Don't add a 5th priority. Don't add RICE unless you have >30 items. Your team is small; a shared sense of what matters beats a formula.

---

## 6. Definition of Ready (before a story enters a sprint)

A story is "ready" when _all_ of these are true. If any are missing, it stays in backlog.

- [ ] Problem + solution written (§T2)
- [ ] Figma linked, design reviewed
- [ ] Edge cases + error states enumerated
- [ ] Analytics events defined and added to events sheet
- [ ] RBAC / permissions called out
- [ ] Notifications (if any) listed + admin controls specified
- [ ] Audit log entries listed
- [ ] Acceptance criteria written (Given/When/Then)
- [ ] Success metric + how it will be measured
- [ ] Eng lead has done a rough estimate

## 7. Definition of Done (before a story ships)

- [ ] Acceptance criteria pass in staging
- [ ] Analytics events verified firing correctly
- [ ] Admin controls / moderation tools (if applicable) are live
- [ ] Release notes drafted
- [ ] Support / community manager briefed
- [ ] Rollback plan documented
- [ ] Feature flag on (default off, enable gradually)

---

## 8. Tooling (opinionated but flexible)

| Job | Tool | Why |
|---|---|---|
| Tickets/stories | Linear or Jira | Whichever eng prefers; both fine |
| Specs / PRDs | Google Docs or Notion | Commentable, linkable |
| Design | Figma | Obvious |
| Analytics | Mixpanel, Amplitude, or PostHog | Pick one, commit |
| Error tracking | Sentry | Non-negotiable from day one |
| Feature flags | GrowthBook, LaunchDarkly, or Unleash | Ship behind flags always |
| Community mgmt | Discord/Slack + a Zendesk/Intercom-lite | Whatever handles scale |
| Roadmap | Simple quarterly doc, not Aha (unless you need it) | Don't overspend here |

At Scrut we use Jira + Aha + Google Docs + Figma + Metabase + Mixpanel. Overkill for your team size.

---

## 9. The incident that shaped our release gate

On 2026-03-31 we shipped an email notification feature to production. The business logic was correct — we sent emails about real pending tasks. But the admin controls to configure/disable notifications weren't built yet. Admins had no heads-up and no ability to opt their end-users out. Emails landed as a surprise flood. Customers complained. Same-day rollback.

**The rule that came out of it:** _admin governance ships before user-facing behaviour._ Doesn't matter how correct the logic is — if the people accountable for the experience can't see it or turn it off, you're not ready to release.

**For your community app, this translates directly:**
- Moderation tools before public posting features
- Content reporting flow before content virality features
- User block/mute before DMs
- Compliance/KYC flows before money-adjacent features

Ship the brakes before the accelerator.

---

## 10. Templates

Copy these, adapt freely.

### §T1 — Problem Brief (Discovery)

```markdown
# [Feature name] — Problem brief

**Author:** [name]  **Date:** [yyyy-mm-dd]  **Status:** Draft / Under review / Approved

## Problem
[1-2 paragraphs. Who has the problem, what is the problem, how do we know — with evidence. Quotes from user interviews > your intuition.]

## Evidence
- [Link to interview notes, support tickets, analytics, community threads]
- [Quantify if possible: "X% of users hit this", "Y tickets last month"]

## Why now?
[What has changed / what unlocks this being solvable now?]

## Who's affected?
[User segments, estimated size, impact severity]

## Hypothesis
If we [do X], then [metric Y] will improve because [reason].

## Out of scope
[What this is NOT. Crucial for keeping scope small.]

## Open questions
[Things you don't know yet and need to learn before writing a PRD]

## Decision
Approved to define / Needs more research / Rejected (with reason)
```

### §T2 — User Story / PRD (Definition)

Adapted from Scrut's 12-section template. Prune sections that don't apply.

```markdown
# [Story title] — PRD

**Owner:** [PM]  **Designer:** [name]  **Eng lead:** [name]
**Status:** Draft / In review / Ready / In dev / Shipped
**Jira/Linear:** [link]  **Figma:** [link]

## 1. Problem statement
[From the problem brief, condensed]

## 2. Proposed solution
[What we're building, at a conceptual level. Not screens yet.]

## 3. User flows (per role)
For each user role:
- End user
- Moderator
- Admin
- (Auditor / compliance reviewer if applicable)

Describe the happy path + key error/edge paths.

## 4. Roles & permissions (RBAC)
| Action | End user | Moderator | Admin |
|---|---|---|---|
| Post | ✓ | ✓ | ✓ |
| Delete own post | ✓ | ✓ | ✓ |
| Delete any post | — | ✓ | ✓ |
| Ban user | — | limited | ✓ |

## 5. Plan/pricing (if you monetize)
[Which plan does this feature belong to? Free / Paid / Pro?]

## 6. Audit logs
Every admin/moderator action that should be logged:
| Action | Actor | Target | Data captured | Visibility |
|---|---|---|---|---|
| Ban user | Admin/Mod | User ID | Reason, duration | Admin + audit export |

## 7. Product areas impacted
[Which other surfaces of the app does this touch? Feed, profile, notifications, search...]

## 8. Analytics events
| Event name | Trigger | Properties |
|---|---|---|
| `post_created` | On successful post submit | post_id, topic, has_media, char_count |
| `post_reported` | On report submission | post_id, reason_category |

(Update the central events sheet with these.)

## 9. Notifications
| Type | Trigger | Recipient | Channel | Admin control |
|---|---|---|---|---|
| Push | New reply to your post | Post author | Push + in-app | User-level opt-out + global admin toggle |

**Note:** admin controls must ship _before_ or _with_ the notification. Not after.

## 10. Data migration / seeding
[Anything needed for existing users? Backfills? Defaults?]

## 11. Out of scope
[Explicit list. Harder than it looks — do it.]

## 12. Non-functional requirements
- Performance targets (p95 latency, load)
- Compliance considerations (fintech: KYC, data residency, PII handling)
- Accessibility (WCAG AA minimum)
- i18n readiness

## 13. Acceptance criteria
- Given [state], when [action], then [outcome]
- [One per flow]

## 14. Success metrics
- **Primary:** [metric, target, timeframe] — e.g. "30% of active users post at least once within 14 days of feature ship"
- **Guardrail:** [what must NOT degrade] — e.g. "Crash-free rate stays >99.5%"
- **Instrumentation:** [which events/dashboards]

## 15. Risks
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Spam wave on launch | High | High | Rate limits + human-in-loop moderation queue pre-launch |
```

### §T3 — Sprint plan

```markdown
# Sprint [N] — [start date] to [end date]

## Goal
[One sentence. The outcome, not a list of tickets.]

## Committed
| Story | Owner | Estimate | State |
|---|---|---|---|
| ... | ... | ... | Ready |

## Stretch
[Things we'll pick up if we finish committed early]

## Dependencies / risks
- [External blockers, API waits, design gaps]

## Out of scope this sprint
[Say it loud so no one sneaks it in]
```

### §T4 — Release checklist

```markdown
# Release — [Feature / version]
**Target date:** [yyyy-mm-dd]  **Release manager:** [name]

## Pre-release
- [ ] All acceptance criteria pass in staging
- [ ] Analytics events verified (check events sheet)
- [ ] Feature flag configured (default: OFF)
- [ ] Admin controls live and tested
- [ ] Moderation tools / support runbook updated
- [ ] Rollback plan documented
- [ ] Release notes drafted (§T5)
- [ ] Legal/compliance sign-off (if fintech-material)
- [ ] Community/support team briefed

## Rollout plan
- Stage 1: Internal team (1 day)
- Stage 2: 5% of users (2-3 days, watch metrics)
- Stage 3: 50% (watch another 2 days)
- Stage 4: 100%

## Kill criteria
Roll back immediately if:
- Crash-free rate drops below [X]%
- [Key metric] drops by >[Y]%
- P0 bug reported by >[Z] users

## Post-release (Day 1, Day 7, Day 30)
- [ ] Metrics check against target
- [ ] Support ticket review
- [ ] Community sentiment check
```

### §T5 — Release notes (internal + external)

```markdown
# [Feature name] — [version / date]

## For users (external)
**What's new:** [One sentence, benefit-led]
**How to use it:** [2-3 bullets or a short walkthrough]
**What to know:** [Limitations, known issues]

## For the team (internal)
**Shipped:** [Commit range / PR links]
**Flags:** [Flag name, default state, rollout %]
**Analytics:** [Dashboards to watch]
**Support scripts:** [Likely questions + answers]
**Known issues:** [with Jira/Linear links]
```

### §T6 — Incident postmortem

Write one within 48 hours of any rollback, outage, or customer-visible bug.

```markdown
# Postmortem — [incident name]
**Date:** [yyyy-mm-dd]  **Duration:** [start → end]  **Severity:** P0/P1/P2  **Author:** [name]

## Summary
[2-3 sentences: what broke, who was affected, how it was resolved]

## Timeline
- HH:MM — [Event]
- HH:MM — [Detection]
- HH:MM — [Mitigation started]
- HH:MM — [Resolved]

## Impact
- Users affected: [number / %]
- Duration: [minutes]
- Revenue / trust impact: [qualitative if hard to quantify]

## Root cause
[The underlying why. "Blameless" — focus on systems, not individuals.]

## What went well
- [Detection speed, communication, rollback ease]

## What went wrong
- [Detection gaps, missing alarms, process breaks]

## Action items
| Owner | Action | Due |
|---|---|---|
| ... | Add alert for X | yyyy-mm-dd |
| ... | Add release gate for Y | yyyy-mm-dd |

## Lessons
[1-3 durable rules to apply to future work. These become part of the playbook.]
```

### §T7 — Experiment brief (for A/B tests)

```markdown
# Experiment — [name]

**Hypothesis:** If we [change], [metric] will [direction] by [size] because [reason].

**Population:** [Who sees it]
**Variants:** Control vs Treatment(s)
**Primary metric:** [Exact definition + how measured]
**Guardrail metrics:** [Must not degrade]
**Minimum detectable effect:** [%]
**Sample size / duration:** [How long to reach stat sig]
**Stop conditions:** [When do we call it]

**Result:** [Fill in post-test]
**Decision:** Ship / Kill / Iterate
```

### §T8 — User research interview script (consumer/community context)

```markdown
# User interview — [segment]

## Warm-up (5 min)
- Tell me about yourself — work, what you do online.
- Walk me through how you currently discuss fintech / investing / [topic].

## Problem exploration (15 min) — Mom Test principles
- Tell me about the last time you [behaviour]. (Not: "would you use X?")
- What was frustrating about that?
- What did you do next / instead?
- How often does this happen?

## Current solutions (10 min)
- What do you use today? (Reddit, Twitter, Discord, WhatsApp groups?)
- What do you love / hate about each?
- If that tool disappeared tomorrow, what would you do?

## Concept probe (10 min) — only if relevant, last
- Show mockup / describe concept
- What's confusing? What's missing? What would stop you from using this?
- (Don't ask "would you pay?" — ask "have you ever paid for something like this?")

## Close (5 min)
- Anyone else we should talk to?
- Can we follow up in [N] weeks?

## Notes template
- Quotes (verbatim, with timestamps)
- Behaviours observed (not stated)
- Contradictions
- Surprises
```

---

## 11. Fintech-community-specific callouts

Where your domain demands extra care beyond generic product ops:

1. **Moderation is a core product surface, not support.** Staff it early. Your biggest risk is spam / scams / pump-and-dump rings. Every post/message/profile needs report + review flows from day one.
2. **Compliance-adjacent features need Legal review.** Anything that looks like investment advice, solicitation, or financial recommendation — get sign-off before shipping. Have a disclaimer pattern library.
3. **Content retention + deletion.** Know your jurisdictions. GDPR / DPDP / CCPA — decide retention and deletion policy before you hit scale.
4. **Identity & trust signals.** Decide early: real name, pseudonymous, verified? Each has different moderation + trust implications. Reversing this later is brutal.
5. **KYC gating.** If users ever transact, get professional help on KYC/AML before building. Don't DIY this.

---

## 12. How to use this document

1. **Don't adopt all of it on day one.** Pick: PRD template (§T2), release checklist (§T4), postmortem template (§T6). That's 80% of the value.
2. **Make templates live documents.** Paste them into Notion/Google Docs and let them evolve. A template that hasn't changed in 6 months is dead.
3. **The test of good process:** _does it make you ship better, or just feel more organized?_ If a section never gets filled out, cut it.

---

_Derived from Scrut Automation's product ops practice, adapted for a small consumer fintech team._
