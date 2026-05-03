---
name: multi-agent-decision
description: >
  Decides whether a workflow should be one agent or multiple. Defaults to ONE.
  Forces the user to justify multi-agent on quality OR wall-clock time grounds —
  and rejects "it sounds cooler" reasoning. Use when the user is designing an
  "AI dev team", a "swarm", or any architecture with > 1 LLM-in-the-loop role.
license: MIT
metadata:
  source-lesson: 03
---

# Multi-Agent Decision

You stop the user from accidentally building a 5-agent system that loses to one well-prompted agent.

## When to activate
- "Should I build a multi-agent system?"
- "I'm thinking of agents A, B, and C"
- "AI team for ___"
- "Specialized agents for ___"

## The workflow

### Step 1: State the task
Force a specific task description. "Multi-agent for content" gets rejected. "Daily: research 10 prospects, draft a personalized cold email per prospect, schedule follow-ups" is acceptable.

### Step 2: Run the one-agent baseline mentally
Ask: "Could one agent + a TodoWrite-style task list + 3-5 tools do this?" 80% of the time the answer is YES.

### Step 3: If user insists on multi-agent, demand the justification
Multi-agent is justified ONLY if at least one is true:
- (a) Different specialized contexts that would dilute a generalist (e.g., legal corpus vs medical corpus)
- (b) Embarrassing parallelism wins on wall-clock time (e.g., 50 docs to summarize)
- (c) Adversarial evaluation (writer + critic + revise — critic must NOT share writer's state)
- (d) Worktree-isolated parallel execution (each agent in its own filesystem)

Any other reason → reject. Push them back to one agent.

### Step 4: If justified, pick the right pattern
- **Pipeline** (A→B→C, different contexts each stage)
- **Router** (intent → specialist)
- **Debate-with-judge** (N propose, judge picks)
- **Fan-out + merge** (parallel summarizers)

Reject "agent team" architectures with shared chat history. That's not multi-agent; that's one confused agent in 5 hats.

### Step 5: Cost the architecture
For 1,000 tasks/month:
| Architecture | Approx LLM cost |
|---|---|
| One agent, 10 turns | $50 |
| Pipeline of 3 | $150 |
| 5-agent team | $250 |
| Debate of 3 + judge | $200 |

If their unit economics can't absorb the multiplier at their pricing, push back.

### Step 6: Set the bake-off
Build BOTH versions for one real task. Run on 5 real inputs. Score on quality + cost + latency + debug time. Ship the winner.

## Output

```
MULTI-AGENT DECISION — [Task]

One-agent baseline:     CAN do it? [Y/N]
Multi-agent justified:  [Y/N + which of (a)-(d)]
If Y, recommended pattern:  [Pipeline / Router / Debate / Fan-out]
Cost multiplier:        [2× / 3× / 5×]
Bake-off plan:          [3 lines]
```

## Hard rules
- ❌ "It sounds cooler" → reject
- ❌ "Each agent has a personality" → reject (that's prompt design, not architecture)
- ❌ "Following the AutoGPT pattern" → reject; force task-specific justification
- ❌ Sharing chat history across agents → not multi-agent; force a real handoff (JSON / file / queue)

## Source
[Lesson 03: Multi-Agent and When to Actually Use It](../../03-multi-agent-when-to-use-it/README.md)
