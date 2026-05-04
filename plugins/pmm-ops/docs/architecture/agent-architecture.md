# PMMStudio: Production-Ready Agent Architecture

**Version:** 1.0
**Date:** April 9, 2026
**Standard:** Harvey.ai / Notion Agents level production readiness

---

## The Org Chart Model: Agents as a Virtual PMM Team

PMMStudio's agent architecture mirrors how the best PMM organizations are actually structured. Inspired by Pi.dev's agent-as-employee model and real PMM org design (mothi, Atlassian, Shopify), agents are organized like a high-performing PMM team — with a clear reporting structure, defined charters, and cross-functional collaboration.

### The Virtual PMM Org Chart

```
                        ┌─────────────────────┐
                        │    HEAD OF PMM       │
                        │   (The PMM / User)   │
                        │                      │
                        │  Sets strategy,       │
                        │  approves outputs,    │
                        │  configures guardrails│
                        └──────────┬────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
         ┌──────────▼───┐  ┌──────▼──────┐  ┌───▼──────────┐
         │  STRATEGY     │  │ INTELLIGENCE│  │  ACTIVATION  │
         │  LAYER        │  │ LAYER       │  │  LAYER       │
         │  (VP-level)   │  │ (Director)  │  │  (Director)  │
         └──────┬────────┘  └──────┬──────┘  └──────┬───────┘
                │                  │                 │
    ┌───────────┼──────┐    ┌──────┼──────┐    ┌────┼────────────┐
    │           │      │    │      │      │    │    │    │       │
┌───▼──┐  ┌────▼─┐ ┌──▼─┐ ┌▼────┐┌▼────┐┌▼──┐┌▼──┐┌▼──┐┌▼───┐┌▼───┐
│Posit-│  │Narra-│ │Pric│ │Rese-││CI   ││Per-││Con-││Sale││Prop││RFP │
│ioning│  │tive  │ │ing │ │arch ││Agent││sona││tent││s En││osal││Auto│
│Agent │  │Agent │ │Agt │ │Agent││     ││Agt ││Wkfl││able││Gen ││    │
└──────┘  └──────┘ └────┘ └─────┘└─────┘└────┘└────┘└────┘└────┘└────┘

         ┌──────────────────────────────────────────────┐
         │              OPERATIONAL LAYER                │
         │            (Cross-Functional)                 │
         │                                              │
         │  ┌────────┐  ┌──────────┐  ┌──────────┐     │
         │  │Launch  │  │Metrics & │  │Alignment │     │
         │  │Planning│  │Attribut. │  │Agent     │     │
         │  │Agent   │  │Agent     │  │          │     │
         │  └────────┘  └──────────┘  └──────────┘     │
         └──────────────────────────────────────────────┘

         ┌──────────────────────────────────────────────┐
         │            INFRASTRUCTURE LAYER               │
         │                                              │
         │         ┌──────────────────┐                 │
         │         │  Context Engine  │                 │
         │         │  + Company KB    │                 │
         │         │  + Product KB(s) │                 │
         │         │  + Signal Agent  │                 │
         │         └──────────────────┘                 │
         └──────────────────────────────────────────────┘
```

### How This Maps to Real PMM Org Structure

A real PMM team (like the mothi PMM org) is structured with:
- **Product Pods** (vertical): Each PMM owns 1-2 products — handles positioning, launches, enablement for their product
- **Functional Pods** (horizontal): Cross-cutting functions like sales enablement, research, product comms that serve all product pods

PMMStudio mirrors this exactly:

| Real PMM Org | PMMStudio Equivalent | How It Works |
|---|---|---|
| **Head of PMM** | The Human User | Sets strategy, approves outputs, configures guardrails |
| **Senior PMMs (pod leads)** | Strategy Layer agents | Positioning, Narrative, Pricing — each "owns" a strategic domain |
| **Intelligence team** | Intelligence Layer agents | Research, CI, Persona — gather and maintain knowledge |
| **Activation team** | Activation Layer agents | Content, Sales Enablement, Proposals, RFP — produce outbound assets |
| **Operations/GTM** | Operational Layer agents | Launch Planning, Metrics, Alignment — coordinate execution |
| **Infrastructure/Ops** | Infrastructure Layer | Context Engine, Company KB, Product KB, Signal Agent — the backbone |

### Product Pods in PMMStudio

For **multi-product companies**, agents are scoped per product — just like real PMM pods:

```
PRODUCT POD: "Payments"              PRODUCT POD: "Secure ID"
┌────────────────────────┐           ┌────────────────────────┐
│ Product KB: Payments   │           │ Product KB: Secure ID  │
│                        │           │                        │
│ Positioning Agent      │           │ Positioning Agent      │
│  → Payments messaging  │           │  → SecureID messaging  │
│                        │           │                        │
│ CI Agent               │           │ CI Agent               │
│  → Stripe, Razorpay    │           │  → Hyperverge, IDfy    │
│                        │           │                        │
│ Launch Agent           │           │ Launch Agent           │
│  → UPI feature launch  │           │  → CKYC launch         │
│                        │           │                        │
│ Persona Agent          │           │ Persona Agent          │
│  → Merchant personas   │           │  → Compliance personas │
└────────────────────────┘           └────────────────────────┘
            │                                    │
            └──────────┬─────────────────────────┘
                       │
              SHARED LAYERS (cross-pod)
              ┌────────────────────────┐
              │ Company KB (mothi)  │
              │ Content Agent (shared) │
              │ Metrics Agent (shared) │
              │ Alignment Agent (shared│
              │ Narrative Agent (shared│
              │   → company narrative) │
              └────────────────────────┘
```

**Some agents run per-product-pod** (Positioning, CI, Launch, Persona — because each product has unique positioning, competitors, personas, and launch plans).

**Some agents run cross-pod** (Content, Metrics, Alignment, Narrative — because brand voice, measurement, stakeholder comms, and company story are shared).

**The PMM (Head of PMM) configures which mode each agent runs in.**

### Agent Seniority Model (Inspired by Pi.dev)

Just like employees have seniority levels that determine autonomy, agents have **earned autonomy levels** that increase over time:

