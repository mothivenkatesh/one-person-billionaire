# Company KB: Onboarding & Context Building — Product Spec

**Version:** 1.0
**Date:** April 9, 2026

---

## The Core Principle

> **Minimum input, maximum context. Teach while you collect.** The user gives us a URL and we guide them through the right questions — showing examples and sample outputs at every step so they know what "good" looks like, even if they've never built a messaging doc before.

The worst onboarding: "Please upload your positioning doc, competitive analysis, and sales deck."
**Problem:** Most PMMs — especially first-PMM-hires or startup PMMs — don't HAVE these. They're the ones who need to create them.

The second-worst onboarding: "Paste your URL, answer 5 questions, done."
**Problem:** PMMs don't always know what the RIGHT context to provide is. Asking "describe your target audience" gets you a vague answer. Showing an example and asking "which of these looks closest to yours?" gets you a useful one.

The best onboarding: **"Let me show you what great looks like, then help you build it for your company."**

### The Onboarding Philosophy

1. **Never ask a blank-page question.** Always show an example or sample output FIRST, then ask the PMM to confirm, edit, or build their own version inspired by the example.
2. **Teach PMM best practices while collecting context.** The onboarding itself is a mini-course in positioning, ICP definition, and competitive analysis.
3. **Accept "I don't know yet" as a valid answer.** Flag it as a gap, recommend which agent can help fill it, and move on. Never block progress.
4. **Offer multiple input modes** for every question: type your own, pick from examples, upload a doc, or skip for now.

---

## The 3-Layer Context Building Architecture

```
Layer 1: AUTO-ENRICHMENT (0 effort from user)
  Website scraping → Product analytics connection → CRM pull → Gong extraction
  Builds ~50% of the Company KB in minutes

Layer 2: GUIDED CONVERSATION (5-10 minutes from user)
  AI-guided Q&A that fills gaps auto-enrichment couldn't cover
  "Based on your website, it looks like you target [X]. Is that right?"
  Builds another ~30% of the Company KB

Layer 3: PROGRESSIVE DEEPENING (ongoing, zero-effort)
  Every agent interaction enriches the KB automatically
  Upload docs when you want to (not when you have to)
  KB gets smarter every week without the user doing anything extra
```

---

## Layer 1: Auto-Enrichment (The "Paste Your URL" Moment)

### Step 1: Website Intelligence Extraction

**User input:** Just the company website URL

**What we auto-extract:**

```
FROM THE HOMEPAGE:
├── Company name
├── Tagline / H1 (current positioning attempt)
├── Product description (H2 / subheadline)
├── Value propositions (from value prop sections)
├── Target audience signals (from copy: "for teams that...", "built for...")
├── Product category (from meta description, schema markup, copy)
├── Social proof (logos, testimonials, customer quotes)
├── CTA language (what action they're driving: "Start free trial", "Book demo", "Talk to sales")
└── GTM motion signal (free trial = PLG, "talk to sales" = sales-led, both = hybrid)

FROM THE PRICING PAGE:
├── Pricing tiers (free/starter/pro/enterprise)
├── Price points
├── Feature gating (what's in each tier)
├── Value metric (per seat, per usage, flat rate)
├── Enterprise signal (custom pricing, "contact sales")
└── Competitor comparison (if they have a comparison page)

FROM THE PRODUCT PAGES:
├── Feature list and descriptions
├── Use cases highlighted
├── Integrations listed
├── Technical requirements mentioned
└── Product screenshots/demo (for product understanding)

FROM THE ABOUT PAGE:
├── Company story / origin
├── Team size signals
├── Funding status (if mentioned)
├── Office locations
└── Mission/vision statements

FROM THE BLOG:
├── Content themes (what topics they write about)
├── Posting frequency
├── Target audience signals from content
└── Thought leadership angles

FROM THE CAREERS PAGE:
├── Team size signal (number of open roles)
├── Department structure signal (which teams are hiring)
├── Growth stage signal
└── Culture/values
```

**Processing:** AI agent reads the entire website (like a PMM doing a messaging audit on day 1 of a new job) and generates a structured "Company Profile Draft" — a first-pass Company KB that's already 50% useful.

**Time for user:** ~30 seconds (paste URL, click "Analyze")
**Time for system:** ~2-3 minutes of crawling and extraction
**Output:** A pre-populated Company KB dashboard the user can review

### Step 2: Connected Tool Auto-Enrichment (Optional, Adds Depth)

If the user connects tools during onboarding (or later), each connection auto-enriches specific parts of the KB:

| Connected Tool | What We Auto-Extract | KB Section Enriched |
|---|---|---|
| **CRM (Salesforce/HubSpot)** | Top customers by revenue, deal sizes, win rates, loss reasons, competitor fields, sales cycle length, industry/segment breakdown | Customer Context, Competitive Context, ICP signals |
| **Gong/Chorus** | Customer language patterns, pain points mentioned, competitor mentions, objection themes, "current way" references, feature requests | Customer Context, Competitive Context, Positioning signals |
| **Product Analytics (Amplitude/Mixpanel)** | Feature adoption rates, activation milestones, power user behaviors, churn predictors, user segments | Product Context, ICP behavioral signals |
| **G2/Capterra** | Your reviews (strengths/weaknesses), competitor reviews, category positioning, buyer intent data | Competitive Context, Customer sentiment |
| **Google Analytics / Website** | Traffic sources, top pages, conversion funnels, content performance | Content Intelligence, GTM motion signals |
| **Slack (specific channels)** | Competitive intel shared, customer feedback, product discussions | Competitive Context, Customer Context |
| **Google Drive / Notion** | Existing messaging docs, positioning docs, battlecards, personas, launch plans (if user grants access to specific folders) | All KB sections — this is the richest optional source |

**Key UX principle:** Connections are **optional and progressive**. The product works with just a URL. Each connection makes it smarter but is never required.

---

## Layer 2: Guided Enablement Conversation (The "Show-Then-Ask" Interview)

After auto-enrichment, the system knows a lot — but has gaps and uncertainties. More importantly, **many PMMs don't know what the "right" answers look like.** The onboarding doesn't just collect context — it teaches PMMs what great context looks like by showing real examples before asking every question.

### The Core Pattern: Show, Ask, Accept "I Don't Know"

Every question follows this pattern:

```
1. SHOW: Display a real-world example of a great answer
2. EXPLAIN: One sentence on WHY this matters and how agents use it
3. ASK: Let the PMM respond in one of 4 ways:
         ○ Type their own
         ○ Pick from suggested options (from auto-enrichment)
         ○ Upload a doc that contains this
         ○ "I don't have this yet" → gap flagged, agent assigned to help
4. VALIDATE: Agent confirms understanding, asks one follow-up if needed
```

### The Conversation Flow (6 Sections)

**SECTION 1: PRODUCT CONTEXT**

Agent shows what it auto-extracted and asks PMM to confirm. If PMM says "I'm not sure how to describe it well," agent shows 3 real examples:

- **Category anchor** (Figma): "A collaborative interface design tool"
- **Use case anchor** (Loom): "Record quick videos to explain anything"
- **Problem anchor** (Gong): "Captures your sales conversations and shows you what's working"

Then provides a fill-in-the-blank template: "[Product] is a [category] that helps [audience] [do what]."

Tip shown: "The best product descriptions name WHO it's for and WHAT they can do. Don't worry about perfection — we'll refine this with the Positioning Agent later."

**SECTION 2: TARGET AUDIENCE / ICP**

Agent shows a **complete sample ICP one-pager** (anonymized) with all fields filled: company type, industry, must-have criteria, buyer/champion/end-user roles, current way, and trigger event.

Then explains the concept of "current way" (FletchPMM): "This is what your prospect does TODAY without your product. Could be a manual process, a spreadsheet, a competitor, or nothing at all. This single insight makes your Positioning Agent and CI Agent 10x smarter."

Pre-fills what it found from the website. PMM fills gaps or says "I haven't defined my ICP yet" — which triggers: "Very common. Your Research Agent can help you build this. I'll add 'Define ICP' as your first recommended action."

**SECTION 3: COMPETITIVE LANDSCAPE**

Agent shows the **3 types of competition** framework (FletchPMM):
1. DIRECT: Other products in your category (Figma vs Sketch)
2. STATUS QUO: The manual workaround they use today (spreadsheets, email, "we just don't do this")
3. ADJACENT: Products in a nearby category expanding toward you (Notion moving into project mgmt)

Shows auto-detected competitors from G2/review sites. PMM confirms, adds, or says "I haven't done competitive research yet" — which triggers: "Your CI Agent will start monitoring these competitors immediately and build you a competitive brief within 48 hours."

**SECTION 4: MESSAGING & POSITIONING**

Agent shows the **Atlassian Message House** visual diagram with a filled example: positioning roof + 3 value pillars + proof points.

PMM can: upload existing messaging doc, describe scattered messaging across docs/decks, or say "I don't have formal messaging yet."

