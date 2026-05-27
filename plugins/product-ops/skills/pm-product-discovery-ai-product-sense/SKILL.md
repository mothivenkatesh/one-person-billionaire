---
name: pm-product-discovery-ai-product-sense
description: "Build AI product sense: the ability to anticipate what's impactful AND feasible with AI. Move past consumer chatbots into coding agents (Cursor / Claude Code), build a personal productivity OS, learn model tradeoffs hands-on. Use when transitioning into AI PM, evaluating AI feature ideas, or preparing for an AI PM interview."
---

# Building AI Product Sense

## Purpose

AI product sense is the ability to correctly anticipate what will be truly impactful for users AND feasible with AI. Generic product sense isn't enough — you need a working mental model of how LLMs reason, where they fail, and what the cost/latency/reliability tradeoffs look like in practice.

This skill applies the framework from Lenny's "How to build AI product sense."

## When to Use

- You're transitioning from a general PM role to an AI PM role
- Your team is evaluating AI feature ideas and you need to separate "feasible" from "demo-ware"
- You're preparing for an AI PM interview
- You can describe ChatGPT but couldn't explain how a tool-using agent decides when to call a tool

## Core Argument

Consumer chatbot UIs HIDE how AI works. Coding-agent UIs (Cursor, Claude Code) SHOW it — reasoning steps, tool calls, context windows, file edits. To build intuition, switch your default AI workspace from ChatGPT to a coding agent, even for non-coding tasks.

## Learning Path

### Foundation (Weeks 1-2)
1. Install **Cursor**.
2. Learn the three panels: chat, editor, file explorer.
3. Use Cursor for non-coding work: drafting docs, organizing notes, building personal databases.
4. Observe what reasoning steps the agent shows — this is the intuition layer most PMs miss.

### Model & Tool Tradeoffs (Weeks 3-4)
5. Run the same task on 3+ models (Claude Opus, GPT-5, Gemini 2.5).
6. Notice how each handles tool calls differently.
7. Form genuine opinions: which model do you reach for when, and why.
8. Read the model release notes. Notice the framing differences between labs.

### Hands-On Practice (Weeks 5-8)
9. Build a personal productivity OS in Cursor.
10. Add a RAG layer over your notes/docs.
11. Implement an agent memory system (persistent state across sessions).
12. Practice context engineering — what to include, what to omit, why.

## Habits That Compound

- **Use the coding agent for non-coding work** — that's the trick. It strips the consumer veneer.
- **Run the same prompt across models** to feel the differences in your hands, not in benchmarks.
- **Read raw model outputs**, including the reasoning traces. Develop a feel for which mistakes are model-class limits vs. prompt issues.
- **Build, don't read.** A weekend prototype teaches more than a month of newsletters.

## Recommended Tools

- **Cursor** — primary recommendation; transparent reasoning and tool calls
- **Claude Code** — long-running independent tasks; pairs well with skills/CLAUDE.md systems
- **Anthropic Claude Opus 4.5+** — for writing and reasoning-heavy tasks
- Substitute equivalents as the frontier moves

## What "AI Product Sense" Looks Like in Practice

A PM with AI product sense can, in a 30-min review:
- Identify which proposed features are token-bounded and will cost too much at scale
- Spot UI patterns that hide hallucinations from users (bad)
- Distinguish "the model can do this" from "the model can do this reliably at p95 latency"
- Predict which features will get worse as the model gets faster and cheaper (and which will get better)
- Push back on engineering effort estimates with informed counter-questions

## Process

1. **Switch your default work surface** to a coding agent. Use it for 80% of your AI interactions this month.
2. **Run a cross-model bake-off** for one task you do weekly.
3. **Build one personal AI tool** — even a 200-line script. Persistent memory + RAG + tool use.
4. **Document your model preferences** in writing. If you can't write them down, you don't have them yet.
5. **Review your team's last 3 AI feature decisions.** Where would AI product sense have changed the call?

## Output

A working personal AI productivity setup with:
- Cursor or equivalent installed as default
- A documented model-preference matrix (model × task type)
- One personal tool built (RAG over notes, agent loop, etc.)
- A written reflection on what surprised you in the build

## Tips

- ChatGPT is fine for end users. As a PM, you need to see the wiring.
- Don't chase the frontier model weekly — pick one, learn its failure modes deeply, then sample alternatives.
- Read the model spec docs, not just benchmarks. The constraints matter more than the scores.
- Your AI product sense compounds with hours of hands-on agent time. Newsletters substitute poorly.

---

### Further Reading

- [How to build AI product sense — Lenny Rachitsky](https://www.lennysnewsletter.com/p/how-to-build-ai-product-sense)
- [A guide to AI prototyping for product managers — Lenny Rachitsky](https://www.lennysnewsletter.com/p/a-guide-to-ai-prototyping-for-product)
- [Beyond vibe checks: A PM's complete guide to evals — Lenny Rachitsky](https://www.lennysnewsletter.com/p/beyond-vibe-checks-a-pms-complete)
- [Everyone should be using Claude Code more — Lenny Rachitsky](https://www.lennysnewsletter.com/p/everyone-should-be-using-claude-code)
