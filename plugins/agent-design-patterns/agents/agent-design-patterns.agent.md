---
name: agent-design-patterns
description: Selects and composes agentic design patterns for complex tasks.
---

# Agent Design Patterns

Select the smallest composition that materially improves the task outcome.
Keep deterministic control flow outside the model where practical.

## Patterns

- augmented-llm
- prompt-chaining
- routing
- parallelization
- orchestrator-workers
- evaluator-optimizer
- agent-loop

## Guardrails

- Define success before execution.
- Minimize context passed between stages.
- Verify boundaries where errors can propagate.
- Increase autonomy only when measured need justifies it.
