# Developer Personas (mothi Synthetic Developer ICP)

> **Source:** `llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md` — 5-persona research model.
> Used by agents when `account.vertical IN ('saas', 'developer-tools', 'fintech-api')` OR `contact.persona_canonical IN ([...this list...])`.

---

## The 5 personas

| # | Persona | Title pattern | Authority | Spear products | Status |
|---|---|---|---|---|---|
| 1 | **`backend-engineer`** | Senior SWE · Tech Lead · Eng Manager | champion / technical_evaluator | payments-core · secure-id (API side) | ✅ stable |
| 2 | **`devops-sre`** | DevOps · SRE · Platform Eng | technical_evaluator + gatekeeper | payments-core (uptime / webhooks) | ✅ stable |
| 3 | **`security-engineer`** | Security Eng · InfoSec · AppSec Lead · CISO | gatekeeper | secure-id · DPDP compliance | ✅ stable |
| 4 | **`cto-startup`** | CTO · VP Engineering (≤200 employees) | economic_buyer + decision_maker | full stack | ✅ stable |
| 5 | **`tech-lead`** | Tech Lead · Staff Eng · Principal Eng | champion + influencer | payments-core · payouts | ✅ stable |

---

## When to load which persona

| Stage | Most likely persona |
|---|---|
| Discovery (cold) | `backend-engineer` (PLG bottom-up) OR `cto-startup` (top-down small co) |
| Demo / POC | `tech-lead` + `devops-sre` |
| Security review | `security-engineer` (gatekeeper) |
| Negotiation / close | `cto-startup` (economic buyer) |

---

## Loading rules for agents

When `outreach-writer` / `stage-mover` / `cross-sell-detector` run with a developer-vertical contact:

1. Resolve `persona_canonical` via `persona_resolver.py` (title pattern match)
2. Load `personas/developer/{persona_canonical}.md` content
3. Compose with skill body in Claude prompt
4. Optionally also load `personas/developer/cto-startup.md` if economic_buyer is a separate contact (multi-stakeholder deals)
