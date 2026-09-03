# PMCR-O Architecture

## Core model

PMCR-O is a self-referential improvement loop with a durable Goal, a changing operational Seed Intent, role-accountable Frames, and a Reflector-owned next-seed handoff.

```text
Human
  |
  v
Messy Seed Intent
  |
  v
Orchestrator
  |  discovers capabilities and manages the Goal
  v
Planner
  |  produces the minimum sufficient PlanFrame
  v
Maker
  |  builds/executes the plan
  v
Checker
  |  independently validates evidence
  v
Reflector
  |  synthesizes the cycle and owns the next Seed Intent
  v
Seed Intent
  |
  +-----------------------------> next PMCR-O cycle
```

The loop is self-referential because the output of one cycle is an executable Seed Intent that becomes the control input of the next cycle.

## Goal versus intent

- **Goal**: durable high-level objective managed by the Orchestrator.
- **Messy Seed Intent**: the literal human-provided message or command. It is preserved verbatim as provenance and is not assumed to be well-formed.
- **Seed Intent**: the current structured, executable intent for the next cycle. After initialization, the Reflector normally owns production of the next Seed Intent.
- **Converged Intent**: the sufficiently resolved operational objective reached when more refinement is not expected to materially improve the result.

Once a cycle has a canonical Seed Intent, the original Messy Seed Intent is provenance, not the active control input.

## The Orchestrator

The Orchestrator is a meta-controller, not merely a worker router. It can also act as an orchestrator-worker while establishing the first operational path: discover installed capabilities, resolve plugin/skill addresses, select an initial strategy, and manage the Goal across cycles.

It must not impersonate the Reflector as the authority for the next Seed Intent.

## Capability address

Seed Intent is capability-addressable through the marketplace convention:

```text
/[plugin]:[skill] [optional instructions]
```

This syntax lets a Seed Intent resolve against the installed capability surface. Plugin/skill choice is informed by the Orchestrator, Planner, Maker, and Checker evidence; the Reflector packages the resulting next action as the next Seed Intent.

## Self-reference and backward flow

Each Frame declares its role and points to the relevant prior evidence and cycle state. The backward flow is accountability: a claim can be traced to the role that made it, the artifact it acted on, the check that evaluated it, and the reflection that changed future behavior.

A trail is therefore an accountable sequence of Frames, not a transcript.
