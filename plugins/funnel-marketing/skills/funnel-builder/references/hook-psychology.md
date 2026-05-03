# Hook Psychology Reference

A lens that complements `funnel-templates.md`. Templates describe funnel **architecture** (what the user sees: tripwire → upsell, VSL → app → call, etc.). This file describes the **psychology** that moves users between stages — the actual sentences that flip a stranger into a lead, a lead into a customer, a customer into a high-ticket buyer.

Use during **Phase 3 (Funnel Mapping)** in parallel with template matching:
- Templates answer "What's the architecture?"
- Hooks answer "What sentence is doing the conversion work?"

A funnel can match a canonical template perfectly and still leak — because the *hooks at the stage transitions* are weak. Naming the hooks (with verbatim quotes) is often what makes a teardown actionable rather than descriptive.

**Golden rule:** extract the ACTUAL PHRASE the target uses — don't paraphrase. The specific words matter because they reveal the psychological mechanism. A hook is not a strategy; it's a sentence.

---

## The 4 canonical hooks

Every funnel has (or should have) four stage-transition hooks:

1. **Hook 1 — TOF → MOF (Attention trigger).** What gets a cold scroll to click through?
2. **Hook 2 — MOF → Free (Identity / belonging trigger).** What gets them to opt in?
3. **Hook 3 — Free → Paid (Commitment trigger).** What converts free to paid?
4. **Hook 4 — Paid → Bottom (Escalation trigger).** What moves paid customers to high-ticket?

Find each. Quote the actual phrase. Name the psychological sub-pattern. Note when the hook is missing or weak — that's often the most useful finding.

---

## Hook 1 — TOF → MOF (Attention trigger)

**Job:** Get a stranger scrolling a feed to click through to the target's owned destination.

**Where to find it:** YouTube video titles (especially top 10 most-viewed), pinned social posts, thumbnail text, TikTok hook lines.

### Sub-patterns

**1a. Income promise**
- Pattern: `[outcome] That Makes [$X]` or `[$X] from [method]`
- Example: *"Faceless Video System That Makes You $20K/yr"*
- Psychology: specific dollar figures feel credible where vague claims don't; acts as a filter for the intended audience
- Tell: titles have dollar amounts

**1b. Self-story curiosity**
- Pattern: `"How I Built [outcome]"`, `"I Made [X] in [Y time]"`
- Example: *"How I Built a $100K Lead Gen That Prints Money"*
- Psychology: first-person framing triggers vicarious learning + social proof
- Tell: "I" in the title

**1c. Viral language**
- Pattern: superlatives + emotional intensifiers
- Examples: "Prints Money", "Ultimate", "Nobody Talks About", "Changed Everything", "Crazy"
- Psychology: algorithm-trained language pattern; triggers stop-scroll reflex
- Often stacked with 1a or 1b

**1d. Novelty / unexpected method**
- Pattern: `"[outcome] with $0 tools"`, `"[outcome] without [expected tool]"`, `"in [Y days]"`
- Example: *"I Vibecoded a $10,000 Agency Website With $0 Google AI Tools"*
- Psychology: cheap + fast + surprising method triggers "if they can, so can I"

**1e. Pain interrupt**
- Pattern: `"Stop [common-bad-behavior]"`, `"You're doing [X] wrong"`
- Example: *"Stop Writing Cold Emails Like This"*
- Psychology: direct address + negative framing ≈ rubbernecking instinct

**1f. Format innovation**
- Pattern: the creator invents a new content format inside their niche (case study disguised as entertainment, etc.)
- Examples: Hormozi's Shark-Tank-style live business teardowns; Neuro Knowledge's vboard manifestation videos; Sameer's 1-vs-10 Q&A format
- Psychology: novelty + nurturing-disguised-as-entertainment — prospects don't realize they're being sold to because the format reads as content
- Tell: identify the dominant format in the target's niche, then check if the target uses it or invented their own
- This is often a **master positioning move** — flag in Phase 4 strategic observations as "category-of-one play," not just as a Hook 1

---

## Hook 2 — MOF → Free (Belonging / identity trigger)

**Job:** Convert attention into an identified lead — email signup, community join, or install/sign-up.

**Where to find it:** website hero headline, Skool/Discord/Circle community "about" page, newsletter opt-in copy, bio lines across platforms.

### Sub-patterns

**2a. Identity shift**
- Pattern: `"Quit your [old identity]. Become [new identity]."`
- Example: *"Join Us To Build Your AI Agency & Quit Your 9-5"*
- Psychology: sells a new self, not a product; tribal framing via "join us"
- This is often the **master identity frame** — the line that recurs across every stage of the funnel

**2b. Free value stack**
- Pattern: `"Get [N] free [deliverables]"`, `"Free [lead magnet]"`
- Example: *"Free workflow library — 100+ templates"*
- Psychology: tangible, quantified value lowers commitment friction

**2c. Community belonging**
- Pattern: `"Join [N]+ members"`, `"Be part of [movement]"`
- Example: *"Join 32,800+ members already building"*
- Psychology: herd behavior + proof a peer group exists

