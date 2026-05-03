# Lesson 01: The Minimum Viable Agent

## TL;DR

Every agent — Claude Code, Cursor, the next $100M SaaS — is the same 30-line `while` loop. Write it yourself before reaching for LangGraph, CrewAI, or AutoGen. If you can't build the loop in 30 minutes, frameworks will hide problems you'll spend weeks debugging later.

## Core idea

```
def agent(user_msg, tools):
    messages = [{"role": "user", "content": user_msg}]
    while True:
        response = llm.create(messages=messages, tools=tools)
        messages.append({"role": "assistant", "content": response.content})
        if response.stop_reason == "end_turn":
            return response.content
        for tool_call in response.tool_uses:
            result = execute(tool_call)
            messages.append({"role": "user", "content": [
                {"type": "tool_result", "tool_use_id": tool_call.id, "content": result}
            ]})
```

That's it. **The model decides; the code executes.** Everything else in this curriculum is decoration around this loop.

## How it works in practice

A working agent has 4 parts:

```
┌──────────────────────────────────────────────────────────┐
│  1. MODEL          Claude Sonnet 4.6 (default)           │
│  2. TOOLS          5–10 labeled functions                │
│  3. LOOP           the 30 lines above                     │
│  4. EVALS          20 hand-written test cases              │
└──────────────────────────────────────────────────────────┘
```

### 1. Pick a model

| Task | Model | Why |
|---|---|---|
| Default | Claude Sonnet 4.6 | Best price/quality in 2026 |
| Cheap, fast | Claude Haiku 4.5 | 10× cheaper, good enough for routing/classification |
| Hard reasoning | Claude Opus 4.7 (1M ctx) | When evals show Sonnet failing |
| Long context | Gemini 2.5 Pro | 1M tokens cheap, weaker reasoning |

**Default rule:** Sonnet for everything until evals tell you otherwise.

### 2. Define tools

A tool is a function with a name, description, and parameter schema. The model reads the **description** to decide when to call it. Description craft > function code.

```python
{
    "name": "search_web",
    "description": "Search the live web. Use when the user asks about current events, recent prices, or anything past the model's knowledge cutoff.",
    "input_schema": {
        "type": "object",
        "properties": {"query": {"type": "string"}},
        "required": ["query"]
    }
}
```

**Bad description:** `"Search."`
**Good description:** `"Search the live web. Use when the user asks about current events, recent prices, or anything past the model's knowledge cutoff."`

The good one tells the LLM *when* and *why*, not just *what*. Models pick the right tool 30–40% more often with good descriptions.

### 3. The loop

The loop above is intentionally minimal. You will eventually add:
- Max iterations (avoid runaway loops)
- Token budget per session
- Tool-call retry on transient errors
- Streaming output to the user
- Conversation persistence (save messages to DB)

But add them *one at a time, when evals show pain*. Don't add them upfront.

### 4. Evals from day 1

Before you ship the agent to one external user, write **20 hand-graded test cases**:

```yaml
# evals.yaml
- input: "What's the weather in Bangalore today?"
  expected_tool: search_web
  expected_pattern: "temperature"

- input: "Convert 100 USD to INR using today's rate"
  expected_tool: search_web
  expected_pattern: "₹|INR|rupee"
```

Run them on every code change. If any fail, you don't ship. We'll go deep on this in Lesson 04.

## Common traps

| Trap | Why it kills you |
|---|---|
| Reaching for LangGraph before writing the loop | You'll inherit abstractions you don't understand and can't debug |
| Defining 50 tools for a v0 | Model gets confused; pick 3–5 max |
| Vague tool descriptions | Wrong tools called; mysterious bugs |
| No max-iteration guard | Runaway loops = surprise $200 LLM bill |
| Shipping without evals | Silent regressions for months |
| "I'll add error handling later" | First production crash teaches you why |

## What you do NOT need on day 1

- A framework (LangGraph, CrewAI, AutoGen, ADK)
- A vector DB (Pinecone, Chroma, Weaviate)
- An orchestrator UI
- Multi-agent architecture
- MCP servers
- Streaming
- Auth, billing, dashboards

Build these *only when a real user complaint forces them*.

## Exercise

**Build a "summarize this URL" agent in 60 minutes.**

Requirements:
1. One model: Claude Sonnet 4.6
2. Two tools: `fetch_url(url)` and `done(summary)`
3. The 30-line loop above (no framework)
4. 5 hand-written eval cases (mix of news article, blog post, GitHub README, error case, very long page)

When you finish, you've built the same architecture that powers Claude Code. Everything in this curriculum is variations on this theme.

## Further reading

- Anthropic, [Building Effective Agents](https://www.anthropic.com/research/building-effective-agents) — required reading

---

[← Premise](../00-the-honest-premise/README.md) | [Next → Lesson 02: The Harness Is the Moat](../02-the-harness-is-the-moat/README.md)
