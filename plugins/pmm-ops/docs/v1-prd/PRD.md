# PMMStudio V1 — Product Requirements Document

**Product:** PMMStudio — The GTM Builder
**Tagline:** "Build your Go-To-Market in 60 minutes, not 6 weeks."
**Version:** 1.0
**Date:** April 9, 2026
**Target Launch:** 6-8 weeks from start of development

---

## What We're Building

A single guided experience that walks a PMM through the complete GTM workflow — from market research to shipping a launch plan — in one session. Behind the scenes, 5 interconnected modules share context. To the user, it's one seamless flow.

**Not an "agent platform." Not a dashboard. A guided builder that produces a complete GTM document.**

---

## The V1 Workflow (5 Steps, ~60 Minutes)

```
STEP 1          STEP 2          STEP 3          STEP 4          STEP 5
RESEARCH        COMPETITIVE     PRFAQ           POSITIONING     GTM PLAN
ICP + TAM       INTELLIGENCE    Working         Messaging &     Launch Plan
                                Backwards       Differentiation

"Who are we     "Who else       "What are we    "How do we      "How do we
 selling to      is out there    building and     talk about      ship this
 and how big     and how do      why does it      this?"          to market?"
 is the          they            matter?"
 market?"        position?"

10 min          10 min          15 min          15 min          10 min
```

**Each step feeds the next.** Research informs CI. CI informs PRFAQ. PRFAQ informs Positioning. Positioning informs GTM Plan. The user never starts from a blank page.

---

## Step 0: Input — How the GTM Project Starts

In reality, PMMs don't always start from scratch. They receive inputs from PMs, founders, or sales teams that kick off the GTM process. PMMStudio V1 supports **5 input modes** — the user picks whichever matches their starting point:

### Input Mode 1: URL Only (cold start)
**When:** New company, new product, or no existing docs.
- Paste website URL → system auto-extracts everything it can → guided conversation fills gaps.
- Best for: First-time users, startup PMMs, exploring the product.

### Input Mode 2: PRD / Product Spec Upload
**When:** PM hands you a PRD and says "build the GTM for this."
- Upload the PRD (Google Doc, Notion export, PDF, Word doc)
- System auto-extracts: product description, feature list, target audience (if mentioned), problem statement, use cases, technical requirements, timeline
- **Pre-fills Steps 1-3** from the PRD content:
  - Step 1 (Research): Product context + audience signals → PMM validates and sharpens ICP
  - Step 2 (CI): Product category identified → auto-kicks off competitive research
  - Step 3 (PRFAQ): Problem/solution already articulated in PRD → auto-generates PRFAQ draft

```
USER uploads: "Feature_PRD_v2.pdf"

SYSTEM: "I extracted the following from your PRD:

  Product: [name + description]
  Problem: [problem statement from PRD]
  Target user: [user persona from PRD]
  Key features: [feature list]
  Success metrics: [from PRD if available]
  Timeline: [release date if mentioned]

  I've pre-filled Steps 1-3 with this context.
  Let's sharpen the ICP and competitive landscape
  to build your GTM.

  → [Start with Step 1: Validate ICP]"
```

### Input Mode 3: PRFAQ Upload
**When:** The Amazon-style working-backwards process already happened. PM or founder wrote the PRFAQ. PMM's job is to turn it into positioning + GTM.
- Upload the PRFAQ document
- System extracts: headline, problem, solution, customer quote, FAQs, success metrics
- **Step 3 is already done** — system skips straight to validation:
  - Cross-checks PRFAQ claims against CI data (Step 2)
  - Validates ICP assumptions (Step 1)
  - Generates positioning from PRFAQ (Step 4)

```
USER uploads: "KFS_PRFAQ_Internal.docx"

SYSTEM: "I found a complete PRFAQ. Here's what I extracted:

  Headline: [from PRFAQ]
  Problem: [from PRFAQ]
  Solution: [from PRFAQ]
  Customer quote: [from PRFAQ or 'missing']
  Key FAQs: [listed]

  Step 3 is pre-filled ✓

  Before we build positioning, let me validate this against
  market data:
  → Step 1: Does the ICP match the PRFAQ's target audience?
  → Step 2: Does the competitive landscape support the
             differentiation claims in the PRFAQ?

  → [Start validation]"
```

### Input Mode 4: Call Notes / Meeting Notes Upload
**When:** PMM just came out of a customer call, PM sync, or sales debrief and wants to turn raw notes into structured GTM thinking.
- Upload call notes (typed notes, Otter/Fireflies transcript, Gong summary, or raw text paste)
- System extracts: customer pain points, feature requests, competitive mentions, objection patterns, buying signals, persona signals
- **Enriches Step 1** (Research) with real customer voice data:

```
USER uploads: "Pine_Labs_Compliance_Call_Notes.txt"

SYSTEM: "I extracted the following from your call notes:

  CUSTOMER PAIN POINTS DETECTED:
  1. 'Large number of MCC codes were wrong after regulation change'
  2. 'Exposed to unnecessary compliance risk overnight'
  3. 'Over-reliance on merchant self-declaration'

  COMPETITIVE MENTIONS:
  → Current way: 'Manual review + fragmented GST-check tools'

  PERSONA SIGNALS:
  → Head of Compliance is the buyer (compliance risk = #1 pain)
  → Operations team is the end user (onboarding workflow)

  BUYING TRIGGERS:
  → RBI regulation change created urgency

  I've added this to your Research context.
  → [Continue to Step 1: Validate ICP with this data]"
```

### Input Mode 5: Existing Positioning / Messaging Doc Upload
**When:** PMM already has positioning from a previous cycle and wants to refresh or rebuild.
- Upload existing messaging doc, positioning statement, or GTM plan
- System extracts current positioning, compares against latest CI data, and identifies what's changed
- **Accelerates the workflow** — instead of building from scratch, system shows: "Here's what still holds, here's what's changed, here's what needs updating."

```
USER uploads: "MCC_Positioning_v1.docx"

SYSTEM: "I found your existing positioning:

  Current statement: '[existing positioning]'
  Current pillars: [3 pillars listed]
  Last updated: [date from doc metadata]

  WHAT'S CHANGED SINCE THEN:
  → CI detected: [2 competitor moves]
  → Market shift: [new regulation or trend]
  → Customer language: [Gong data shows different pain points]

  RECOMMENDATION: Refresh pillars 1 and 3. Pillar 2 still holds.

  → [Start guided refresh]"
```

### Why Multiple Input Modes Matter

| PMM Scenario | Input Mode | What Happens |
|---|---|---|
| New product, no docs | URL only | Full 5-step flow from scratch |
| PM drops a PRD | PRD upload | Steps 1-3 pre-filled from PRD, PMM validates + adds market context |
| Amazon-style company, PRFAQ exists | PRFAQ upload | Step 3 done, system validates claims against market data, then builds positioning |
| PMM just did customer discovery | Call notes upload | Research enriched with real customer voice, then continues through the flow |
| Quarterly messaging refresh | Existing doc upload | System diffs current positioning against latest market data, recommends what to update |
| PM + PMM kickoff meeting | Notes upload | Meeting notes → structured GTM starting point in minutes |

**The key insight:** The GTM workflow always follows the same 5 steps. But the STARTING POINT varies based on what the PMM already has. PMMStudio V1 meets the PMM where they are — whether that's a blank slate or a stack of existing docs.

---

## Step 1: Research — ICP + Market + TAM (10 min)

### What It Does

Takes the PMM from "I know my product" to "I know exactly who I'm targeting, how big the opportunity is, and what my customers do today without me."

### The Flow

**1a. Auto-Extract (30 seconds)**

User pastes their website URL. System crawls and extracts:
- Product description, features, pricing
- Target audience signals from copy
- Value propositions from website
- Social proof (logos, testimonials)
- GTM motion signals (free trial = PLG, "book demo" = sales-led)

**1b. ICP Builder (5 minutes)**

Guided, show-then-ask format:

