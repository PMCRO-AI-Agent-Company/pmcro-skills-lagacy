# Earned Knowledge: constraint-20260903-090939-powershell-array-return-wrapping

constraint_id: constraint-20260903-090939-powershell-array-return-wrapping
kind: constraint
scope: plugins/pmcro-loop/engine (PowerShell array-returning functions)
status: active
superseded_by: 
created_at: 2026-09-03T14:09:39Z

## Statement
Any PmcroEngine.psm1 function that returns an array (e.g. Get-PmcroQueue, Find-PmcroRecoverableRuns, Find-PmcroUnresolvedIntake) must have its result wrapped in @(...) at the call site before .Count or += is used on it. PowerShell unrolls a single-element or empty array return onto the pipeline, silently binding the receiving variable to a bare object or $null instead of a collection. Observed independently twice: once as an empty-array unroll (Find-PmcroRecoverableRuns, run-cycle.ps1 Step 0, cycle-20260903-123224), once as a single-element unroll on the += operator (Add-PmcroIntake appending to Get-PmcroQueue's result, cycle-20260903-125025). Both were caught in the isolated fixture before reaching live files, but the recurrence across two independently-written functions elevates this from a one-off note to an active engine-wide convention.

## Evidence (source trails)
- cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine
- cycle-20260903-125025-task-seed-intent-queue-ingress

## Narrowest valid scope
Per accountability-and-trails.md: the narrowest valid scope should be
preserved, and evidence should support confidence and later supersession.
Widening this record's scope beyond what the cited evidence actually
demonstrated requires new evidence, not an edit to this file -- write a
new record and set this one's status to superseded / superseded_by
instead of loosening scope in place.