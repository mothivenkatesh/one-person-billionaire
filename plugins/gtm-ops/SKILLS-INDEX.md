# skills/

> Claude Code skills — markdown-first, composable, loaded on-demand by agents at runtime.

---

## Why skills live here AND in Google Shared Drive

**Two homes, two purposes:**

| Home | Purpose |
|---|---|
| **`skills/` in this repo** | Version-controlled source of truth · code-reviewable · Promptfoo-eval-tested |
| **Google Shared Drive `mothi GTM AI/Skills/`** | Team-editable surface for non-engineers (PMM, Demand Gen) · auto-synced to local for Claude Code · web-editable via Google Docs |

**Sync direction:** repo is canonical. Shared Drive mirrors the repo (one-way sync). Edits proposed in Drive go through the same eval gate before merging back to the repo.

---

## To build (per gtm-context.md §5)

| Skill | Purpose | Status | Owner |
|---|---|---|---|
| `icp-scout` | Daily prospect ingestion + ICP scoring | 🔲 | PMM |
| `outreach-writer` | Per-tier personalized email drafts | 🔲 | PMM |
| `reply-classifier` | Smartlead reply → intent → SF activity | 🔲 | RevOps |
| `stage-mover` | Stage-stagnation detection + meeting prep | 🔲 | RevOps |
| `cross-sell-detector` | Product-pair attach scoring | 🔲 | PMM |
| `dormant-detector` | 30/60/90d dormancy → re-engagement | 🔲 | CS |
| `churn-saver` | Churn-risk composite + CSM brief | 🔲 | CS |
| `weekly-report` | Weekly digest generation | 🔲 | Marketing Ops |
| `drive-transcript-extractor` | Drive AI transcript → typed properties | 🔲 | RevOps |
| `forms-router` | Google Forms intake → SF lead routing | 🔲 | RevOps |
| `din-watchdog` | 15-min anomaly scan for unauthorized launches | 🔲 | RevOps |

---

## Skill format

Each skill = one folder with `SKILL.md` (and optionally `examples/`, `evals/`):

```
skills/icp-scout/
├── SKILL.md                  ← the skill itself
├── examples/                 ← good/bad input-output pairs
│   ├── good-bfsi.md
│   └── bad-noise.md
└── evals/                    ← Promptfoo cases (referenced from /evals top-level)
    └── cases.yaml
```

**Frontmatter required** (see top-level [`CONTRIBUTING.md`](../CONTRIBUTING.md) for full template).

---

## Skill composition rules

1. **One skill = one responsibility.** Persona skills don't include channel craft; channel skills don't include persona.
2. **Frontmatter declares dependencies.** `depends_on: [content-strategist, dpdp-compliance]`.
3. **Skills never call MCPs directly.** They describe *what* to do; agents *do* it.
4. **Tested via Promptfoo.** Every skill has 5+ eval cases for "does loading this skill change the right thing."
5. **Versioned in git.** Every skill has a semver bump on material change.

---

## Reused / referenced skills (live in `mothi-os` private repo)

These existing skills are referenced by the agents in this repo but live in [mothi-os](https://github.com/mothivenkatesh/mothi-os) (Mothi's master personal OS):

- `content-strategist` (6-framework copy base)
- `cold-campaigns` (cold email patterns)
- `follow-up-nurture` (nurture sequences)
- `mothi-outreach-agent` (mothi-flavored outreach)
- `psy-trigs` (218 psychological triggers)
- `secure-id-comms`, `secure-id-deal`, `secure-id-launch` (Secure ID PMM bundle)
- `discord-engage`, `discord-grow`, `discord-measure` (community ops patterns)

**When building agents in this repo, prefer reusing these via Shared Drive sync over re-implementing.**

---

## Adding a new skill

See top-level [`CONTRIBUTING.md`](../CONTRIBUTING.md) §"Adding a new Claude Code skill".
