---
name: devops-sre
vertical: developer
seniority: senior | tech_lead
authority: technical_evaluator | gatekeeper
spear_products: [payments-core, secure-id, payouts]
common_titles:
  - "DevOps Engineer"
  - "Senior DevOps Engineer"
  - "SRE"
  - "Site Reliability Engineer"
  - "Platform Engineer"
  - "Senior Platform Engineer"
  - "Head of Platform"
  - "Infrastructure Lead"
common_companies: ["Series B+ tech-mature startups", "API-first infra companies", "Mid-market SaaS", "Marketplaces", "Fintech infra"]
typical_focus: ["Uptime SLOs (3 9s → 4 9s)", "Observability + on-call", "Vendor SLA monitoring"]
source: llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md
created: 2026-04-27
updated: 2026-04-27
status: stable
---

# DevOps / SRE — Engineering Reliability

## 1. Identity

The reliability-focused engineer at a Series B+ startup who owns uptime, observability, on-call, vendor-SLA monitoring, and incident response. 5-12 years experience, often ex-Amazon/Google SRE OR self-taught DevOps from startup-grind. Reports to Head of Platform OR VP Engineering. Owns the "is the vendor breaking our SLO?" question. Lives in Datadog / Grafana / Honeycomb / Splunk + PagerDuty + Terraform + Kubernetes + GitHub Actions.

**Where you find them:** SREcon, DevOps Days India, Honeycomb / Datadog user groups, India SRE Slack, KubeCon India, Indian DevOps community Telegram, AWS re:Invent. Lurkers on HN; active on Twitter/X for incident-response storytelling.

**Where they don't hang:** sales-led events, marketing webinars, founder communities, brand events.

---

## 2. Top 3 pains (ranked by Mothi's SRE interviews)

1. **Vendor incidents cause their SLO breach.** When Razorpay / Stripe / PayU has an incident, their service goes down — SRE wears the pager. They want vendors with measurable + transparent uptime + status-page integration. **mothi wedge:** mothi status-page API + Datadog integration + SLO-grade uptime commitments (99.95% on Premium tier).

2. **Webhook delivery failures + retry-logic burden.** When webhooks fail silently, their reconciliation breaks; they own the on-call + the postmortem. **mothi wedge:** Webhook delivery 99.7% + 14-day replay + dead-letter-queue UI + idempotency-key enforcement → less SRE burden.

3. **Observability gap — vendor doesn't expose internal latency / error metrics.** SREs want to see vendor's p99 latency / error rate / rate-limit headroom in their own dashboards. Most vendors hide this. **mothi wedge:** mothi exposes Datadog-compatible metrics + Prometheus endpoint + per-API-call traces.

