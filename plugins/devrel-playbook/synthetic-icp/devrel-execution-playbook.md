# DevRel Execution Playbook — Cashfree Developer Advocacy
## Platform → Discord → Docs → Sandbox → Merchant

> **Core principle:** You are a developer who happens to work at Cashfree and genuinely helps people solve payment problems. The advocacy is a byproduct of being useful, not the goal itself.

---

## 1. Platform Engagement Playbook

### Reddit Execution

**Account Setup (Week 1-2: Karma Building)**
- Subreddits to join: r/developersindia, r/indianstartups, r/webdev, r/reactjs, r/node, r/FlutterDev, r/django, r/laravel, r/SaaS, r/IndiaInvestments, r/CreditCardsIndia
- Spend 2 weeks answering NON-payment questions (React hooks, Node debugging, career advice)
- Target: 500+ karma before any payment-related post
- Flair correctly per sub, read each sub's rules page

**Trigger Threads to Monitor (set up alerts)**
Search terms to watch daily:
- "payment gateway" in r/developersindia, r/indianstartups, r/webdev
- "Razorpay" across all subs (answer competitor complaints)
- "UPI integration" across all subs
- "accept payments India" across all subs
- "payment gateway recommendation" across all subs
- "Stripe India alternative" across all subs
- "international payments India developer" across all subs

**Response Templates (adapt, never copy-paste)**

*When someone asks "which payment gateway for my project?"*
```
What are you building? The answer depends on your use case:
- If you're pre-revenue and just need to accept payments fast → [specific advice]
- If you're building a marketplace and need split payments/payouts → [specific advice]
- If you need international payments from India → [specific advice]

I've integrated [X gateway] for [use case] and here's what I found: [genuine experience].
For payouts specifically, I found Cashfree's Auto-Collect and payout APIs
faster to implement — T+1 settlement vs T+2 elsewhere.

Happy to share more details if you tell me your stack.
```

*When someone complains about Razorpay settlement holds*
```
This is unfortunately common. A few things that help:
1. Keep your KYC docs updated proactively
2. Maintain a clear refund policy on your website
3. Document all transactions with proper GST compliance

For what it's worth, T+1 settlement exists at some gateways.
I've seen fewer settlement disputes with gateways that have
faster default cycles — less time for holds to trigger.

What's your current monthly GMV? That affects your options.
```

*When someone asks about UPI integration*
```
UPI Intent is the way to go now — UPI Collect was deprecated by NPCI.
Here's the flow:
1. Backend creates payment order via gateway API
2. Frontend triggers UPI Intent (opens user's UPI app)
3. User approves in their UPI app
4. Webhook confirms payment to your backend

The tricky part is webhook reliability — make sure you implement
idempotent handlers. [Technical detail specific to their stack]

If you're on [their framework], I can share a working code snippet.
```

**What NEVER to do on Reddit:**
- Never link to Cashfree in the post body (gets removed as spam)
- Never use "we" or "our product" language — you're a developer, not a salesperson
- Never reply to your own post with a Cashfree link
- Never post the same response in multiple threads
- Only mention Discord when someone asks "where can I get more help?"

**Content to post (original threads, 1x/week max):**
- "I tested 3 payment gateways for my marketplace — here's what happened" (genuine comparison with numbers)
- "TIL about UPI Autopay mandates — here's how recurring payments actually work in India"
- "I built a [project] with [payment gateway] — here's my integration timeline"
- "Payment gateway webhook reliability test — I monitored 10K events across 3 providers"

---

### X (Twitter) Execution

**Profile Setup:**
- Bio: "Building payment integrations | Dev at Cashfree | Writes about UPI, APIs, and developer tools"
- Pinned tweet: Your best technical thread or a "what I learned" post
- Follow: Indian dev influencers, fintech founders, payment engineers at competitors

**Daily Routine (30 min/day):**
1. Check notifications and reply to mentions (5 min)
2. Search "payment gateway India" / "UPI integration" / "Razorpay issue" — reply to 3-5 relevant tweets (15 min)
3. Quote-tweet one interesting fintech/payment post with added technical context (5 min)
4. Engage with 3 developer community tweets (like + reply) (5 min)

