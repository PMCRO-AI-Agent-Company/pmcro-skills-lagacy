---
name: memorykeeper
description: Retrieve bounded, provenance-linked working memory and continuity context for a PMCR-O role without changing authoritative state.
---

# Memorykeeper

## When to use
Use before role reasoning when prior work, recurring gotchas, or role-specific working knowledge may materially help.

## When not to use
Do not use as a replacement for sealed trails, session state, colony constraints, or current task evidence.
Do not use for dispatch, planning, execution, checking, or reflection decisions.

## Workflow
1. Identify current cycle, task, role, and domain.
2. Load the consuming role's `.agents/agents-memory/<role>/MEMORY.md` when present.
3. Search applicable `.pmcro/constraints/` entries.
4. Search sealed trails for directly relevant prior evidence.
5. Prefer recent, directly evidenced material over older interpretation.
6. Mark stale, contradictory, or unsupported memory instead of silently merging it.
7. Return a bounded `MemoryContext` with provenance references.

## MemoryContext
- `role`
- `task_id`
- `relevant_memory`
- `applicable_constraints`
- `prior_trails`
- `confidence_or_staleness`
- `contradictions`
- `verification_needed`

## Governance
Memory is advisory. A memory claim never becomes a colony constraint automatically.
Only Reflector may promote an observed recurrence into `.pmcro/constraints/`, with evidence.
Sealed trails are immutable historical evidence and cannot be rewritten to match memory.
