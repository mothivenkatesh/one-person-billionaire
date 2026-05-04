# BFSI Personas

> **Source:** `llm-wiki/wiki/concepts/secure-id-platform-architecture.md` + Mothi-authored AOP-FY27 + WTFraud community signals.
> Used by agents when `account.vertical = 'bfsi'` OR `contact.persona_canonical IN ([...this list...])`.

---

## The 4 personas

| # | Persona | Title pattern | Authority | Spear products | Status |
|---|---|---|---|---|---|
| 1 | **`head-of-payments`** | Head of Payments · VP Payments · Payments Lead (Banks/NBFCs) | champion + economic_buyer | Mobile360 + Secure ID + Bureau prefill | ✅ stable |
| 2 | **`chief-risk-officer`** | CRO · Head of Risk · Chief Risk Officer | economic_buyer + gatekeeper | Mobile360 (NTC + risk signals) | ✅ stable |
| 3 | **`head-of-onboarding`** | Head of Onboarding · Head of KYC · V-CIP Lead | champion + technical_evaluator | Mobile360 + V-CIP + Secure ID | ✅ stable |
| 4 | **`compliance-head`** | Head of Compliance · CCO · Compliance Officer | gatekeeper (RBI/DPDP/PCI) + technical_evaluator | Secure ID DPDP layer | ✅ stable |

---

## When to load which persona

| Stage | Most likely persona |
|---|---|
| Discovery | `head-of-payments` (P&L conversation: bureau cost + completion rate) |
| POC | `head-of-onboarding` (V-CIP + Mobile360 benchmarks) |
| Risk review | `chief-risk-officer` (NTC coverage + alternate-data limits) |
| Compliance review | `compliance-head` (DPDP audit + RBI signals-not-scores) |
| Pricing negotiation | `head-of-payments` + `compliance-head` |

---

## Vertical-specific mothi hooks for BFSI

| Pain | mothi spear product | Hook |
|---|---|---|
| Bureau prefill misses 50-60% of NTC applicants | Mobile360 | 190M+ NTC coverage from single mobile-number input |
| Karza/HyperVerge POC takes 3+ weeks | mothi-managed POC | 5-day SE-driven benchmark deck |
| V-CIP completion rate <70% | Mobile360 + Secure ID stack | 18-22% dropout reduction at peer banks |
| RBI signals-not-scores enforcement | Secure ID DPDP layer | Alternate-data-free architecture, audit-ready |
| Lender BSA cost stack | Perfios co-sell + RPD partnership | Bundled pricing, single contract |

---

## Loading rules for agents

When `outreach-writer` / `stage-mover` / `cross-sell-detector` run with a BFSI-vertical contact:

1. Resolve `persona_canonical` via title pattern
2. Load `personas/bfsi/{persona_canonical}.md`
3. ALSO load `personas/bfsi/compliance-head.md` if `account.industry = 'BFSI lending'` AND deal in proposal+ stage (compliance is gatekeeper for ₹5Cr+ deals)
4. Compose with skill body in Claude prompt

---

## mothi's WTFraud community advantage

BFSI sales cycles in India are slow (12-18mo). The **WTFraud community (350+ practitioners, 600+ Discord members/mo growth)** that Mothi runs is the unfair channel: BFSI personas trust peer-validation more than vendor pitch. Always check if a BFSI prospect is in the WTFraud orbit before cold outreach — warm community intro >> cold email.