```
LEVEL 1: NEW HIRE (Week 1-4)
  ● Everything is draft — human reviews all outputs
  ● Agent asks lots of clarifying questions
  ● Learning loop is in "absorb" mode — collecting patterns
  ● Confidence thresholds are set high (>85% for auto-actions)
  ● All T2 actions require approval

LEVEL 2: RAMPED (Month 2-3)
  ● Routine outputs auto-approved (e.g., weekly CI digest)
  ● Agent proactively suggests actions based on patterns
  ● Learning loop starts making recommendations
  ● Confidence threshold relaxes to >75% for auto-actions
  ● Some T2 actions auto-approved based on PMM configuration

LEVEL 3: TRUSTED (Month 4-6)
  ● Agent runs most workflows autonomously
  ● PMM reviews exceptions, not every output
  ● Agent detects and flags its own uncertainty
  ● Learning loop is mature — agent "knows" what this PMM prefers
  ● T2 auto-approved for established patterns
  ● PMM spends time on strategy, agent handles execution

LEVEL 4: SENIOR (Month 6+)
  ● Agent anticipates needs before PMM asks
  ● Chains run end-to-end with minimal human intervention
  ● Agent recommends strategic shifts (not just tactical execution)
  ● PMM functions as a true "Head of PMM" — reviewing agent work
    the way a VP reviews their team's work
  ● Only T3 (external) and novel/high-stakes actions need approval
```

**Level progression is earned, not automatic.** An agent only moves up when:
- Human approval rate exceeds 80% (outputs are consistently good)
- Average edits per output are declining (agent is learning PMM preferences)
- No hard guardrail violations in the last 30 days
- PMM explicitly approves the autonomy upgrade ("Yes, I trust the CI Agent to auto-post the weekly digest to Slack")

### The Weekly "Team Standup" (Agent Coordination)

Like a real PMM team standup, PMMStudio runs a weekly coordination cycle:

```
MONDAY: AGENT STANDUP (auto-generated, PMM reviews)
┌─────────────────────────────────────────────────┐
│  PMMSTUDIO WEEKLY BRIEF — Week of April 14      │
│                                                   │
│  INTELLIGENCE LAYER:                              │
│  ├─ CI Agent: 3 competitive changes detected      │
│  │  → [Competitor X pricing drop] HIGH IMPACT     │
│  │  → [Competitor Y new feature] MEDIUM           │
│  │  → [Competitor Z blog post] LOW                │
│  ├─ Research Agent: 12 Gong calls processed       │
│  │  → New pain point emerging: "data latency"     │
│  ├─ Persona Agent: 2 personas enriched            │
│  │  → "Data Engineer" persona freshness: 95%      │
│  │  → "VP Data" persona freshness: 67% ⚠️         │
│  ├─ Signal Agent: 5 high-intent accounts          │
│  │  → 2 new, 3 recurring                         │
│  │                                                │
│  STRATEGY LAYER:                                  │
│  ├─ Positioning Agent: Messaging still valid ✓    │
│  │  → But recommend addressing Competitor X       │
│  │     pricing in value messaging                 │
│  ├─ Narrative Agent: No inconsistencies ✓         │
│  ├─ Pricing Agent: Competitor price drop may      │
│  │  require packaging response — analysis ready   │
│  │                                                │
│  ACTIVATION LAYER:                                │
│  ├─ Content Agent: 4 posts queued for approval    │
│  ├─ Sales Enablement: Battlecard updated (draft)  │
│  ├─ Proposal Agent: 2 proposals in pipeline       │
│  │                                                │
│  OPERATIONAL LAYER:                               │
│  ├─ Launch Agent: CKYC launch on track (T-8 days) │
│  ├─ Metrics Agent: Win rate up 3% vs last month   │
│  ├─ Alignment Agent: Weekly updates sent to Sales  │
│  │                                                │
│  YOUR TOP 3 ACTIONS THIS WEEK:                    │
│  1. Review Competitor X pricing response plan      │
│  2. Approve updated battlecard                     │
│  3. Schedule VP Data persona refresh interviews    │
└─────────────────────────────────────────────────┘
```

### Why Org-Chart Architecture Matters

| Without Org Structure | With Org Structure |
|---|---|
| 15 agents feel like 15 separate tools | 15 agents feel like a coordinated team |
| PMM has to manually route work between agents | Agents route work to each other like team members |
| No clear hierarchy of what's strategic vs tactical | Strategy → Intelligence → Activation → Operations layers are clear |
| Multi-product = chaos | Product pods keep each product's context clean |
| Agent autonomy is binary (on/off) | Earned autonomy model mirrors real team trust-building |
| No coordination rhythm | Weekly standup keeps everything visible and prioritized |

---

## Architecture Principles

### 1. Every Agent Is a First-Class System

Each agent is NOT a prompt wrapper. Each agent is a complete system with:
- **Defined task scope** — what it can and cannot do
- **Tool access** — which APIs, data sources, and external systems it can read/write
- **Permission model** — what actions require human approval vs auto-execute
- **Guardrails** — hard boundaries that cannot be overridden
- **State management** — persistent memory, session state, and execution history
- **Learning loop** — how it improves over time from feedback and outcomes
- **Error handling** — what happens when things go wrong
- **Observability** — logging, tracing, and auditability of every action

### 2. The Agent Execution Model

