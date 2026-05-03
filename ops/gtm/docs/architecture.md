# Architecture — gtm-ops 3-layer stack

This repo (`gtm-ops`) is the working implementation of the **GTM AI Stack** reference architecture — 28 tools across INPUT / BRAIN / OUTPUT, mapped to 10 GTM Builder flows. The conceptual reference lives in the wiki at `C:/Users/mothi/llm-wiki/wiki/concepts/gtm-ai-stack.md` (the tool catalog is its own concept; this repo is one implementation of it).

## Layers

### INPUT — every possible buying signal

- **CRM** — HubSpot (system of record)
- **Enrichment** — Clay (orchestrator) over Apollo, ZoomInfo, Clearbit, Proxycurl, Hunter, BuiltWith + Claygent AI
- **Intent** — Common Room (unified 1P/2P/3P), 6sense, Bombora, G2 Buyer Intent
- **Visitor ID** — RB2B / Koala / Clearbit Reveal
- **Call intel** — Gong / Fireflies / Fathom / Granola
- **Competitive** — Ahrefs / Meta Ads Library / BuiltWith
- **Content signal** — Typefully analytics (replies, saves, DMs as intent)
- **Custom web** — Scrapling (no-API gap-filler)

### BRAIN — orchestration + knowledge

- **Orchestration** — LangGraph (stateful + HITL) + cortex (WAT pattern skill modes)
- **Model routing** — OpenRouter (Claude ↔ Haiku ↔ GPT ↔ Llama)
- **Knowledge** — llm-wiki (durable) + Postgres + pgvector (structured + embeddings)
- **Evals** — Promptfoo / Braintrust

### OUTPUT — action

- **Dashboards** — Metabase
- **Rep UI** — Slack bot, HubSpot writebacks, Gmail drafts
- **Cold email** — Smartlead (preferred), Instantly, Lemlist
- **LinkedIn** — Dripify, HeyReach
- **Enterprise SEP** — Salesloft, Outreach
- **Content distribution** — Typefully (via Composio MCP)
- **Paid activation** — LinkedIn / Meta / Google Ads APIs

## Tool-to-flow map

| Flow | Tools it routes through |
|---|---|
| 1. Meeting prep copilot | HubSpot + ZoomInfo + Gong + Granola + Ahrefs + Meta Ads + llm-wiki → LangGraph + OpenRouter (Opus) → Slack |
| 2. Slack action items | Gong/Fathom → LangGraph → HubSpot tasks + Slack |
| 3. CRM enrichment | HubSpot webhook → LangGraph → Clay waterfall (Apollo → ZoomInfo → Proxycurl → Claygent) → OpenRouter (Haiku) → HubSpot writeback |
| 4. Follow-up drafter | Transcript → LangGraph + HITL → OpenRouter (Haiku+Opus) → Gmail draft |
| 5. Cold-deal dashboard | HubSpot → Postgres view (`cold_deal_flags`) → Metabase |
| 6. Forecasting with CI | HubSpot → Postgres → Prophet → Metabase |
| 7. Win/loss analysis | HubSpot + Gong → LangGraph cluster extractor → llm-wiki + Metabase + Typefully thread |
| 8. Multi-channel outbound | Clay/Common Room list → LangGraph → Smartlead + Dripify → reply webhook → HubSpot deal + Slack |
| 9. Champion tracking | Common Room + Clay Signals (job changes) → LangGraph → Smartlead + LinkedIn Ads |
| 10. Content-to-pipeline | Typefully analytics → LangGraph → Clay enrich → HubSpot lead + Slack |

## Why this shape

Tools are swappable (ZoomInfo ↔ Apollo ↔ Clearbit on the enrichment side). Signal sources multiply each year (new ones slot into INPUT without touching BRAIN). The orchestrator (LangGraph) owns state, retries, and HITL — not the tools themselves. Every integration lives in `src/gtm_ops/integrations/` as a thin typed client with a single responsibility.

## Gaps this scaffold doesn't close

- **Salesforce** — Razorpay-scale orgs run Salesforce, not HubSpot. Swap HubSpot client for a Salesforce REST client; schema stays the same.
- **Production model serving** — add LangSmith for tracing + eval observability in prod.
- **Access tiers** — Dripify and ZoomInfo require partner/enterprise API access. Portfolio demo uses Apollo + Proxycurl as stand-ins.