```
SYSTEM: "Based on your website, it looks like you're targeting
         [auto-detected audience]. Let me help you sharpen this."

         Here's what a strong ICP looks like:
         ┌─────────────────────────────────────────┐
         │ SAMPLE ICP:                              │
         │ Company: Mid-market SaaS (200-2K emp)    │
         │ Industry: B2B software, fintech          │
         │ Must do: Run data pipelines regularly     │
         │ Buyer: VP/Director of Data               │
         │ End user: Data engineers                  │
         │ Current way: Custom Python/Airflow ETL    │
         │ Trigger: New data source request (3+ wks) │
         └─────────────────────────────────────────┘

GUIDED QUESTIONS:
  1. "What type of company is your ideal customer?"
     → [auto-suggested from website + editable]

  2. "Who buys this? (title of the person signing the check)"
     → [free text, with examples: "VP Engineering", "Head of Data"]

  3. "Who uses it daily? (title of the person in the product)"
     → [free text, with examples]

  4. "What do they do TODAY without your product?"
     ← THIS IS THE MOST IMPORTANT QUESTION
     → [free text, with examples: "spreadsheets", "custom scripts",
        "a competitor", "they just live with the pain"]

  5. "What triggers them to look for a solution?"
     → [free text, with examples: "new compliance requirement",
        "team grew past 10 people", "lost a deal because of it"]

ACCEPT "I DON'T KNOW":
  Every question has a "not sure yet" option.
  → System notes the gap and auto-fills a hypothesis:
     "Based on similar companies, your buyer is likely [X].
      We'll refine this as we learn more."
```

**ICP Scorecard Output:**

```
YOUR ICP SCORECARD:

Segment: [Auto-generated name, e.g., "Mid-market B2B SaaS"]

  Retention potential:  ████████░░  8/10
  Access (can we reach): ██████░░░░  6/10
  Sales velocity:       ███████░░░  7/10
  Activation speed:     █████████░  9/10

  OVERALL FIT: STRONG

  ⚠️ Gaps to investigate:
  → Access score is moderate — where does this audience hang out?
     (This will inform your GTM channel strategy in Step 5)
```

**1c. TAM Sizing — Triangulated (3 minutes)**

System auto-generates TAM using three methods. PMM reviews and adjusts.

```
YOUR MARKET SIZE (Auto-Generated):

METHOD 1 — BOTTOM UP:
  [X] companies matching your ICP criteria (from LinkedIn/Crunchbase data)
  × $[Y] estimated ACV (from your pricing page)
  × [Z]% addressable (not already using a competitor)
  = $[TOTAL] bottom-up TAM

METHOD 2 — TOP DOWN:
  [Category] market is $[X]B (source: [analyst report])
  Your addressable slice: [Y]% based on segment focus
  = $[TOTAL] top-down TAM

METHOD 3 — ANALOGY:
  [Similar company] in [adjacent market] has [X] customers
  at $[Y] ACV = $[Z] revenue
  Applying to your market: $[TOTAL] analogy TAM

TRIANGULATED ESTIMATE:
  ┌─────────────────────────────────────────┐
  │  TAM: $[X]M                             │
  │  SAM: $[Y]M (your reachable segment)    │
  │  SOM: $[Z]M (what you can win in Y1-2)  │
  │                                          │
  │  "Start here" segment: [specific SOM]    │
  │  → [X] target accounts                   │
  └─────────────────────────────────────────┘

  💡 "Market to your SOM, not your TAM."
     Your long-term play is the full market.
     Your GTM plan (Step 5) targets the SOM.
```

### Step 1 Output
- ICP definition (one-pager with scorecard)
- Persona sketches (buyer + end user)
- "Current way" mapping
- TAM/SAM/SOM with triangulation
- Trigger events identified

---

## Step 2: Competitive Intelligence (10 min)

### What It Does

Takes the PMM from "I kind of know my competitors" to "I have a structured competitive landscape with clear differentiation angles."

### The Flow

**2a. Auto-Detection (1 minute)**

System automatically identifies competitors from:
- G2/Capterra category data
- Website copy analysis (comparison pages, "vs" content)
- Search results for product category
- CRM data (if connected — future V2)

```
SYSTEM: "I found these potential competitors:"

  DIRECT COMPETITORS (same category):
  ✓ [Competitor A] — [one-line description] — detected from G2
  ✓ [Competitor B] — [one-line description] — detected from your website
  ? [Competitor C] — [one-line description] — less certain
  + [Add competitor]

  STATUS QUO COMPETITOR:
  → [Auto-filled from Step 1 "current way"]:
    "Spreadsheets / manual process / doing nothing"

  💡 "Early-stage companies usually compete more against the STATUS QUO
     than against direct competitors." — FletchPMM
```

**2b. Competitive Analysis (7 minutes)**

For each confirmed competitor (top 3), system auto-researches and presents:

```
COMPETITOR BRIEF: [Competitor A]

  POSITIONING (from their website):
  "[Their H1/H2 tagline and value props]"

  PRICING (from their pricing page):
  [Tier structure and price points]

  STRENGTHS (from G2 reviews — top 3 themes):
  1. [Strength 1]
  2. [Strength 2]
  3. [Strength 3]

  WEAKNESSES (from G2 reviews — top 3 complaints):
  1. [Weakness 1]
  2. [Weakness 2]
  3. [Weakness 3]

  YOUR POTENTIAL DIFFERENTIATION:
  Based on your ICP and "current way" (from Step 1),
  here are angles where you can win:
  → [Differentiation angle 1]
  → [Differentiation angle 2]
  → [Differentiation angle 3]
```

**2c. Differentiation Mode (2 minutes)**

```
SYSTEM: "Based on your market, here's your differentiation mode:"

  ┌─────────────────────────────────────────────┐
  │ YOUR MARKET MATURITY: [Auto-detected]        │
  │                                              │
  │ ○ EARLY MARKET (contextual differentiation)  │
  │   → Your real competitor is the status quo   │
  │   → Lead with: "There's a better way"        │
  │                                              │
  │ ● GROWING MARKET (competitive differentiation)│
  │   → Direct product-to-product competition    │
  │   → Lead with: "Here's why we're better"     │
  │                                              │
  │ ○ MATURE MARKET (ecosystem differentiation)  │
  │   → Competition is on trust & ecosystem      │
  │   → Lead with: "Here's why we're safer"      │
  └─────────────────────────────────────────────┘

  "You're in a GROWING MARKET. This means your positioning
   (Step 4) should directly address [Competitor A] and
   [Competitor B]'s weaknesses while highlighting your
   unique strengths."
```

### Step 2 Output
- Competitive landscape (top 3 + status quo mapped)
- Per-competitor brief (positioning, pricing, strengths, weaknesses)
- Differentiation angles identified
- Market maturity + differentiation mode determined
- Feeds directly into Step 3 (PRFAQ) and Step 4 (Positioning)

---

## Step 3: PRFAQ — Working Backwards (15 min)

### What It Does

Before you position or plan a launch, you need internal alignment on WHAT you're bringing to market and WHY it matters. The PRFAQ (Press Release / FAQ) format — pioneered by Amazon — forces clarity.

**Why PRFAQ before Positioning:** The PRFAQ crystallizes the customer problem, the solution, and the "so what?" in plain language. This becomes the raw material that the Positioning module refines into market-facing messaging.

### The Flow

**3a. Press Release Generator (8 minutes)**

System pre-fills from Steps 1 & 2 and guides the PMM through Amazon's working-backwards format:

