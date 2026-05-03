# Reo.dev Playbook Mapping for Cashfree DevRel

Which of Reo.dev's 44 playbooks are relevant for growing the Cashfree developer ecosystem. Mapped to the [Developer GTM Funnel](cashfree-developer-gtm-funnel.md) stages.

**Role of Reo.dev:** One enabler among many. Useful for scaling the DISCOVER and BUILD stages beyond organic reach. Not a substitute for community fundamentals (response speed, tribal knowledge, ambassador relationships).

---

## Relevant Playbooks by Funnel Stage

### DISCOVER Stage — Finding Developers to Bring into the Ecosystem

#### Competitive Intel (Highest ROI for Cashfree)

No one else is systematically targeting developers frustrated with Indian payment API competitors. This is the unique play.

| Playbook | Complexity | What It Does | Cashfree Application |
|---|---|---|---|
| **Identify Developers Opening Issues on Competitor GitHub** | Beginner | Tracks devs filing issues/comments on competitor repos | Developers filing Razorpay SDK bugs are actively frustrated. Reach out with "Cashfree solves this" + Discord link. Highest-intent signal available. |
| **Track All Accounts Evaluating a Competitor GitHub Repo** | Beginner | Account-level view of competitor evaluation (forks, stars, issues, PRs) | Companies actively evaluating Razorpay/Stripe SDKs. Proactive outreach with Cashfree comparison content + Discord community invite. |
| **Track Developers Engaging with Competitor GitHub** | Beginner | Individual developer tracking on competitor repos | Developer-level targeting. Pair with personalized outreach referencing their specific competitor interaction. |
| **Find Accounts with Multiple Developers Evaluating Competitor Repos** | Beginner | Flags accounts where 2+ devs are active on competitor repos | Multiple developers = team-level evaluation decision. Higher conversion probability. Worth a personal outreach from DevRel, not just automated DM. |

**How to set up:** Connect Razorpay, Stripe, PayU, and Paytm GitHub repos as competitor sources. Set up keyword monitoring for `razorpay`, `stripe india`, `payment gateway issue`, `upi api bug` across community listening.

#### LinkedIn & Community Signals

| Playbook | Complexity | What It Does | Cashfree Application |
|---|---|---|---|
| **Find Profiles in ICP Accounts Engaging with Company LinkedIn** | Beginner | Tracks who reposts, comments, reacts to your LinkedIn posts | Developers engaging with Cashfree LinkedIn dev content are warm leads. They already know Cashfree exists — DM with Discord invite converts at high rate. |
| **Identify Active Leads in Slack Community from ICP Accounts** | Beginner | Surfaces ICP developers active in Slack channels | Cross-funnel to Discord. If Cashfree joins relevant fintech/developer Slack communities, this identifies high-value members to invite. |

#### GitHub & SDK Signal Tracking

| Playbook | Complexity | What It Does | Cashfree Application |
|---|---|---|---|
| **Find Decision Makers in ICP Accounts Active on GitHub** | Beginner | Finds CTOs/VPs at companies where devs use your SDK | The CTO whose team uses Cashfree → invite to Discord for product roadmap content, beta access. Enterprise path. |
| **Identify Leads in ICP Accounts Active on GitHub** | Beginner | Combines GitHub activity + ICP filters | Filter: Indian startups (Series A-C) + active on Cashfree SDK repos → targeted Discord outreach with "join 500+ payment developers" messaging. |
| **Recently Active Accounts (2+ devs, 30 days)** | Advanced | Flags accounts with multiple developers active recently | 2+ devs from same company = team-level integration in progress. Highest-urgency outreach — they need community support right now. |
| **Accounts Forking Your Repo** | Advanced | Identifies accounts that forked Cashfree SDK repos | Forking = actively experimenting with code. Perfect moment for "need help with your integration? Join our Discord." |

#### Hiring Signals

| Playbook | Complexity | What It Does | Cashfree Application |
|---|---|---|---|
| **Find Accounts Actively Hiring for ICP Tech Stack** | Beginner | Companies hiring payment/fintech integration roles | Companies hiring "payment API developer" or "fintech backend engineer" → they'll need integration support → Discord is the ramp-up channel for their new hires. |

---

### BUILD Stage — Converting Discord Members to Cashfree Users

These playbooks help identify which Discord members are deepening their Cashfree engagement, so DevRel can provide targeted support.

| Playbook | Complexity | What It Does | Cashfree Application |
|---|---|---|---|
| **Identify Product Signup Leads Active on Docs** | Beginner | Combines product login data with docs engagement | Discord member who signed up for Cashfree + reading docs heavily = ready for integration support. Proactive DM: "I see you're working on [X], need help?" |
| **Spot Accounts Highly Active on Developer Docs** | Intermediate | Tracks frequent docs visitors by account | Accounts reading Cashfree docs 10+ times in a week → they're deep in integration. If they're not in Discord yet, invite them. If they are, check if they need help. |
| **Track Accounts Active on Key Docs Pages** | Beginner | Monitors specific docs sections | Developer visiting webhook docs 5+ times → likely stuck on webhook setup. Trigger #get-help prompt or direct DevRel outreach with code snippet. |
| **Find Accounts Interacting with Code Commands** | Intermediate | Tracks CLI/SDK-level product usage | Developers running Cashfree SDK commands → confirmed builders. These are your most valuable Discord members — ensure they're getting fast responses. |

