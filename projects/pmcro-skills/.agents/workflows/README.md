# .agents/workflows

Local workflow catalog boundary for PMCR-O.

## Ownership

The skills repository defines the governance and contracts that a workflow must satisfy. The runtime execution host owns executable PMCR-O declarative workflow definitions and their MAF/Aspire/MCP/HIL bindings.

Do not create a second hand-written PMCR-O loop here. Workflow definitions placed in this directory are catalog or specification artifacts unless explicitly bound by the runtime.

## Canonical lifecycle

```text
Orchestrate → Plan → Make → Check → Reflect → Seal
```

Checker failure closes the current cycle through Reflector; retry is a new cycle, not an in-cycle jump back to Maker or Planner.

## Boundaries

- Orchestrator is the dispatcher, not the workflow engine.
- Planner, Maker, Checker, and Reflector own their respective phase artifacts.
- TYPE1 operations require recorded approval before execution.
- Memorykeeper and Trailkeeper are supporting roles, not lifecycle phases.
- `.pmcro/` remains authoritative for queue, session continuity, trails, and earned constraints.
- The runtime is responsible for translating the declarative workflow into executable workflow graphs.