**2d. Promise of ongoing value**
- Pattern: `"Weekly [deliverable] delivered to your inbox"`
- Example: *"Weekly AI trend analysis, tested use cases, step-by-step walkthroughs"*
- Psychology: drip anticipation — the signup locks in a recurring "why am I subscribed" moment

**2e. Free-course gateway**
- Pattern: a 3–10 hour long-form free video positioned as the primary lead magnet (replaces newsletter opt-in entirely)
- Example: Caleb's 6-hour personal-branding course → ~100K leads observed; FXG's 10-hour trading course → primary lead source
- Psychology: extreme volume of free value triggers reciprocity reflex AND delivers the 7-hour-of-content nurture in a single sitting
- Tell: a single YouTube video ≥ 3 hours, cross-promoted from IG bio / X pinned / story CTAs / website hero
- For info-coaching targets, this is the dominant 2025–2026 Hook 2 — newsletter opt-ins are a weaker variant

**2f. Zero-friction technical install (dev-tool variant)**
- Pattern: a one-line install command shown directly on the homepage (no signup gate, no email capture)
- Example: Hermes Agent's `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash` on the homepage hero
- Psychology: pasting the command IS the conversion event; the dev tribe's secret handshake; MIT license + open weights remove every "what's the catch?" objection
- Tell: docs / homepage have an immediate executable command, not a "Sign up free" button
- Common for OSS / dev-tool targets — see `case-studies/hermes-agent.md`

---

## Hook 3 — Free → Paid (Commitment trigger)

**Job:** Convert a free user who trusts you into a paying customer.

**Where to find it:** sales page copy (course landing page), premium tier "about" page, pinned community posts promoting paid, email sequences (if observable).

### Sub-patterns

**3a. Risk reversal (guarantee)**
- Pattern: `"[outcome] or [refund]"`, `"Money-back guarantee"`
- Example: *"Land your first AI client in 3 months — or your money back"*
- Psychology: shifts downside risk from buyer to seller; strongest single trigger when credible
- Tell: look for "money back", "guarantee", "or it's free", "risk-free"
- **Post-2024 calibration (info-coaching only):** in saturated niches (business coaching, trading, fitness, agency-building), aggressive guarantees can flip to a NEGATIVE signal — they suggest a commodity offer compensating for weak proof. Mature operators in burned niches lead with proof (named client results, recorded video testimonials, payment screenshots) and skip the guarantee. If the target leads with a guarantee in a mature niche, flag as "category commodity tell" rather than "strong Hook 3"

**3b. Scarcity (seat/time limits)**
- Pattern: `"Only [N] spots"`, `"Limited seats"`, `"Cohort closes [date]"`
- Example: *"10 spots only for Lifetime Access"*
- Psychology: FOMO + social proof (others are taking the spots)

**3c. Price anchor**
- Pattern: `"$[high] value → $[low] today"`
- Example: *"$1,164/yr value — early access $97 lifetime"*
- Psychology: reframes the price as a discount from a higher reference point

**3d. Specific time-bound outcome**
- Pattern: `"Achieve [X] in [Y time]"`
- Example: *"First paying client in 30 days"*
- Psychology: paints a concrete mental picture of the ROI timeline

**3e. Value stack**
- Pattern: `"[N] courses + [N] templates + [N] live calls + [bonus]"`
- Example: *"15 courses · 1,133 modules · 100+ templates · money-back"*
- Psychology: quantity signals "a lot for the price"

**3f. Default-path engineering (open-core variant)**
- Pattern: the paid product is offered as the *default* option in onboarding/docs alongside free alternatives, but with lower configuration friction
- Example: Hermes Agent docs list Nous Portal first among model providers; using Portal requires zero API-key plumbing vs OpenRouter's setup steps
- Psychology: the conversion lever is friction, not persuasion. No upsell modal, no nag, no feature gating — just default-path easier
- Tell: paid product appears in onboarding as a recommended option, not pitched explicitly anywhere
- Common for OSS / dev-tool open-core funnels

**Strong Hook 3s typically combine 2–3 of these sub-patterns.**

---

## Hook 4 — Paid → High-Ticket / Bottom (Commitment escalation)

**Job:** Move a paying customer to book a 1:1, hire the agency, enter enterprise pipeline, or upgrade to the premium tier.

**Where to find it:** agency website ("About", "Work", "Services"), 1:1 booking page, testimonials section, LinkedIn "Featured" section, closing slides of course content.

### Sub-patterns

**4a. Zero-friction CTA**
- Pattern: `"Free Quote"`, `"15-min call"`, `"Chat with us"`, `"See if it's a fit"`
- Example: *"Free Quote"* (vs. heavier "Book a Consultation")
- Psychology: removes commitment anxiety; feels consultative not salesy
- Tell: compare the CTA word choice across stages — the bottom CTA is usually deliberately softer than the paid CTA

**4b. Authority transfer**
- Pattern: client logos, years in business, credentials, team bios, founding-team prior reputation
- Example: *"5+ years · clients: Stockvins, HKBU, TDX"* OR *"Backed by Paradigm · $50M Series A · team behind Hermes 4 LLM"*
- Psychology: borrowed credibility — attention transfers from prior work to current offering

