---
name: pm-product-discovery-ai-prototyping
description: "Pick the right AI prototyping tool (v0 / Bolt / Lovable / Replit / Cursor / Claude / Claude Code) and use proven prompt patterns to ship a working prototype in under an hour. Use when validating an idea, building a demo for stakeholders, mocking a flow before engineering invests, or testing a UI with users."
---

# AI Prototyping for Product Managers

## Purpose

Prototyping used to be a designer-and-engineer sport. With AI coding tools, a PM can ship a working prototype — runnable, shareable, sometimes deployable — in under an hour. The skill is no longer "can you code"; it's "can you pick the right tool and write the right prompt."

This skill applies the framework from Lenny's "A guide to AI prototyping for product managers."

## When to Use

- Validating a new product idea before engineering investment
- Building a demo to align stakeholders or fundraise
- Mocking a user flow for a usability test
- Stress-testing a design before locking the spec
- Communicating intent to engineering with a runnable artifact instead of a Figma

## Tool Selection Matrix

| Tool Category | Tools | Best For | Strengths |
|---|---|---|---|
| **Chatbots** | Claude, ChatGPT | Single-page prototypes (calculators, visualizations) | Fastest path; Claude Artifacts hosts the output |
| **Cloud builders** | v0, Bolt, Replit, Lovable | Multi-page + design + backend prototypes | Full-stack hosting; multi-file; shareable links |
| **Local agents** | Cursor, Claude Code, Windsurf | Production-quality work; debugging; multi-codebase | Direct codebase editing; context-aware |

## Quick Decision Rules

- **Match a design exactly** → v0
- **Quick prototype with flexible styling** → Bolt
- **Internal tools or data transforms** → Replit
- **Production integrations (GitHub, Supabase, auth)** → Lovable
- **Serious bugs or complex codebase** → Cursor
- **Long-running independent task** → Claude Code

## Prompt Patterns That Work

### Pattern A — Design-to-prototype
> "Build a prototype to match this design. Match it exactly. Use Tailwind CSS. Match styles, fonts, spacing, and colors." (attach screenshot)

**Tool:** Bolt / v0 · **Time:** ~5 min

### Pattern B — Feature addition (hyperspecific)
> "In the dashboard sidebar, add a section labeled 'Saved views' between 'Reports' and 'Settings'. It should list views in a vertical stack with a 24px icon, 14px label, hover state of `#F4F6F8`, and a '+' button at the bottom that opens a modal."

**Trick:** Hyperspecific descriptions beat vague ones every time.

### Pattern C — Blank-canvas build
> "Create a comprehensive [product type] system with [3-5 core features]."

**Tool:** Bolt / v0 · **Time:** ~5 min

## Common Pitfalls and Fixes

| Pitfall | Cause | Fix |
|---|---|---|
| Vague AI output | Underspecified prompt | Describe every component explicitly |
| Design mismatch | Tool hallucinates spacing/colors | Attach the actual screenshot, not a description |
| Lovable hard to edit | Architecture limitation | Start in Lovable, finish debugging in Cursor |
| Bolt loses state on refresh | Browser-based server | Wire Supabase for persistence |

## Prototype-to-Spec Workflow

1. **Validate the concept** with v0 / Bolt in 5-15 minutes.
2. **Gather feedback** by sharing the deploy link with 3-5 target users.
3. **Iterate** with follow-up prompts. Don't restart — refine.
4. **Transition to production** by moving the final spec to Cursor + your real codebase.
5. **Document learnings** in the PRD so engineering inherits the validated decisions, not just the UI.

## Capability Boundaries

- Cloud tools can't run complex backend logic (Bolt) or be directly edited file-by-file (Lovable).
- Chatbots can't host code, build multi-page apps, or persist data between sessions.
- Local tools require existing developer environment setup.

## Output

A working prototype with:
- A deploy / preview URL stakeholders can click
- A list of what was validated and what wasn't
- A handoff doc for engineering (or a refined PRD)

## Tips

- Start cheap. Don't pull out Cursor for a calculator.
- Screenshots > descriptions when matching designs.
- If the tool drifts mid-session, restart with a tighter prompt instead of fighting it.
- Save your best prompts. PM prompt patterns compound across products.

---

### Further Reading

- [A guide to AI prototyping for product managers — Lenny Rachitsky](https://www.lennysnewsletter.com/p/a-guide-to-ai-prototyping-for-product)
- [How to build AI product sense — Lenny Rachitsky](https://www.lennysnewsletter.com/p/how-to-build-ai-product-sense)
- [What people are vibe coding (and actually using) — Lenny Rachitsky](https://www.lennysnewsletter.com/p/what-people-are-vibe-coding-and-actually)
