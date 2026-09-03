---
name: trailkeeper
description: Preserves PMCR-O cognitive trail history, lifecycle transitions, and evidence provenance. Use when recording or reconciling cycle history, trail state, or cross-cycle continuity; do not use for dispatch, planning, execution, checking, or next-seed decisions.
---

# Trailkeeper

Preserve an auditable cognitive trail without becoming another orchestration or
reflection mechanism.

## When to Use

- Record a verified lifecycle transition or cycle event.
- Reconcile trail continuity across cycles.
- Link durable knowledge to its originating trail and evidence.
- Detect missing, contradictory, or unverifiable trail state.

## When Not to Use

- Dispatching: use `orchestrate`.
- Planning: use `plan-frame`.
- Execution: use `make-frame`.
- Acceptance validation: use `check-frame`.
- Cycle disposition or next-seed decisions: use `reflect-and-seed`.

## Workflow

1. Read the current `.pmcro/session-state.md` and applicable cycle trail.
2. Identify the lifecycle transition and its authoritative evidence.
3. Record only observed facts and repository-relative references.
4. Preserve the cycle boundary: never reopen a sealed trail to repair history.
5. Link cross-cycle continuity to trail IDs rather than copying unsupported
   conclusions into history.
6. When memory is updated, retain provenance to the source trail; memory is
   interpretation, while the trail remains historical evidence.
7. Report contradictions or missing evidence for the owning role to resolve.

## Validation

- [ ] The trail corresponds to the correct cycle ID.
- [ ] Lifecycle state agrees with session-state and queue evidence.
- [ ] Evidence is observable and repository-relative.
- [ ] Sealed history was not rewritten.
- [ ] Memory references retain source provenance.
- [ ] No dispatch, planning, execution, checking, or seed decision was taken.

## Common Pitfalls

- Treating memory as authoritative history: return to the sealed trail.
- Letting Trailkeeper become Reflector: record; do not decide the next seed.
- Inventing lifecycle events: report missing evidence instead.
- Using absolute machine paths: resolve paths from repository context.


## Capability provenance

When a cycle uses a discovered plugin or skill, record the provider name,
provider project, manifest-relative path, capability selected, and the
resolution reason in the Cognitive Trail. Treat `.pmcro/capability-registry.json`
as generated evidence: refresh it when installed projects change and do not
promote its contents to colony law without Reflector review.
