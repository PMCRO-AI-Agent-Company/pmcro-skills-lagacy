---
name: initialize
description: Bootstrap a PMCR-O session by loading framework instructions, capability metadata, durable state, trails, constraints, and approvals before autonomous execution. Invoke with /pmcro:initialize.
---

# PMCR-O Initialize

Use this skill at the start of a runtime session or when a session must be reconstructed from durable state.

## Contract

1. Inspect `.agents/` instructions and the installed plugin/skill capability surface.
2. Load the `pmcro` semantic contracts.
3. Load `.pmcro/session-state.md`, queue, constraints, approvals, and relevant trails.
4. Establish the current Goal and active Seed Intent, if any.
5. Treat a new human message as immutable Messy Seed Intent.
6. Resolve explicit `/[plugin]:[skill] [optional instructions]` commands against the marketplace.
7. Hand control to the Orchestrator for the PMCR-O cycle.

Initialization does not invent the Reflector's Seed Intent. It prepares the context in which the cycle can produce one.

## Continuity

Durable files are the continuity boundary. Chat history may add context, but the system must be able to resume from `.pmcro/` and the installed framework without requiring the original conversation transcript.

## Safety

Do not infer blanket approvals, credentials, or external authority from prior sessions. Existing approval records remain scoped and must still satisfy the current TYPE1 operation.