```
┌──────────────────────────────────────────────────────┐
│                   ORCHESTRATION LAYER                  │
│  Routes tasks, manages dependencies, handles chaining │
└──────────────┬───────────────────────┬────────────────┘
               │                       │
    ┌──────────▼──────────┐ ┌──────────▼──────────┐
    │    AGENT RUNTIME     │ │    AGENT RUNTIME     │
    │ ┌──────────────────┐ │ │ ┌──────────────────┐ │
    │ │  Task Planner    │ │ │ │  Task Planner    │ │
    │ │  (decomposes     │ │ │ │  (decomposes     │ │
    │ │   goal → steps)  │ │ │ │   goal → steps)  │ │
    │ ├──────────────────┤ │ │ ├──────────────────┤ │
    │ │  Tool Executor   │ │ │ │  Tool Executor   │ │
    │ │  (calls tools    │ │ │ │  (calls tools    │ │
    │ │   within scope)  │ │ │ │   within scope)  │ │
    │ ├──────────────────┤ │ │ ├──────────────────┤ │
    │ │  State Manager   │ │ │ │  State Manager   │ │
    │ │  (persists work  │ │ │ │  (persists work  │ │
    │ │   across sessions│ │ │ │   across sessions│ │
    │ ├──────────────────┤ │ │ ├──────────────────┤ │
    │ │  Guard Layer     │ │ │ │  Guard Layer     │ │
    │ │  (enforces       │ │ │ │  (enforces       │ │
    │ │   permissions)   │ │ │ │   permissions)   │ │
    │ ├──────────────────┤ │ │ ├──────────────────┤ │
    │ │  Learning Loop   │ │ │ │  Learning Loop   │ │
    │ │  (feedback →     │ │ │ │  (feedback →     │ │
    │ │   improvement)   │ │ │ │   improvement)   │ │
    │ └──────────────────┘ │ │ └──────────────────┘ │
    └──────────────────────┘ └──────────────────────┘
               │                       │
    ┌──────────▼───────────────────────▼────────────────┐
    │              CONTEXT GRAPH (shared state)           │
    │  Company KB + Product KB + all intelligence layers  │
    └────────────────────────────────────────────────────┘
```

### 3. Permission Tiers

Every agent action falls into one of four permission tiers:

| Tier | Description | Approval Required? | Example |
|---|---|---|---|
| **T0: Read** | Read from Context Graph or external source | Never | CI Agent reads competitor website |
| **T1: Draft** | Generate output for human review | Never (output is draft) | Positioning Agent generates messaging doc |
| **T2: Internal Action** | Modify Context Graph, create internal artifacts | Configurable (default: auto) | Research Agent updates persona doc |
| **T3: External Action** | Push to external systems, notify external stakeholders | Always requires approval | Alignment Agent posts to sales Slack channel |

---

## Agent Specifications

### Agent 1: Positioning & Messaging Agent

```yaml
agent_id: positioning-agent
version: 1.0
status: production

# ─── IDENTITY ───
name: "Positioning & Messaging Agent"
role: "The strategist — builds and maintains positioning, messaging pillars, and value propositions"
primary_user: PMM

# ─── DEFINED TASKS ───
tasks:
  can_do:
    - Generate positioning statement using configured framework
    - Create messaging hierarchy (brand → product → audience → channel levels)
    - Build message house (roof + 3-5 value pillars + proof points)
    - Generate value proposition canvas
    - Run FletchPMM positioning anchors analysis (market x product elements)
    - Generate Minimum Viable Positioning (MVP positioning pairs)
    - Determine competitive vs contextual differentiation mode
    - Test messaging against synthetic ICP personas
    - Generate elevator pitches (10/30/100 word variants)
    - Assess messaging impact when CI Agent detects competitive changes
    - Generate "framing the need" narrative (current state → trigger → consequence → new way)
    - Run "right to win" analysis (product, credibility, distribution, team, timing)
    - Recommend messaging A/B test variants
    - Generate persona-specific messaging variants
    - Generate channel-specific messaging adaptations
  cannot_do:
    - Publish messaging externally (requires Content Agent or human)
    - Change pricing or packaging (Pricing Agent scope)
    - Create sales-ready assets (Sales Enablement Agent scope)
    - Make competitive claims without CI Agent validation
    - Override human-approved positioning without re-approval

# ─── TOOL ACCESS ───
tools:
  read:
    - context_graph.company_kb          # Company context
    - context_graph.product_kb          # Product details
    - context_graph.customer_knowledge  # Personas, voice of customer
    - context_graph.competitive_intel   # Competitor data
    - context_graph.pricing_intel       # Pricing context for value positioning
    - context_graph.performance         # Which messaging has worked historically
    - context_graph.narrative_intel     # Master narrative for consistency
    - external.website_scraper          # Analyze competitor/own website copy
    - external.g2_reviews               # Customer language from reviews
    - integration.gong                  # Customer language from calls (if connected)
    - integration.crm                   # Win/loss data (if connected)
  write:
    - context_graph.positioning_intel   # Store positioning anchors, statements
    - context_graph.brand_knowledge     # Update messaging hierarchy, pillars
    - artifacts.positioning_doc         # Generate positioning documents
    - artifacts.message_house           # Generate message house documents
    - artifacts.value_prop_canvas       # Generate canvas artifacts

# ─── PERMISSIONS ───
permissions:
  auto_execute:     # T0-T1: No approval needed
    - Read any Context Graph data
    - Generate draft positioning/messaging docs
    - Run analysis (competitive impact, right to win, anchor analysis)
    - Create draft A/B test variants
  requires_approval: # T2: Configurable
    - Update Context Graph positioning data (default: auto-approve)
    - Update messaging hierarchy (default: require approval)
    - Mark positioning as "approved/current" (always require approval)
  always_requires_approval: # T3
    - Push messaging to external systems
    - Trigger downstream agent updates (e.g., tell Sales Enablement to update)
    - Archive/deprecate previous positioning

# ─── GUARDRAILS ───
guardrails:
  hard_limits:
    - NEVER generate messaging that contradicts approved brand guidelines
    - NEVER make competitive claims without sourced data from CI Agent
    - NEVER claim capabilities the product doesn't have (validate against Product KB)
    - NEVER use competitor brand names in a disparaging way in external messaging
    - NEVER generate pricing claims without Pricing Agent validation
    - MAX 5 positioning variants per session (prevent decision paralysis)
  soft_limits:
    - Flag if messaging is >80% similar to a competitor's messaging
    - Flag if positioning hasn't been reviewed in >90 days
    - Flag if messaging pillars don't have proof points attached
    - Warn if positioning targets >3 segments simultaneously (FletchPMM: focus)

# ─── STATE MANAGEMENT ───
state:
  persistent:
    - current_positioning_statement (versioned, with approval history)
    - messaging_hierarchy (versioned: brand → product → audience → channel)
    - messaging_pillars (with proof points and confidence scores)
    - positioning_anchors (primary + secondary, with rationale)
    - differentiation_mode (contextual/competitive/mature + evidence)
    - right_to_win_scores (5 dimensions, last assessed date)
    - historical_positioning (all previous versions with dates and reasons for change)
    - a_b_test_history (variants tested, results, learnings)
  session:
    - current_working_draft
    - framework_selected (FletchPMM / Dunford / Message House / custom)
    - feedback_received_this_session
  checkpoints:
    - Auto-save draft every 5 minutes during active session
    - Create version snapshot before any major change
    - Log all human edits with diff

# ─── LEARNING LOOP ───
learning:
  inputs:
    - Human edits to generated positioning (what did they change and why?)
    - A/B test results from Content Agent (which messaging variant performed better?)
    - Win/loss correlation from Metrics Agent (did messaging change impact win rate?)
    - Sales feedback via Gong (are reps using the messaging? how are prospects reacting?)
    - Content performance data (which messaging angles drive engagement?)
  adaptations:
    - Adjust messaging tone based on what resonates with the specific audience
    - Prioritize frameworks that produce outputs the PMM approves with fewer edits
    - Learn which proof points are most persuasive (from sales call data)
    - Detect messaging drift over time and recommend refresh
  feedback_mechanism:
    - After each output: thumbs up/down + optional comment
    - Monthly: "Positioning Health Check" — reviews all messaging against current market data
    - Quarterly: "Messaging Retrospective" — correlates positioning changes to business outcomes

# ─── ERROR HANDLING ───
errors:
  insufficient_context: "I need more information about [specific gap] to generate strong positioning. Want to run a quick Research Agent session first?"
  conflicting_data: "I found conflicting signals — your Gong calls suggest customers care about [X] but your website leads with [Y]. Let's resolve this."
  low_confidence: "I'm only 62% confident in this positioning because [reason]. Recommend validating with [specific action] before approving."
  stale_data: "The competitive data I'm using is from [date]. Recommend running CI Agent refresh before finalizing."

# ─── OBSERVABILITY ───
observability:
  logs:
    - Every task executed (input, output, duration, confidence)
    - Every Context Graph read/write
    - Every human approval/rejection with reason
    - Every framework applied and parameters used
  metrics:
    - Outputs generated per session
    - Human approval rate (how often do PMMs approve vs reject/edit?)
    - Average edits per output (trending toward fewer = agent is learning)
    - Time from "positioning need detected" to "approved positioning"
  alerts:
    - Positioning unchanged for >90 days while market has shifted
    - Approval rate drops below 50% (agent outputs aren't useful)
    - Messaging consistency score drops (Narrative Agent detected drift)

# ─── CHAINING ───
triggers_from:
  - ci_agent.major_competitive_change → reassess positioning
  - research_agent.new_customer_insights → update customer language in messaging
  - pricing_agent.pricing_change → realign value positioning
  - narrative_agent.narrative_update → ensure messaging ladders up
triggers_to:
  - sales_enablement_agent → update battlecards, talk tracks when messaging changes
  - content_agent → update content with new messaging pillars
  - narrative_agent → validate narrative consistency
  - alignment_agent → notify stakeholders of messaging changes
  - launch_agent → use current messaging for launch materials
```