**Reply Strategy (where the real reach is):**
- Reply to high-follower accounts within 30 min of their post
- Always add new information — "Great point, and here's another angle: [technical insight]"
- When devs complain about payment integration: "What stack? I might be able to help"
- When devs share "I built X": "How did you handle the payment webhook reliability? That's the part most tutorials skip"

**Thread Templates (2x/week):**

*Technical deep-dive thread:*
```
1/ How UPI Autopay actually works under the hood 🧵

Most tutorials show you the API call.
But here's what happens between NPCI, the bank, and your gateway:

2/ When a user sets up a mandate...
[4-6 technical tweets with diagrams or code]

7/ If you're implementing this, the gotcha is [specific edge case].

Here's a working example in Node.js: [gist link]

I write about payment engineering weekly. Follow for more.
```

*"What I learned" thread:*
```
1/ I spent a week benchmarking UPI success rates across 3 gateways.

Here's what the data actually shows (not the marketing claims):

2/ Methodology: [how you tested]
3/ Results: [actual numbers]
4/ The surprise: [unexpected finding]
5/ What this means if you're choosing a gateway today: [actionable advice]
```

*Engagement bait (drives replies):*
```
Hot take: Most "payment gateway comparison" articles are useless because
they compare features, not integration experience.

The real comparison should be:
- Time to first test payment
- Webhook reliability over 10K events
- Support response time when something breaks at 2am

What's your #1 criterion? 👇
```

**Posting Schedule:**
- 9-10am IST: Original post or thread (peak Indian dev engagement)
- 12-1pm IST: Replies and engagement
- 6-7pm IST: Quote-tweet or engagement post
- Never post on weekends (dev Twitter drops 60%)

---

### LinkedIn Execution

**Profile Optimization:**
- Headline: "Developer Advocate @ Cashfree Payments | Helping developers build better payment experiences"
- About: Your story of building payment integrations, what you've learned, why you care about DX
- Featured: Pin your best 3 posts

**Post Templates (2x/week):**

*Personal story format (highest reach):*
```
Last week, a developer in our Discord couldn't figure out why
their UPI webhooks were failing silently.

After 30 minutes of debugging together, we found the issue:
[specific technical root cause]

This happens to 1 in 3 developers integrating UPI for the first time.

Here's how to avoid it:
→ [Point 1]
→ [Point 2]
→ [Point 3]

What's the worst payment integration bug you've encountered?
```

*Data/insight format:*
```
I analyzed 17,000+ developer comments about Indian payment gateways.

The #1 complaint isn't pricing.
It's not features.

It's support response time after onboarding.

The pattern across EVERY gateway:
✓ Great communication during sales
✗ Silence after you're live

3 things that would fix this:
→ [Solution 1]
→ [Solution 2]
→ [Solution 3]

Agree? What's been your experience?
```

*Carousel post topics (high save rate):*
- "5 UPI integration mistakes every developer makes"
- "Payment gateway comparison: what the pricing pages don't tell you"
- "How to debug payment webhook failures (step by step)"
- "The developer's checklist before going live with payments"