```
SYSTEM: "Let's write the press release your company would publish
         when this product/feature launches. This forces clarity on
         what matters most."

         I've pre-filled what I can from your ICP and competitive
         research. Edit and refine — your words matter here.

┌─────────────────────────────────────────────────────┐
│  INTERNAL PRESS RELEASE (DRAFT)                      │
│                                                       │
│  HEADLINE:                                            │
│  [Auto-generated: "[Company] Launches [Product] to    │
│   Help [ICP] [Solve Problem]"]                        │
│  → [Edit ✏️]                                          │
│                                                       │
│  SUB-HEADLINE:                                        │
│  [Auto-generated: one sentence on the key benefit,    │
│   informed by differentiation angles from Step 2]     │
│  → [Edit ✏️]                                          │
│                                                       │
│  OPENING PARAGRAPH:                                   │
│  [City, Date] — [Company] today announced [Product],  │
│  a [category] that helps [ICP persona] [key benefit]. │
│  [Product] addresses [specific problem from ICP       │
│  research] by [key capability], enabling [ICP] to     │
│  [desired outcome].                                   │
│  → [Edit ✏️ — all fields pre-filled from Steps 1-2]  │
│                                                       │
│  PROBLEM PARAGRAPH:                                   │
│  "Today, [ICP] struggles with [problem]. The current  │
│  approach — [current way from Step 1] — leads to      │
│  [consequences]. [Supporting data point]."             │
│  → [Edit ✏️]                                          │
│                                                       │
│  SOLUTION PARAGRAPH:                                  │
│  "[Product] solves this by [how it works]. Unlike      │
│  [competitors/status quo from Step 2], [Product]       │
│  [key differentiator]. This means [ICP] can now        │
│  [specific outcome]."                                  │
│  → [Edit ✏️]                                          │
│                                                       │
│  CUSTOMER QUOTE:                                      │
│  "[Hypothetical or real customer quote about the       │
│  problem and how the product solves it]"               │
│  → [Edit ✏️ or "I don't have a customer quote yet"]   │
│                                                       │
│  GETTING STARTED:                                     │
│  "[How customers can access/try the product.           │
│  Pricing. Availability.]"                              │
│  → [Edit ✏️]                                          │
└─────────────────────────────────────────────────────┘

💡 "If the press release is hard to write, the product
   isn't clear enough yet. That's the point of this
   exercise — to find the gaps before you launch."
```

**3b. FAQ Generator (5 minutes)**

System auto-generates FAQs from the PRFAQ + research, organized by audience:

```
INTERNAL FAQ (Auto-Generated — Edit as Needed)

CUSTOMER FAQs:
  Q: What is [Product]?
  A: [Auto-generated from press release]

  Q: How is this different from [Competitor A]?
  A: [Auto-generated from Step 2 differentiation angles]

  Q: How much does it cost?
  A: [Auto-generated from pricing page data]

  Q: Who is this for?
  A: [Auto-generated from Step 1 ICP]

INTERNAL / SALES FAQs:
  Q: Why are we building this?
  A: [Auto-generated from problem paragraph]

  Q: What's the competitive landscape?
  A: [Auto-generated from Step 2 competitive brief]

  Q: What's the TAM for this?
  A: [Auto-generated from Step 1 TAM sizing]

  Q: What's the launch timeline?
  A: [Placeholder — will be filled in Step 5]

  Q: How do we measure success?
  A: [Placeholder — will be filled in Step 5]

+ [Add your own FAQ]
```

**3c. PRFAQ Clarity Check (2 minutes)**

```
SYSTEM: "Let me check your PRFAQ for clarity issues."

  CLARITY SCORE: 78/100

  ✓ Problem is specific and quantified
  ✓ Solution clearly addresses the stated problem
  ⚠️ Differentiation could be sharper — your "unlike [competitors]"
     section sounds similar to Competitor A's own positioning.
     Recommend: lead with [specific unique capability] instead.
  ⚠️ Customer quote is hypothetical — flag to validate with a
     real customer before external launch
  ✓ Getting started section is clear

  "Your PRFAQ is solid. The positioning module (next step)
   will refine this into market-facing messaging."
```

### Step 3 Output
- Complete internal PRFAQ (press release + FAQ)
- Clarity score with specific improvement suggestions
- Crystallized problem statement, solution description, and differentiation
- Raw material that feeds directly into positioning

---

## Step 4: Positioning & Messaging (15 min)

### What It Does

Takes the raw material from Steps 1-3 (ICP, competitive landscape, PRFAQ) and refines it into a formal positioning framework and messaging hierarchy.

### The Flow

**4a. Positioning Anchors (3 minutes)**

```
SYSTEM: "Based on your research and PRFAQ, here are your
         positioning options."

  YOUR POSITIONING ANCHORS:
  ┌─────────────────────────────────────────────┐
  │ MARKET ELEMENTS         PRODUCT ELEMENTS     │
  │ (who/where/why)         (what/how)            │
  │                                              │
  │ ☑ Persona: [from ICP]   ☑ Category: [from web]│
  │ ☐ Company type           ☐ Capability          │
  │ ☐ Context/situation      ☐ Feature             │
  │ ☑ Problem: [from PRFAQ] ☐ Benefit             │
  └─────────────────────────────────────────────┘

  RECOMMENDED MVP POSITIONING (your H1/H2):

  Option A (Category + Persona):
  "[Product] is the [category] for [persona]"
  e.g., "Figma is the collaborative design tool for teams"

  Option B (Problem + Capability):
  "[Product] helps [persona] [solve problem] by [capability]"
  e.g., "Loom lets you record quick videos to explain anything"

  Option C (Outcome + Differentiator):
  "[Product] is the only [category] that [unique differentiator]"
  e.g., "Gong shows you what's actually working in your sales calls"

  → Pick one, or write your own
  → "Which of these would you say at a dinner party
     when someone asks what your company does?"
```

**4b. Message House Builder (7 minutes)**

```
SYSTEM: "Let's build your Message House."

  ┌─────────────────────────────────────────────┐
  │              POSITIONING ROOF                 │
  │  [Auto-filled from 4a — your chosen          │
  │   MVP positioning statement]                  │
  │  → [Edit ✏️]                                  │
  └──────────────────┬────────────────────────────┘
           ┌─────────┼─────────┐
     ┌─────▼─────┐ ┌─▼───────┐ ┌▼──────────┐
     │ PILLAR 1  │ │ PILLAR 2│ │ PILLAR 3  │
     │           │ │         │ │           │
     │ Value     │ │ Value   │ │ Value     │
     │ Prop:     │ │ Prop:   │ │ Prop:     │
     │ [auto]    │ │ [auto]  │ │ [auto]    │
     │           │ │         │ │           │
     │ Proof:    │ │ Proof:  │ │ Proof:    │
     │ [auto]    │ │ [auto]  │ │ [auto]    │
     │           │ │         │ │           │
     │ Customer  │ │ Cust.   │ │ Cust.     │
     │ Pain:     │ │ Pain:   │ │ Pain:     │
     │ [auto]    │ │ [auto]  │ │ [auto]    │
     └───────────┘ └─────────┘ └───────────┘

  Auto-filled from:
  → Value Props: PRFAQ solution paragraph + website extraction
  → Proof Points: from website (logos, metrics, testimonials)
  → Customer Pains: from ICP research (Step 1) + "current way"
  → Competitive contrast: from CI analysis (Step 2)

  Each pillar: [Edit all fields ✏️]

  💡 "Each pillar should pass the 'only we can say this' test.
     If a competitor could say the same thing, it's not
     differentiated enough."
```

**4c. Messaging Outputs (5 minutes)**

System auto-generates from the Message House:

```
YOUR MESSAGING KIT (Auto-Generated):

  ELEVATOR PITCHES:
  → 10-word: "[Product] helps [persona] [outcome]."
  → 30-word: [expanded with differentiator]
  → 100-word: [full story with proof points]

  PERSONA-SPECIFIC MESSAGING:
  → For [Buyer persona]: [pain-led, ROI-focused variant]
  → For [End user persona]: [capability-led, time-saving variant]

  COMPETITIVE MESSAGING:
  → vs [Competitor A]: "Unlike [A] which [weakness], we [strength]"
  → vs [Competitor B]: "Unlike [B] which [weakness], we [strength]"
  → vs Status Quo: "Instead of [current way], [Product] lets you..."

  HEADLINE VARIANTS (for A/B testing):
  → Variant 1: [category-anchor headline]
  → Variant 2: [problem-anchor headline]
  → Variant 3: [outcome-anchor headline]

  All ✏️ editable. All exportable.
```

### Step 4 Output
- Positioning statement (with chosen anchors)
- Message House (3 pillars with proof points)
- Elevator pitches (10/30/100 word)
- Persona-specific messaging variants
- Competitive messaging (vs each competitor + status quo)
- Headline variants for testing

---

## Step 5: GTM Launch Plan (10 min)

### What It Does

Takes everything from Steps 1-4 and generates an actionable launch plan — tiered, timestamped, with clear ownership and asset checklist.

### The Flow

**5a. Launch Tiering (2 minutes)**