---

### Agent 14: RFP Automation Agent (NEW)

```yaml
agent_id: rfp-agent
version: 1.0
status: production

# ─── IDENTITY ───
name: "RFP Automation Agent"
role: "Auto-generates contextual RFP/questionnaire responses from approved content"
primary_user: PMM, Sales, Presales

# ─── DEFINED TASKS ───
tasks:
  can_do:
    - Ingest RFP documents (Excel, PDF, Word, multi-tab/multi-section)
    - Parse RFP into individual questions with context
    - Auto-generate first-draft responses from approved content library
    - Customize responses by product line, industry, geography, or buyer segment
    - Pull competitive differentiation into RFP responses (from CI Agent)
    - Pull customer proof points and case studies into responses
    - Generate compliance/security section responses from Product KB
    - Support co-editing workflow (PMM + Sales + Presales review)
    - Compile final polished RFP response document
    - Track RFP response win rates by template and approach
    - Learn from winning RFPs to improve future responses
    - Flag questions that have no approved answer (new content needed)
    - Generate "RFP Content Gap Report" — what questions keep coming up that we don't have good answers for?
  cannot_do:
    - Submit RFPs externally (always requires human send)
    - Make contractual or legal commitments
    - Promise features on the roadmap as current capabilities
    - Fabricate customer references or proof points
    - Override compliance/legal-approved language in security sections

# ─── TOOL ACCESS ───
tools:
  read:
    - context_graph.product_kb          # Product features, capabilities, limitations
    - context_graph.positioning_intel   # Current messaging and value props
    - context_graph.competitive_intel   # Competitive differentiation
    - context_graph.customer_knowledge  # Case studies, proof points, customer quotes
    - context_graph.pricing_intel       # Pricing for RFP cost sections
    - context_graph.deal_intel          # Past winning RFP patterns
    - artifacts.content_library         # All approved content (docs, decks, one-pagers)
    - artifacts.security_responses      # Pre-approved security/compliance answers
    - integration.crm                   # Account context for the specific RFP
    - integration.gong                  # Past conversations with this account
  write:
    - artifacts.rfp_response            # Generated RFP documents
    - context_graph.deal_intel          # Log RFP patterns and outcomes
    - context_graph.content_gaps        # Flag unanswered question patterns

# ─── PERMISSIONS ───
permissions:
  auto_execute:
    - Parse uploaded RFP into questions
    - Generate draft responses from approved sources
    - Pull relevant content and proof points
    - Create compiled response document
  requires_approval:
    - Finalize response for export/send
    - Include pricing information in response
    - Reference specific customer names as proof points
  always_requires_approval:
    - Any response touching legal/contractual language
    - Any response making future roadmap commitments
    - Sending/submitting the RFP response externally

# ─── GUARDRAILS ───
guardrails:
  hard_limits:
    - ONLY use approved content sources for responses (no hallucination)
    - NEVER fabricate case studies, metrics, or customer quotes
    - NEVER promise capabilities that don't exist in Product KB
    - NEVER include future roadmap items as current capabilities (unless flagged and approved)
    - NEVER override legal/compliance-approved response templates
    - Every response must include a source reference (which content it pulled from)
  soft_limits:
    - Flag questions with <70% confidence match to existing content
    - Flag questions that appear in >3 RFPs without a strong approved answer (content gap)
    - Warn if response length exceeds typical for question type
    - Flag if customer-specific context is missing from CRM

# ─── STATE MANAGEMENT ───
state:
  persistent:
    - rfp_response_library (all past responses, indexed by question type)
    - winning_patterns (which response approaches correlate with wins)
    - content_gap_registry (frequently asked questions without good answers)
    - response_templates_by_vertical (industry-specific response libraries)
  session:
    - current_rfp_document (parsed questions + generated responses)
    - review_status_per_question (draft/reviewed/approved/flagged)
    - account_context (pulled from CRM for this specific RFP)

# ─── LEARNING LOOP ───
learning:
  inputs:
    - Human edits to generated responses (what did they change?)
    - RFP win/loss outcomes (which response approaches won?)
    - New content created to fill gaps (expands future response capability)
    - Feedback from presales/sales on response quality
  adaptations:
    - Improve response quality for frequently-asked question types
    - Learn which proof points and case studies are most persuasive per vertical
    - Adapt response tone/depth based on buyer segment patterns
    - Identify and pre-build responses for emerging question themes

# ─── CHAINING ───
triggers_from:
  - sales_enablement_agent.content_update → refresh RFP response library
  - ci_agent.competitive_change → update competitive differentiation responses
  - pricing_agent.pricing_update → refresh pricing section templates
triggers_to:
  - content_agent → flag content gaps for new content creation
  - metrics_agent → log RFP outcomes for ROI tracking
  - sales_enablement_agent → winning response patterns inform battlecards
```

