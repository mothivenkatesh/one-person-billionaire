# Persona Integration Architecture

> **Why personas are a first-class layer in gtm-ops** — and how skills, agents, schema, evals, and resolver work together.

---

## The problem (before personas/)

Skills like `icp-scout` and `outreach-writer` had a `contact_persona` enum field — `cfo`, `cto`, `founder`, etc. — but only used it for:
- A small ICP-score modifier (+0.5)
- A tone shift in copy generation

That's not "persona-aware." That's persona-labeled.

The deep persona research that already exists at mothi (5-persona Synthetic Developer ICP in llm-wiki, 28K-row D2C research at `D:\dtc-research`, Mothi's BFSI AOP-FY27 work) was doing **nothing** for the agents.

---

## The architecture

```
┌──────────────────────────────────────────────────────────┐
│  SOURCE DATA                                              │
│  - llm-wiki/sources/mothi-synthetic-developer-icp.md  │
│  - D:\dtc-research\ corpus                                │
│  - Mothi-authored BFSI AOP                                │
│  - Real call transcripts (continuous)                     │
└────────────────────────▼─────────────────────────────────┘
                         │
                         ▼  PMM curates →
┌──────────────────────────────────────────────────────────┐
│  PERSONA FILES (gtm-ops/personas/)                        │
│  - One markdown file per canonical persona                │
│  - 7-section structure: identity, pains, success metrics, │
│    decision criteria, language, objections, buyer-or-not  │
│  - Frontmatter: name, vertical, seniority, authority,     │
│    spear_products, common_titles                          │
│  - Versioned in git; reviewable; testable                 │
└────────────────────────▼─────────────────────────────────┘
                         │
                         ▼  Loaded by agents at runtime
┌──────────────────────────────────────────────────────────┐
│  AGENT RUNTIME                                            │
│  agent_prompt = skill_body                                │
│              + load_persona(contact.persona_canonical)    │
│              + load_vertical_context(account.vertical)    │
│              + user_input                                 │
└────────────────────────▼─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│  PERSONA-AWARE OUTPUT                                     │
│  - ICP scoring with persona-modifier + persona pains      │
│  - Outreach with persona-language + persona-objections    │
│  - Meeting briefs with persona-aware discovery questions  │
│  - Save messages tuned to persona's success metrics       │
│  - Cross-sell pitches in persona's preferred format       │
└──────────────────────────────────────────────────────────┘
```

---

## The 6 integration points

### 1. Persona files (`personas/`)

Source of truth. Each persona gets one markdown file with a strict 7-section structure (identity, pains, success metrics, decision criteria, language, objections, buyer-or-not). Frontmatter is parseable for the resolver and registry.

### 2. Schema extension (`sql/004_persona_extensions.sql`)

- `contacts.persona_canonical` — typed string referencing a registry entry
- `contacts.persona_confidence` — 0.0-1.0; <0.8 flags for review
- `contacts.persona_resolved_by` — agent or human attribution
- `contacts.secondary_personas` — for multi-stakeholder deals
- `persona_registry` — single source of truth for available personas
- `persona_known_instances` — auto-populated as drive-transcript-extractor learns named decision-makers

### 3. Persona resolver (`src/gtm_ops/flows/persona_resolver.py`)

Maps SF Contact `title` + `account.vertical` to canonical persona name.

3-stage resolution:
1. **Exact match** against `common_titles` array (confidence 0.95)
2. **Keyword/substring match** with priority ranking (confidence 0.75)
3. **LLM fallback** via Claude Haiku (confidence 0.6-0.85)

Runs in two modes:
- Synchronous helper for any agent that needs to resolve a contact's persona on-demand
- Bulk backfill cron (LangGraph flow) — scans null `persona_canonical` rows

### 4. Skill frontmatter declaration

Persona-aware skills add to their frontmatter:

```yaml
loads_personas: true
persona_resolver: contact.persona_canonical → personas/{vertical}/{persona_canonical}.md
```

This makes the dependency explicit + auditable. The skill doesn't load personas itself — the agent runtime does — but the skill declares what shape of persona it expects.

### 5. Agent runtime composition

Every persona-aware agent (icp-scout, outreach-writer, stage-mover, cross-sell-detector, dormant-detector, churn-saver) wraps its Claude API call with persona loading:

```python
from gtm_ops.flows.persona_resolver import resolve_persona

# Inside the agent's "load skill" node:
persona_resolution = await resolve_persona(
    title=contact["title"],
    vertical=account["vertical"],
    company_size=account.get("employees"),
)

if persona_resolution["persona_canonical"]:
    persona_body = open(f"personas/{vertical}/{persona_resolution['persona_canonical']}.md").read()
else:
    persona_body = ""  # fallback: skill works without persona context but less personalized

prompt = (
    f"{skill_body}\n\n"
    f"--- ACTIVE PERSONA ---\n{persona_body}\n\n"
    f"--- USER CONTEXT ---\n{user_input}"
)
```

### 6. Promptfoo eval (`evals/cases/persona-loading.yaml`)

Regression cases that prove persona loading WORKS. Sample case:

```yaml
- vars:
    contact_persona: backend-engineer
    spear_product: payments-core
  assert:
    - type: contains
      value: 'webhook'   # persona's #1 pain should show in output
    - type: not-contains
      value: 'industry-leading'   # persona-anti-pattern phrase
```

If a future skill change accidentally drops persona awareness, evals fail. CI gate at 85% pass rate prevents merge.

---

## Why this beats the alternatives

| Alternative approach | Why we didn't | What we did instead |
|---|---|---|
| Embed persona context inline in each skill | 11 skills × 16 personas = 176 update points; impossible to maintain | One skill, one persona file, runtime composition |
| Use a single "persona" enum without depth | Was the original problem — surface-only labeling | Full markdown persona files with 7 sections |
| Auto-extract personas from each transcript on the fly | Too expensive + inconsistent; persona models drift per call | Curated stable persona files + continuous learning via drive-transcript-extractor writing to persona_known_instances |
| Build personas in a separate vendor (Mutiny / Default / etc.) | Vendor lock-in; can't version-control | Markdown in our repo |

---

## Maintenance + governance

### When to update a persona file

- After every 10+ real call transcripts hit the same persona, review for new pains/objections
- After RBI / DPDP / category-shifting events, review BFSI personas for compliance language
- When a new product launches, update `spear_products` for relevant personas
- Quarterly review: PMM owner ensures `status` reflects reality (stable / draft / stale)

### Who can edit personas

- PMM lead (Mothi) for all personas
- Vertical-specific PMM for their vertical
- Compliance team for compliance-language sections
- All edits go through PR + Promptfoo eval gate before merge

### When to add a new persona

Trigger: any of these happens 3+ times in a quarter:
- Resolver returns "unknown" for a recurring title pattern
- Agent output for a known persona feels off because the persona doesn't match the actual title
- Sales/CSM team requests a sub-persona (e.g., split `head-of-payments` into "bank-head-of-payments" vs "nbfc-head-of-payments")

Process: see `personas/README.md` "Adding a new persona" section.

---

## Cross-references

- `personas/README.md` — registry + folder structure + load rules
- `personas/{vertical}/PERSONA-INDEX.md` — index per vertical
- `sql/004_persona_extensions.sql` — schema
- `src/gtm_ops/flows/persona_resolver.py` — resolution logic
- `evals/cases/persona-loading.yaml` — regression cases
- `docs/gtm-context.md` §1.3 (Persona skills) — original spec
- `llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md` — developer persona source
- `D:\dtc-research\` — D2C operator persona source
- `llm-wiki/wiki/concepts/secure-id-platform-architecture.md` — BFSI persona source
