---
name: pm-execution-ai-evals
description: "Design PM-grade evaluations for AI products using the four-part judge-LLM formula (role, context, goal, terminology). Use when shipping an AI feature, debugging quality regressions, designing an eval set, or moving past vibe-checks to measurable AI quality."
---

# PM Evaluations for AI Products

## Purpose

You are a senior PM responsible for the quality of an AI feature. Evals are the AI equivalent of regression tests — they measure whether your model + prompt + tools combination is doing what users need. PMs own evals because the criteria are product judgements, not engineering ones.

This skill applies the framework from Lenny's "Beyond vibe checks: A PM's complete guide to evals."

## When to Use

- Shipping a new AI feature and need to know when it's "good enough"
- Debugging a quality regression after a model upgrade or prompt change
- Building an eval set before going to GA
- The team is shipping on vibes and you need a measurable bar
- Engineering keeps asking "what does success look like?" for an AI output

## The Three Eval Approaches

| Approach | Mechanism | When | Watch-out |
|---|---|---|---|
| **Human evals** | Thumbs up/down from users or SME labels | Early signal; rare/high-stakes outputs | Sparse, expensive, unclear what the thumb meant |
| **Code-based evals** | Deterministic assertions (regex, JSON-validity, latency) | API-call validity, structured output, code-gen | Useless on subjective/open-ended outputs |
| **LLM-as-judge** | A separate LLM grades the agent's outputs against a rubric | Scale + subjectivity; default for most PMs | Needs calibration; probabilistic; volume-dependent |

Most PM-owned evals are LLM-as-judge.

## The Four-Part Judge-LLM Formula

Every judge prompt needs four components. Miss one and the eval is noise.

### 1. Set the Role
Prime the judge for the task domain.
> "You are an expert evaluator examining customer-support replies for tone and accuracy."

### 2. Provide Context
Feed the actual application data — message chains, retrieved context, user goal — not just the model output in isolation.

### 3. Define the Goal
This is where mediocre evals become excellent ones. Articulate precisely what you want measured.
> "Score 1-5 on whether the reply directly addresses the user's stated question without inventing facts."

### 4. Ground the Terminology
Specify what success/failure means in your domain. "Hallucination" means different things in legal vs. customer support.

## Common Eval Criteria (start here)

- **Hallucination** — accuracy vs. fabrication relative to provided context
- **Tone/toxicity** — appropriate to your product voice
- **Overall correctness** — primary task done well (Q&A accuracy, intent classification correct)
- **Code generation** — runs without error; passes test cases
- **Summarization quality** — captures key info, no padding
- **Retrieval relevance** — RAG returned the right chunks

## Process

1. **Pick the user-facing failure mode that matters most.** Don't start with 12 criteria; start with the one that would get you paged.
2. **Collect 50-200 real production examples** spanning easy/medium/hard. Include known failures.
3. **Draft v1 of the judge prompt** using the four-part formula.
4. **Hand-label 30 examples yourself.** This is your ground truth.
5. **Run the judge against those 30.** Calibrate until judge agreement with you is >80%.
6. **Expand to the full set.** Now you can grade new versions of the model/prompt against a stable benchmark.
7. **Track score over time.** Wire it into CI if possible so prompt changes can't ship without an eval pass.

## Output

A working eval suite with:
- A defined judge prompt per criterion
- A labeled ground-truth set (30-200 examples)
- A scoring dashboard (CSV or notebook)
- A pass/fail threshold tied to the release decision

## Tips

- PMs write the judge prompt; engineers wire the harness. Don't outsource the rubric.
- One excellent eval beats ten mediocre ones.
- If two reasonable humans disagree on a label, the rubric is too vague — fix the goal/terminology before re-running.
- Don't measure things you wouldn't act on. Every eval should map to a release decision.
- Re-calibrate the judge when you change models — judge behavior drifts too.

---

### Further Reading

- [Beyond vibe checks: A PM's complete guide to evals — Lenny Rachitsky](https://www.lennysnewsletter.com/p/beyond-vibe-checks-a-pms-complete)
- [How to build AI product sense — Lenny Rachitsky](https://www.lennysnewsletter.com/p/how-to-build-ai-product-sense)
