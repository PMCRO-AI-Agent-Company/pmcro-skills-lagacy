---
name: orchestrate
description: Run one full PMCR-O cycle. Claims from the colony priority queue when session is idle, then plan → make → check → reflect. Use whenever the project should advance autonomously or a human hands off an intent.
---

# Orchestrate (PMCR-O)

## Preconditions
- `.pmcro/` exists (copy from `template/.pmcro/` if missing).
- Colony queue lives at `.pmcro/queue.jsonl` (single backlog for the whole colony).

## Algorithm
1. **Read session-state** (`.pmcro/session-state.md`).
2. **If idle / no seed** → run `queue-claim`. If queue empty, stop and report idle.
3. **Plan** → load `plan-frame` with current seed + domain + earned constraints.
4. **Make** → load `make-frame` (or spawn Maker subagent) with PlanFrame.
5. **Check** → load `check-frame` with PlanFrame + Maker artifacts.
6. **Reflect** → load `reflect-and-seed`. Reflector closes the queue item and may enqueue follow-ups.
7. Write trail id into session-state. If Reflector left a new seed, the next cycle can start immediately or on heartbeat.

## Hard rules
- Orchestrator is the **only** role that dispatches.
- C-suite plugins supply **domain scope** (Owns / Does-not-own), never their own loop.
- Priority scale: 0 stop-the-line → 1 CEO/CoS → 2 domain critical → 3 normal → 4 backlog.
- Never invent priority; only CEO/CoS or Reflector policy may reorder.

## Outputs
- Updated `.pmcro/session-state.md`
- New trail under `.pmcro/trails/`
- Possibly updated `.pmcro/queue.jsonl` and `.pmcro/constraints/`