---

### GO LIVE → GROW Stage — Accelerating MTU and GMV

These playbooks help identify when to push for go-live and when existing accounts are ready to expand.

| Playbook | Complexity | What It Does | Cashfree Application |
|---|---|---|---|
| **Identify ICP Accounts with Active Developer Evaluation** | Intermediate | Spots accounts in active evaluation stage | Accounts evaluating Cashfree → accelerate through Discord support → faster time-to-first-transaction → MTU. |
| **Identify Active Developers from High-Intent Accounts** | Advanced | Finds developer leads within hot accounts | High-intent accounts → identify the specific developers building the integration → community onboarding + dedicated support. |
| **Revive Cold CRM Opportunities Using Developer Activity** | Advanced | Monitors cold deals for new developer activity | Dead deal showing fresh Cashfree SDK activity → the developer is back. Re-engage via Discord before a competitor wins them. |
| **Detect Deal Stalls Early** | Intermediate | Alerts when active deals slow down | Stalled integration (no new API calls in 2 weeks) → DevRel reaches out in Discord → unblock → move to production. |

---

## Not Relevant for Cashfree DevRel (28 playbooks)

Skip these unless Cashfree builds a dedicated sales dev (SDR) motion for developer accounts.

| Category | Count | Why Skip |
|---|---|---|
| HubSpot Workflows | 4 | CRM sync, lead auto-assignment — sales ops, not DevRel |
| Zapier Workflows | 2 | LaGrowthMachine multi-channel outbound — outbound sales automation |
| CRM to Revenue (remaining) | 2 | CRM owner monitoring, deal-stage tracking — sales manager tooling |
| Developer ABM (remaining) | 3 | 6Sense integration, CSV enrichment, surge detection — enterprise ABM |
| Automations (remaining) | 4 | Real-time alerts for hot accounts, LinkedIn ad auto-enrollment — SDR workflow |
| List Building | 3 | Audience discovery, retargeting, buyer finding — marketing ops |
| OSS Telemetry | 1 | Requires deep telemetry instrumentation — Phase 2 if at all |

---

## Implementation Priority

### Week 1-2 (Setup)

1. Connect Cashfree GitHub repos (`cashfree-pg`, `cashfree-payout`, etc.) as owned repos
2. Connect Razorpay, Stripe, PayU GitHub repos as competitor sources
3. Set community listening keywords: `cashfree`, `razorpay issue`, `payment gateway india`, `upi api`, `payment integration bug`
4. Connect Cashfree LinkedIn company page

### Week 3-4 (First Plays)

5. Activate **Competitive Intel** playbooks — identify developers frustrated with Razorpay/Stripe
6. Activate **LinkedIn engagement** playbook — DM developers reacting to Cashfree posts
7. Activate **Recently Active Accounts** + **Forking Accounts** — outreach to warm SDK users

### Month 2+ (Scaling)

8. Activate **Docs tracking** playbooks — proactive support for developers deep in integration
9. Activate **Hiring Signals** — target companies hiring payment developers
10. Activate **Deal stall detection** — prevent integration abandonment

### Month 3+ (Revenue Connection)

11. Activate **High-intent account** playbooks — identify accounts ready to go live
12. Activate **Cold opportunity revival** — re-engage dormant integrations

---

## Measurement

Track Reo.dev as one acquisition channel among many. It should appear in the DISCOVER stage metrics:

| Metric | What to Track |
|---|---|
| Developers identified by Reo.dev/month | Volume of actionable signals |
| Reo.dev-sourced Discord joins/month | Conversion from signal to community member |
| Reo.dev-sourced Cashfree signups/month | Attribution through the funnel |
| Cost per Discord member (Reo.dev channel) | Compare against LinkedIn DM, docs CTA, organic |

If Reo.dev-sourced members don't activate and convert at higher rates than organic, reconsider the spend.

---

## Sources

- [Reo.dev All Playbooks](https://www.reo.dev/all-playbooks) — 44 playbooks across 11 collections
- [Developer Communities Collection](https://www.reo.dev/playbook-collection/developer-communities) — 2 playbooks (LinkedIn, Slack)
- [OSS Collection](https://www.reo.dev/playbook-collection/oss) — 6 playbooks (GitHub signals)
- [Competitive Intel Collection](https://www.reo.dev/playbook-collection/competitive-intel) — 4 playbooks (competitor repo tracking)
- [Developer PLG Collection](https://www.reo.dev/playbook-collection/developer-plg) — 6 playbooks (docs, product, code signals)