```
SYSTEM: "Based on your PRFAQ and product context, here's my
         recommended launch tier:"

  ┌─────────────────────────────────────────────┐
  │ RECOMMENDED TIER: [Tier 2 — Significant]     │
  │                                              │
  │ Reasoning:                                    │
  │ → New feature (not new product) ← lower tier │
  │ → Affects core ICP ← higher tier              │
  │ → Has competitive differentiation ← higher    │
  │ → No pricing change ← lower tier              │
  │                                              │
  │ ○ Tier 1 — Flagship (press, events, everything)│
  │ ● Tier 2 — Significant (blog, email, social,   │
  │            enablement, limited paid)            │
  │ ○ Tier 3 — Standard (blog, email, in-product)  │
  │ ○ Tier 4 — Minor (release notes, community)    │
  │                                              │
  │ → [Accept] or [Change tier]                   │
  └─────────────────────────────────────────────┘
```

**5b. Launch Plan Generator (5 minutes)**

Auto-generates a complete plan based on selected tier:

```
YOUR LAUNCH PLAN: [Product/Feature Name]
Tier: [2 — Significant]
Launch Date: [User sets or "TBD"]

TIMELINE:
  T-6 weeks: ☐ Finalize positioning & messaging (done ✓ — Step 4)
  T-5 weeks: ☐ Brief sales team on positioning
  T-4 weeks: ☐ Create launch assets (see asset list below)
  T-3 weeks: ☐ Internal enablement (sales training)
  T-2 weeks: ☐ Seed launch with beta customers / early access
  T-1 week:  ☐ Final reviews, stakeholder sign-off
  T-0:       ☐ LAUNCH DAY
  T+1 week:  ☐ Monitor metrics, gather initial feedback
  T+2 weeks: ☐ Launch retrospective
  T+1 month: ☐ Post-launch performance review

STAKEHOLDER BRIEF:
  ┌──────────────────────────────────────────┐
  │ DECIDE: [PMM name — you]                  │
  │ INPUT:  [PM, Sales lead, Content lead]    │
  │ NOTIFY: [Exec team, CS, Support, Partners]│
  └──────────────────────────────────────────┘

ASSET CHECKLIST (Tier 2):
  ☐ Blog post (announcement)
  ☐ Email to customer base
  ☐ Social media posts (LinkedIn, X) — 3 variants
  ☐ Sales one-pager
  ☐ Updated battlecard (competitive section)
  ☐ Internal FAQ (already generated ✓ — from Step 3)
  ☐ Demo script / product walkthrough
  ☐ In-product notification
  ☐ Landing page update (optional)

NOT NEEDED FOR TIER 2:
  ✗ Press release / media outreach
  ✗ Event keynote
  ✗ Paid advertising campaign
  ✗ Analyst briefing
```

**5c. Metrics & Success Definition (3 minutes)**

```
SYSTEM: "How will you know if this launch succeeded?"

  RECOMMENDED METRICS (based on your tier + goals):

  LEADING INDICATORS (first 2 weeks):
  ☑ Blog post views / engagement
  ☑ Email open rate + click-through
  ☑ Sales enablement adoption (% of reps who viewed materials)
  ☑ Social media impressions + engagement

  LAGGING INDICATORS (30-90 days):
  ☑ Feature adoption rate among target ICP
  ☑ Pipeline influenced by launch content
  ☑ Competitive win rate change (if applicable)
  ☑ Customer feedback themes

  ANTI-METRICS (things NOT to track for this launch):
  ✗ Total revenue (too broad, too many variables)
  ✗ NPS change (too slow, too many factors)
  ✗ Number of assets created (vanity — tracks output, not impact)

  → [Customize metrics]
```

### Step 5 Output
- Launch tier with reasoning
- Complete timeline (T-6 weeks to T+1 month)
- Stakeholder map (DIN framework — Decide/Input/Notify)
- Asset checklist (tier-appropriate)
- Success metrics (leading + lagging + anti-metrics)

---

## The Final Output: One Exportable GTM Document

At the end of the 60-minute workflow, the PMM has a single, comprehensive document:

```
┌─────────────────────────────────────────────────────┐
│  GTM DOCUMENT: [Product/Feature Name]                │
│  Generated by PMMStudio — [Date]                     │
│                                                       │
│  1. ICP & MARKET SIZING                               │
│     → ICP definition with scorecard                   │
│     → Persona profiles (buyer + end user)             │
│     → "Current way" mapping                           │
│     → TAM/SAM/SOM (triangulated)                      │
│     → Trigger events                                  │
│                                                       │
│  2. COMPETITIVE LANDSCAPE                             │
│     → Top 3 competitors profiled                      │
│     → Status quo competitor mapped                    │
│     → Strengths/weaknesses per competitor              │
│     → Differentiation angles                          │
│     → Market maturity assessment                      │
│                                                       │
│  3. PRFAQ                                             │
│     → Internal press release                          │
│     → Customer FAQ                                    │
│     → Internal/Sales FAQ                              │
│     → Clarity score                                   │
│                                                       │
│  4. POSITIONING & MESSAGING                           │
│     → Positioning statement with anchors              │
│     → Message House (3 pillars + proof points)        │
│     → Elevator pitches (10/30/100 word)               │
│     → Persona-specific messaging                      │
│     → Competitive messaging                           │
│     → Headline variants for testing                   │
│                                                       │
│  5. GTM LAUNCH PLAN                                   │
│     → Launch tier + reasoning                         │
│     → Timeline (T-6 weeks to T+1 month)               │
│     → Stakeholder map (DIN)                           │
│     → Asset checklist                                 │
│     → Success metrics (leading + lagging)             │
│                                                       │
│  [Export as Notion Page]                               │
│  [Export as Google Doc]                                │
│  [Download as PDF]                                    │
│  [Copy to Clipboard]                                  │
└─────────────────────────────────────────────────────┘
```

---

## What V1 Does NOT Include

| Not in V1 | Why | When It Ships |
|---|---|---|
| Content generation (LinkedIn posts, blogs) | Separate product surface, not core GTM workflow | V3 |
| Sales enablement assets (battlecards, talk tracks) | Can be generated FROM the GTM doc, but V1 focuses on the strategy | V3 |
| Signal activation (intent data) | Requires integrations not in V1 | V4 |
| Pricing strategy | Complex, requires deep data | V4 |
| Team collaboration | V1 is single-player | V2 |
| Deep integrations (CRM, Gong, Amplitude) | V1 uses only website scraping + public data (G2) | V2-V3 |
| Custom frameworks | V1 uses opinionated defaults | V2 |
| Proposal/RFP generation | Separate workflow | V4 |
| Narrative agent | The PRFAQ covers the core narrative need in V1 | V3 |
| Agent marketplace | Wayyyy later | V5+ |

---

## Technical Architecture (V1 — Keep It Simple)

```
┌─────────────────────────────────────────────┐
│  FRONTEND: Next.js / React web app           │
│  Single-page guided workflow                 │
│  Markdown export (Notion, Google Docs, PDF)  │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│  BACKEND: Node.js / Python API               │
│                                              │
│  ┌──────────────────────────────────────┐    │
│  │  CONTEXT LAYER (lightweight V1)      │    │
│  │  - Company context (from onboarding) │    │
│  │  - Product context (from URL scrape) │    │
│  │  - Competitive context (from G2/web) │    │
│  │  - Session state (workflow progress) │    │
│  │  Stored: PostgreSQL + Redis cache    │    │
│  └──────────────────────────────────────┘    │
│                                              │
│  ┌──────────────────────────────────────┐    │
│  │  MODULES (not "agents" in V1)        │    │
│  │  1. Research Module                  │    │
│  │  2. CI Module                        │    │
│  │  3. PRFAQ Module                     │    │
│  │  4. Positioning Module               │    │
│  │  5. GTM Plan Module                  │    │
│  │                                      │    │
│  │  Each module:                        │    │
│  │  - Reads context layer               │    │
│  │  - Calls LLM (Claude API) with       │    │
│  │    structured prompts + context      │    │
│  │  - Writes output back to context     │    │
│  │  - Passes context to next module     │    │
│  └──────────────────────────────────────┘    │
│                                              │
│  ┌──────────────────────────────────────┐    │
│  │  ENRICHMENT SERVICES                 │    │
│  │  - Website scraper (Firecrawl/Jina)  │    │
│  │  - G2 review data (API or scraping)  │    │
│  │  - Competitor pricing extraction     │    │
│  │  - TAM data (LinkedIn/Crunchbase)    │    │
│  └──────────────────────────────────────┘    │
│                                              │
│  LLM: Claude API (Sonnet for speed,         │
│        Opus for complex analysis)            │
└──────────────────────────────────────────────┘
```

