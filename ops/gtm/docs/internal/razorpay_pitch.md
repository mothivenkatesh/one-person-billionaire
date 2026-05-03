# Razorpay GTM Builder — cover pitch (private)

> Hi [recruiter] — I built `gtm-ops` this week as a working implementation of the GTM Builder role as I'd approach it.

Three things the repo shows that a résumé can't:

### 1. I think in stacks, not tools

The [architecture doc](architecture.md) maps 28 tools to 3 layers (INPUT → BRAIN → OUTPUT). I picked each tool for a specific reason — Smartlead over Instantly for deliverability, Granola over Gong for exec context, LangGraph over raw LangChain for HITL, OpenRouter over direct Anthropic for cost routing. I know why, not just what.

### 2. I already built the substrate

- **cortex** — my Python agent framework with WAT pattern (Workflows + Agents + Tools), self-healing via Haiku, self-modifying workflows at runtime.
- **ai-sdr-agent** — a 3-tier qualified SDR with score gates at 4.0 and 3.0, TSV-first state management, Chrome → WebFetch → WebSearch tool fallback chain.
- **23 live Claude Code skills** — including `follow-up-nurture` (scans CRM, reads email history, drafts via Gmail MCP) and a 9-agent `SuperAffiliate` stack.

This demo wires LangGraph + production integrations (HubSpot, Fathom, Smartlead, Dripify, Typefully, OpenRouter) on top of them.

### 3. I know the GTM pain because I lived it

I'm the PMM who authored Cashfree's ₹120 Cr Secure ID AOP — 14 sheets, 10 agentic AI agents on the roadmap, 38 competitor displacement target accounts, Perfios RPD partnership (₹5–15 Cr Year-1 ARR). The "copilot for meeting prep" flow isn't a toy — it's the tool I wished I had shipped 6 months ago when prepping for Reeju-level discovery calls.

## What I'd ship in the first 90 days

- **Wk 1–2** — CRM enrichment pipeline replacing manual Clay workflows for 20% of the AE book. Metric: enrichment coverage % (target: 2x current).
- **Wk 3–6** — Meeting prep copilot for top 50 accounts. Metric: AE minutes saved per discovery call (target: -20m).
- **Wk 7–12** — Deal-cold flagging in Slack + weekly win/loss thread published to Razorpay's developer X account. Metric: deal-slip recovery rate + reply-engaged followers.

Available for a call any weekday. Portfolio repo + Loom in the first email.