For "I don't have messaging" — agent asks the single best proxy question: "When a friend asks 'what does your company do?', what do you say?" This raw "founder pitch" becomes seed material for the Positioning Agent.

**SECTION 5: SALES & CUSTOMER CONTEXT**

Agent explains: "The words your CUSTOMERS use to describe your product are more valuable than the words your MARKETING uses."

Asks: How do your best customers describe you? What's your GTM motion (PLG/sales-assisted/sales-led/enterprise)? Who are your top 3-5 customers?

Each question includes an example of what a good answer looks like.

**SECTION 6: YOUR PRIORITY (Determines First Agent)**

"What's the ONE thing you most need help with right now?"

Each option shows a **preview screenshot** of what the recommended agent's first output will look like — so the PMM can see exactly what they'll get before they start.

### The "I Don't Have This Yet" Philosophy

This is the most important design decision. At every question, "I don't know / I don't have this" is a **first-class response**, not a failure state.

| Gap Identified | System Response |
|---|---|
| No product description | Pre-fills from website + shows 3 template patterns |
| No ICP defined | Flags as priority → recommends Research Agent → shows sample ICP Scorecard |
| No competitive research | Auto-creates monitoring → CI Agent delivers brief in 48 hours |
| No messaging/positioning | Shows Message House example → captures "friend pitch" → queues Positioning Agent |
| No customer language data | Recommends VoC research → if Gong connected, auto-extracts |
| Not sure about GTM motion | Infers from website signals → confirms with user |
| No customers yet | Switches to pre-PMF mode → focuses on hypothesis, not validation |

**Every "I don't know" becomes a task for an agent.** The onboarding isn't just collecting context — it's building the PMM's first to-do list.

### Maturity-Adaptive Onboarding

The conversation adapts based on the PMM's situation (auto-detected from early answers):

| Situation | Adaptation |
|---|---|
| First PMM hire, no assets | More examples, more explanation, more "build from scratch" agent tasks |
| Experienced PMM, has docs | Skip examples, focus on upload + confirmation, suggest refinement |
| PMM team with frameworks | Upload-first flow, bulk import, team workspace setup |
| Pre-revenue / pre-PMF | All frameworks switch to hypothesis mode, focus on Research + Positioning |
| Multi-product company | Triggers Product KB setup per product |

### Sample Docs Library

Every section links to real examples the PMM can reference:

| Section | Sample Shown | Source |
|---|---|---|
| Product description | Figma, Loom, Gong one-liners | Public websites |
| ICP definition | Filled ICP one-pager | FletchPMM Scorecard + WbD SPICED |
| Competition | 3-type framework + sample brief | FletchPMM |
| Messaging | Atlassian Message House (filled) | Template library |
| Launch planning | Sample Tier 2 plan | AWS template |
| Battlecard | Filled competitive battlecard | Klue best practices |
| Pricing | Sample Good/Better/Best structure | SaaS pattern |

### The "Minimum Viable KB" (Still Just 5 Things)

1. **What is your product?** (auto-extracted, confirmed, or template-assisted)
2. **Who is it for?** (auto-extracted, confirmed, or flagged for Research Agent)
3. **What does it replace?** ("current way" — prompted with examples, or flagged as gap)
4. **Who are your competitors?** (auto-detected + confirmed, or CI Agent auto-starts)
5. **What are you trying to do right now?** (priority — determines first agent)

With just these 5, every agent is immediately useful. Everything else deepens quality over time.

---

## Layer 3: Progressive Deepening (The KB That Builds Itself)

This is the magic layer. After onboarding, the Company KB gets smarter every day without the user doing anything extra.

### How Every Agent Enriches the KB

| When This Happens... | The KB Learns... |
|---|---|
| Positioning Agent generates messaging | Current positioning anchors, value props, messaging pillars get stored |
| CI Agent monitors competitors | Competitor profiles, pricing changes, feature launches get logged |
| Research Agent synthesizes Gong calls | Customer language, pain points, objection patterns get extracted |
| Sales Enablement Agent tracks asset usage | Which messaging resonates with sales, which doesn't |
| Signal Agent detects intent signals | Behavioral ICP patterns, buying triggers |
| Content Agent tracks post performance | What topics, formats, and angles work for your audience |
| Pricing Agent analyzes deal data | WTP signals, discount patterns, tier conversion rates |
| Metrics Agent correlates activities to outcomes | What PMM activities actually drive pipeline |
| Narrative Agent flags inconsistencies | Messaging gaps between teams/channels |

### "Upload When You Want To" (Not When You Have To)

The system works without any doc uploads. But uploading enriches the KB significantly:

**Smart Upload UX:**
```
DASHBOARD PROMPT (contextual, not nagging):

"Your Positioning Agent would be 3x more effective with your
 existing messaging doc. Want to upload it?"
 [Upload]  [Skip — I'll create new messaging]  [Remind me later]
```

**What happens when docs ARE uploaded:**

| Doc Type | What We Extract | Which Agents Benefit |
|---|---|---|
| **Existing messaging/positioning doc** | Current positioning statement, value props, persona definitions, competitive claims, messaging pillars | Positioning, Narrative, Content, Sales Enablement |
| **Sales deck / pitch deck** | Current narrative arc, proof points used, competitive positioning, demo flow | Narrative, Sales Enablement, Proposal Generator |
| **Battlecards** | Competitive strengths/weaknesses, objection handling, win themes, loss reasons | CI, Sales Enablement |
| **Persona docs** | ICP definition, buyer/user/champion profiles, pain points, decision criteria | Research, Positioning, Content |
| **Launch plans (past)** | Launch process, tiering used, channels used, outcomes | Launch Planning, Metrics |
| **Case studies** | Customer stories, proof points, ROI data, use cases | Narrative, Sales Enablement, Content |
| **Product specs / PRDs** | Feature details, technical capabilities, roadmap items | All agents (product context) |
| **Brand guide** | Voice, tone, visual guidelines, do's and don'ts | Content, Narrative (brand guardrails) |
| **Win/loss reports** | Why you win, why you lose, competitor intelligence | CI, Positioning, Research |
| **Pricing docs** | Current pricing model, tiers, feature gating, discount rules | Pricing Agent |
| **Customer research** | Interview transcripts, survey results, NPS data | Research, Positioning |
| **Internal strategy docs** | Company OKRs, GTM strategy, annual plans | Metrics, Alignment |

**Processing:** Uploaded docs are AI-parsed, structured, and mapped to the appropriate Context Graph layers. The user sees: "I extracted 47 data points from your messaging doc. Here's what I found — confirm or edit."

---

## The Onboarding UX: End-to-End Flow

### Screen 1: Welcome
```
┌─────────────────────────────────────────────────┐
│                                                   │
│  Welcome to PMM Agent OS                          │
│                                                   │
│  Let's get your agents up to speed on your        │
│  company in about 5 minutes.                      │
│                                                   │
│  Paste your company website URL:                  │
│  ┌─────────────────────────────────────────┐     │
│  │ https://                                 │     │
│  └─────────────────────────────────────────┘     │
│                                                   │
│  [Analyze My Company →]                           │
│                                                   │
└─────────────────────────────────────────────────┘
```

### Screen 2: Auto-Analysis (2-3 minutes)
```
┌─────────────────────────────────────────────────┐
│                                                   │
│  Analyzing yourcompany.com...                     │
│                                                   │
│  ✓ Homepage messaging extracted                   │
│  ✓ Pricing page analyzed                          │
│  ✓ Product features mapped                        │
│  ✓ Competitor signals detected                    │
│  ◌ Blog content themes identifying...             │
│  ◌ Social proof cataloging...                     │
│                                                   │
│  While we analyze, tell us about yourself:        │
│                                                   │
│  Your role: [PMM ▾]                               │
│  Your team size: [Solo / 2-5 / 6-15 / 15+ ▾]     │
│                                                   │
└─────────────────────────────────────────────────┘
```

### Screen 3: Review & Confirm (the "Smart Interview")
```
┌─────────────────────────────────────────────────┐
│                                                   │
│  Here's what I found. Let's make sure I got       │
│  it right.                                        │
│                                                   │
│  YOUR PRODUCT                                     │
│  ┌─────────────────────────────────────────┐     │
│  │ "Acme is a [data integration platform]   │     │
│  │  for [data teams] that [automates ETL    │     │
│  │  pipelines]"                              │     │
│  └─────────────────────────────────────────┘     │
│  [That's right ✓]  [Let me edit ✏️]               │
│                                                   │
│  YOUR VALUE PROPS (extracted from website)        │
│  1. ✓ "Zero-maintenance pipelines"                │
│  2. ✓ "300+ pre-built connectors"                 │
│  3. ? "Enterprise-grade security" ← less sure     │
│  [Confirm all]  [Edit]  [Add missing ones]        │
│                                                   │
│  YOUR AUDIENCE                                    │
│  Based on your copy, it seems like you target:    │
│  • Data engineers                                 │
│  • Analytics teams                                │
│  • VP/Director of Data                            │
│  [That's right ✓]  [Let me edit ✏️]               │
│                                                   │
└─────────────────────────────────────────────────┘
```