### Tech Stack (Lean)

| Layer | Choice | Why |
|---|---|---|
| Frontend | Next.js + Tailwind | Fast, modern, good DX |
| Backend | Python (FastAPI) | Best LLM ecosystem, fast development |
| Database | PostgreSQL + Redis | Reliable, handles context storage |
| LLM | Claude API (Anthropic) | Best for structured analysis and writing |
| Website scraping | Firecrawl or Jina Reader | Reliable, handles JS rendering |
| Hosting | Vercel (frontend) + Railway/Render (backend) | Simple, scales later |
| Auth | Clerk or Supabase Auth | Fast to implement |
| Payments | Stripe | Standard |
| Export | Notion API + Google Docs API + PDF generation | Core export formats |

---

## Pricing (V1)

| Tier | Price | What You Get |
|---|---|---|
| **Free** | $0 | 1 complete GTM project. Full workflow. Export as PDF. |
| **Pro** | $39/month | Unlimited GTM projects. All export formats (Notion, Google Docs, PDF). Saved context (iterate on projects over time). Competitive monitoring alerts (basic — weekly digest). |

**Why Free tier matters:** ChatPRD got 100K users with a generous free tier. The free GTM doc IS the marketing — if it's good, PMMs share it with their team, and the team upgrades.

---

## Success Metrics (For Us)

| Metric | Target (3 months post-launch) |
|---|---|
| Sign-ups | 5,000 free accounts |
| GTM docs generated | 10,000+ |
| Free-to-Pro conversion | 5-8% |
| Paid users | 250-400 |
| MRR | $10-16K |
| Completion rate (start → finish workflow) | >60% |
| NPS | >50 |
| Referral rate | >15% (users sharing with PMM peers) |

---

## Launch Plan (For PMMStudio Itself)

**Week 1-2:** Build core workflow (Research + CI modules)
**Week 3-4:** Build PRFAQ + Positioning modules
**Week 5-6:** Build GTM Plan module + export + auth + payments
**Week 7:** Internal testing, polish, bug fixes
**Week 8:** Launch

