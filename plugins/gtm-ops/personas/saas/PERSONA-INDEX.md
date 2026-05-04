# SaaS Personas

> **Source:** Mothi's PMM corpus + SaaSBOOMi research + Indian SaaS founder interviews.
> Used by agents when `account.vertical = 'saas'` OR `contact.persona_canonical IN ([...this list...])`.

---

## The 2 personas (v1 — minimal, expand as deals justify)

| # | Persona | Title pattern | Authority | Spear products | Status |
|---|---|---|---|---|---|
| 1 | **`cfo-saas`** | CFO · VP Finance · Head of Finance (Series B+) | economic_buyer + gatekeeper | Payments + AutoPay + Payouts | ✅ stable |
| 2 | **`head-of-revops`** | Head of RevOps · VP Revenue Operations · Director RevOps | champion + technical_evaluator | Payments + AutoPay (subscription billing) | ✅ stable |

---

## Vertical-specific mothi hooks for SaaS

| Pain | mothi spear product | Hook |
|---|---|---|
| Recurring billing reliability (UPI AutoPay coverage) | AutoPay | India's deepest UPI AutoPay coverage + dunning recovery engine |
| Cross-border (global SaaS customers) | International PG | Sub-2% MDR INR settlement, FX hedging |
| Working capital for India-HQ'd SaaS | Capital | Pre-approved line based on mothi transaction history |
| MDR cost on annual contracts | Payments | Volume-tier negotiation |

---

## Status

This is the smallest persona vertical for v1. Most Indian SaaS use Stripe globally + a domestic gateway for INR billing — mothi's sweet spot is the AutoPay + International PG combo. Will expand to founder-saas + cto-saas + head-of-customer-success once v1 deals validate the wedge.
