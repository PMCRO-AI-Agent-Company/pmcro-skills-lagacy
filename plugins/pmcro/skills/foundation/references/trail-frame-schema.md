# PMCR-O Trail Frame Schema

Trail Frames are structured, self-referential records intended to be auditable and optionally usable as training/evaluation data.

## Minimum frame

```yaml
frame:
  frame_id: frame-001
  trail_id: trail-001
  cycle_id: cycle-001
  role: orchestrator|planner|maker|checker|reflector
  input_ref: frame-or-seed-id
  output: structured role result
  evidence_refs: []
  backward_refs: []
  timestamp: 2026-09-03T00:00:00Z
  run_id: null            # set only if this frame's cycle involved a live Run
  checkpoint_ref: null    # path to the checkpoint that was active, if any
  recovery_decision: null # resume|compensate|retry|null, plus evidence, if this frame followed an interruption
```

## Role additions

Planner Frames should identify the current Seed Intent, minimum sufficient plan, capabilities required, and acceptance conditions.

Maker Frames should identify the actual work performed, capability/tool usage, artifacts, and execution outcome.

Checker Frames should identify independent checks, evidence, verdict, blockers, and failed acceptance criteria.

Reflector Frames should identify lessons, earned knowledge, strategy changes, terminal disposition, and the next executable Seed Intent when applicable.

Orchestrator Frames should identify Goal state, capability resolution, dispatch decision, and O-Mode strategy selection.

## Training/evaluation fields

Where safe and appropriate, a frame may additionally contain:

```yaml
learning:
  eligible_for_training: false
  eligible_for_evaluation: true
  knowledge_class: evaluation_case
  generalization_scope: null
  confidence: provisional
  source_trails: [trail-001]
```

Training eligibility is a data-governance decision. Audit history and private/transient information should not automatically become training data.
