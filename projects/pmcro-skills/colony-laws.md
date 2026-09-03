# Colony Laws

Cross-repo governance rules for any PMCR-O implementation in this colony
(agent-skills/plugins/pmcro-loop, pmcro-runtime, pmcro-agent-system, and
any future repo). Source: extracted from active `.clinerules` and
`orchestrate`/`queue-*` SKILL.md hard rules already in force.

## Dispatch
- Orchestrator is the **only** role that dispatches a cycle.
- C-suite / domain plugins supply domain scope (Owns / Does-not-own) —
  never their own loop.

## Queue
- One shared colony priority queue per repo (`.pmcro/queue.jsonl`).
- Priority scale: 0 stop-the-line, 1 CEO/CoS, 2 domain critical,
  3 normal, 4 backlog.
- Never invent priority; only CEO/CoS or Reflector policy may reorder.
- If queue is empty and a human hands off an intent, enqueue it first
  (`created_by: human`) — do not bypass the queue.

## Mutation & trails
- TYPE1 (state-changing) mutations require explicit human approval
  before execution.
- All trail sealing must happen in the same session as the edit.
- No shell echo for writes — use native write tools.

## Portability
- W-PORTABILITY-001: no literal drive-letter paths in code/config.
  Config must resolve paths relative to repo root or via environment.