---

### Agent 15: Context Engine Agent (Nucleus-Equivalent)

```yaml
agent_id: context-engine
version: 1.0
status: production

# ─── IDENTITY ───
name: "Context Engine"
role: "The persistent intelligence backbone — aggregates, enriches, and serves context to all agents and connected tools"
primary_user: System (all agents) + PMM (for KB management)

# ─── DEFINED TASKS ───
tasks:
  can_do:
    - Ingest and structure data from all connected integrations
    - Maintain Company KB and Product KB(s) — auto-enrich from connected sources
    - Serve contextual data to any agent on demand
    - Detect data staleness and trigger refresh workflows
    - Resolve conflicts between data sources (e.g., website says X, CRM says Y)
    - Auto-classify incoming data into correct Context Graph layers
    - Run "Context Health Check" — identify gaps, staleness, conflicts
    - Surface proactive insights ("3 accounts showed intent spike this week")
    - Maintain data lineage (where did each data point come from? when? how confident?)
    - Handle data privacy and PII masking across all layers
    - Manage data retention policies
    - Expose context via API for external tool queries (Phase 4)
    - Power the MCP protocol layer for connected AI tools (Claude, ChatGPT, etc.)
  cannot_do:
    - Generate customer-facing content (delegate to specific agents)
    - Make strategic recommendations (delegate to specific agents)
    - Take external actions (no Slack posts, no CRM updates without agent delegation)
    - Access data from integrations the user hasn't authorized

# ─── TOOL ACCESS ───
tools:
  read:
    - ALL context_graph layers (full read access)
    - ALL connected integrations (within user-authorized scope)
    - external.website_scraper (for Company/Product KB enrichment)
  write:
    - ALL context_graph layers (auto-enrichment from integrations)
    - context_graph.data_lineage (provenance tracking)
    - context_graph.health_metrics (staleness, confidence, gaps)

# ─── PERMISSIONS ───
permissions:
  auto_execute:
    - Read from any connected integration
    - Enrich Context Graph from integration data
    - Update data freshness timestamps
    - Run health checks and flag issues
    - Serve context to other agents
  requires_approval:
    - First-time integration connection (user must authorize)
    - Resolve conflicting data (flag to PMM, recommend resolution)
    - Delete or archive Context Graph entries
  always_requires_approval:
    - Expose data via public API
    - Share data with external services
    - Change data retention/privacy settings

# ─── GUARDRAILS ───
guardrails:
  hard_limits:
    - NEVER expose PII outside the system without masking
    - NEVER access integrations the user hasn't explicitly authorized
    - NEVER store raw credentials (OAuth tokens managed by platform, not agent)
    - NEVER serve stale data without flagging the staleness date
    - EVERY data point must have provenance (source, date, confidence)
    - Data retention follows user-configured policy (default: 2 years)
  soft_limits:
    - Flag data older than 30 days as "potentially stale"
    - Flag conflicting data from multiple sources
    - Warn if Context Graph has >20% gaps in any layer
    - Alert if integration sync fails for >24 hours

# ─── STATE MANAGEMENT ───
state:
  persistent:
    - Full Context Graph (all layers, versioned)
    - Integration sync history (last sync, records processed, errors)
    - Data lineage graph (every fact → source → date → confidence)
    - Context Health Score (per layer, per product, overall)
    - Enrichment log (what was added, when, from where)
  session:
    - Active queries from agents
    - Pending conflict resolutions
    - Current sync status per integration

# ─── LEARNING LOOP ───
learning:
  inputs:
    - Which context data agents query most (optimize retrieval for hot paths)
    - Which data PMMs correct most often (improve source quality ranking)
    - Integration reliability metrics (which sources are most accurate?)
    - Agent output quality correlated with context completeness
  adaptations:
    - Prioritize enrichment from most-queried data sources
    - Increase confidence weighting for most-reliable sources
    - Pre-fetch and cache frequently-accessed context patterns
    - Auto-suggest integrations that would fill the biggest context gaps

# ─── OBSERVABILITY ───
observability:
  dashboard:
    - Context Graph completeness score (per layer, per product)
    - Integration sync status (green/yellow/red per integration)
    - Data freshness map (heatmap of when each section was last updated)
    - Agent query patterns (which agents query what, how often)
    - Conflict resolution queue (pending, resolved, auto-resolved)
  alerts:
    - Integration sync failure >24h
    - Context completeness drops below 50% for any product
    - Data conflict detected between sources
    - PII detected in an unexpected field
```