**Launch channels:**
1. Product Hunt (aim for top 5 — "The GTM Builder for PMMs")
2. PMA Slack community (95K members)
3. LinkedIn (PMM community — Mothi's network + GoPMM)
4. Sharebird community
5. r/productmarketing
6. Mothi's personal LinkedIn content (build in public)

**Launch messaging (using our own product!):**
> "I was tired of spending 6 weeks building GTM docs from scratch every time I launched something. So I built PMMStudio — a guided workflow that produces a complete ICP definition, competitive analysis, PRFAQ, positioning framework, and launch plan in 60 minutes. Try it free."

---

## Expansion Roadmap (Post-V1)

```
V1 (Now):       GTM Builder (Research + CI + PRFAQ + Positioning + GTM Plan)
                 → Single-player, one workflow, one output

V2 (Month 3):   + Saved context (iterate on projects over time)
                 + Team sharing (collaborate on GTM docs)
                 + Basic CI monitoring (weekly competitive digest)
                 + CRM integration (auto-enrich ICP from Salesforce/HubSpot)

V3 (Month 6):   + Content Generator (produce assets FROM the GTM plan)
                 + Sales Enablement (battlecards, talk tracks FROM positioning)
                 + Gong integration (customer language auto-enrichment)
                 + Persona module (standalone deep persona builder)

V4 (Month 9):   + Signal Activation (intent data → action routing)
                 + Pricing module (WTP analysis, packaging optimization)
                 + Proposal/RFP generator
                 + Narrative module (company-level story architecture)
                 + Launch metrics tracking

V5 (Month 12+): Full "PMMStudio" — the AI Studio for PMMs
                 + Deep integrations (full stack)
                 + Agent marketplace
                 + API
                 + Enterprise features (SSO, compliance)
```

**The 16-agent architecture we designed is the V5 destination. This PRD is V1 — the first step that proves the market.**

---

## Real-World Validation: How a PMM Actually Does This Today

### Case Study 1: Mothi's Personal Positioning Framework

Mothi Venkatesh (PMM, 4+ YOE) built his own positioning and messaging strategy using FletchPMM-style anchors — applied to HIMSELF as a product. This perfectly mirrors what PMMStudio V1 automates:

**What Mothi did manually → What PMMStudio V1 automates:**

| Mothi's Manual Step | PMMStudio V1 Equivalent | Time Saved |
|---|---|---|
| **Step 1: Choose primary anchors** (Category: "PMM with 4+ YOE", Use Case: "aligning decisions with market insights to position product uniquely", Alternative: "AI PMM") | **Step 4a: Positioning Anchors** — system presents market elements x product elements, recommends primary + secondary anchors | Manual: 2-3 hours of framework study + application. PMMStudio: 3 minutes guided selection |
| **Step 2: Choose secondary anchors** (Company: "B2B SaaS", Persona: "Senior PMM / Director") | **Step 1b: ICP Builder** — company type, buyer persona, end user defined with examples | Already part of the flow |
| **Step 3: Link problem to anchors** — defined the problem hiring managers face, wrote differentiator summary | **Step 3: PRFAQ** — problem paragraph auto-generated from ICP research + competitive gaps, differentiator from CI analysis | Manual: 3-4 hours of writing + reflection. PMMStudio: 8 minutes of guided editing |
| **Step 4: Build 3 differentiator pillars** with sub-problems, capabilities, and benefits for each | **Step 4b: Message House Builder** — 3 value pillars auto-generated from PRFAQ + CI + ICP, each with proof points, customer pain, and capabilities | Manual: 4-6 hours. PMMStudio: 7 minutes of review + editing |

**Mothi's framework structure maps 1:1 to PMMStudio's flow:**
```
Mothi's Framework:           PMMStudio V1:
Primary Anchors         →     Step 4a: Positioning Anchors
Secondary Anchors       →     Step 1b: ICP (company + persona)
Problem → Anchors       →     Step 3: PRFAQ (problem paragraph)
3 Differentiator Pillars →    Step 4b: Message House (3 pillars)
Capabilities + Benefits  →    Step 4b: Proof points per pillar
Elevator Pitch           →    Step 4c: Messaging Outputs
```

**Key insight from Mothi's work:** The best positioning starts with ANCHORS (what to lead with), then links PROBLEMS to those anchors, then builds PILLARS with capabilities + benefits. This is exactly FletchPMM's methodology — and exactly what PMMStudio V1 guides users through.

---

### Case Study 2: Mothi's KFS GTM (Real Product Launch)

Mothi executed a complete GTM motion for a Contract Lifecycle Management (CLM) product launching under an RBI regulatory mandate. This is the EXACT workflow PMMStudio V1 replaces:

**What Mothi did over 3 months → What PMMStudio V1 does in 60 minutes:**

| Phase | What Mothi Did Manually | PMMStudio V1 Equivalent |
|---|---|---|
| **ICP Discovery** | 1:1 problem discovery calls with existing + new customers. Identified 3 ICPs: Head of Digital Innovation, Head of Operations, Head of Technology | **Step 1b: ICP Builder** — guided ICP definition with buyer/champion/user roles. System would auto-suggest ICPs from CRM data if connected. |
| **Buyer Persona Matrix** | Built a matrix per persona: Top Challenge, Value Prop, Unique Benefit, Positioning, Buying Motivation — all differentiated per persona | **Step 1b → Step 4c:** Persona-specific messaging auto-generated. Each persona gets tailored value prop, positioning line, and buying motivation — derived from ICP research + competitive analysis. |
| **Cross-Functional Strategy** | Defined roles for PM, Account Management, PMM, CS, RevOps — who does what | **Step 5b: Launch Plan** — auto-generates DIN stakeholder map + RACI with role assignments |
| **Competitive Analysis** | Compared product capability against regulatory requirements and alternatives | **Step 2: CI Module** — auto-analyzes competitors, identifies differentiation angles, maps "current way" (manual compliance processes) |
| **Marketing Execution Plan** | 3-month Gantt chart: regulation deck, pitch deck, demo video, battlecards, training, email campaigns, WhatsApp campaigns, webinar, customer story | **Step 5b: Launch Plan** — auto-generates tiered asset checklist with timeline. For a Tier 1 regulatory launch like this, system would recommend all assets Mothi manually planned. |
| **Pitch Deck** | Built a 16-page narrative deck: Regulation context → Why comply → How Contract360 solves it → Language support → Demo | **Step 3: PRFAQ** generates the narrative structure (problem → solution → proof → CTA). Step 4 generates the messaging that goes INTO the deck. Deck creation itself is V3 (Content Generator). |
| **Results Tracking** | Tracked leads, demos, pipeline, closed deals, win/loss analysis | **Step 5c: Metrics** — auto-defines leading indicators (demos, engagement) + lagging indicators (pipeline, closed deals) + recommends win/loss analysis post-launch |

**What's striking:** Mothi's KFS launch followed our exact 5-step sequence — ICP research → competitive analysis → narrative/PRFAQ → positioning/messaging per persona → GTM execution plan. He just did it manually across Notion, Google Docs, spreadsheets, and pitch decks over 3 months. PMMStudio compresses this into a single guided session.

---

### Case Study 3: Mothi's Market Insight for MSME Credit Scoring

Mothi led strategic product validation for an alternative credit scoring product — using AI-powered market research to identify which data sources could assess thin-file MSME borrowers.

**What he did:** Used structured AI prompts to research alternative data factors (digital presence, transactional activity, regulatory compliance, fraud indicators) → categorized into a framework → validated with PM + credit analysts → built positioning → created narrative pitch deck → secured sandbox approval.

**PMMStudio V1 equivalent:**
- **Step 1c: TAM Sizing** — the MSME market research (64M MSMEs, $530B credit gap, 14% formal access) is exactly the kind of top-down TAM analysis our module auto-generates
- **Step 2: CI Module** — understanding "traditional credit scoring" as the "current way" and alternative data as the new approach is competitive/contextual differentiation
- **Step 3: PRFAQ** — the narrative arc (Market Gap → Problem → Case Study → Solution → Confidence Score → Sample Report) is a textbook PRFAQ structure
- **Step 4: Positioning** — "Enabling credit access for the underserved through inclusive, AI-powered credit assessment" is a classic positioning statement with category + problem + differentiator

**Key validation:** Even the most strategic PMM work — product validation, market insight, new category creation — follows the same Research → CI → PRFAQ → Position → Plan sequence. PMMStudio V1's workflow is universally applicable.

---

### Case Study 4: Mothi's MCC Classification Positioning at Signzy (Research-Led Positioning)

This is the most instructive case study — it shows how a PMM builds positioning for a complex B2B product by starting with deep research and competitive intelligence BEFORE writing a single line of messaging. Exactly the workflow PMMStudio V1 enforces.

**The Context:**
RBI tightened scrutiny on merchant aggregators and PSPs over MCC (Merchant Category Code) misuse — penalties, advisories, license suspensions. Signzy had 5 APIs (GST to MCC, WebCrawler, ShopLens AI, MSME Alt Data, Transaction Monitoring) that needed a clear positioning story for lenders.

**What Mothi did → What PMMStudio V1 automates:**

**Step 1: Research & Insights (PMMStudio Steps 1 + 2)**

Mothi organized his research into three branches — this maps perfectly to our Research + CI modules:

| Mothi's Research Branch | What He Found | PMMStudio Module |
|---|---|---|
| **Regulatory Signals** | RBI advisories put MCC governance under spotlight. Industry commentary (Ram Rastogi) highlighted misclassification as systemic non-compliance. | **Step 1: Research** — auto-detects regulatory triggers, industry signals, market shifts from news + analyst sources |
| **Competitive Landscape** | Existing solutions were fragmented — limited to GST checks or manual review teams. No competitor offered full lifecycle automated MCC governance. | **Step 2: CI** — auto-maps competitors, identifies "current way" (manual checks + fragmented tools), detects whitespace |
| **Customer Discovery** | Compliance heads cited over-reliance on merchant self-declaration as top risk. Banks flagged limited visibility into post-onboarding merchant behavior. | **Step 1: Research** — synthesizes customer pain points. Plus a real Head of Compliance quote about MCC codes being wrong after regulation change. |

**Key insight from this case:** Mothi's research revealed that the product positioning needed to bifurcate APIs into "pre-onboarding" vs "post-onboarding" use cases — and further into "GST" vs "non-GST" merchants. This insight came from a PM-PMM conversation where Mothi brought compliance research and the PM brought the technical API structure. **PMMStudio's Research module should surface exactly these kinds of structural insights — not just pain points, but how to ORGANIZE the product's positioning architecture.**

**Step 2: Positioning Framework (PMMStudio Step 4)**

From the research, Mothi built:

| Mothi's Positioning Element | What He Created | PMMStudio Equivalent |
|---|---|---|
| **Positioning Statement** | "For merchant aggregators and PSPs facing regulatory risk, Signzy's MCC Classification & Onboarding Suite delivers compliant onboarding and continuous merchant monitoring. Unlike manual checks or fragmented tools, it provides end-to-end, AI-powered MCC governance." | **Step 4a: Positioning Anchors** — Persona anchor (aggregators/PSPs) + Problem anchor (regulatory risk) + Category anchor (MCC Classification Suite) + Differentiation (end-to-end vs fragmented) |
| **Positioning Line** | "Automate MCC mapping and monitoring across the merchant lifecycle with audit-ready assurance." | **Step 4c: Elevator Pitches** — 10/30/100 word variants auto-generated from Message House |

**Step 3: Persona-Specific Messaging (PMMStudio Step 4b-4c)**

This is where the case study is most valuable. Mothi built a 4-persona messaging matrix:

| Persona | Pain Point | Message | Proof Point |
|---|---|---|---|
| Head of Compliance | Risk of fines, license suspension | "Stay audit-ready. Eliminate MCC errors before regulators find them." | End-to-end MCC suite, automated audit-ready reports |
| Risk & Fraud Teams | False positives, missed fraud | "Catch hidden high-risk merchants early." | AI-driven anomaly detection, category drift alerts |
| Business/Onboarding Teams | Slow onboarding, manual checks | "Frictionless onboarding at scale — without cutting compliance corners." | 2x faster onboarding, GST to MCC instant mapping |
| CXOs | Profitability erosion from MDR mispricing | "Protect your margins by stopping MCC arbitrage." | Monitoring tools that prevent MDR leakage |

**This is exactly PMMStudio Step 4c's "Persona-Specific Messaging" output** — but Mothi built it manually over days. PMMStudio auto-generates this matrix from the ICP personas (Step 1) + competitive differentiation (Step 2) + positioning pillars (Step 4b).

**Step 4: Results & Impact (PMMStudio Step 5c: Metrics)**

After rolling out the positioning:
- Sales moved from feature pitching to compliance-first conversations
- Prospects acknowledged Signzy as the only full MCC lifecycle solution
- Thought leadership aligned with regulatory concerns (credibility)
- Deal cycles shortened — compliance-first positioning addressed the #1 pain upfront

**PMMStudio Step 5c: Metrics** would define these as success metrics BEFORE launch: "sales adoption of new messaging" (leading indicator), "prospect perception shift" (leading), "deal cycle length" (lagging), "competitive positioning recognition" (lagging).

---

**Why this case study matters most for PMMStudio V1:**

This is the hardest PMM problem — a complex B2B product with multiple APIs, multiple personas, regulatory urgency, and no existing market category ("MCC governance suite" didn't exist as a term before Mothi positioned it).

If PMMStudio V1 can guide a PMM through THIS level of complexity and produce output THIS structured, it proves the product works for any B2B positioning challenge. The simpler cases (basic SaaS feature launch, startup positioning) become easy.

The workflow Mothi followed:
```
Research (regulatory + competitive + customer)
    ↓
Structural insight (pre/post onboarding × GST/non-GST)
    ↓
Positioning statement (persona + problem + solution + differentiator)
    ↓
Positioning line (one-line summary)
    ↓
Persona-specific messaging matrix (4 personas × pain/message/proof)
    ↓
GTM impact (sales adoption, market traction, deal acceleration)
```

This IS PMMStudio V1's flow: Research → CI → PRFAQ → Positioning → GTM Plan.

---

### What These Case Studies Prove

1. **The workflow is real.** Four different PMM projects (personal positioning, regulatory product launch, market validation, complex B2B product positioning) all follow the same Research → CI → Position → Message → GTM sequence. We didn't invent this workflow — we observed it in practice across multiple contexts.

2. **The pain is real.** Each project took weeks-to-months of manual work across 5+ tools. PMMStudio compresses this without sacrificing quality.

3. **The methodology works.** FletchPMM anchors, persona-specific messaging matrices, PRFAQ narrative structures, competitive landscape mapping, tiered launch plans — these are exactly what practitioners use. PMMStudio just makes them executable at machine speed.

4. **The output format matches.** The deliverables (ICP scorecard, competitive brief, persona matrix, positioning statement, message house, GTM execution plan) map 1:1 to PMMStudio V1's output document.

5. **Complexity is handled.** Case Study 4 (MCC at Signzy) proves the workflow handles complex B2B products with multiple APIs, multiple personas, regulatory drivers, and category creation — not just simple SaaS launches. If it works for this, it works for anything.

6. **Research + CI MUST come before positioning.** Every case study confirms: the PMM who skips research and CI produces generic positioning. Mothi's best work (MCC, KFS, MSME Credit) all started with deep market + competitive + customer research. PMMStudio V1's 5-step sequence enforces this — you literally cannot get to Step 4 (Positioning) without completing Steps 1-2 (Research + CI).

---

## Ideal User Profiles

### Profile 1: "Mothi" — The Mid-Level PMM at a Growth-Stage B2B Company

| Attribute | Detail |
|---|---|
| **Title** | PMM / Senior PMM (3-6 YOE) |
| **Company** | B2B SaaS, fintech, or enterprise software. 50-500 employees. Series A-C. |
| **Team** | Solo PMM or 2-3 person team. Reports to Head of Marketing or VP Product. |
| **Products** | Supports 2-4 products or feature areas. Complex, technical products (APIs, platforms, compliance tools). |
| **Day-to-day** | Juggles positioning, launches, enablement, CI, and content — all at once, with no dedicated help for any of them. |
| **Skills** | Strong strategic thinker. Knows FletchPMM/Dunford frameworks. Can build a persona matrix and positioning statement. But the EXECUTION eats all their time. |
| **Current tools** | Google Docs, Notion, ChatGPT (for drafts), Google (for research), spreadsheets (for tracking). No Klue, no Gong, no Highspot. |
| **Core frustration** | "I know HOW to do great positioning. I just don't have TIME to do the research, CI, and synthesis that makes it great. So I cut corners, and the output suffers." |
| **What PMMStudio gives them** | The research + CI + synthesis done in 20 minutes instead of 2 weeks. So they can spend their time on the STRATEGIC decisions (which anchors to lead with, which persona to prioritize) rather than the mechanical work (scraping competitor websites, reading G2 reviews, building comparison tables). |
| **Willingness to pay** | $39/mo without blinking. This replaces 20+ hours/month of manual work. |
| **How they find us** | LinkedIn PMM community, PMA Slack, Sharebird, colleague recommendation. |

### Profile 2: "Sarah" — The First PMM Hire at a Startup

| Attribute | Detail |
|---|---|
| **Title** | PMM / Product Marketing Manager (1-3 YOE) or first marketing hire wearing the PMM hat |
| **Company** | Seed to Series A startup. 10-50 employees. Often first non-engineering marketing hire. |
| **Team** | Solo. No marketing team. Reports to CEO or Head of Product. |
| **Products** | Single product, early stage. May not have clear positioning yet. |
| **Day-to-day** | Everything. Website copy, sales deck, product launch, customer calls, content, social. "PMM" is 20% of the job; the other 80% is whatever the business needs. |
| **Skills** | Smart and scrappy, but may not have formal PMM training. Doesn't know FletchPMM anchors or PRFAQ format. Learns fast but doesn't know what "great" looks like yet. |
| **Current tools** | ChatGPT, Google Docs, Canva. Maybe a free Notion workspace. |
| **Core frustration** | "I don't even know where to START. Everyone has an opinion on our messaging but nobody has a framework. I need someone to show me what good looks like and walk me through it." |
| **What PMMStudio gives them** | The methodology + guided process + examples that turn a blank page into a complete GTM doc. PMMStudio is their PMM mentor in a box. |
| **Willingness to pay** | Free tier first. Converts to $39/mo after first GTM doc proves its value to the CEO. |
| **How they find us** | Product Hunt, Google search ("how to write positioning"), PMM communities, LinkedIn content. |

### Profile 3: "Marcus" — The PMM Director Scaling a Team

| Attribute | Detail |
|---|---|
| **Title** | Director / Head of Product Marketing (6-10 YOE) |
| **Company** | Growth to enterprise. 200-2000 employees. Multiple product lines. |
| **Team** | 3-8 PMMs. Needs consistency across the team's output. |
| **Products** | Multiple product lines (like mothi with Payments + Secure ID + Payouts). Each needs its own positioning, CI, and GTM plan. |
| **Day-to-day** | Reviews team's work, aligns with leadership, manages cross-functional stakeholders. Less hands-on execution, more strategy and quality control. |
| **Skills** | Expert PMM. Knows all frameworks. Problem isn't knowledge — it's SCALE. Can't review every positioning doc and GTM plan at the quality level they want. |
| **Current tools** | Confluence, Notion, Google Workspace, maybe Klue or Highspot. |
| **Core frustration** | "I have 6 PMMs and every one of them produces positioning docs differently. I need a standard process that ensures consistent quality without me reviewing every word." |
| **What PMMStudio gives them** | Standardized workflow for the team. Every PMM goes through the same 5-step process, produces the same structured output. Marcus reviews the strategic decisions, not the document structure. |
| **Willingness to pay** | $39/user/mo for team tier (V2). This is a team productivity tool, not a personal one. |
| **How they find us** | Their PMMs discover it individually → Marcus sees the output → buys it for the team. Bottom-up adoption. |

### Why "Mothi" Is the V1 Target

Profile 1 is our beachhead. Here's why:

| Factor | Why Mothi, Not Sarah or Marcus |
|---|---|
| **They know what good looks like** | Can evaluate PMMStudio's output quality. Sarah can't (yet). Marcus delegates. |
| **They'll use it immediately** | They have a positioning project THIS WEEK. Sarah may not. Marcus needs team features (V2). |
| **They'll pay quickly** | $39/mo is obvious ROI for someone doing this work weekly. Sarah needs to convince the CEO first. |
| **They'll tell their PMM friends** | Mid-level PMMs are the most active in communities (PMA, Sharebird, LinkedIn). They share tools that work. |
| **They'll upgrade to Team** | When Marcus sees the output, Mothi becomes the internal champion for a team purchase. |
| **Their pain is quantifiable** | "I spent 3 weeks on the MCC positioning project. PMMStudio would have done Step 1-2 in 20 minutes." |

---

## V1 Walkthrough: What PMMStudio Would Have Done for Mothi's MCC Project

This is the most concrete way to show what V1 actually produces. Let's walk through exactly what would happen if Mothi used PMMStudio for the Signzy MCC Classification positioning.

### Step 1: Research (10 min)

**Mothi pastes:** `signzy.com`

**Auto-extract (30 seconds):**
- Product: "Signzy — Digital onboarding and verification platform for regulated entities"
- Features detected: KYC, Video KYC, eSign, OCR, MCC Classification
- Audience: Banks, NBFCs, fintech, insurance
- GTM motion: Sales-led (enterprise)

**ICP Builder (5 min):**

```
SYSTEM: "Which product are you building a GTM for?"
  → [MCC Classification & Onboarding Suite]

SYSTEM: "Based on your website, your target audience for MCC
         is regulated financial institutions. Let me sharpen this."

  Company type: Merchant aggregators, PSPs, banks with merchant business
  Buyer persona: Head of Compliance / Head of Risk
  End user: Compliance teams, onboarding teams
  Current way: "Manual MCC review + GST-based checks + fragmented tools"
  Trigger: "RBI tightened scrutiny on MCC misuse — penalties and
            license suspensions"
```

**TAM auto-generated:**
```
  Bottom-up: ~200 merchant aggregators + ~50 PSPs + ~100 banks
             with merchant business × ₹10-50L ACV = ₹35-175Cr TAM
  Top-down: India RegTech market ₹5,000Cr (2025) × MCC governance
            slice (~2-3%) = ₹100-150Cr
  SOM: Top 50 aggregators + PSPs facing immediate regulatory
       pressure = ₹15-25Cr addressable NOW
```

### Step 2: CI (10 min)

**Auto-detected competitors:**
```
  DIRECT: None offering full lifecycle MCC governance
  FRAGMENTED: GST-checking APIs, manual review teams, basic MCC lookup tools
  STATUS QUO: "Merchant self-declaration + periodic manual audit"

  MARKET MATURITY: EARLY → Contextual differentiation mode
  "Your real competitor is the status quo (manual checks + fragmented
   tools), not another product. Lead with: 'There's a better way to
   handle MCC governance end-to-end.'"

  KEY INSIGHT: No competitor offers a full lifecycle, automated MCC
  governance suite. This is a WHITESPACE opportunity.

  DIFFERENTIATION ANGLES:
  1. End-to-end (pre + post onboarding) vs. point solutions
  2. AI-powered vs. manual review
  3. Audit-ready reporting vs. ad-hoc compliance
```

### Step 3: PRFAQ (15 min)

**Auto-generated press release (pre-filled from Steps 1-2):**

```
HEADLINE: "Signzy Launches MCC Classification & Onboarding Suite
           to Help Merchant Aggregators Eliminate Regulatory Risk"

PROBLEM: "In 2025, the RBI tightened scrutiny on MCC misuse,
          resulting in penalties, advisories, and license suspensions
          for merchant aggregators and PSPs. Existing solutions are
          fragmented — limited to GST checks or manual review teams —
          leaving institutions exposed to compliance risk."

SOLUTION: "Signzy's MCC Classification & Onboarding Suite delivers
           end-to-end, AI-powered MCC governance — from onboarding
           to continuous monitoring. Five integrated APIs (GST to MCC,
           WebCrawler, ShopLens AI, MSME Alt Data, Transaction
           Monitoring) provide automated classification, anomaly
           detection, and audit-ready reporting."

CUSTOMER QUOTE: [Flagged as needs real quote — suggests using the
                 Pine Labs Head of Compliance quote from research]

FAQ auto-generated:
  Q: "What makes this different from existing MCC tools?"
  A: "Unlike fragmented solutions that only handle GST-based
      classification, Signzy provides full lifecycle coverage..."
```

### Step 4: Positioning (15 min)

**Positioning anchors recommended:**

```
  Primary: Problem Anchor (regulatory risk) + Category Anchor
           (MCC Classification Suite)
  Secondary: Persona Anchor (aggregators/PSPs) + Capability Anchor
             (end-to-end AI governance)

  MVP POSITIONING:
  "Signzy's MCC Classification Suite automates MCC mapping and
   monitoring across the merchant lifecycle with audit-ready assurance."

  MESSAGE HOUSE:
  ┌─────────────────────────────────────────────────────┐
  │ "End-to-end, AI-powered MCC governance for          │
  │  regulated entities"                                 │
  └───────────────────┬─────────────────────────────────┘
        ┌─────────────┼─────────────┐
   ┌────▼────┐   ┌────▼────┐   ┌───▼─────┐
   │ PILLAR 1│   │ PILLAR 2│   │ PILLAR 3│
   │ Audit-  │   │ Fraud   │   │ Scale   │
   │ Ready   │   │ Defense │   │ Without │
   │ Compli- │   │         │   │ Friction│
   │ ance    │   │         │   │         │
   │         │   │         │   │         │
   │ Auto    │   │ AI      │   │ 2x      │
   │ reports │   │ anomaly │   │ faster  │
   │         │   │ detect  │   │ onboard │
   └─────────┘   └─────────┘   └─────────┘
```

**Persona-specific messaging auto-generated:**

```
  HEAD OF COMPLIANCE:
  Pain: Risk of fines, license suspension
  Message: "Stay audit-ready. Eliminate MCC errors before
            regulators find them."
  Proof: End-to-end MCC suite, automated audit-ready reports

  RISK & FRAUD TEAMS:
  Pain: False positives, missed fraud
  Message: "Catch hidden high-risk merchants early."
  Proof: AI-driven anomaly detection, category drift alerts

  BUSINESS/ONBOARDING:
  Pain: Slow onboarding, manual checks
  Message: "Frictionless onboarding at scale — without cutting
            compliance corners."
  Proof: 2x faster onboarding, GST to MCC instant mapping

  CXOs:
  Pain: MDR mispricing, margin erosion
  Message: "Protect your margins by stopping MCC arbitrage."
  Proof: Monitoring tools that prevent MDR leakage
```

**This output matches Mothi's actual messaging matrix almost exactly** — because it's derived from the same research and competitive analysis using the same methodology.

### Step 5: GTM Plan (10 min)

```
  TIER: Tier 1 — Flagship
  Reasoning: New product suite + regulatory urgency + whitespace
             opportunity + multiple personas

  TIMELINE:
  T-6: Positioning + messaging (done ✓)
  T-5: Brief sales team on compliance-first positioning
  T-4: Create assets (pitch deck, battlecards, demo video,
       regulation change deck)
  T-3: Sales training (compliance-first conversations)
  T-2: Customer outreach (existing clients via Email + WhatsApp)
  T-1: Webinar prep (partner with industry body — e.g., FACE)
  T-0: LAUNCH
  T+2: Customer success story (Ashva Finance)
  T+4: Win/loss analysis

  STAKEHOLDERS (DIN):
  Decide: PMM (Mothi)
  Input: PM, Sales lead, Compliance SME
  Notify: CS, Support, RevOps

  ASSET CHECKLIST (Tier 1):
  ☐ Regulation change deck
  ☐ Sales pitch deck
  ☐ Internal + external demo video
  ☐ Battle cards
  ☐ F2F sales training
  ☐ Email campaign sequence (3-month)
  ☐ WhatsApp campaign sequence
  ☐ Webinar with industry partner
  ☐ Customer success story
  ☐ One-pager per persona

  METRICS:
  Leading: Qualified leads from webinar + outreach, demos completed,
           sales adoption of new messaging
  Lagging: Pipeline ARR, deals closed, competitive win rate,
           deal cycle length change
```

### The Comparison

| What Mothi Did Manually | Time | What PMMStudio V1 Produces | Time |
|---|---|---|---|
| Research: regulatory signals, competitive landscape, customer discovery (1:1 calls with compliance heads) | 2-3 weeks | Step 1 + 2: Auto-research from web + G2 + regulatory sources, structured into 3 branches | 20 min |
| PRFAQ / narrative (problem framing, solution description) | 3-5 days | Step 3: Auto-generated from research, editable | 15 min |
| Positioning statement + positioning line | 2-3 days | Step 4a: Anchors recommended, statement generated | 3 min |
| Persona messaging matrix (4 personas × pain/message/proof) | 3-5 days | Step 4c: Auto-generated from ICP + CI + positioning | 5 min |
| GTM execution plan (3-month timeline, asset checklist) | 1 week | Step 5: Auto-tiered plan with timeline + assets + metrics | 10 min |
| **TOTAL** | **4-6 weeks** | **TOTAL** | **~55 min** |

**The quality gap:** PMMStudio's output is a strong FIRST DRAFT — probably 70-80% of what Mothi produced manually. The remaining 20-30% (the Pine Labs compliance head quote, the PM-PMM conversation about pre/post onboarding bifurcation, the nuanced industry body relationship for the webinar) comes from the PMM's domain expertise and relationships. PMMStudio handles the mechanical research and synthesis; the PMM adds the strategic judgment and human context.

**That's the value prop:** Not "PMMStudio replaces PMMs." It's "PMMStudio gives PMMs back 80% of their time so they can spend it on the 20% that only humans can do — customer relationships, strategic judgment, cross-functional influence."
