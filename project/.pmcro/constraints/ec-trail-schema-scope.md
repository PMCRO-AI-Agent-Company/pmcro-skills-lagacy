# EC: Trail schema is per-repo, not global

status: proposed (first observation, single trail so far — promote after a
second independent cycle confirms)
source_trail: cycle-20260902-000010-task-understand-pmcro-framework

## Rule
Do not assume one universal "sealed trail" schema across all PMCR-O repos.

- P:/agent-skills (this marketplace repo, plugins/pmcro-loop) implements
  trails as ONE markdown file per cycle at
  .pmcro/trails/cycle-<yyyyMMdd-HHmmss>-<task_id>.md with
  '## PlanFrame/MakeFrame/CheckFrame/Reflection' sections and a
  trail_sealed: true|false flag (see engine/PmcroEngine.psm1,
  engine/run-cycle.ps1).
- The separate pmcro-agent-system / pmcro-runtime (.NET/MAF) project uses a
  different schema: GUID folder + per-phase JSONL + disposition.json.

Before reporting "no sealed trail found" or "trail schema violated" in
either repo, check which repo you are in and apply that repo's own engine
convention, not the other one's.