**LinkedIn Algorithm Hacks (legitimate):**
- First 60-90 min engagement determines reach — reply to every comment quickly
- End every post with a question (drives comments)
- No external links in the post body (kills reach) — put links in first comment
- Tag 3-5 relevant people (not spam, people who'd genuinely have an opinion)
- Post as yourself, never as company page

---

### Quora Execution

**Topics to Follow and Answer:**
- Best payment gateway India (evergreen, high search traffic)
- Razorpay vs Cashfree (comparison, high intent)
- UPI integration for developers
- Payment gateway for startups India
- eNACH implementation
- KYC verification API India
- International payment gateway India
- BNPL integration India

**Answer Structure (Quora rewards long, structured answers):**

```
## [Restate the question as a heading]

**Short answer:** [1-2 sentence direct answer]

**Detailed breakdown:**

### Option 1: [Gateway name]
- **Best for:** [use case]
- **Pricing:** [actual numbers]
- **Developer experience:** [honest assessment]
- **Gotcha:** [thing they don't advertise]

### Option 2: [Gateway name]
[same structure]

### My recommendation:
For [specific use case the asker described], I'd go with [X] because:
1. [Reason tied to their specific situation]
2. [Technical reason]
3. [Practical reason]

I've integrated both for [context]. Happy to answer follow-up questions.

*Disclosure: I work at Cashfree, so take my comparison with that context.
I've tried to be objective above.*
```

**Transparency rule:** Always disclose your Cashfree affiliation on Quora. It builds trust and Quora's community values it. Hiding it and getting caught = permanent credibility damage.

---

### HackerNews Execution

**Rule #1:** Never promote on HN. Ever. Not even subtly.

**What works:**
- Comment on payment/fintech threads with specific technical knowledge
- "Show HN" only for genuinely interesting open-source tools or technical writeups
- Commenting on Razorpay/Stripe/payment threads with insider perspective on how payment systems actually work

**Comment style:**
```
Former/current payment infrastructure engineer here.

The webhook reliability issue people are describing is more fundamental
than it seems. The problem is: [specific technical explanation of why
webhooks are inherently unreliable in payment systems].

At the infrastructure level, the solution is [technical approach].
[Company X] handles this by [specific implementation detail you know].

If you're building payment integrations, the practical fix is:
1. Always implement idempotent webhook handlers
2. Add a polling fallback that checks payment status every 5 min
3. Never trust a single webhook delivery — always verify via API
```

**"Show HN" post ideas (only if you actually build these):**
- "Show HN: Open-source payment webhook testing tool"
- "Show HN: UPI payment flow simulator for developers"
- "Show HN: Comparison tool for Indian payment gateway APIs"

---

## 2. Discord Advocacy Structure

### Channel Architecture

```
📢 ANNOUNCEMENTS
  #changelog          — API updates posted here FIRST (exclusivity)
  #events             — office hours, live coding, hackathons

💬 COMMUNITY
  #introductions      — new members introduce themselves + what they're building
  #what-are-you-building — showcase projects, get feedback
  #general-chat       — off-topic, community building

🛠️ DEVELOPER HELP
  #payment-gateway    — PG integration questions
  #payouts            — payout/disbursement questions
  #upi-integration    — UPI-specific help
  #webhook-help       — webhook debugging (highest friction point)
  #sandbox-issues     — sandbox bugs and setup help (fastest path to conversion)

📚 RESOURCES
  #tutorials          — community-written guides + official ones
  #code-snippets      — working code examples by language/framework
  #api-updates        — SDK releases, deprecation notices

🏆 PROGRAMS
  #community-champions — recognition for active helpers
  #bug-bounty         — report API bugs, get rewarded
  #feedback           — product feedback directly to eng team
```

### Discord Bot Automation

**Keyword-triggered help:**
When someone types a keyword, bot auto-suggests relevant docs:

| Keyword | Auto-response |
|---------|--------------|
| "webhook" | "📖 Webhook docs: [link] \| Common issues: [link] \| Need human help? Tag @dev-advocate" |
| "sandbox" | "🧪 Sandbox setup guide: [link] \| Test credentials: [link] \| Stuck? Drop your error here" |
| "UPI" | "📱 UPI integration guide: [link] \| UPI Intent vs QR: [link]" |
| "payout" | "💸 Payout API docs: [link] \| Bulk payouts: [link] \| Auto-collect: [link]" |
| "error" / "failed" | "🔍 Share your error code + stack trace and I'll help debug. Common fixes: [link]" |
| "KYC" | "📋 KYC requirements: [link] \| Common rejection reasons: [link]" |

**New member onboarding flow:**
1. Welcome message: "Hey [name]! What are you building? Drop a note in #introductions"
2. Role assignment: Developer / Founder / Student / Agency
3. 24hr follow-up DM: "Found what you need? Here are the most popular resources: [3 links based on their role]"
4. 7-day check: "How's your integration going? Need help with anything?"

### Discord Engagement Cadence

| Activity | Frequency | Owner |
|----------|-----------|-------|
| Answer #dev-help questions | Daily (<2hr response SLA) | Dev Advocate |
| Post in #changelog (real updates) | Every release | Dev Advocate + Eng |
| "Build with Cashfree" live session | Weekly (Thu 3pm IST) | Dev Advocate |
| Code review / debug session | 2x/month | Dev Advocate |
| Community spotlight (feature a member's project) | Weekly | Dev Advocate |
| Office hours (open Q&A on voice) | 2x/month (Fri 4pm IST) | Dev Advocate + PM |

### Discord → Conversion Path

```
Developer joins Discord
        ↓
Asks question in #dev-help
        ↓
Gets answer + relevant docs link within 2hrs
        ↓
Starts sandbox integration (tracked via #sandbox-issues activity)
        ↓
Hits friction → gets real-time help in Discord
        ↓
Goes live → celebrates in #what-are-you-building
        ↓
Becomes community helper → recognized in #community-champions
        ↓
Refers other developers → flywheel
```

---

## 3. Content Engine

### Weekly Content Calendar

| Day | Platform | Content Type | Topic Source |
|-----|----------|-------------|-------------|
| Mon | LinkedIn | Personal story post | Weekend Discord interaction |
| Mon | Reddit | 3 thread replies | Monitor trigger keywords |
| Tue | X | Technical thread (5-7 tweets) | Synthetic ICP pain point |
| Tue | Quora | 2 long-form answers | Evergreen questions |
| Wed | X | Engagement (replies only) | High-follower dev posts |
| Wed | Reddit | 2 thread replies | Payment gateway questions |
| Thu | LinkedIn | Data/insight post | Scraped data insights |
| Thu | Discord | Live build session (3pm IST) | Community-requested topic |
| Fri | X | "Hot take" or poll | Payment ecosystem opinion |
| Fri | Reddit | 1 original post (if earned) | Integration learnings |

### Content Pillars (rotate through these)

1. **Payment integration how-tos** — Technical tutorials, code snippets, debugging guides
2. **Payment ecosystem insights** — UPI data, gateway comparisons, regulatory changes
3. **Developer stories** — "I built X", "What I learned integrating Y", community spotlights
4. **Pain point solutions** — Directly addressing the top pain points from your scraped data
5. **Behind the scenes** — How Cashfree builds things, engineering decisions, technical architecture

### Content from Scraped Data (your competitive advantage)

Your synthetic ICP dataset tells you exactly what developers complain about. Turn each pain point into content:

| Pain Point (from data) | Content Angle | Platform |
|------------------------|--------------|----------|
| Razorpay settlement holds | "How payment settlement actually works in India" | LinkedIn + X thread |
| Webhook unreliability | "How to build bullet-proof webhook handlers" | Dev.to article + Reddit |
| KYC onboarding friction | "The developer's KYC checklist — avoid rejection" | Quora + LinkedIn |
| Sandbox-production mismatch | "5 things your payment sandbox doesn't test" | X thread + HN comment |
| Support ghosting post-onboarding | "What good developer support looks like" | LinkedIn (position Cashfree Discord as the answer) |
| UPI Collect deprecation | "UPI Intent migration guide — what you need to change" | Dev.to + Reddit |
| Pydantic v2 incompatibility (Cashfree) | Fix it, then post "We fixed it" in Discord + changelog | Discord + X |
| Flutter SDK callback issues (Razorpay) | "How to handle payment callback edge cases in Flutter" | Dev.to + Reddit |

---

## 4. Tracking Framework

### UTM-Tagged Discord Invite Links

Create unique invite links per platform:

```
https://discord.gg/cashfree-dev?utm_source=reddit&utm_medium=comment&utm_campaign=devrel
https://discord.gg/cashfree-dev?utm_source=twitter&utm_medium=reply&utm_campaign=devrel
https://discord.gg/cashfree-dev?utm_source=linkedin&utm_medium=post&utm_campaign=devrel
https://discord.gg/cashfree-dev?utm_source=quora&utm_medium=answer&utm_campaign=devrel
https://discord.gg/cashfree-dev?utm_source=hackernews&utm_medium=comment&utm_campaign=devrel
https://discord.gg/cashfree-dev?utm_source=devto&utm_medium=article&utm_campaign=devrel
```

### Metrics Dashboard (Weekly)

**Top of Funnel (Awareness)**
| Metric | Target | Source |
|--------|--------|--------|
| X impressions | 50K/week | X Analytics |
| Reddit thread views | 10K/week | Reddit post insights |
| LinkedIn post impressions | 20K/week | LinkedIn Analytics |
| Quora answer views | 5K/week | Quora Stats |

**Mid Funnel (Engagement → Discord)**
| Metric | Target | Source |
|--------|--------|--------|
| Discord invite clicks (by platform) | 100/week | UTM tracking |
| Discord new members | 50/week | Discord server insights |
| Discord active members (weekly) | 30% of total | Discord insights |
| Docs page visits from Discord | 200/week | GA with Discord referral |

**Bottom Funnel (Conversion)**
| Metric | Target | Source |
|--------|--------|--------|
| Sandbox signups from Discord members | 20/week | Internal tracking |
| First API call from Discord members | 10/week | DevStudio analytics |
| Merchant activation from Discord | 5/week | Internal CRM |
| Time from Discord join → first API call | <7 days | Cohort analysis |

### Attribution Model

```
Platform post/reply → [UTM-tagged Discord link] → Discord join
  → #dev-help interaction → Docs click → Sandbox signup
  → First test payment → First live payment → Active merchant

Track each step. The bottleneck tells you where to invest.
```

---

## 5. Anti-Spam Safeguards

### Platform-Specific Rules to Avoid Bans

**Reddit:**
- Max 10% of your posts/comments should mention Cashfree (Reddit's 10% rule)
- Never post the same content in multiple subreddits
- Never use URL shorteners (auto-removed)
- Don't post more than 3 times in any sub in one day
- If a mod removes your post, don't repost — message the mod

**X:**
- Don't mass-follow/unfollow (gets flagged as bot)
- Don't reply with identical text to multiple tweets
- Don't use more than 3 hashtags per tweet
- Space out tweets by 15+ minutes (rapid posting = spam flag)
- Don't DM people unsolicited

**LinkedIn:**
- Max 1 post per day (algorithm penalizes multiple)
- Don't edit a post within 10 minutes (resets engagement)
- Don't use external links in post body (put in first comment)
- Don't tag more than 5 people per post

**Quora:**
- Always disclose affiliation
- Don't answer your own questions
- Don't copy-paste the same answer to similar questions
- Write unique answers even for similar topics

**HN:**
- Never use upvote rings
- Don't comment on your own Show HN with sock puppet accounts
- Don't submit your own blog posts more than once
- Flagged accounts are silently shadowbanned — check in incognito

### The "Would a Mod Flag This?" Test

Before posting anything, ask: "If I were a moderator who's seen 1000 spam posts today, would this look like one?" If there's any doubt, rewrite it to be more helpful and less promotional.

---

## 6. Quick-Start: First 30 Days

**Week 1: Foundation**
- [ ] Set up Reddit account, start karma building (non-payment answers)
- [ ] Optimize X, LinkedIn, Quora profiles
- [ ] Set up Discord channel structure
- [ ] Create UTM-tagged invite links for each platform
- [ ] Set up keyword alerts for trigger threads (Reddit, X, Quora)

**Week 2: Content Seeding**
- [ ] Post first LinkedIn article (personal story about payment integration)
- [ ] Answer 5 Quora questions (with Cashfree disclosure)
- [ ] Start replying to dev tweets about payment issues
- [ ] Post first Discord #changelog update
- [ ] Answer 3 Reddit threads (non-promotional, genuinely helpful)

**Week 3: Rhythm**
- [ ] First X technical thread
- [ ] First Dev.to article (tutorial format)
- [ ] First Discord live build session
- [ ] Start tracking metrics weekly
- [ ] Identify top 5 community members to nurture as champions

**Week 4: Scale**
- [ ] First Reddit original post (earned through karma + engagement)
- [ ] LinkedIn carousel post
- [ ] Discord community spotlight
- [ ] First HN comment on a relevant thread
- [ ] Review metrics: which platform drives most Discord joins?
- [ ] Double down on highest-performing channel

---

*Generated from synthetic ICP analysis of 23,000+ developer comments across 6 platforms.*
*Based on real engagement patterns from r/developersindia, HackerNews, Dev.to, GitHub, and Quora.*
