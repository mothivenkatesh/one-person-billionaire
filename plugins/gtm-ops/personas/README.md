# personas/

> **First-class persona models for gtm-ops.** Loaded by agents at runtime alongside skills. mothi-specific — real products, real competitors, real Indian fintech context.

---

## Why personas live here (vs. embedded in skills)

Skills describe **what to do**. Personas describe **who you're talking to.** They compose at runtime:

```
agent_prompt = skill_body
             + load_persona(contact.persona_canonical)
             + load_vertical_context(account.vertical)
             + user_input
```

This split means:
- A skill can serve any persona (one outreach-writer skill, 20 personas)
- A persona can serve any skill (head-of-payments persona used by ICP-Scout, Outreach-Writer, Stage-Mover, Churn-Saver, Cross-Sell-Detector)
- PMM can update persona models without touching agent code
- Promptfoo can regression-test persona-aware behavior

---

## Folder structure

```
personas/
├── developer/             ← mothi Synthetic Developer ICP — 5 technical personas
├── d2c-operator/          ← D2C founder + ops + growth + CFO + marketing
├── bfsi/                  ← Banks, NBFCs, lending — head-of-payments, CRO, head-of-onboarding, compliance
└── saas/                  ← SaaS subscription — CFO, head-of-revops
```

Each subfolder has:
- **`PERSONA-INDEX.md`** — list of personas in this vertical with one-line descriptions
- **`{persona-name}.md`** — the persona file itself

---

## Persona file structure

Every persona follows this shape (frontmatter + 6 mandatory sections):

```markdown
---
name: backend-engineer
vertical: developer
seniority: ic | senior | tech_lead | manager | director
authority: champion | influencer | technical_evaluator | economic_buyer | gatekeeper
spear_products: [secure-id, payments-core]   # which mothi products are most relevant
common_titles: [...]                           # title patterns for resolver matching
source: llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: stable | draft | stale
---

# {Persona name}

## 1. Identity (who they are)
## 2. Top 3 pains (ranked, with mothi-relevant context)
## 3. Success metrics they own
## 4. Decision criteria when evaluating mothi
## 5. Language that resonates / language that turns them off
## 6. Common objections + mothi-specific responses
## 7. When this persona is the buyer / when not (still relevant)
```

---

## How agents load personas

### Pattern 1 — Skill-level loading (Python flows)

```python
from gtm_ops.flows.persona_resolver import resolve_persona

persona_body = resolve_persona(
    persona_canonical=contact.persona_canonical,   # e.g., 'backend-engineer'
    vertical=account.vertical                       # e.g., 'developer'
)
prompt = skill_body + "\n\n--- ACTIVE PERSONA ---\n" + persona_body + "\n\n" + user_input
```

### Pattern 2 — n8n workflow loading

The n8n workflow has a "Load Persona" HTTP Request node that reads from Drive (mirrored from this repo) using `contact.persona_canonical` as the lookup key.

### Pattern 3 — Direct skill reference

Skills with `loads_personas: true` in frontmatter declare this dependency. The agent runtime auto-loads the matching persona file before invoking the skill.

---

## Title pattern → `persona_canonical` resolution

The `persona_resolver.py` utility maps SF Contact titles to canonical persona names:

| Title pattern (regex/keyword) | Canonical persona |
|---|---|
| `head of payments`, `vp payments`, `payments lead` | `head-of-payments` (BFSI) |
| `cto`, `vp engineering`, `head of engineering` | `cto-startup` (developer) OR `cto` (BFSI/SaaS) by vertical |
| `founder`, `co-founder`, `ceo` (small co) | `founder-d2c` if D2C; `founder-saas` if SaaS |
| `cfo`, `vp finance`, `head of finance` | `cfo-d2c` / `cfo-saas` by vertical |
| `head of growth`, `growth lead`, `vp growth` | `head-of-growth` (D2C) |
| `head of risk`, `chief risk officer`, `cro` | `chief-risk-officer` (BFSI) |
| `compliance`, `head of compliance` | `compliance-head` (BFSI) |
| `software engineer`, `senior engineer`, `tech lead` | `backend-engineer` OR `tech-lead` (developer) |
| `devops`, `sre`, `infrastructure` | `devops-sre` (developer) |
| `security engineer`, `infosec` | `security-engineer` (developer) |

Confidence: ≥0.8 → set `persona_canonical`; <0.8 → flag for manual review.

---

## Status

| Vertical | Personas planned | Built so far |
|---|---|---|
| Developer | 5 | 1 (`backend-engineer`) |
| D2C operator | 5 | 1 (`founder-d2c`) |
| BFSI | 4 | 1 (`head-of-payments`) |
| SaaS | 2 | 0 |

**Exemplars complete (3 of 16). The rest follow the same pattern — PMM expands as needed.**

---

## Adding a new persona

1. Create file at `personas/{vertical}/{persona-name}.md` following the structure above
2. Add a row to `personas/{vertical}/PERSONA-INDEX.md`
3. Add resolver pattern to `src/gtm_ops/flows/persona_resolver.py` if title pattern is new
4. Add Promptfoo eval cases in `evals/cases/persona-loading.yaml`
5. Update `CHANGELOG.md`

See `docs/persona-integration.md` for the deeper architectural rationale + integration points.

---

## Source data

- `llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md` — the 5-persona dev research (canonical source)
- `D:\dtc-research\` — D2C operator research corpus (28K-row Reddit + interviews)
- `llm-wiki/wiki/concepts/secure-id-platform-architecture.md` — BFSI persona context
- Real call transcripts via `drive-transcript-extractor` — auto-extracts persona signals to refine the model over time
