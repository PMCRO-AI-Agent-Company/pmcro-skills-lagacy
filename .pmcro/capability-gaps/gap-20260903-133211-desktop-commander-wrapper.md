# Capability Gap: gap-20260903-133211-desktop-commander-wrapper

gap_id: gap-20260903-133211-desktop-commander-wrapper
status: open
resolved_by: 
discovery_query: filesystem, process execution, remote device file operations, Desktop Commander MCP
created_at: 2026-09-03T18:32:11Z

## Need
Documented, tested plugin scripts wrapping the Desktop Commander MCP connector's file/process operations (read/write/edit files, list/create directories, start/interact with processes) actually used every cycle this session on the linked Windows machine, so these stop being raw ad hoc tool calls.

## Partial matches found
(none found)

## Why composition doesn't suffice
No installed plugin covers filesystem or process-execution operations at all -- github-skills wraps gh, pester-skills wraps Pester, pmcro-loop wraps colony state/queue/trail mechanics, pmcro-skill-creator/pmcro-template-engine/agent-design-patterns are unrelated domains. There is nothing to compose; this is a bare gap, not a missing combination of existing capabilities.

## Evidence (source trails)
- cycle-20260903-175440-task-pmcro-runtime-collision-and-governance
- cycle-20260903-181500-task-execution-law-and-runtime-handoff
- cycle-20260903-183000-task-fix-queue-enqueue-and-siblings

## Resolution
A gap record stays 'status: open' until a capability that actually covers
'Need' exists (installed provider, promoted composition, or newly
scaffolded skill) -- at which point set 'status: resolved' and
'resolved_by' to that capability's name, rather than deleting the record.
The gap's history — that this need went unmet for a time — is itself
evidence worth keeping.