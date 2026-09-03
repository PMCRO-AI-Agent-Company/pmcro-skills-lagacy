# Accountability, Frames, and Trails

## Frames

A PMCR-O trail is composed of self-referential Frames. Each Frame identifies its role, cycle, input, output, evidence, and relationships to other Frames.

Typical role Frames are:

- OrchestratorFrame — capability discovery, Goal management, dispatch, and O-Mode selection.
- PlannerFrame — minimum sufficient plan and required capabilities.
- MakerFrame — work actually performed and artifacts produced.
- CheckerFrame — independent validation and evidence.
- ReflectorFrame — synthesis, lessons, earned constraints, and next Seed Intent.

## Backward flow

Frames point backward to the evidence and prior phase they depend on. A later Frame can therefore be traced to the claim, action, artifact, or observation that caused it.

```text
ReflectorFrame
    <- CheckerFrame
        <- MakerFrame
            <- PlannerFrame
                <- OrchestratorFrame
                    <- Seed Intent
```

This backward flow is the accountability layer. It is intended to answer: who decided this, what evidence supported it, what actually happened, and what changed because of it?

## Trail schema

A durable trail should capture at least:

```yaml
trail:
  trail_id: trail-001
  goal_id: goal-001
  messy_seed_intent: raw human message
  seed_intent: /plugin:skill instructions
  frames:
    - role: orchestrator
      frame_id: frame-001
      output: ...
    - role: planner
      frame_id: frame-002
      output: ...
    - role: maker
      frame_id: frame-003
      output: ...
    - role: checker
      frame_id: frame-004
      output: ...
    - role: reflector
      frame_id: frame-005
      output: ...
  learned_knowledge: ...
  next_seed_intent: /plugin:skill instructions
```

## Learned knowledge

Do not treat every observation as a universal rule. The Reflector may propose:

- a **constraint** when a boundary is demonstrated;
- a **rule/policy** when repeated experience supports operational guidance;
- a **strategy preference** when evidence suggests an O-Mode transition;
- a **skill candidate** when behavior generalizes into a reusable capability;
- a **training/evaluation example** when the frame is useful for model improvement;
- an **audit record** when information should remain historical without becoming active knowledge.

The narrowest valid scope should be preserved. Evidence should support confidence and later supersession.

## Example

A Maker using a permitted interaction path receives a service challenge. Checker verifies the workflow did not complete. Reflector records an earned constraint scoped to the affected service and interaction context, then issues a new Seed Intent using a compliant alternative strategy. The original failure remains part of the trail instead of being erased.