---

### Standardized Agent Spec Template (For All 15 Agents)

Every agent in PMMStudio follows this exact specification format:

```yaml
# ─── REQUIRED SECTIONS (every agent must define) ───

agent_id:           # unique identifier
version:            # semantic versioning
status:             # development | beta | production | deprecated

name:               # human-readable name
role:               # one-sentence role description
primary_user:       # who primarily interacts with this agent

tasks:
  can_do: []        # exhaustive list of permitted tasks
  cannot_do: []     # explicit scope boundaries

tools:
  read: []          # data sources this agent can read from
  write: []         # data stores this agent can write to

permissions:
  auto_execute: []        # T0-T1: no approval needed
  requires_approval: []   # T2: configurable per team
  always_requires_approval: [] # T3: always needs human sign-off

guardrails:
  hard_limits: []   # immutable constraints (cannot be overridden)
  soft_limits: []   # warnings/flags (can be acknowledged and bypassed)

state:
  persistent: []    # survives across sessions
  session: []       # lives within a single session
  checkpoints: []   # auto-save and versioning rules

learning:
  inputs: []        # what data feeds the learning loop
  adaptations: []   # how the agent improves over time
  feedback_mechanism: [] # how humans provide feedback

errors: {}          # how the agent handles specific failure modes

observability:
  logs: []          # what gets logged
  metrics: []       # what gets measured
  alerts: []        # what triggers notifications

# ─── CHAINING (how agents connect) ───
triggers_from: []   # events from other agents that trigger this agent
triggers_to: []     # events this agent sends to other agents
```

---

## Cross-Agent Infrastructure

### Orchestration Layer

The orchestration layer manages agent-to-agent communication, dependency resolution, and execution ordering.

```
CHAINING RULES:
1. An agent can ONLY trigger agents listed in its triggers_to spec
2. Triggered agents run asynchronously unless the triggering agent
   needs the output to continue (dependency)
3. Circular chains are detected and blocked (A→B→C→A)
4. Human approval gates pause the chain until approved
5. Chain execution is fully logged with trace IDs for debugging
6. Any agent in a chain can escalate to human if confidence < threshold

EXAMPLE CHAIN (Competitive Price Drop):
┌─────────┐    ┌──────────┐    ┌───────────┐    ┌──────────┐
│CI Agent │───→│Positioning│───→│Sales Enable│───→│Alignment │
│detected │    │reassess   │    │update cards│    │notify    │
│change   │    │messaging  │    │+ tracks    │    │sales     │
└─────────┘    └──────────┘    └───────────┘    └──────────┘
     │              │               │                │
     │         [T2: auto]     [T2: approval]   [T3: approval]
     │              │               │                │
  auto-exec    PMM reviews     PMM approves     PMM approves
                 draft        battlecard edits   Slack message

CHAIN TRACE LOG:
chain_id: ch_29f8a3
trigger: ci_agent.competitive_price_change
  → positioning_agent.reassess_messaging (auto, 12s, confidence: 88%)
  → sales_enablement_agent.update_battlecard (awaiting approval)
  → [PAUSED: waiting for human approval on battlecard edits]
```

### Confidence Scoring System

Every agent output includes a confidence score that determines routing:

```
CONFIDENCE TIERS:
  90-100%  →  HIGH    →  Auto-approve eligible (if permission allows)
  70-89%   →  MEDIUM  →  Human review recommended, flag areas of uncertainty
  50-69%   →  LOW     →  Human review required, show reasoning
  <50%     →  INSUFFICIENT → Cannot proceed, surface specific gaps needed

CONFIDENCE CALCULATION:
  Base confidence = f(context_completeness, data_freshness, model_certainty)

  Adjustments:
    + Higher if similar task was approved before with few edits
    + Higher if multiple data sources corroborate
    - Lower if key Context Graph layers are missing
    - Lower if data is >30 days old
    - Lower if task is novel (no prior approved outputs of this type)
```

### Agent Versioning & Rollback

```
VERSIONING:
  Every agent output is versioned: v1, v2, v3...
  Human approvals are tagged: v2-approved
  Rollback to any previous version is one click
  Diff view between any two versions

AGENT UPDATES:
  Agent behavior updates ship as versioned releases
  Users can pin to a specific agent version
  Breaking changes require explicit opt-in
  A/B testing of agent versions for quality improvement
```

---

### Agent 14: Persona Intelligence Agent (NEW — Standalone)

