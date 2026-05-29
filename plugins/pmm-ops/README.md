# pmm-ops

**5 skills for Product Marketers who want to position, message, and launch faster.**

| Skill | What it does |
|---|---|
| [`superpmm`](./skills/superpmm) | AI-powered GTM Builder — Research → CI → PRFAQ → Positioning → GTM Plan in ~60 min |
| [`pmm-messaging`](./skills/pmm-messaging) | Defensible messaging & positioning from scratch — 3-tier model, JTBD, message house |
| [`insideinsights`](./skills/insideinsights) | Brand insight methodology (Amit Kumar) — find the human conflict your product resolves |
| [`sales-enablement`](./skills/sales-enablement) | Sales enablement strategist — full enablement lifecycle, grounded in 222 Sharebird Q&As |
| [`voice-engine`](./skills/voice-engine) | Distill any operator's public writing into a Voice Profile, then ghostwrite/audit in their voice. Ships a complete Logan Hendrickson example (29 posts). |

**Applied:** [`applied/`](./applied) holds strategy docs produced *with* these skills — the [AIPMM agent blueprint](./applied/aipmm-agent-blueprint.md) (PMM-function → skill → gap map + agent architecture) and the [10x/100x use-case list](./applied/10x-100x-use-cases.md).

---

# SuperPMM

### Build your Go-To-Market in 60 minutes, not 6 weeks.

SuperPMM (codename: PMMStudio) is an AI-powered GTM Builder for Product Marketers. One guided workflow that produces a complete ICP definition, competitive analysis, PRFAQ, positioning framework, and launch plan.

---

## The Problem

- **300,000+ PMMs globally.** 44% are teams of 1-2 people.
- **96% use AI tools.** Only 34% use them strategically.
- Product release cycles compressed from 6.4 to 2.8 weeks. Campaign timelines stayed at 8-12 weeks.
- PMMs juggle 15+ disconnected tools. None of them talk to each other.

**The tools exist. The system doesn't.**

---

## What SuperPMM Does

A single guided workflow with 5 steps:

```
RESEARCH        COMPETITIVE     PRFAQ           POSITIONING     GTM PLAN
ICP + TAM       INTELLIGENCE    Working         Messaging &     Launch Plan
                                Backwards       Differentiation

"Who are we     "Who else       "What are we    "How do we      "How do we
 selling to?"    is out there?"  building?"       talk about it?"  ship it?"

10 min          10 min          15 min          15 min          10 min
```

### 5 Input Modes

| Mode | When |
|---|---|
| **URL only** | New company, cold start |
| **PRD upload** | PM drops a PRD, you build the GTM |
| **PRFAQ upload** | Working-backwards doc already exists |
| **Call notes** | Just finished customer/PM call |
| **Existing doc** | Refreshing previous positioning |

### Output

One exportable GTM document containing:
- ICP definition with scorecard + TAM sizing (triangulated)
- Competitive landscape (top 3 + status quo mapped)
- Internal PRFAQ (press release + FAQ)
- Positioning statement + Message House (3 pillars)
- Persona-specific messaging + competitive messaging
- Tiered launch plan with timeline, stakeholders, and metrics

---

## Embedded Methodology

SuperPMM doesn't invent new frameworks. It embeds proven ones and makes them executable at machine speed.

| Framework | Source |
|---|---|
| Positioning Anchors + MVP Positioning | FletchPMM (400+ projects) |
| Obviously Awesome | April Dunford |
| SPICED ICP Diagnostic | Winning by Design |
| ICP Scorecard (Retention, Access, Velocity, Activation) | FletchPMM |
| Message House | Atlassian |
| Content Playground (depth x intent) | Ashley Faus |
| Launch Tiering | Spotify, Seismic, Superhuman, AWS |
| DIN Framework (Decide/Input/Notify) | Google |
| 34 PMM OKRs + 6 Anti-Patterns | Hattie the PMM |
| Hero's Journey for PMM | BILL / Charles Tsang |

Plus 30+ templates from PMM leaders at Amazon AWS, Shopify, Google, SurveyMonkey, Zoom, Databricks, Algolia, and more.

---

## Repository Structure

```
super-pmm/
|
+-- docs/
|   +-- v1-prd/
|   |   +-- PRD.md                          # V1 Product Requirements Document
|   |
|   +-- vision/
|   |   +-- product-vision.md               # Full product vision (16 agents, V5 destination)
|   |
|   +-- architecture/
|   |   +-- agent-architecture.md           # Production-ready agent specs (YAML, Harvey.ai level)
|   |   +-- company-kb-spec.md              # Company KB + Product KB + onboarding UX spec
|   |
|   +-- marketing/
|   |   +-- why-superpmm.md                 # "Why SuperPMM?" marketing manifesto
|   |
|   +-- research/
|   |   +-- market-opportunity.md           # Market sizing, competition, business model
|   |
|   +-- templates/                          # 17 real-world PMM templates
|   |   +-- Atlassian Message House.xlsx
|   |   +-- Algolia Messaging Framework.xlsx
|   |   +-- Launch Plan (AWS).xlsx
|   |   +-- PMM GTM Launch Execution Plan (SurveyMonkey).xlsx
|   |   +-- Positioning & Messaging Framework (Shopify).xlsx
|   |   +-- Storytelling Framework (BILL).xlsx
|   |   +-- Google DIN Framework.xlsx
|   |   +-- Qualitative Research (Zoom).xlsx
|   |   +-- Stakeholder Management (Databricks).xlsx
|   |   +-- Winning by Design ICP Blueprint.pdf
|   |   +-- Developer Persona Playbook.pdf
|   |   +-- PMM OKRs (Hattie).pdf
|   |   +-- Positioning eBook (PMA).pdf
|   |   +-- ...and more
|   |
|   +-- case-studies/                       # Real-world PMM case studies that validate the workflow
|       +-- PMM Positioning - Mothi.xlsx
|       +-- KFS Pitch Deck.pdf
|
+-- README.md
```

