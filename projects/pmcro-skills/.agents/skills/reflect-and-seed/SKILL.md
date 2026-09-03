---
name: reflect-and-seed
description: Close the cycle, preserve accountable Frame history, promote earned knowledge, and produce the next executable Seed Intent or terminal disposition. Invoke as /pmcro-skills:reflect-and-seed.
---

# Reflect and Seed

## Invocation

```text
/pmcro-skills:reflect-and-seed
```

Use `/pmcro-skills:queue-enqueue` for follow-up queue writes. Consult `/pmcro:intent-refinement`, `/pmcro:accountability-and-trails`, and `/pmcro:seed-intent-contract` for semantic contracts.

## Ownership

The Reflector is the default and authoritative producer of the next canonical Seed Intent after a cycle. It does not invent a seed without evidence: the next Seed Intent is synthesized from Goal, Orchestrator/Planner/Maker/Checker Frames, artifacts, observations, constraints, failures, strategy history, and learned outcomes.

## Required Seed form

The next Seed Intent is executable and capability-addressable:

```text
/[plugin]:[skill] [optional instructions]
```

Record the command plus lineage metadata. The original human message remains Messy Seed Intent provenance and is not the active next-cycle command.

## Actions
1. Write the cycle trail under `.pmcro/trails/<cycle-id>.md`, preserving the role Frames and intent transition.
2. Record what was planned, executed, checked, learned, and rejected.
3. Promote justified observations into scoped constraints, rules/policies, O-Mode strategy evidence, skill candidates, training/evaluation examples, or audit-only history.
4. Mark the queue item `done` or `blocked` as appropriate.
5. Determine whether another cycle is justified.
6. When another cycle is justified, emit the next executable Seed Intent from the accumulated evidence and preserve its parent lineage.
7. When the Goal is complete, converged, superseded, or blocked, record the terminal disposition and evidence.

## Knowledge discipline

A single observation is not automatically a universal rule. Preserve scope, confidence, provenance, recurrence, and supersession. Repeated validated experience may strengthen operational policy or become a candidate reusable skill.

## Failure / strategy change

When Checker's `verdict` is `fail`, close the current cycle and record RetryContext. Do not send control back to Maker or Planner mid-cycle. The Reflector should consider whether repeated failure warrants an O-Mode strategy transition before producing the next Seed Intent.

## Autonomy contract

The next cycle must be restartable from durable repository state: session-state, queue, constraints, approvals, and trails. Chat memory is optional enrichment, not the continuity boundary.