### Screen 4: Fill the Gaps (critical questions)
```
┌─────────────────────────────────────────────────┐
│                                                   │
│  A few things I couldn't figure out from your     │
│  website. These will make your agents much        │
│  smarter.                                         │
│                                                   │
│  WHO ARE YOUR TOP COMPETITORS?                    │
│  (I found mentions of Fivetran and Stitch on      │
│  review sites. Who else?)                         │
│  ┌─────────────────────────────────────────┐     │
│  │ 1. Fivetran (auto-detected)              │     │
│  │ 2. Stitch (auto-detected)                │     │
│  │ 3. [                                ]    │     │
│  └─────────────────────────────────────────┘     │
│                                                   │
│  WHAT DO PROSPECTS DO TODAY WITHOUT YOU?           │
│  (The spreadsheet, the manual process, the        │
│  competitor — the "current way")                  │
│  ┌─────────────────────────────────────────┐     │
│  │ [                                      ] │     │
│  └─────────────────────────────────────────┘     │
│                                                   │
│  WHAT'S YOUR #1 PRIORITY RIGHT NOW?               │
│  ○ Launching something new                        │
│  ○ Improving positioning/messaging                │
│  ○ Winning more competitive deals                 │
│  ○ Building sales enablement                      │
│  ○ Proving PMM's impact with metrics              │
│  ○ Something else                                 │
│                                                   │
│  [Finish Setup →]                                 │
│                                                   │
└─────────────────────────────────────────────────┘
```

### Screen 5: Your Dashboard (agents are ready)
```
┌─────────────────────────────────────────────────┐
│                                                   │
│  Your agents are ready.                           │
│                                                   │
│  COMPANY KB: 67% complete                         │
│  ████████████████░░░░░░░░                         │
│  (Connect more tools or upload docs to go deeper) │
│                                                   │
│  RECOMMENDED FIRST ACTION:                        │
│  Based on your priority ("improve positioning"),  │
│  start with the Positioning Agent →               │
│                                                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐         │
│  │Positioning│ │    CI    │ │ Research │         │
│  │  Agent   │ │  Agent   │ │  Agent   │         │
│  │  READY   │ │  READY   │ │  READY   │         │
│  └──────────┘ └──────────┘ └──────────┘         │
│                                                   │
│  BOOST YOUR AGENTS (optional):                    │
│  ┌─────────────────────────────────────────┐     │
│  │ 📄 Upload existing docs  (+15% context)  │     │
│  │ 🔗 Connect Gong           (+20% context) │     │
│  │ 🔗 Connect Salesforce     (+18% context) │     │
│  │ 🔗 Connect Amplitude      (+12% context) │     │
│  └─────────────────────────────────────────┘     │
│                                                   │
└─────────────────────────────────────────────────┘
```

---

## The "Context Score" — Gamifying KB Completeness

Every agent shows a **Context Score** — a percentage indicating how much context it has to work with. This gently nudges users to deepen the KB without blocking them.

```
POSITIONING AGENT
Context Score: 72% ████████████████░░░░░░

What's boosting your score:
✓ Website messaging analyzed
✓ Competitors identified
✓ Target audience confirmed
✓ "Current way" defined

What would improve it:
△ Upload existing messaging doc (+8%)
△ Connect Gong for customer language (+10%)
△ Run ICP research with Research Agent (+6%)
△ Add 3+ customer proof points (+4%)
```

**Why this works:**
- User sees immediate value at 50-60% context (agents produce useful output right away)
- Score creates gentle motivation to deepen over time
- Each improvement is specific and actionable (not "upload more docs")
- Score is per-agent (Positioning Agent might be at 80% while Pricing Agent is at 30%)

---

## Progressive Enrichment Triggers

The system doesn't just wait for uploads — it actively identifies opportunities to deepen the KB:

| Trigger | What Happens |
|---|---|
| User runs Positioning Agent for the first time | Agent asks 2-3 clarifying questions that enrich the KB ("What's your #1 differentiator vs [competitor]?") |
| CI Agent detects a new competitor | "I found [New Competitor] mentioned in 3 recent G2 reviews comparing them to you. Should I add them to your competitive set?" |
| Research Agent processes a Gong call | Auto-extracts customer language and pain points → updates persona docs → notifies PMM: "I found 3 new pain points mentioned this week" |
| User creates their first battlecard | Agent asks: "What's your go-to objection response when prospects mention [Competitor]?" → stores in CI knowledge |
| PMM uploads a doc mid-workflow | System immediately parses and integrates into relevant KB sections |
| Week 2 check-in | "Your agents have learned a lot in the first 2 weeks. Here's what's new in your Company KB — anything to correct?" |