```yaml
agent_id: persona-agent
version: 1.0
status: production

# ─── IDENTITY ───
name: "Persona Intelligence Agent"
role: "Builds, maintains, and activates living buyer/user personas that feed every other agent"
primary_user: PMM

# ─── DEFINED TASKS ───
tasks:
  can_do:
    # ── PERSONA CREATION ──
    - Build persona from scratch using guided research methodology
    - Run FletchPMM "unit of work" analysis per persona segment
    - Map "current way" per persona (existing workflow/tool/workaround)
    - Run SPICED diagnostic per persona (Winning by Design)
    - Map identity transitions per persona (who they ARE → who they're BECOMING)
    - Build buying committee map (buyer, champion, end-user, blocker, influencer)
    - Define anti-personas (who is NOT your ICP)
    - Build developer persona archetypes (13 types x awareness levels) for dev-tool companies
    - Generate persona one-pagers (company-level ICP + per-persona profiles)
    - Generate segment typing questions (3-5 Qs that classify any prospect into a segment)

    # ── PERSONA ENRICHMENT (living data) ──
    - Auto-extract customer language and pain points from Gong/Chorus call transcripts
    - Analyze CRM patterns per persona type (conversion rates, ACV, cycle length, churn)
    - Map persona types to product usage patterns from Amplitude/Mixpanel
    - Mine G2/Capterra reviews for persona-specific sentiment
    - Analyze support tickets for persona-specific pain points
    - Monitor community discussions (Reddit, LinkedIn, Slack) for persona language
    - Update persona profiles continuously from enrichment sources
    - Track persona freshness and flag stale profiles

    # ── PERSONA ACTIVATION (feeding other agents) ──
    - Serve persona context to any agent on demand
    - Generate persona-specific messaging variants (for Positioning Agent)
    - Generate persona-specific content briefs (for Content Agent)
    - Generate persona-specific talk tracks (for Sales Enablement Agent)
    - Generate persona-specific objection handling (for Sales Enablement Agent)
    - Recommend persona targeting per launch tier (for Launch Agent)
    - Feed persona WTP signals to Pricing Agent
    - Apply persona typing to intent signals (for Signal Agent)
    - Personalize proposals per buying committee member (for Proposal Agent)
    - Adapt RFP response tone to expected reader persona (for RFP Agent)

    # ── PERSONA ANALYSIS & REPORTING ──
    - Generate persona coverage dashboard (completeness per persona)
    - Generate persona performance report (which personas convert/expand/churn)
    - Run persona-to-revenue correlation analysis
    - Identify emerging persona segments from data patterns
    - Generate "persona gap" alerts (data shows a new segment we haven't defined)
    - Run quarterly persona health check (are personas still accurate?)

  cannot_do:
    - Conduct live customer interviews (recommend and provide interview guides)
    - Access customer PII beyond what's in authorized integrations
    - Auto-publish persona changes externally (all changes are internal Context Graph)
    - Override PMM-approved persona definitions without re-approval
    - Create personas for products not in the Product KB
    - Fabricate customer quotes or attribute language without source

# ─── TOOL ACCESS ───
tools:
  read:
    - context_graph.company_kb              # Company context
    - context_graph.product_kb              # Product features, use cases
    - context_graph.customer_knowledge      # Existing persona data
    - context_graph.competitive_intel       # How competitors target each persona
    - context_graph.positioning_intel       # Current messaging per persona
    - context_graph.performance             # Which persona segments perform best
    - context_graph.signal_intel            # Intent patterns by persona type
    - context_graph.pricing_intel           # WTP signals per segment
    - context_graph.content_intel           # Content engagement per persona
    - context_graph.deal_intel              # Win/loss by persona involvement
    - integration.gong                      # Call transcripts for language extraction
    - integration.chorus                    # Same as Gong
    - integration.crm                       # Deal data, contact roles, firmographics
    - integration.amplitude                 # Product usage by user type
    - integration.mixpanel                  # Same as Amplitude
    - integration.g2                        # Review sentiment by reviewer role
    - integration.capterra                  # Same as G2
    - integration.zendesk                   # Support tickets by user type
    - integration.intercom                  # Chat/support by user type
    - external.linkedin                     # Job title intelligence (via API where available)
    - external.community_monitor            # Reddit, Slack, LinkedIn group listening
  write:
    - context_graph.customer_knowledge      # Persona profiles, ICP data
    - context_graph.customer_knowledge.personas          # Individual persona docs
    - context_graph.customer_knowledge.icp_scorecard     # Segment ratings
    - context_graph.customer_knowledge.buying_committee   # Committee maps
    - context_graph.customer_knowledge.anti_personas      # Who to avoid
    - context_graph.customer_knowledge.typing_questions   # Segmentation Qs
    - context_graph.customer_knowledge.identity_transitions # Transition maps
    - artifacts.persona_one_pagers          # Exportable persona documents
    - artifacts.icp_scorecard               # Exportable ICP scoring
    - artifacts.interview_guides            # Research questionnaires

# ─── PERMISSIONS ───
permissions:
  auto_execute:
    - Read from any authorized integration
    - Extract language patterns from Gong/Chorus transcripts
    - Analyze CRM patterns and product usage data
    - Generate draft persona profiles
    - Run persona coverage and freshness analysis
    - Serve persona context to other agents
    - Generate interview guides and research templates
    - Update persona enrichment data (language, pain points, usage patterns)
  requires_approval:
    - Create a new persona type (PMM should validate before it's propagated)
    - Modify an approved persona's core definition (title, segment, ICP criteria)
    - Archive or deprecate a persona
    - Change ICP scorecard ratings for a segment
    - Reclassify a segment as anti-persona
  always_requires_approval:
    - Push persona data to external systems
    - Share persona profiles outside the team workspace
    - Delete persona profiles or historical data

# ─── GUARDRAILS ───
guardrails:
  hard_limits:
    - NEVER fabricate customer quotes — all language must have source attribution
    - NEVER create personas from <3 data points (minimum viable evidence)
    - NEVER store or surface raw PII in persona profiles (aggregate patterns only)
    - EVERY persona claim must include data source and date
    - NEVER override PMM-approved persona definitions without explicit re-approval
    - MAX 7 active persona types per product (prevent persona sprawl)
    - Anti-personas MUST be defined alongside personas (who NOT to target)
  soft_limits:
    - Flag personas not updated in >90 days as "potentially stale"
    - Flag persona profiles with <5 enrichment data points as "thin"
    - Warn if a persona type has <3 customer examples validating it
    - Alert if buying committee map is missing for a persona with ACV >$10K
    - Flag if Gong data shows a persona pain point not reflected in the persona profile
    - Warn if >30% of deals involve a persona type not in the defined set

# ─── STATE MANAGEMENT ───
state:
  persistent:
    - persona_profiles: [{
        persona_id, name, type (buyer/champion/user/blocker/influencer),
        segment, titles, unit_of_work, current_way,
        spiced (situation/pain/impact/critical_event/decision),
        identity_transition (current_identity → emerging_identity),
        pain_points (functional + emotional, with source attribution),
        goals, decision_criteria, objections,
        language_patterns (extracted from Gong, reviews, community),
        content_preferences, channel_preferences,
        buying_behavior (avg_cycle, avg_acv, win_rate, expansion_rate),
        anti_signals (red flags that indicate poor fit),
        freshness_score, last_enriched, enrichment_sources,
        version_history
      }]
    - icp_scorecard: [{
        segment, retention_score, access_score, velocity_score, activation_score,
        overall_priority, evidence, last_assessed
      }]
    - buying_committees: [{
        account_type, roles: [persona_refs], decision_process, typical_timeline
      }]
    - anti_personas: [{
        description, why_not, common_signals, last_validated
      }]
    - typing_questions: [{
        question, answer_options, segment_mapping, validation_rate
      }]
    - identity_transitions: [{
        persona_ref, current_identity, emerging_identity, transition_drivers,
        how_product_accelerates, messaging_implications
      }]
    - enrichment_log: [{
        date, source, persona_affected, data_points_added, confidence
      }]
  session:
    - current_persona_in_progress (during creation/editing)
    - research_mode (creating new vs enriching existing)
    - interview_guide_draft
  checkpoints:
    - Auto-save persona drafts every edit
    - Version snapshot before any approval-gated change
    - Monthly persona snapshot for trend analysis

# ─── LEARNING LOOP ───
learning:
  inputs:
    - Human edits to persona profiles (what did the PMM change? why?)
    - Win/loss correlation by persona type (which personas predict wins?)
    - Sales rep feedback on persona accuracy (via Gong call analysis + surveys)
    - Content engagement per persona (which persona-targeted content performs?)
    - Product adoption by persona type (which personas activate fastest?)
    - Customer churn by persona type (which personas are least sticky?)
    - Emerging title patterns in CRM (new roles appearing in deals)
    - Community language evolution (terms shifting over time)
  adaptations:
    - Improve persona definitions based on win/loss patterns
    - Auto-suggest new persona types when data shows unrecognized segments
    - Refine language pattern extraction based on PMM corrections
    - Adjust enrichment source weighting based on accuracy track record
    - Detect and flag persona drift (when a persona's reality diverges from definition)
    - Learn which persona attributes are most predictive of deal outcomes
    - Improve typing question accuracy based on segment classification validation
  feedback_mechanism:
    - Per-persona: "Is this persona profile accurate?" (quarterly prompt)
    - Per-enrichment: "I found this new pain point from Gong. Add to persona?" (real-time)
    - Per-deal: "This deal involved [Persona X] but played out differently than expected. Update?" (post-deal)
    - Quarterly: "Persona Health Report" — completeness, freshness, accuracy, performance correlation

# ─── ERROR HANDLING ───
errors:
  insufficient_data: |
    "I don't have enough data to build a confident persona for [segment].
    I need at least: 3 customer examples, 5 Gong call excerpts, and CRM
    data on 10+ deals. Here's an interview guide to fill the gap —
    or connect Gong for auto-extraction."
  conflicting_signals: |
    "Gong calls suggest [Persona X] cares most about [A], but G2 reviews
    emphasize [B]. These may represent sub-segments. Want me to split
    this into two persona variants?"
  stale_persona: |
    "This persona hasn't been enriched in 120 days and your market has
    shifted (CI Agent detected 3 competitive changes affecting this segment).
    Recommend a refresh — I can auto-enrich from connected sources or
    generate an interview guide for validation."
  persona_sprawl: |
    "You have 8 active persona types for this product (max recommended: 7).
    Two of them ([X] and [Y]) overlap by 73%. Recommend merging or
    deprecating one. Here's the comparison."
  new_segment_detected: |
    "In the last 30 days, 12 deals involved contacts with titles matching
    [New Role Pattern] that doesn't map to any defined persona.
    Want me to create a draft persona for this emerging segment?"

# ─── OBSERVABILITY ───
observability:
  dashboard:
    - Persona coverage map (completeness per persona per product)
    - Persona freshness heatmap (last enriched date per persona)
    - Persona-to-revenue correlation (win rate, ACV, cycle by persona)
    - Enrichment activity feed (what data flowed in, from where, when)
    - Agent query log (which agents queried which persona data)
  metrics:
    - Persona coverage % (how complete is each persona profile)
    - Persona freshness (days since last enrichment)
    - Persona accuracy (how often do PMMs edit auto-enriched data)
    - Persona-deal correlation (which personas predict wins)
    - Typing question accuracy (how often do typing Qs correctly classify)
    - Enrichment velocity (data points added per week per source)
  alerts:
    - Persona stale >90 days with active deals in that segment
    - New segment detected in CRM/Gong with no matching persona
    - Persona accuracy drops (PMM overriding >40% of enrichments)
    - Win rate for a persona segment changes >15% (persona may need update)
    - Buying committee structure changed in recent deals

# ─── CHAINING ───
triggers_from:
  - research_agent.new_customer_insights → enrich persona language/pain points
  - ci_agent.competitive_shift → reassess persona competitive preferences
  - signal_agent.new_segment_detected → draft new persona type
  - metrics_agent.persona_performance_change → flag persona for review
  - context_engine.integration_sync → auto-enrich from new data
  - pricing_agent.wtp_data → update persona pricing sensitivity
triggers_to:
  - positioning_agent → updated persona data changes messaging recommendations
  - content_agent → persona update triggers content re-optimization
  - sales_enablement_agent → persona change triggers talk track updates
  - narrative_agent → persona shift triggers narrative adaptation
  - launch_agent → persona priority change affects launch targeting
  - signal_agent → persona typing rules update signal routing
  - pricing_agent → persona WTP signals inform pricing models
  - proposal_agent → persona update changes proposal personalization
  - rfp_agent → persona update changes RFP response tone
  - alignment_agent → major persona change triggers stakeholder notification
```

---

## Summary: PMMStudio Agent Roster (16 Agents)

| # | Agent | Type | Status |
|---|---|---|---|
| 0 | **Context Engine** | Infrastructure | Production |
| 1 | **Positioning & Messaging** | Strategic | Production |
| 2 | **Competitive Intelligence** | Intelligence | Production |
| 3 | **Launch Planning** | Operational | Production |
| 4 | **Sales Enablement** | Activation | Production |
| 5 | **Customer & Market Research** | Intelligence | Production |
| 6 | **Signal Activation** | Intelligence | Production |
| 7 | **AI Content Workflow** | Activation | Production |
| 8 | **Media Proposal Generator** | Revenue | Production |
| 9 | **Narrative** | Strategic | Production |
| 10 | **Product Pricing** | Strategic | Production |
| 11 | **Metrics & Attribution** | Operational | Production |
| 12 | **Cross-Functional Alignment** | Operational | Production |
| 13 | **RFP Automation** | Revenue | Production |
| 14 | **Persona Intelligence** | Intelligence | Production |

Each agent follows the standardized spec template with defined tasks, tool access, permissions, guardrails, state management, learning loop, error handling, and observability.
