# funnel-marketing

Two skills for funnel marketing and conversion copy. Install once; both skills auto-trigger from natural-language phrases.

## Skills

### 1. `funnel-builder`

Reverse-engineer a competitor's product/service launch & distribution strategy. Four phases — Discovery → Timeline → Funnel Mapping → Synthesis — produce an intelligence report another team could use to replicate (or counter) the strategy.

**Triggers when** the user says things like *"reverse engineer this funnel"*, *"teardown of [company]"*, *"how did X launch"*, *"what's their distribution playbook"*, *"decode their funnel"*, or supplies a competitor URL and asks how it was built into market.

**What ships:**
- `SKILL.md` — 4-phase workflow with confirmation gates and exact-format outputs
- `references/phase-1-discovery.md` — 15-category footprint source matrix (web, blogs, socials, forums, communities, app stores, review sites, code repos, launch platforms, press, ad libraries, SEO/backlink intel, vernacular/regional)
- `references/phase-2-timeline.md` — dating techniques (Wayback, WHOIS, schema.org, RSS pubDates, GitHub commit history, crt.sh, Crunchbase) with conflict-resolution heuristics
- `references/phase-3-funnel.md` — funnel-shape selection (PLG / sales-led / marketplace / dev tool / consumer / services / community-led) + AARRR mapping with evidence
- `references/phase-4-synthesis.md` — playbook structure (one-line strategy, channel-mix matrix, messaging-evolution, "Copy This in 90 Days" plan, what NOT to copy)
- `references/funnel-templates.md` — 12 canonical funnel templates (Tripwire, VSL→app→call, Webinar, PLG, Freemium, Lead Magnet, Challenge, Book, High-ticket app, DTC, Affiliate, Marketplace) with conversion benchmarks, variants, failure modes, and reveal signals — grounded in 45,056 real Reddit conversations
- `references/hook-psychology.md` — the 4 stage-transition hooks (TOF→MOF, MOF→Free, Free→Paid, Paid→Bottom) with 30+ sub-patterns. Complements `funnel-templates.md` — templates describe architecture, hooks describe the sentences doing the conversion work
- `references/info-coaching-patterns.md` — 10 vertical-specific operating patterns for coach/consultant/info-marketer/creator-economy targets (simplicity tell, guarantee anti-pattern post-2024, format innovation, IG reels-vs-stories split, free-course-as-lead-magnet, 7–14h watch-time rule, messaging frame audit, pre-call sell-through, webinar+VSL combo signal, polish-vs-relatability calibration)
- `scripts/` — re-runnable scrape pipeline using [reddit-scraper](https://github.com/mothivenkatesh/reddit-scraper). Scrape 20 funnel subreddits → filter → comment-tree pull → tally template/anti-pattern/platform/guru mentions
- `data/` — 219 raw Reddit JSON files (~89 MB): 20 subreddit top-1000 dumps + 199 full comment trees of top funnel-relevant threads. Total: 45,056 analyzed conversations

**Worked examples:** see [`case-studies/`](./case-studies/) for full intelligence reports produced by running the skill on real targets. Currently includes [`hermes-agent.md`](./case-studies/hermes-agent.md) — open-source dev-tool teardown (Nous Research's AI agent, 130K stars in 10 weeks) showing open-core funnel mechanics that aren't in the Reddit corpus.

**Reddit data methodology** (see `references/funnel-templates.md` Section 0):
- 20 subreddits scraped (r/marketing, r/Entrepreneur, r/SaaS, r/copywriting, r/sales, r/AffiliateMarketing, r/clickfunnels, r/digital_marketing, r/EntrepreneurRideAlong, r/Sidehustles, r/smallbusiness, r/sweatystartup, r/PPC, r/FacebookAds, r/marketingautomation, r/EmailMarketing, r/landingpages, r/Conversion, r/growthhacking, r/SEO)
- 8,443 posts → 3,533 funnel-relevant after keyword filtering → 200 top-engagement threads → 44,857 meaningful comments analyzed (score ≥5)
- Top findings ground in primary data: GoHighLevel mentioned 5× more than ClickFunnels in current discourse · Affiliate / bridge-page funnels dominate practitioner discussion · Tripwire/Challenge/Book funnels (Brunson ecosystem) under-discussed vs. their guru reputation

### 2. `psychology-triggers`

Apply 218 psychological sales and marketing triggers to outbound copy, landing pages, social posts/CTAs, blog content, ad copy, sales scripts, webinar scripts, and pitch decks.

**Triggers when** the user is writing, reviewing, improving, or brainstorming any persuasion-focused copy and wants explicit psychological levers applied (loss aversion, social proof, anchoring, commitment, scarcity, authority, reciprocity, in-group, contrast, ownership bias, etc.).

## Install

This plugin is part of the [agentic-gtm-stack](https://github.com/mothivenkatesh/agentic-gtm-stack) marketplace. From Claude Code:

```
/plugin marketplace add mothivenkatesh/agentic-gtm-stack
/plugin install funnel-marketing@agentic-gtm-stack
```

## Re-running the Reddit scrape

The 45,056-conversation dataset can be regenerated quarterly to detect template-popularity shifts:

```bash
git clone https://github.com/mothivenkatesh/reddit-scraper.git
cd reddit-scraper
pip install -r requirements.txt

# Copy the scripts from this plugin
cp ../agentic-gtm-stack/plugins/funnel-marketing/skills/funnel-builder/scripts/*.py .
cp ../agentic-gtm-stack/plugins/funnel-marketing/skills/funnel-builder/scripts/targets-funnels.txt .

# Run the pipeline
python3 scrape.py --file targets-funnels.txt --sort top --max 1000
python3 analyze-funnels.py
python3 scrape.py --file top-funnel-threads.txt
python3 deep-analyze.py
```

Then update `references/funnel-templates.md` Section 0 with the refreshed counts. Watch for: GoHighLevel rising, ClickFunnels declining, new platform appearing, guru-mention sentiment shifts.

## License

MIT