---

## Data Model: What the Company KB Actually Stores

```
CompanyKB {
  // Core Identity (from onboarding)
  company_name: string
  website_url: string
  stage: enum [seed, series_a, series_b, growth, enterprise]
  business_model: enum [saas, marketplace, plg, sales_led, hybrid]
  gtm_motion: enum [self_serve, sales_assisted, enterprise, channel, mixed]
  team_size: number
  pmm_team_size: number

  // Product (auto-extracted + user-confirmed)
  products: [{
    name: string
    category: string
    description: string  // user's words, not website copy
    features: [{ name, description, tier }]
    pricing: { model, tiers: [{ name, price, features }] }
    value_metric: string
    roadmap_highlights: [string]
  }]

  // Customer (auto-extracted + user-enriched + agent-enriched)
  icp: {
    definition: string  // user's description
    segments: [{
      name: string
      firmographics: { size, industry, geo, revenue }
      unit_of_work: string  // FletchPMM
      current_way: string  // FletchPMM
      spiced: { situation, pain, impact, critical_event, decision }  // WbD
      scorecard: { retention, access, velocity, activation }  // FletchPMM
    }]
    personas: [{
      name: string
      role: enum [buyer, champion, end_user]
      titles: [string]
      pain_points: { functional: [string], emotional: [string] }
      decision_criteria: [string]
      language_patterns: [string]  // from Gong
      content_preferences: [string]
    }]
    typing_questions: [{ question, segment_mapping }]  // Sonia Moaiery
  }

  // Competitive (auto-detected + user-confirmed + CI-agent-enriched)
  competitors: [{
    name: string
    url: string
    tier: enum [primary, secondary, emerging]
    current_way_alternative: boolean  // is this a "do nothing" competitor?
    differentiation_phase: enum [contextual, competitive, mature]  // FletchPMM
    how_we_win: string
    how_we_lose: string
    pricing: { model, tiers, last_updated }
    recent_moves: [{ date, description, significance }]
  }]
  current_way: string  // what prospects do WITHOUT any product

  // Brand (auto-extracted + user-refined)
  brand: {
    voice: { formality, technical_depth, personality_traits: [string] }
    tone_guidelines: string
    messaging_hierarchy: {
      brand_level: string
      product_level: [{ product, message }]
      audience_level: [{ persona, message }]
      channel_level: [{ channel, tone_adaptation }]
    }
    messaging_pillars: [{ pillar, claim, proof_point, customer_language }]
    dos_and_donts: [string]
  }

  // Positioning (agent-generated, user-approved)
  positioning: {
    anchors: { primary: string, secondary: string }  // FletchPMM
    mvp_positioning: { market_element, product_element }  // FletchPMM
    positioning_statement: string
    differentiation_mode: enum [contextual, competitive, mature]
    right_to_win: { product, credibility, distribution, team, timing }
    value_proposition_canvas: object
  }

  // Narrative (agent-generated, user-approved)
  narrative: {
    origin_story: string
    market_narrative: string
    product_narrative: string
    customer_narratives: [{ customer, story }]
    future_narrative: string
  }

  // Goals & Priorities (user-set, periodically refreshed)
  priorities: {
    company_okrs: [string]
    pmm_priorities: [string]
    current_quarter_focus: string
    planned_launches: [{ name, date, tier }]
    biggest_challenges: [string]
  }

  // TAM (agent-calculated, user-validated)
  tam: {
    bottom_up: { accounts, avg_acv, penetration, total }
    top_down: { industry_size, category_share, addressable }
    analogy: { comparable, basis, estimate }
    reachable_greens: [{ segment, size, readiness, priority }]
    validated_against_pipeline: boolean
  }

  // Meta
  context_score: number  // 0-100
  created_at: datetime
  last_enriched: datetime
  enrichment_sources: [{ source, date, data_points_added }]
}
```

---

---

## The Product KB: Deep Product Intelligence for Every Agent

The Company KB gives agents company-level context. But for a PMM supporting multiple products, each product needs its own deep knowledge base. This is the **Product KB** — a structured, per-product intelligence layer that makes every agent product-aware.

### Why Product KB Is Separate from Company KB

