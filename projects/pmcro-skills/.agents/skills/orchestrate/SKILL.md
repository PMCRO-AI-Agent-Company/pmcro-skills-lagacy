---
name: orchestrate
description: Run PMCR-O while managing the durable Goal, resolving capability addresses, selecting O-Mode: Dynamic Resonance, and dispatching Planner → Maker → Checker → Reflector. Invoke as /pmcro-skills:orchestrate.
---

# Orchestrate (PMCR-O)

## Invocation

```text
/pmcro-skills:orchestrate [optional human intent]
```

Use `/pmcro:<skill>` for semantic contracts and `/pmcro-skills:<skill>` for executable governance/capabilities.

## Intent contract

- A supplied human message is immutable **Messy Seed Intent**.
- The Orchestrator owns the durable high-level **Goal**.
- The current **Seed Intent** is the executable operational command for the current cycle.
- The Reflector normally owns production of the next Seed Intent after a cycle.
- Later cycles consume the Reflector-produced Seed Intent rather than reusing the original Messy Seed Intent.

## Responsibilities

The Orchestrator is a meta-controller. It manages the Goal, inspects the installed marketplace capability surface, resolves `/[plugin]:[skill]` addresses, can act as an orchestrator-worker during discovery/routing, selects O-Mode strategy, and is the only role that dispatches.

The Orchestrator does not replace the Reflector as the authority for the next canonical Seed Intent.

## Algorithm
1. Preserve explicit human input as Messy Seed Intent.
2. Read `.pmcro/session-state.md`, queue, constraints, approvals, and active trail.
3. Establish/resume the Goal and current Seed Intent.
4. Resolve the Seed Intent command against the available marketplace capabilities.
5. Select O-Mode: Dynamic Resonance strategy using current intent, capability availability, trail evidence, repeated failures, constraints, approvals, and expected progress.
6. Dispatch Planner → Maker → Checker → Reflector.
7. Reflector closes the cycle and either emits the next Seed Intent or establishes a terminal/converged status.
8. Continue from the Reflector-produced Seed Intent subject to cycle limits and stop conditions.

## O-Mode adaptation

Repeated failures are evidence for strategy change, not permission to retry forever. O-Mode can select direct execution, repeated optimization, options/clarification, chain/tree/graph-style deliberation, ReAct-style observation/action, or another supported strategy. Strategy changes and their evidence belong in the trail.

## Failure path

Phase order is strictly Orchestrator → Planner → Maker → Checker → Reflector. A failed CheckFrame closes the current cycle through Reflector; Reflector records RetryContext and emits a fresh Seed Intent when another cycle is justified. No mid-cycle retry.

## Hard rules
- Orchestrator is the only role that dispatches.
- Reflector normally owns the next Seed Intent.
- Never silently transform normalized Seed Intent into claimed verbatim human intent.
- Never read or write another repo's `.pmcro/` state.
- TYPE1 approval, scope, and human-decision boundaries remain authoritative.

## Outputs
- Updated `.pmcro/session-state.md`
- New accountable trail under `.pmcro/trails/`
- Next Seed Intent or terminal/converged disposition
- Possibly updated `.pmcro/queue.jsonl`, `.pmcro/constraints/`, and approvals

## Implementation
The engine can deterministically read state, claim queue items, allocate trails, and enforce approval checks. Model-driven role work fills the role Frames and seals the trail. The semantic contracts live in the `pmcro` plugin.
