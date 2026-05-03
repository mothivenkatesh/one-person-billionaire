# 90-second demo script

**Opening (10s)** — "I built `gtm-ops` to show how a GTM Builder would actually wire AI into a 370-rep sales org. It's the reference architecture — 28 tools across 3 layers — with 10 GTM Builder JD flows scaffolded or stubbed."

**README + architecture (20s)** — "Ten flows mapped to 10 integrations. Two flows — `meeting_prep` and `crm_enrichment` — are fully scaffolded with LangGraph, typed state, HITL checkpoints, and OpenRouter routing. The architecture doc explains every tool's slot and why it earns it."

**Live run — meeting_prep (25s)** — "Pass a deal_id. LangGraph pulls the deal from HubSpot, fetches stakeholders, runs competitive (Ahrefs + Meta Ads), loads past transcripts from `llm-wiki`, synthesizes a brief with Opus, pauses for my approval, and posts to Slack. Observable via LangSmith traces."

**Dashboards (15s)** — "Postgres holds the deals + signals. This materialized view (`cold_deal_flags`) flags cold deals with temperature + days-cold + recent-signal count. Metabase renders it live at `localhost:3000`."

**Evals (15s)** — "Promptfoo config runs 20+ test cases against every prompt with latency + cost thresholds. Regression-safe before I touch the synthesis prompts."

**Closing (5s)** — "Code + README + architecture doc are in the repo. Contributions welcome, hiring considered."
