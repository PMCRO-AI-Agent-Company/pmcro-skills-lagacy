# Architecture Governance

## Purpose

This document defines the minimum governance contract for architecture changes in pmcro-skills.
It complements `colony-laws.md`; it does not override constitutional rules.

## Authority

- `colony-laws.md` is authoritative for dispatch, queue, mutation, trails, and portability.
- `CONTEXT.md` describes repository topology and role boundaries.
- `INSTRUCTIONS.md` describes operational invocation and handoffs.
- Active cycle trails are the evidence record for individual changes.

## Change boundaries

Architecture changes must identify the affected boundary before implementation.
The Planner describes the intended change and acceptance evidence.
The Maker executes only the approved scope.
The Checker independently validates behavior and structure.
The Reflector records disposition and any durable lesson.

## Workflow boundaries

Aspire AppHost is the composition boundary for deployable services and MCP resources.
Production projects belong under `src/`; tests belong under `tests/`.
Cross-project references must remain consistent with the root solution and package management.

## Governance boundaries

TYPE1 mutations require explicit recorded approval before Maker execution.
Destructive deletion, secrets, security bypasses, and irreversible external actions require separate approval.
No architecture change may introduce a second queue or a parallel lifecycle.

## Validation

Every architecture mutation must include structural validation and, where applicable, build/test evidence.
A cycle is complete only after CheckFrame passes and the trail is sealed in the same session.
