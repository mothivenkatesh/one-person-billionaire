# D2C Operator Personas

> **Source:** `D:\dtc-research\` — 28K-row Reddit corpus + 40+ founder interviews validating Cashfree's 5 D2C use cases.
> Used by agents when `account.vertical = 'd2c'` OR `contact.persona_canonical IN ([...this list...])`.

---

## The 5 personas

| # | Persona | Title pattern | Authority | Spear products | Status |
|---|---|---|---|---|---|
| 1 | **`founder-d2c`** | Founder · Co-Founder · CEO (D2C ≤500 employees) | economic_buyer + decision_maker | Payments + Payouts + International PG | ✅ stable |
| 2 | **`head-of-growth`** | Head of Growth · VP Growth · Marketing Lead | champion + technical_evaluator | Payments (checkout conv) + AutoPay | ✅ stable |
| 3 | **`head-of-ops`** | Head of Operations · COO · Ops Manager | champion + technical_evaluator + economic_buyer | Payouts + COD-RTO + Reconciliation | ✅ stable |
| 4 | **`cfo-d2c`** | CFO · VP Finance · Head of Finance (Series B+) | economic_buyer + gatekeeper | Payments (MDR) + Capital + Payouts | ✅ stable |
| 5 | **`marketing-lead`** | CMO · VP Marketing · Head of Brand | champion + influencer | Payments (checkout) + AutoPay (subscription) | ✅ stable |

---

## When to load which persona

| Stage | Most likely persona |
|---|---|
| Discovery (cold) | `founder-d2c` for ≤200 employee co; `head-of-growth` for 200-500 |
| Demo / POC | `head-of-ops` (validates Payouts + COD-RTO) + `head-of-growth` (validates checkout) |
| Pricing negotiation | `cfo-d2c` (CFO joins; MDR conversation) |
| Cross-sell (Payments → Payouts) | `head-of-ops` (Payouts buyer) |
| Cross-sell (Payments → International PG) | `founder-d2c` (strategic decision, often founder-led) |
| Cross-sell (Payments → Capital) | `cfo-d2c` (working-capital decision) |

---

## Vertical-specific Cashfree hooks for D2C

| Pain | Cashfree spear product | Hook |
|---|---|---|
| MDR cost at scale | Payments Core | Volume-tier negotiation; cite peer-merchant savings |
| Vendor / influencer payout volume | Payouts | T+0 settlement, single API for IMPS/UPI/RTGS/NEFT |
| Cross-border (UAE / SG / US shipping) | International PG | Sub-2% MDR INR settlement + FX hedging |
| Subscription / refill model | AutoPay | India's deepest UPI AutoPay coverage + dunning recovery |
| Working capital / cash-flow | Capital | Pre-approved line based on Cashfree transaction history |
| COD-RTO management | Pre-COD + Refund Velocity | India-specific COD intelligence layer |

---

## Loading rules for agents

When `cf-outreach-writer` / `cf-stage-mover` / `cf-cross-sell-detector` run with a D2C-vertical contact:

1. Resolve `persona_canonical` via title pattern
2. Load `personas/d2c-operator/{persona_canonical}.md`
3. For Tier A/B accounts with multi-stakeholder deal: also load secondary persona (e.g., founder-d2c + head-of-growth jointly for big decisions)
4. Compose with skill body in Claude prompt