---

## Key Documents

| Document | What It Is | Read This If... |
|---|---|---|
| [V1 PRD](docs/v1-prd/PRD.md) | Buildable product spec. 5 steps, 5 input modes, tech stack, pricing, 4 case studies. | You want to understand what we're building FIRST. |
| [Product Vision](docs/vision/product-vision.md) | Full 16-agent platform vision. The V5 destination. | You want to understand where we're GOING. |
| [Agent Architecture](docs/architecture/agent-architecture.md) | Production-ready YAML specs. Org-chart model. Seniority levels. | You want to understand HOW the agents work. |
| [Company KB Spec](docs/architecture/company-kb-spec.md) | Onboarding UX. "Show-then-ask" methodology. | You want to understand the ONBOARDING experience. |
| [Why SuperPMM](docs/marketing/why-superpmm.md) | Marketing manifesto. 5 Constraints framework. | You want the PITCH. |
| [Market Opportunity](docs/research/market-opportunity.md) | TAM/SAM/SOM, competition, business model. | You want the MARKET case. |

---

## V1 Pricing

| Tier | Price | What You Get |
|---|---|---|
| **Free** | $0 | 1 complete GTM project |
| **Pro** | $39/month | Unlimited projects, all exports, saved context |

---

## Roadmap

```
V1 (Now):       GTM Builder (Research + CI + PRFAQ + Positioning + GTM Plan)
V2 (Month 3):   + Team sharing + CI monitoring + CRM integration
V3 (Month 6):   + Content Generator + Sales Enablement + Persona module
V4 (Month 9):   + Signals + Pricing + Proposals + Narrative
V5 (Month 12+): Full AI Studio — 16 agents + integrations + API + marketplace
```

---

## Tech Stack (V1)

| Layer | Choice |
|---|---|
| Frontend | Next.js + Tailwind |
| Backend | Python (FastAPI) |
| Database | PostgreSQL + Redis |
| LLM | Claude API (Anthropic) |
| Website scraping | Firecrawl / Jina Reader |
| Hosting | Vercel + Railway |
| Auth | Clerk / Supabase Auth |
| Payments | Stripe |

---

## Validated by Real PMM Work

The V1 workflow is validated against 4 real-world PMM case studies:

1. **Personal Positioning** (FletchPMM anchors applied to self-branding)
2. **KFS Product Launch** (regulatory compliance GTM for Contract360)
3. **MSME Credit Scoring** (market insight + product validation for alternative credit)
4. **MCC Classification at Signzy** (research-led positioning for complex B2B product with 4 personas)

All four followed the exact same sequence: **Research -> CI -> Position -> Message -> GTM Plan.** SuperPMM automates this.

---

## Built by

**Mothi Venkatesh** — Product Marketing, Cashfree Payments

---

# InsideInsights

### Find the human conflict your brand resolves. Then own it.

`insideinsights` codifies **Amit Kumar's InsideInsights brand strategy methodology** — a framework for drilling past what a product *shows* (depiction) to what it *solves* (insight) to the *conflict* it resolves.

Core thesis: every successful brand addresses a human inadequacy framed as two opposing values (**Value A ↔ Value B**). Brands that resolve this conflict are worshipped. Brands that don't are just products.

### What it does

- Strips any product to its **objective vs. symbolic reality**
- Finds the **human inadequacy** (the insight — always reducible to one word)
- Frames it as a **conflict** (Value A ↔ Value B format)
- Defines the **brand role** (how the product resolves the conflict)
- Distinguishes **depiction from insight** (the most common PMM mistake)
- Uses Indian cultural context fluently — Bollywood, cricket, caste constructs, B2B fintech

### Invoke with

```
/insideinsights
find the insight for [product]
what conflict does [brand] resolve
brand positioning for [product]
what inadequacy does [X] address
```

### Source

Built from 6 weeks of Amit Kumar's InsideInsights 2026 WhatsApp course — session notes, live discussions, and brand deconstructions across Nike, Coke, Google, Hero Splendor, Lata Mangeshkar, Dhurandhar, Dhoni, Pepsi, Surf Excel, and 20+ more.

---

# Voice Engine

### Model an operator's voice, then write as them.

`voice-engine` turns a person's public writing into a reusable **Voice Profile**, then ghostwrites, audits, or ideates content that sounds unmistakably like them. The insight that makes it more than "write like X": **voice = tone + POV + taste.** It encodes not just sentence cadence but the *refusals* — what the person would never say — so output passes the "would they actually post this?" test.

Three phases: **harvest** a public corpus (LinkedIn/X/blog) → **distill** 6 dimensions (POV, tone, structure, lexicon, taste, resonance) → **apply** (ghostwrite / audit / ideate, with a 5-point refusal check).

### Invoke with

```
/voice-engine
write a LinkedIn post about X like <person>
does this draft sound like <person>?
what's <person>'s POV / tone of voice?
study this creator
```

### Ships a complete worked example

[`skills/voice-engine/data/logan-hendrickson_voice-profile.md`](./skills/voice-engine/data/logan-hendrickson_voice-profile.md) + `logan-hendrickson_corpus.json` — **Logan Hendrickson** (Head of PMM at Overhaul, ex-messaging consultant), 29 posts spanning 2022→2026, harvested past LinkedIn's activity gate via the profile-preview + WebSearch-permalink method documented in the SKILL. A finished profile you can read as a template, or use as a reference PMM voice.

---

## License

MIT