| Company KB | Product KB |
|---|---|
| One per company | One per product/product line |
| Company stage, GTM motion, team structure | Product-specific features, pricing, technical details |
| Overall ICP and competitive landscape | Product-specific ICP, use cases, and competitors |
| Brand voice and narrative | Product-specific messaging and positioning |
| Changes slowly (quarterly) | Changes frequently (every release) |

A PMM at a multi-product company (like mothi with Secure ID, Payments, Payouts) needs separate Product KBs for each — but they all inherit from the same Company KB.

### Product KB Structure (Based on Real-World SOPs)

Inspired by how the best product teams actually document products internally (e.g., mothi Secure ID's internal SOP structure):

```
Product KB: [Product Name]
│
├── 1. PRODUCT OVERVIEW
│   ├── What is [Product]? (plain English, 2-3 sentences)
│   ├── Why does it exist? (the before/after — what changed in the market)
│   ├── Who can use it? (eligible customer types, verticals, regulations)
│   └── Internal positioning line (one-sentence internal positioning)
│
├── 2. PRODUCT ARCHITECTURE
│   ├── How it works (end-to-end flow, simplified)
│   ├── Key components / modules
│   ├── Integration models (API, SDK, dashboard, file-based)
│   ├── Technical requirements / dependencies
│   └── Architecture diagrams (if available)
│
├── 3. FEATURES & CAPABILITIES
│   ├── Feature list with descriptions
│   ├── Feature status (live, beta, planned)
│   ├── Key differentiating features (vs. competitors)
│   ├── Quality checks / security features
│   ├── Performance specs (latency, uptime, throughput)
│   └── Current limitations and known gaps
│
├── 4. USE CASES
│   ├── Primary use cases (top 3-5)
│   ├── Use case by vertical/industry
│   ├── Use case by persona (buyer vs. end-user)
│   └── Customer examples per use case
│
├── 5. TARGET AUDIENCE (Product-Specific ICP)
│   ├── Who buys this? (buyer persona + title + decision process)
│   ├── Who uses this? (end-user persona)
│   ├── Who champions this? (internal champion at customer)
│   ├── Verticals / segments with best fit
│   └── Verticals / segments with poor fit (anti-ICP)
│
├── 6. COMPETITIVE LANDSCAPE (Product-Specific)
│   ├── Direct competitors for THIS product
│   ├── "Current way" (what they do without this product)
│   ├── How we win against each competitor
│   ├── How we lose against each competitor
│   ├── Key differentiators (why Secure ID CKYC is different)
│   └── Competitive pricing comparison
│
├── 7. PRICING & PACKAGING
│   ├── Pricing model (per API call, per verification, subscription)
│   ├── Pricing tiers and what's included
│   ├── Discount rules and approval thresholds
│   ├── Free tier / trial offering
│   └── How to activate / procurement process
│
├── 8. MESSAGING & POSITIONING
│   ├── Internal positioning statement
│   ├── External tagline / headline
│   ├── Value propositions (3-5 pillars)
│   ├── Proof points per pillar
│   ├── Messaging by persona (buyer vs. user vs. champion)
│   ├── Messaging by vertical
│   └── Elevator pitches (10-word, 30-word, 100-word)
│
├── 9. SALES ENABLEMENT
│   ├── How to pitch this product
│   ├── Discovery questions to ask
│   ├── Demo flow / how to give a demo
│   ├── Objection handling (top 5-10 objections)
│   ├── Talk tracks by persona
│   ├── ROI talking points / calculator
│   └── Customer stories / proof points for sales
│
├── 10. INTEGRATION & ONBOARDING
│   ├── How to integrate (API endpoints, SDKs)
│   ├── How to test (sandbox, test credentials)
│   ├── Onboarding workflow (merchant/customer side)
│   ├── Time to go live (typical)
│   ├── Common integration issues and fixes
│   └── Documentation links
│
├── 11. FAQ
│   ├── Customer-facing FAQ
│   ├── Internal FAQ (sales/CS)
│   └── Technical FAQ
│
├── 12. PRODUCT ROADMAP (Next 2-3 Quarters)
│   ├── Planned features and enhancements
│   ├── Upcoming launches
│   ├── Migration paths (old → new)
│   └── Deprecation timeline (if applicable)
│
└── 13. GLOSSARY
    └── Product-specific terms and definitions
```

### How the Product KB Gets Populated

**Option A: Upload Existing Product Docs (Fastest)**

PMM uploads existing internal SOPs, product specs, PRDs, or product one-pagers. The system AI-parses them and maps content to the Product KB structure automatically.

```
USER: [Uploads "Secure ID - Internal SOP.docx"]

AGENT: "I found 6 products in this document:
        1. CKYC (Central KYC)
        2. OKYC → DigiLocker Aadhaar Verification
        3. SmartOCR
        4. Video KYC
        5. Face Match
        6. Aadhaar Verification (deprecated)

        I've auto-populated Product KBs for each.
        The CKYC Product KB is 85% complete.

        Key items I extracted:
        ✓ What it is and why it exists
        ✓ Who can use it (regulated entities)
        ✓ How Secure ID enables it (API + Reporting models)
        ✓ All interaction types (Search, Download, Upload, Compare)
        ✓ On-premise compliance model
        ✓ Key differentiators ('Probable Match Handling')
        ✓ Who buys it internally at customer
        ✓ Internal positioning line

        Gaps to fill:
        △ Pricing details
        △ Customer examples
        △ Competitive comparison

        [Review CKYC Product KB →]  [Review All Products →]"
```

**Option B: Guided Product Interview (When No Docs Exist)**

```
AGENT: "Let's build a Product KB for [Product Name].
        I'll ask you 10 questions. Should take about 10 minutes.

        1. In one sentence, what does [Product] do?
        2. What problem did customers have BEFORE this product existed?
        3. Who typically buys this? (role/title)
        4. What's the #1 thing that makes this product different from alternatives?
        5. How does pricing work?
        ..."
```

**Option C: Auto-Extract from Connected Tools**

| Source | What We Extract for Product KB |
|---|---|
| Product website / landing page | Features, pricing, use cases, messaging |
| API docs / developer portal | Integration details, endpoints, technical specs |
| Jira / Linear | Feature status, roadmap, release dates, bug counts |
| Productboard | Feature requests, customer feedback, prioritization |
| CRM (product-level deals) | Win/loss by product, product-specific pipeline, ACV by product |
| Gong (product-mentioned calls) | Product-specific objections, competitive mentions, customer language |
| Help center / docs site | FAQ content, common issues, onboarding guides |

### How Product KB Connects to Agents

Every agent can be **scoped to a specific product** when running:

```
USER: "Generate positioning for SmartOCR"

AGENT: [Reads SmartOCR Product KB]
       [Reads Company KB for overall context]
       [Reads Competitive Intelligence for SmartOCR-specific competitors]
       [Reads Customer Research for SmartOCR-specific personas]

       → Generates SmartOCR-specific positioning using FletchPMM anchors,
         grounded in the product's actual capabilities and competitive reality
```

```
USER: "Create a launch plan for CKYC"

AGENT: [Reads CKYC Product KB — knows regulated entity audience, API + reporting models]
       [Reads Company KB — knows mothi's stage, GTM motion, team structure]
       [Reads Launch Planning templates — selects appropriate tier]

       → Generates a launch plan that knows CKYC is a compliance product
         for regulated entities, requiring different channels and messaging
         than a self-serve fintech product
```

### Multi-Product Dashboard

For companies with multiple products, the dashboard shows Product KB health per product:

```
PRODUCT KBs                              Context Score
┌─────────────────────────────────────────────────┐
│ CKYC                    ████████████████░░  85%  │
│ SmartOCR                ████████████░░░░░░  65%  │
│ Video KYC               ██████████░░░░░░░░  52%  │
│ Face Match              ████████░░░░░░░░░░  40%  │
│ DigiLocker Aadhaar      ██████░░░░░░░░░░░░  30%  │
│                                                   │
│ [+ Add Product]                                   │
└─────────────────────────────────────────────────┘
```

---

## Summary: The 3-Step Answer to "How Do I Build the Company KB?"

### Step 1: Paste URL + Answer 5 Questions (5 minutes)
- Website auto-crawl extracts product, messaging, pricing, audience, competitors
- 5 guided questions fill critical gaps (competitors, current way, priority)
- **Result: 50-70% Company KB, agents are immediately useful**

### Step 2: Connect Tools (Optional, 10 minutes)
- CRM → customer data, win/loss, deal patterns
- Gong → customer language, pain points, objections
- Product analytics → usage patterns, activation signals
- G2 → reviews, competitive comparisons
- **Result: 70-85% Company KB, agents are very good**

### Step 3: Upload Docs + Let Agents Learn (Ongoing, Zero Effort)
- Upload existing messaging docs, battlecards, personas, decks when convenient
- Every agent interaction enriches the KB automatically
- Weekly "KB Health Check" surfaces what's new and what needs updating
- **Result: 85-95% Company KB, agents are exceptional**

**The user NEVER has to do Step 2 or Step 3 to get value.** Step 1 alone makes the product useful. Steps 2 and 3 make it indispensable.
