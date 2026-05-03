# Lesson 03: Multi-Agent — and When to Actually Use It

## TL;DR

The default is **one agent**. Multi-agent doubles complexity, multiplies cost, and halves debuggability. Reach for it only when one specialist *clearly* outperforms one generalist on your evals — and most of the time, it doesn't. Most "AI dev team" demos would have worked as one agent + a better prompt + a checklist tool.

## Core idea

```
1 agent  →  cheap, debuggable, good enough for ~80% of tasks
N agents →  use only when:
            (a) tasks need different specialized contexts
            (b) parallelism gives a real time win
            (c) one agent's quality demonstrably caps below the goal
```

Splitting is a tax. Pay it only when the win is bigger than the tax.

## How it works in practice

### The 3 multi-agent patterns that actually work

**1. Pipeline** — output of A feeds into B feeds into C.

```
Researcher  →  Outliner  →  Writer  →  Editor
```

When to use: each stage needs a *different* context shape (researcher needs web search; writer needs tone examples; editor needs style guide). The clean handoff is what justifies the split.

**2. Router (intent → specialist)** — read the input, dispatch to the right specialist.

```
              ┌─→ Refunds Agent
User msg →  Router  ├─→ Tech Support Agent
              └─→ Sales Agent
```

When to use: each specialist needs deep, narrow context that would dilute a generalist. Customer support is the canonical case.

**3. Debate-with-judge** — N agents propose; a judge picks.

```
Approach A  →
Approach B  →  Judge  →  pick best
Approach C  →
```

When to use: high-stakes decisions where you'd rather pay 3× for a calibrated answer. NOT for routine tasks.

### The "we built an AI dev team" trap

Demo:
```
Product Manager Agent  →  defines requirements
Architect Agent        →  designs system
Coder Agent            →  writes code
Tester Agent           →  writes tests
Reviewer Agent         →  reviews PR
```

This looks impressive in a YC demo day video. In production:
- 5× the LLM cost
- 5× the latency (each agent runs sequentially)
- 5× the places it can fail
- 5× the debugging surface
- Worse output than one well-prompted Claude Code session


### When fan-out genuinely beats one prompt

- **Embarrassingly parallel work**: "summarize these 50 documents" — 50 subagents in parallel beats sequential 50× faster
- **Independent specialization that doesn't share context**: customer support routing where each vertical has 100K tokens of context that would bust a generalist's window
- **Adversarial evaluation**: writing + critic + writer-revises loop where the critic *must not* be the same model state
- **Worktree-isolated parallel coding**: one agent builds feature A, another builds feature B, they merge later

### Cost math

| Architecture | Per-task LLM cost (rough) |
|---|---|
| One agent, 10 turns | $0.05 |
| Pipeline of 3 agents | $0.15 (3×) |
| 5-agent "team" | $0.25 (5×) |
| Debate of 3 + judge | $0.20 (4×) |
| Fan-out of 50 parallel summarizers | $2.50 (50×, but in 1/50th the wall-clock time) |

If your customer pays $10/mo, a 5× cost multiplier kills the unit economics. **Multi-agent has to earn its keep on either quality or wall-clock time** — usually quality, almost never both.

## Common traps

| Trap | Why |
|---|---|
| "More agents = better" | Each agent is a place to fail; 5 agents = 5× failure surface |
| Sequential agents that share context | Just be one agent with a checklist — the model handles "phases" fine |
| Debate-of-3 for routine tasks | 3× the cost for marginal quality gain |
| Forgetting to set max iterations on subagents | Runaway subagent → $200 surprise bill |
| "Agentic team" branding before evals | You don't know if it's better; you just hope |
| Coordinating agents through prose | Use structured handoff (JSON, file, queue) — prose is lossy |

## Exercise

Take a *real* multi-step task in your life — "draft my weekly status report from this week's git commits, calendar, and Slack messages."

Build it **two ways**:
1. **One agent** with 3 tools (git, calendar, slack) and a clear system prompt
2. **Pipeline of 3 agents**: Collector → Synthesizer → Writer

Run both on 5 weeks of your real data. Score them on:
- Output quality (1–10)
- Latency (seconds)
- Cost (cents)
- Debugging time when they fail (minutes)

The one-agent version usually wins or ties on quality, and dominates on cost/debug. If the pipeline doesn't win on something measurable, ship the one-agent version. This is the most important lesson in Part 1.

## Further reading

- Anthropic, [Building Effective Agents](https://www.anthropic.com/research/building-effective-agents) — the canonical "patterns vs hype" essay
- Andrew Ng, [Agentic Design Patterns](https://www.deeplearning.ai/the-batch/agentic-design-patterns/) — when each pattern earns its keep

---

[← Lesson 02](../02-the-harness-is-the-moat/README.md) | [Next → Lesson 04: Production-Ready](../04-production-ready/README.md)