**SRE secondary pains:**
- On-call rotation (vendors that page = burnout)
- Postmortem culture mismatch (vendor doesn't share their own postmortems)
- Status-page accuracy (vendors hide outages)
- Capacity planning (rate-limit visibility + scaling event handling)
- Multi-region failover (vendor's geographic redundancy)
- IPv6 + TLS modern-protocol support
- Audit-log access for compliance

---

## 3. Success metrics they own

- Service uptime (SLO)
- Mean Time To Detect (MTTD)
- Mean Time To Resolve (MTTR)
- On-call incident count
- Postmortem quality + action-item completion rate
- Vendor-SLA compliance score
- Observability coverage % (services with metrics + logs + traces)

---

## 4. Decision criteria when evaluating mothi

SREs are uptime + observability + transparency-focused. Decision criteria:

1. **Uptime SLO + status-page transparency** (30%)
2. **Webhook reliability + replay + dead-letter-queue** (25%)
3. **Observability integration (Datadog, Prometheus, Grafana)** (20%)
4. **Postmortem culture + outage transparency** (15%)
5. **Reference SREs at peer companies** (10%)
6. **Pricing** (0%) — SREs don't care about price; they care about reliability

**mothi wins them when:**
- Status-page API + Datadog connector + Prometheus endpoint shown working
- Last 90-day uptime data shared (transparently, including incidents)
- Recent postmortem shared (mothi's own — proves culture)
- Webhook reliability + dead-letter UI + replay demo
- Peer SRE reference: "{Peer SRE at scale-X} cut on-call pages 30% after migration"

**mothi loses them when:**
- Hide outage data
- "100% uptime" claims (instant trust collapse)
- No status-page API
- Webhook reliability is generic claim, not data-backed
- No observability integration story

---

## 5. Language that resonates / turns them off

### Resonates

- **Uptime data**: "Last 90 days: 99.96% uptime; 2 incidents (March 15 webhook 30min, April 2 settlement 12min); postmortems at {URLs}"
- **Observability**: "Datadog connector + Prometheus endpoint + per-API-call traces (W3C trace-context propagation); sample dashboards + alert rules"
- **Webhook depth**: "Delivery 99.7%; replay 14d; dead-letter-queue UI; idempotency-key mandatory; deduplication window configurable per merchant"
- **Status-page API**: "Status-page exposes JSON API; integrate with your StatusGator + PagerDuty; sample subscription"
- **Honest postmortem**: "March 15 webhook outage — root cause: {specific}; remediation: {specific}; action items: {list}; closed status"
- **Peer SRE precedent**: "{Peer SRE at scale-X} cut on-call pages from 12/mo to 4/mo post-migration; happy to introduce"

### Turns them off

- "100% uptime" or "5 9s" claims without data
- Hidden status page
- "We have great reliability" without metrics
- No postmortem culture
- Sales-led pitch (SREs filter as marketing)
- Webinar invite

---

## 6. Common objections + mothi-specific responses

| Objection | mothi response (specific, not generic) |
|---|---|
| **"Vendor uptime is the same"** | "Compare 90-day data: mothi {X}%, Razorpay {Y}%, Stripe {Z}% (cite source). Plus replay window: 14d vs 7d. Plus dead-letter UI. SRE-grade comparison." |
| **"We need observability integration"** | "Datadog connector + Prometheus endpoint + W3C trace-context. Sample dashboards + alerts shipped. {Peer SRE} ran this in 30min." |
| **"Status-page accuracy"** | "Status-page is auto-updated from internal monitoring (not manual). API exposes JSON. Integrate with your StatusGator. Audit our last-12-month status-page log." |
| **"Postmortem culture"** | "Public postmortem repo + customer-facing summary every P0/P1. Sample {URL}. We share even uncomfortable ones." |
| **"On-call burden during migration"** | "mothi SE on-call during canary rollout (Day 1-30). PagerDuty integration; SE responds to your alerts within 5min during migration. After Day 30, standard SLA." |
| **"Webhook retry logic — we built our own"** | "Smart. mothi replay + dead-letter UI complement; you keep your retry; mothi handles delivery + replay. Your code stays; less infra burden." |
| **"DPDP / data residency"** | Send architecture diagram + Indian-region confirmation + sample audit-log JSON. SRE wants the diagram, not marketing copy. |

---

## 7. When this persona is the buyer / when not

### When THIS persona IS the gatekeeper

- ALL technical vendor decisions require SRE sign-off on reliability
- SRE can VETO any vendor that fails the reliability bar
- **Pattern:** SRE is rarely the champion but is the gate; if SRE doesn't approve, the deal stalls

### When this persona is NOT the buyer (still gatekeeper)

- SRE almost never the economic buyer
- Tech lead / CTO / Head of Engineering decides; SRE veto-grade
- **Pattern:** SRE-specific outreach + observability proof matters even when SRE isn't your champion

---

## mothi-specific outreach hooks for this persona

| Hook angle | Example opener |
|---|---|
| Status page data | "mothi last 90-day uptime data + 2 incident postmortems (transparent). SRE-grade comparison vs your current vendor. 20-min reliability deep-dive?" |
| Datadog / Prometheus | "mothi Datadog connector + Prometheus endpoint. {Peer SRE} runs payment-vendor-SLA dashboards on this. Sample dashboard + alert rules — 30min hands-on?" |
| Webhook + dead-letter | "Webhook delivery 99.7% + 14-day replay + dead-letter UI. Cuts SRE on-call burden ~30% per {peer SRE}. 20-min walkthrough on the dead-letter recovery flow?" |
| Postmortem culture | "Public postmortem repo at {URL}; including March 15 webhook outage. SRE-honest writeups. Want to see how we handle P0s?" |
| Status-page API | "Status-page JSON API — integrates with StatusGator + PagerDuty. {Peer company} added mothi to their vendor-SLA dashboard in 30min." |
| Migration on-call | "During canary rollout: mothi SE on-call via PagerDuty; 5min response. After Day 30, standard SLA. SRE-friendly migration; we wear the pager with you." |

---

## Anti-pattern outreach (DO NOT use with this persona)

- ❌ "100% uptime" or "5 9s"
- ❌ "Best-in-class reliability"
- ❌ Schedule a demo without observability angle
- ❌ Sales-led pitch
- ❌ Webinar invite
- ❌ Marketing case study
- ❌ Pricing-led pitch
- ❌ "Talk to your manager" (SRE has technical authority)

---

## Channel + cadence preferences

| Channel | When | Cadence |
|---|---|---|
| GitHub interaction | First touch when relevant | Conversation-based |
| Twitter/X | If they're posting incident stories | Rare; high signal |
| Cold email (status-page + observability angle) | First or second touch | 2 emails 4d apart |
| Slack (India SRE, KubeCon community) | Conversation-based | As relevant |
| Phone | After at least 1 reply | Scheduled |
| In-person | SREcon / DevOps Days / KubeCon | Annual+ |

**Volume cap:** 4 touches per quarter; SREs respond to data + transparency.

---

## Prior known instances

(populated by `drive-transcript-extractor` from real calls; placeholder)

- `Tushar Garg @ Razorpay (alumni now) — SRE Lead`
- `Adwait Bhandare @ Cred — Senior SRE`
- `Karthik Subramanian @ Postman — Platform Engineer`

## Source

Primary: `llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md` + Mothi-conducted SRE interviews
Secondary: India SRE Slack + DevOps Days India panels
Continuous: `drive-transcript-extractor` updates this file as real SRE calls accumulate