**4c. Social proof (named enterprise)**
- Pattern: specific case studies with named brands
- Example: *"We built [X] for [named client] in [timeframe]"*
- Psychology: "if X trusted them, I can trust them" + concrete outcome proof

**4d. Outcome specificity**
- Pattern: `"[result] for [client] in [time]"`
- Example: *"Delivered checkout MVP for Stockvins in 6 weeks"*
- Psychology: demonstrates delivery capability with no fluff

**4e. Exclusivity / invitation-only**
- Pattern: `"We only work with [N] clients at a time"`, `"Apply to work with us"`
- Psychology: scarcity + status signaling — the buyer must qualify

**4f. Deliberate invisibility (OSS / brand-purity variant)**
- Pattern: no public "Enterprise" / "Book a Demo" CTA; bottom of funnel runs through investor introductions and inbound API consumption
- Example: Nous Research has no enterprise CTA on hermes-agent.* domains — the funding raise + model brand equity + Series A investor network do the bottom-funnel work
- Psychology: signals "we don't need to chase you" — passive authority. Only works at scale with prior credibility
- Tell: ask "where is the Demo button?" If not present and the company is real, they're using passive escalation

---

## Cross-stage patterns to look for

### Hook escalation
Well-designed funnels get MORE risk-flipped as stakes rise:
- TOF: pure attention grab (low stakes for user)
- MOF: free commitment (low stakes)
- Free: moderate commitment (trust-building)
- Paid: high commitment → needs money-back, scarcity, price anchor
- Bottom: highest commitment → needs ZERO friction, maximum authority

If a target violates this pattern (aggressive urgency at TOF, vague CTA at Bottom), flag it as a strategic observation in Phase 4.

### The master identity frame
Many well-designed funnels have ONE positioning line that recurs across every stage.
- Example (info-coaching): Andy Lo's *"Build your AI agency & quit your 9-5"* appears in: Skool bio, course hero, video thumbnails, newsletter header
- Example (OSS dev-tool): Hermes's *"An Agent That Grows With You"* appears in: launch tweet, GitHub repo description, homepage hero, all derivative press
- Finding this line is usually a significant insight
- It's typically the implicit promise underneath Hook 2

### The "number signature"
Every hook in a well-optimized funnel has a **specific number**:
- Income: `$X/yr`, `$X/mo`
- Time: `in 3 months`, `in 30 days`, `in 7 days`
- Scarcity: `10 spots`, `100 members`
- Social proof: `N years`, `N clients`, `$N raised`, `N stars`

If a hook lacks a number, it's weaker than it could be — worth flagging as a Phase 4 observation.

### The word swap test
Compare CTA language across stages. If every button says "Buy Now", the funnel is flat. If the buttons progress "Learn More" → "Get Started" → "Join Free" → "Enroll" → "Free Quote", the creator is thinking about commitment asymmetry stage-by-stage.

### Pre-call sell-through layer (between Hook 3 CTA and Hook 4 close)

Between Hook 3 (book-the-call CTA) and Hook 4 (close-on-call), top operators run a sell-through layer that converts as much as the call itself. **Most analyses miss this because the assets are post-CTA and require booking to access.**

Look for:
- Confirmation / thank-you page videos handling top 5–10 objections (60s each)
- FAQ video stacks embedded near the booking CTA
- Pre-call email sequences that are value-drops (one objection per email), NOT generic reminders
- Personalized outreach within 2 minutes of typeform submit (setter qualifies + sends tailored assets)

If you can't access these without booking the call, note the gap explicitly in Phase 4: *"Pre-call sell-through layer not analyzed without booking. Visible CTA copy alone may understate Hook 3 strength by 1.5–2×."*

This is one of the most common analytical blind spots — flag whenever observed or known to be missing.

---

## What to do when hooks are weak or missing

Not every target has all 4 hooks. Possible reasons:
- **Missing Hook 1** (no attention hook in titles) → likely tiny audience or B2B with referral-driven growth
- **Missing Hook 2** (no clear identity frame) → likely a brand still finding positioning
- **Missing Hook 3** (no risk reversal/scarcity/value stack) → low conversion rate; worth flagging — unless it's a default-path engineering play (3f)
- **Missing Hook 4** (no soft CTA at the bottom) → bottom of funnel is underbuilt; high-ticket tier is probably leaking — unless it's a deliberate-invisibility play (4f)

Note which hooks are weak — that's often the most useful finding for the user (e.g., "here's what they're NOT doing well"). When hooks are missing for *strategic* reasons (3f, 4f), name the strategy; when they're missing because the operator hasn't built them, recommend them in the 90-day plan.

---

## How this file integrates with funnel-templates.md

| File | Question it answers |
|---|---|
| `funnel-templates.md` | Which of the 12 architectures is this target running? |
| `hook-psychology.md` (this file) | What sentences are doing the conversion work between stages? |
| `info-coaching-patterns.md` | If the target is in info-coaching, what vertical-specific operating patterns apply? |

Use all three together in Phase 3. The architecture, the hooks, and the vertical patterns describe a funnel from three different angles — none alone is sufficient.
