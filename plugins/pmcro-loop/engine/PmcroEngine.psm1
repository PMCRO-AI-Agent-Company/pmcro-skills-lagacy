# PmcroEngine.psm1
# Deterministic (non-LLM) state/queue/trail/approval mechanics for PMCR-O.
# This module does NOT call any model API. It manages .pmcro state.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Internal key:value helpers (shared by session-state.md and checkpoint files)
# ---------------------------------------------------------------------------

function ConvertFrom-PmcroKeyValueText {
    param([Parameter(Mandatory)][string]$Text)
    $lines = $Text -split "`n"
    $state = [ordered]@{}
    foreach ($line in $lines) {
        if ($line -match '^([a-z_]+):\s?(.*)$') { $state[$matches[1]] = $matches[2].Trim() }
    }
    return $state
}

function ConvertTo-PmcroKeyValueText {
    param([Parameter(Mandatory)][string]$Title,[Parameter(Mandatory)][System.Collections.Specialized.OrderedDictionary]$Fields)
    $out = @("# $Title", '')
    foreach ($k in $Fields.Keys) { $out += "$k`: $($Fields[$k])" }
    return ($out -join "`n")
}

function Get-PmcroUtcNowIso {
    return (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
}

# ---------------------------------------------------------------------------
# Session state
# ---------------------------------------------------------------------------

function Get-PmcroSessionState {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'session-state.md'
    if (-not (Test-Path $path)) { throw "session-state.md not found at $path" }
    $state = ConvertFrom-PmcroKeyValueText -Text (Get-Content -Raw $path)
    return [pscustomobject]$state
}

function Set-PmcroSessionState {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][hashtable]$Fields)
    $current = Get-PmcroSessionState -PmcroRoot $PmcroRoot
    $merged = [ordered]@{}
    foreach ($p in $current.PSObject.Properties) { $merged[$p.Name] = $p.Value }
    foreach ($k in $Fields.Keys) { $merged[$k] = $Fields[$k] }
    $text = ConvertTo-PmcroKeyValueText -Title 'Session State' -Fields $merged
    Set-Content -Path (Join-Path $PmcroRoot 'session-state.md') -Value $text -NoNewline
}

# ---------------------------------------------------------------------------
# Queue
# ---------------------------------------------------------------------------

function Get-PmcroQueue {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'queue.jsonl'; if (-not (Test-Path $path)) { return @() }
    $items = @(); foreach ($line in (Get-Content $path)) { if (-not [string]::IsNullOrWhiteSpace($line)) { $items += ConvertFrom-Json $line } }
    return $items
}

function Save-PmcroQueue {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][array]$Items)
    $lines = @(); foreach ($item in $Items) { $lines += ConvertTo-Json -InputObject $item -Compress }
    Set-Content -Path (Join-Path $PmcroRoot 'queue.jsonl') -Value ($lines -join "`n") -NoNewline
}

function Add-PmcroQueueItem {
    <#
    .SYNOPSIS
      Append one fully-scoped work item to the shared colony queue.

    .DESCRIPTION
      For a raw, not-yet-classified message use Add-PmcroIntake instead
      (see seed-intent-contract.md). This is queue-enqueue's actual
      implementation: Reflector (follow-ups), CEO/CoS (directed work), or
      a human hand off an item that already has a clear seed_intent, and
      this function is what makes appending it validated and
      duplicate-id-checked every time, instead of hand-written JSONL.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$Id,
        [Parameter(Mandatory)][string]$SeedIntent,
        [ValidateRange(0,4)][int]$Priority = 3,
        $Domain = $null,
        [string]$CreatedBy = 'human',
        [string[]]$BlockedBy = @()
    )
    # @() wrap required -- see Add-PmcroIntake's own note: Get-PmcroQueue's
    # array return is unrolled by PowerShell when the queue has exactly one
    # item, and this function appends with +=, which needs a real array.
    $queue = @(Get-PmcroQueue -PmcroRoot $PmcroRoot)
    if ($queue | Where-Object { $_.id -eq $Id }) {
        throw "Queue already contains an item with id '$Id' -- ids must be unique. Pick a different id, or update the existing item instead of duplicating it."
    }
    $item = [ordered]@{
        id = $Id
        priority = $Priority
        domain = $Domain
        status = 'open'
        seed_intent = $SeedIntent
        blocked_by = @($BlockedBy)
        created_by = $CreatedBy
        created_at = Get-PmcroUtcNowIso
    }
    $queue += [pscustomobject]$item
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    return [pscustomobject]$item
}

# ---------------------------------------------------------------------------
# Intake: the message queue as the durable ingress boundary (see
# pmcro:foundation -> seed-intent-contract.md, and .agents/commands/send-message.md)
# ---------------------------------------------------------------------------

function Add-PmcroIntake {
    <#
    .SYNOPSIS
      Durably persists a raw human/agent/external message to queue.jsonl as
      an 'intake' item, verbatim, BEFORE any classification reasoning. No
      model call -- this must be safe to run as the very first action of
      /send-message so a message survives even if the session is
      interrupted immediately after receiving it (the exact failure mode
      that lost 3 of 4 items in an earlier interrupted session).
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet('human','agent','external','system')][string]$Source = 'human',
        [int]$Priority = 2,
        $Domain = $null
    )
    # @() wrap is required here: Get-PmcroQueue's array return is unrolled by
    # PowerShell when the queue has exactly one item (same class of pitfall as
    # the empty-array case documented on Find-PmcroRecoverableRuns), and this
    # function appends to $queue with +=, which needs a real array/collection.
    $queue = @(Get-PmcroQueue -PmcroRoot $PmcroRoot)
    $id = "task-intake-$(Get-Date -Format 'yyyyMMdd-HHmmssfff')"
    $item = [ordered]@{
        id = $id
        priority = $Priority
        domain = $Domain
        status = 'intake'
        seed_intent = $Message
        messy_seed = $true
        blocked_by = @()
        created_by = $Source
        created_at = Get-PmcroUtcNowIso
    }
    $queue += [pscustomobject]$item
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    return [pscustomobject]$item
}

function Find-PmcroUnresolvedIntake {
    <#
    .SYNOPSIS
      Deterministically finds intake items awaiting classification.
      Mirrors Find-PmcroRecoverableRuns but for the ingress side: a
      message that was durably captured but never resolved into a
      canonical open item, an informational close, or a split -- because
      the session that received it was interrupted before classifying it.

    .NOTES
      Wrap the result in @(...) at call sites -- same PowerShell
      empty-array-return caveat as Find-PmcroRecoverableRuns.
    #>
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    return @($queue | Where-Object { $_.status -eq 'intake' })
}

function Resolve-PmcroIntake {
    <#
    .SYNOPSIS
      Rewrites an intake item in place once it has been classified. The
      original raw message is preserved permanently in messy_seed_text for
      provenance (seed-intent-contract.md: "preserve it exactly"), whatever
      the disposition. This function does not decide the disposition --
      that is Orchestrator/Planner-level reasoning, same boundary as every
      other classification decision in this engine.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$TaskId,
        [Parameter(Mandatory)][ValidateSet('enqueued','informational','split')][string]$Disposition,
        [string]$RefinedSeedIntent,
        [int]$Priority,
        [string]$Domain,
        [string]$ResolutionNote
    )
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    $target = $queue | Where-Object { $_.id -eq $TaskId }
    if (-not $target) { throw "Resolve-PmcroIntake: task '$TaskId' not found in queue." }
    if ($target.status -ne 'intake') { throw "Resolve-PmcroIntake: task '$TaskId' is not an intake item (status=$($target.status))." }
    foreach ($item in $queue) {
        if ($item.id -ne $TaskId) { continue }
        $item | Add-Member -NotePropertyName messy_seed_text -NotePropertyValue $item.seed_intent -Force
        $item.PSObject.Properties.Remove('messy_seed')
        switch ($Disposition) {
            'enqueued' {
                if (-not $RefinedSeedIntent) { throw "Resolve-PmcroIntake: 'enqueued' requires -RefinedSeedIntent." }
                $item.status = 'open'
                $item.seed_intent = $RefinedSeedIntent
                if ($PSBoundParameters.ContainsKey('Priority')) { $item.priority = $Priority }
                if ($PSBoundParameters.ContainsKey('Domain')) { $item | Add-Member -NotePropertyName domain -NotePropertyValue $Domain -Force }
            }
            'informational' {
                $item.status = 'done'
                $note = if ($ResolutionNote) { $ResolutionNote } else { 'informational -- no action needed' }
                $item | Add-Member -NotePropertyName resolution_note -NotePropertyValue $note -Force
            }
            'split' {
                $item.status = 'done'
                $note = if ($ResolutionNote) { $ResolutionNote } else { 'split into derived open items (see derived_from_intake)' }
                $item | Add-Member -NotePropertyName resolution_note -NotePropertyValue $note -Force
            }
        }
    }
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    return ($queue | Where-Object { $_.id -eq $TaskId })
}

# ---------------------------------------------------------------------------
# Run identity: runtime instance id (for lease_owner = "<role>@<instance-id>")
# ---------------------------------------------------------------------------

function Get-PmcroRuntimeInstanceId {
    # Deterministic, no model call: identifies *this process*, not a person or chat.
    $host_ = if ($env:COMPUTERNAME) { $env:COMPUTERNAME } elseif ($env:HOSTNAME) { $env:HOSTNAME } else { try { [System.Net.Dns]::GetHostName() } catch { 'unknown-host' } }
    return "$host_-$PID"
}

# ---------------------------------------------------------------------------
# Lease / heartbeat (see pmcro:foundation -> run-recovery-lease.md)
# ---------------------------------------------------------------------------

function Update-PmcroLease {
    <#
    .SYNOPSIS
      Refreshes heartbeat_at/lease_expires_at (and sets lease_owner if not
      already set) on a claimed queue item. Deterministic bookkeeping only --
      does not decide whether the Run is behaving correctly.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$TaskId,
        [string]$LeaseOwner,
        [int]$TtlMinutes = 30
    )
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    $target = $queue | Where-Object { $_.id -eq $TaskId }
    if (-not $target) { throw "Update-PmcroLease: task '$TaskId' not found in queue." }
    if ($target.status -ne 'claimed') { throw "Update-PmcroLease: task '$TaskId' is not claimed (status=$($target.status)); a lease can only be held on a claimed Run." }
    $existingOwner = if ($target.PSObject.Properties.Name -contains 'lease_owner') { $target.lease_owner } else { $null }
    $ownerToWrite = if ($LeaseOwner) { $LeaseOwner } elseif ($existingOwner) { $existingOwner } else { "orchestrator@$(Get-PmcroRuntimeInstanceId)" }

    # Prevent simultaneous ownership: only the current lease holder may refresh
    # its own lease. A different owner may take over ONLY when the existing
    # lease is stale/expired -- i.e. only via the Recovery path, never by a
    # plain heartbeat/checkpoint call racing an active Run. This is the
    # deterministic enforcement of run-recovery-lease.md's "only one runtime
    # may act on a given Run at a time."
    if ($existingOwner -and ($existingOwner -ne $ownerToWrite) -and -not (Test-PmcroLeaseStale -Item $target)) {
        throw "Update-PmcroLease: task '$TaskId' lease is actively held by '$existingOwner' and has not expired (lease_expires_at=$($target.lease_expires_at)); refusing to transfer to '$ownerToWrite'. Simultaneous ownership prevented -- go through Recovery instead."
    }

    $nowIso = Get-PmcroUtcNowIso
    $expiresIso = (Get-Date).ToUniversalTime().AddMinutes($TtlMinutes).ToString('yyyy-MM-ddTHH:mm:ssZ')
    foreach ($item in $queue) {
        if ($item.id -eq $TaskId) {
            $item | Add-Member -NotePropertyName lease_owner -NotePropertyValue $ownerToWrite -Force
            $item | Add-Member -NotePropertyName heartbeat_at -NotePropertyValue $nowIso -Force
            $item | Add-Member -NotePropertyName lease_expires_at -NotePropertyValue $expiresIso -Force
        }
    }
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    return [pscustomobject]@{ task_id = $TaskId; lease_owner = $ownerToWrite; heartbeat_at = $nowIso; lease_expires_at = $expiresIso }
}

function Test-PmcroLeaseStale {
    <#
    .SYNOPSIS
      True when a claimed queue item's lease has expired or was never
      established (no heartbeat_at/lease_expires_at recorded). This is
      evidence of a possibly-interrupted Run -- NOT a verdict on what
      actually happened. See run-recovery-lease.md Recovery section.
    #>
    param([Parameter(Mandatory)][pscustomobject]$Item)
    if ($Item.status -ne 'claimed') { return $false }
    $hasExpiry = ($Item.PSObject.Properties.Name -contains 'lease_expires_at') -and $Item.lease_expires_at
    $hasHeartbeat = ($Item.PSObject.Properties.Name -contains 'heartbeat_at') -and $Item.heartbeat_at
    if (-not $hasExpiry -or -not $hasHeartbeat) {
        # Pre-run-recovery-lease.md item, or a lease that was never written: treat as
        # not-yet-a-Run, not as stale -- absence of these fields is explicitly
        # normal per run-recovery-lease.md ("Run") for items that predate the contract.
        return $false
    }
    $expires = [datetimeoffset]::Parse([string]$Item.lease_expires_at)
    return ([datetimeoffset]::UtcNow -ge $expires)
}

function Find-PmcroRecoverableRuns {
    <#
    .SYNOPSIS
      Deterministically finds claimed queue items whose lease has expired.
      Does not classify resume/compensate/retry -- that requires inspecting
      actual repository/system state and is deferred to the reasoning layer
      (see run-recovery-lease.md Recovery, steps 2-3).

    .NOTES
      Callers must wrap the result in @(...) before reading .Count (PowerShell
      unrolls an empty array return onto the pipeline, so `$x = Find-PmcroRecoverableRuns ...`
      can bind $x to $null when nothing is found) -- same convention already used
      for Get-PmcroQueue/Get-PmcroApprovals elsewhere in this module.
    #>
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    return @($queue | Where-Object { Test-PmcroLeaseStale -Item $_ })
}

# ---------------------------------------------------------------------------
# Checkpoint (see pmcro:foundation -> run-recovery-lease.md)
# ---------------------------------------------------------------------------

function Get-PmcroCheckpointPath {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][string]$TaskId)
    return Join-Path $PmcroRoot "checkpoints/$TaskId.md"
}

function Set-PmcroCheckpoint {
    <#
    .SYNOPSIS
      Writes/updates the durable Checkpoint file for an active Run and
      refreshes its lease (checkpointing is evidence the Run is still
      alive). Checkpoints are working state, not accountability records --
      they are deleted on terminal Trail disposition (Complete-PmcroRun).
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$TaskId,
        [Parameter(Mandatory)][ValidateSet('orchestrator','planner','maker','checker','reflector')][string]$Phase,
        [string]$LastCompletedStep = '',
        [string]$InProgressOperation = '',
        [string]$ExternalStateExpected = 'unknown - not yet observed',
        [string]$LastFrameId = '',
        [string]$LeaseOwner,
        [int]$TtlMinutes = 30
    )
    $checkpointPath = Get-PmcroCheckpointPath -PmcroRoot $PmcroRoot -TaskId $TaskId
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $checkpointPath) | Out-Null
    $nowIso = Get-PmcroUtcNowIso
    $fields = [ordered]@{
        task_id = $TaskId
        phase = $Phase
        last_completed_step = $LastCompletedStep
        in_progress_operation = $InProgressOperation
        external_state_expected = $ExternalStateExpected
        last_frame_id = $LastFrameId
        updated_at = $nowIso
    }
    $text = ConvertTo-PmcroKeyValueText -Title "Checkpoint: $TaskId" -Fields $fields
    Set-Content -Path $checkpointPath -Value $text -NoNewline

    $relRef = "checkpoints/$TaskId.md"
    $lease = Update-PmcroLease -PmcroRoot $PmcroRoot -TaskId $TaskId -LeaseOwner $LeaseOwner -TtlMinutes $TtlMinutes
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    foreach ($item in $queue) { if ($item.id -eq $TaskId) { $item | Add-Member -NotePropertyName checkpoint_ref -NotePropertyValue $relRef -Force } }
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue

    return [pscustomobject]@{ checkpoint_ref = $relRef; checkpoint_path = $checkpointPath; lease = $lease }
}

function Get-PmcroCheckpoint {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][string]$TaskId)
    $path = Get-PmcroCheckpointPath -PmcroRoot $PmcroRoot -TaskId $TaskId
    if (-not (Test-Path $path)) { return $null }
    $state = ConvertFrom-PmcroKeyValueText -Text (Get-Content -Raw $path)
    return [pscustomobject]$state
}

function Remove-PmcroCheckpoint {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][string]$TaskId)
    $path = Get-PmcroCheckpointPath -PmcroRoot $PmcroRoot -TaskId $TaskId
    if (Test-Path $path) { Remove-Item -Path $path -Force }
}

# ---------------------------------------------------------------------------
# Claim / Complete
# ---------------------------------------------------------------------------

function Claim-PmcroTask {
    param([Parameter(Mandatory)][string]$PmcroRoot,[int]$LeaseTtlMinutes = 30)
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    $open = @($queue | Where-Object { $_.status -eq 'open' })
    if ($open.Count -eq 0) { Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ status='idle'; notes='Queue empty at ' + (Get-Date -Format 'o') }; return $null }
    $next = $open | Sort-Object priority | Select-Object -First 1
    $nowIso = Get-PmcroUtcNowIso
    $leaseOwner = "orchestrator@$(Get-PmcroRuntimeInstanceId)"
    foreach ($item in $queue) { if ($item.id -eq $next.id) { $item.status='claimed'; $item | Add-Member -NotePropertyName claimed_at -NotePropertyValue $nowIso -Force; $item | Add-Member -NotePropertyName claimed_by -NotePropertyValue 'orchestrator' -Force } }
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ status='active'; seed_intent=$next.seed_intent; task_id=$next.id; domain=[string]$next.domain; priority=[string]$next.priority }

    # Establish the Run: claiming this queue item IS establishing the Run
    # identity (task_id doubles as run_id) -- no new store, per
    # run-recovery-lease.md. Write an initial checkpoint + lease.
    Set-PmcroCheckpoint -PmcroRoot $PmcroRoot -TaskId $next.id -Phase 'orchestrator' `
        -LastCompletedStep 'claimed' -InProgressOperation '' `
        -ExternalStateExpected 'unchanged - Run just claimed, no work performed yet' `
        -LeaseOwner $leaseOwner -TtlMinutes $LeaseTtlMinutes | Out-Null

    # Re-read so the returned object reflects the lease/checkpoint fields just written.
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    return ($queue | Where-Object { $_.id -eq $next.id })
}

function Complete-PmcroRun {
    <#
    .SYNOPSIS
      Terminal disposition for a Run: sets the queue item's status,
      clears live Run bookkeeping (lease_owner/heartbeat_at/lease_expires_at/
      checkpoint_ref), and deletes the checkpoint file. The Trail, not the
      Run, is what persists after this -- see run-recovery-lease.md
      "Relationship to Trail/Frame".
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$TaskId,
        [Parameter(Mandatory)][ValidateSet('done','blocked')][string]$FinalStatus
    )
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    $found = $false
    foreach ($item in $queue) {
        if ($item.id -eq $TaskId) {
            $found = $true
            $item.status = $FinalStatus
            foreach ($f in @('lease_owner','heartbeat_at','lease_expires_at','checkpoint_ref')) {
                if ($item.PSObject.Properties.Name -contains $f) { $item.PSObject.Properties.Remove($f) }
            }
        }
    }
    if (-not $found) { throw "Complete-PmcroRun: task '$TaskId' not found in queue." }
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    Remove-PmcroCheckpoint -PmcroRoot $PmcroRoot -TaskId $TaskId
}

# ---------------------------------------------------------------------------
# Trail
# ---------------------------------------------------------------------------

function New-PmcroTrail {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][pscustomobject]$Task)
    $trailId = "cycle-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$($Task.id)"
    $trailsDir = Join-Path $PmcroRoot 'trails'; New-Item -ItemType Directory -Force -Path $trailsDir | Out-Null
    $trailPath = Join-Path $trailsDir "$trailId.md"
    $runId = $Task.id
    $checkpointRef = if ($Task.PSObject.Properties.Name -contains 'checkpoint_ref') { $Task.checkpoint_ref } else { '' }
    $body = @"
# Trail: $trailId

trail_id: $trailId
task_id: $($Task.id)
domain: $($Task.domain)
priority: $($Task.priority)
opened: $(Get-Date -Format 'yyyy-MM-dd')
engine_generated: true
run_id: $runId
checkpoint_ref: $checkpointRef

## Seed intent
$($Task.seed_intent)

## OrchestratorFrame
PENDING -- requires agent/model reasoning. If a recovery decision preceded
this cycle (see run-cycle.ps1 recovery scan), record run_id, checkpoint
evidence, recovery_decision (resume|compensate|retry), and the inspection
evidence here per trail-frame-schema.md before continuing.

## PlanFrame (Planner)
PENDING -- requires agent/model reasoning.

## MakeFrame (Maker)
PENDING -- requires agent/model reasoning.

## CheckFrame (Checker)
PENDING -- requires agent/model reasoning.

## Reflection (Reflector)
PENDING -- requires agent/model reasoning.

trail_sealed: false
"@
    Set-Content -Path $trailPath -Value $body -NoNewline
    Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ last_cycle_id=$trailId }
    return $trailPath
}

function New-PmcroRetrospectiveTrail {
    <#
    .SYNOPSIS
      Allocates a trail skeleton for reconstructing PMCR-O accountability
      from a historical/third-party LLM export (a prior chat transcript, a
      non-PMCR-O agent session's own output, or an earlier interrupted
      session's summary) -- see pmcro:foundation ->
      retrospective-trail-reconstruction.md. File-mechanics only: this
      function does not read or interpret the export, does not decide what
      belongs in each Frame, and does not touch queue.jsonl -- a
      retrospective trail documents PAST work, it does not claim a Run.

    .DESCRIPTION
      Deliberately distinct from New-PmcroTrail in three ways:
      1. Naming: "retro-<timestamp>-<slug>" never collides with a live
         queue-driven "cycle-<timestamp>-<task-id>" trail, so a reader can
         tell at a glance which trails came from an actual live cycle in
         this colony and which were reconstructed after the fact.
      2. No run_id/checkpoint_ref/queue claim: there is no live Run to
         recover if this session is interrupted -- the export itself is
         the durable source, not a lease.
      3. engine_generated: true but native_cycle: false, and a mandatory
         source_export/reconstruction_basis header, so the trail cannot be
         mistaken for one produced by an actual live Checker independently
         verifying evidence as it happened.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][string]$SourceExport,
        [Parameter(Mandatory)][string]$ReconstructionBasis,
        [string]$RelatedTaskId = ''
    )
    if ($Slug -notmatch '^[a-z0-9][a-z0-9-]*$') { throw "New-PmcroRetrospectiveTrail: -Slug must be lowercase-kebab-case (got '$Slug')." }
    $trailId = "retro-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$Slug"
    $trailsDir = Join-Path $PmcroRoot 'trails'; New-Item -ItemType Directory -Force -Path $trailsDir | Out-Null
    $trailPath = Join-Path $trailsDir "$trailId.md"
    $body = @"
# Retrospective Trail: $trailId

trail_id: $trailId
kind: retrospective
engine_generated: true
native_cycle: false
related_task_id: $RelatedTaskId
opened: $(Get-Date -Format 'yyyy-MM-dd')
source_export: $SourceExport
reconstruction_basis: $ReconstructionBasis

## Seed intent (reconstructed)
PENDING -- requires agent/model reasoning. Extract the Messy Seed Intent
and, if determinable from the export, the canonical Seed Intent that was
actually acted on. If the export does not clearly support one, say so --
do not infer a cleaner intent than the source shows.

## OrchestratorFrame (reconstructed)
INSUFFICIENT SOURCE EVIDENCE unless overwritten -- requires agent/model
reasoning against the actual export. Every claim here must be evidenced
(directly supported by the export) or explicitly marked inferred (a
reasonable reconstruction not directly stated in the export). Never
present a reconstructed claim as if it were live independently-verified
evidence -- see retrospective-trail-reconstruction.md.

## PlanFrame (reconstructed)
INSUFFICIENT SOURCE EVIDENCE unless overwritten -- same evidenced/inferred
discipline as above.

## MakeFrame (reconstructed)
INSUFFICIENT SOURCE EVIDENCE unless overwritten -- same evidenced/inferred
discipline as above.

## CheckFrame (reconstructed)
INSUFFICIENT SOURCE EVIDENCE unless overwritten -- a reconstructed
CheckFrame is NOT independent verification; it is, at best, a report of
what the export claims was checked. Record verdict as "reported" rather
than "pass"/"fail" unless this session independently re-verified the
outcome against current live state.

## Reflection (reconstructed)
INSUFFICIENT SOURCE EVIDENCE unless overwritten -- same evidenced/inferred
discipline as above. If the export surfaces genuinely new, still-actionable
work, route it through the normal ingress (/send-message intake or
queue-enqueue), not a bespoke mechanism -- a retrospective trail documents
history, it does not bypass the colony's one shared queue.

trail_sealed: false
"@
    Set-Content -Path $trailPath -Value $body -NoNewline
    return $trailPath
}

# ---------------------------------------------------------------------------
# Knowledge promotion: earned constraints and Trail Products (see
# pmcro:foundation -> knowledge-promotion.md, trail-as-product.md)
# ---------------------------------------------------------------------------

function New-PmcroConstraint {
    <#
    .SYNOPSIS
      Writes an earned-knowledge record under .pmcro/constraints/. File
      mechanics only -- this function does NOT decide whether the
      evidence actually justifies the Kind or Statement given; that
      promotion judgment (recurrence, scope, outcome quality, evidence
      strength, contradiction with existing knowledge -- see
      knowledge-promotion.md) is Reflector/model reasoning, same boundary
      already drawn for every other classification decision in this
      engine. The one thing this function DOES enforce deterministically:
      an earned record must cite at least one trail as evidence -- an
      unevidenced "earned" record is a contradiction in terms.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][ValidateSet('constraint','rule-policy','strategy-preference','skill-candidate','training-example','audit-record')][string]$Kind,
        [Parameter(Mandatory)][string]$Scope,
        [Parameter(Mandatory)][string]$Statement,
        [Parameter(Mandatory)][string[]]$EvidenceTrailIds,
        [ValidateSet('provisional','active','superseded')][string]$Status = 'provisional',
        [string]$SupersededBy = ''
    )
    if ($Slug -notmatch '^[a-z0-9][a-z0-9-]*$') { throw "New-PmcroConstraint: -Slug must be lowercase-kebab-case (got '$Slug')." }
    if (@($EvidenceTrailIds | Where-Object { $_ }).Count -eq 0) { throw "New-PmcroConstraint: -EvidenceTrailIds must cite at least one trail -- an earned record with no evidence is not earned." }
    $constraintId = "$Kind-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$Slug"
    $dir = Join-Path $PmcroRoot 'constraints'; New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $path = Join-Path $dir "$constraintId.md"
    $evidenceList = ($EvidenceTrailIds | ForEach-Object { "- $_" }) -join "`n"
    $body = @"
# Earned Knowledge: $constraintId

constraint_id: $constraintId
kind: $Kind
scope: $Scope
status: $Status
superseded_by: $SupersededBy
created_at: $(Get-PmcroUtcNowIso)

## Statement
$Statement

## Evidence (source trails)
$evidenceList

## Narrowest valid scope
Per accountability-and-trails.md: the narrowest valid scope should be
preserved, and evidence should support confidence and later supersession.
Widening this record's scope beyond what the cited evidence actually
demonstrated requires new evidence, not an edit to this file -- write a
new record and set this one's status to superseded / superseded_by
instead of loosening scope in place.
"@
    Set-Content -Path $path -Value $body -NoNewline
    return [pscustomobject]@{ constraint_id = $constraintId; path = $path }
}

function New-PmcroTrailProduct {
    <#
    .SYNOPSIS
      Writes a Trail Product manifest under .pmcro/products/ -- packaged,
      reusable operational experience per trail-as-product.md. File
      mechanics only: does not judge whether the source trail(s) actually
      validate the product, does not bind consumer identity/authority (see
      trail-as-product.md "Identity binding" -- that is a runtime-level
      concern for whoever executes the product, not this manifest).

    .DESCRIPTION
      evidence_class is derived deterministically from the source trail id
      naming convention established by New-PmcroTrail ("cycle-...") vs.
      New-PmcroRetrospectiveTrail ("retro-...") -- never asserted by the
      caller, so a product's provenance cannot silently overstate its own
      evidence strength: all-native trails -> native; all-retrospective ->
      reconstructed; a mix -> mixed. See retrospective-trail-
      reconstruction.md and trail-as-product.md's provenance requirement.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][string[]]$SourceTrailIds,
        [Parameter(Mandatory)][string]$Scope,
        [string]$Version = '0.1.0',
        [string]$Assumptions = '',
        [string]$KnownLimitations = '',
        [string[]]$ReusableSkillReferences = @()
    )
    if ($Slug -notmatch '^[a-z0-9][a-z0-9-]*$') { throw "New-PmcroTrailProduct: -Slug must be lowercase-kebab-case (got '$Slug')." }
    $cited = @($SourceTrailIds | Where-Object { $_ })
    if ($cited.Count -eq 0) { throw "New-PmcroTrailProduct: -SourceTrailIds must cite at least one trail -- a product with no source trail is not a Trail Product." }
    $isNative = @($cited | Where-Object { $_ -notmatch '^retro-' })
    $isRetro = @($cited | Where-Object { $_ -match '^retro-' })
    $evidenceClass = if ($isRetro.Count -eq 0) { 'native' } elseif ($isNative.Count -eq 0) { 'reconstructed' } else { 'mixed' }

    $productId = "product-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$Slug"
    $dir = Join-Path $PmcroRoot 'products'; New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $path = Join-Path $dir "$productId.md"
    $trailList = ($cited | ForEach-Object { "- $_" }) -join "`n"
    $skillRefsList = if (@($ReusableSkillReferences | Where-Object { $_ }).Count -gt 0) { ($ReusableSkillReferences | ForEach-Object { "- $_" }) -join "`n" } else { '(none declared)' }
    $body = @"
# Trail Product: $productId

product_id: $productId
version: $Version
scope: $Scope
evidence_class: $evidenceClass
created_at: $(Get-PmcroUtcNowIso)

## Provenance (source trails)
$trailList

## Assumptions
$Assumptions

## Known limitations
$KnownLimitations

## Reusable skill / marketplace references
$skillRefsList

## Identity binding
Per trail-as-product.md: this product supplies learned procedure and
evidence only. A consumer runtime supplies its own execution identity,
operator identity, authority, accounts/resources, and approvals when it
re-executes this product -- this manifest does not carry or imply any of
those, whatever evidence_class says about the strength of the procedure
itself.
"@
    Set-Content -Path $path -Value $body -NoNewline
    return [pscustomobject]@{ product_id = $productId; evidence_class = $evidenceClass; path = $path }
}

# ---------------------------------------------------------------------------
# Capability gap / composition (see discover-capabilities/SKILL.md's
# Resolution contract step 5, and pmcro:foundation ->
# capability-gap-and-composition.md)
# ---------------------------------------------------------------------------

function New-PmcroCapabilityComposition {
    <#
    .SYNOPSIS
      Records that 2+ existing capabilities, used together, cover a need
      that no single installed provider covers alone -- see
      capability-gap-and-composition.md. File mechanics only: does not
      decide whether the composition actually works: -EvidenceTrailIds
      must show it was exercised. `proven` is derived automatically from
      the evidence count (>=2 independent trails), never asserted by the
      caller -- mirrors New-PmcroTrailProduct's automatic evidence_class
      derivation and knowledge-promotion.md's own bar ("repeated,
      independently checked observations can justify stronger policy").
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][string]$Need,
        [Parameter(Mandatory)][string[]]$ComposedOf,
        [Parameter(Mandatory)][string]$HowItComposes,
        [Parameter(Mandatory)][string[]]$EvidenceTrailIds,
        [ValidateSet('candidate','promoted','superseded')][string]$Status = 'candidate'
    )
    if ($Slug -notmatch '^[a-z0-9][a-z0-9-]*$') { throw "New-PmcroCapabilityComposition: -Slug must be lowercase-kebab-case (got '$Slug')." }
    $composedList = @($ComposedOf | Where-Object { $_ })
    if ($composedList.Count -lt 2) { throw "New-PmcroCapabilityComposition: -ComposedOf must list at least 2 parts -- a single capability is not a composition." }
    $evidence = @($EvidenceTrailIds | Where-Object { $_ })
    if ($evidence.Count -eq 0) { throw "New-PmcroCapabilityComposition: -EvidenceTrailIds must cite at least one trail where this composition was actually exercised." }
    $proven = $evidence.Count -ge 2

    $compositionId = "composition-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$Slug"
    $dir = Join-Path $PmcroRoot 'compositions'; New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $path = Join-Path $dir "$compositionId.md"
    $composedListText = ($composedList | ForEach-Object { "- $_" }) -join "`n"
    $evidenceListText = ($evidence | ForEach-Object { "- $_" }) -join "`n"
    $body = @"
# Capability Composition: $compositionId

composition_id: $compositionId
status: $Status
proven: $($proven.ToString().ToLowerInvariant())
created_at: $(Get-PmcroUtcNowIso)

## Need
$Need

## Composed of
$composedListText

## How it composes
$HowItComposes

## Evidence (source trails)
$evidenceListText

## Promotion
Per knowledge-promotion.md: a composition proven across repeated,
independently checked trails is a skill candidate, not yet a first-class
capability. Promote it by writing a 'skill-candidate' earned-knowledge
record (New-PmcroConstraint) that cites this composition, then scaffold
the real skill via /createskill per INSTRUCTIONS.md -- this manifest
records the proof, it does not itself register a capability.
"@
    Set-Content -Path $path -Value $body -NoNewline
    return [pscustomobject]@{ composition_id = $compositionId; proven = $proven; path = $path }
}

function New-PmcroCapabilityGap {
    <#
    .SYNOPSIS
      Durably records that neither a single installed capability nor a
      composition of existing ones covers a genuine need -- see
      capability-gap-and-composition.md, and discover-capabilities/
      SKILL.md's Resolution contract step 5 ("report unresolved capability
      rather than inventing one"). File mechanics only: does not decide
      whether the gap is real or judge the search quality -- but DOES
      require -CompositionConsidered to be non-empty, so a gap can never
      be recorded without composition having actually been attempted
      first, per the seed intent's own ordering (composition, then
      explicit gap recording only when composition doesn't suffice).
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][string]$Need,
        [Parameter(Mandatory)][string]$CompositionConsidered,
        [Parameter(Mandatory)][string[]]$EvidenceTrailIds,
        [string]$DiscoveryQuery = '',
        [string[]]$PartialMatches = @(),
        [ValidateSet('open','resolved')][string]$Status = 'open',
        [string]$ResolvedBy = ''
    )
    if ($Slug -notmatch '^[a-z0-9][a-z0-9-]*$') { throw "New-PmcroCapabilityGap: -Slug must be lowercase-kebab-case (got '$Slug')." }
    if ([string]::IsNullOrWhiteSpace($CompositionConsidered)) { throw "New-PmcroCapabilityGap: -CompositionConsidered is required -- a gap cannot be recorded without first explaining why no composition of existing capabilities sufficed." }
    $evidence = @($EvidenceTrailIds | Where-Object { $_ })
    if ($evidence.Count -eq 0) { throw "New-PmcroCapabilityGap: -EvidenceTrailIds must cite at least one trail documenting the search." }

    $gapId = "gap-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$Slug"
    $dir = Join-Path $PmcroRoot 'capability-gaps'; New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $path = Join-Path $dir "$gapId.md"
    $partialList = if (@($PartialMatches | Where-Object { $_ }).Count -gt 0) { ($PartialMatches | ForEach-Object { "- $_" }) -join "`n" } else { '(none found)' }
    $evidenceListText = ($evidence | ForEach-Object { "- $_" }) -join "`n"
    $body = @"
# Capability Gap: $gapId

gap_id: $gapId
status: $Status
resolved_by: $ResolvedBy
discovery_query: $DiscoveryQuery
created_at: $(Get-PmcroUtcNowIso)

## Need
$Need

## Partial matches found
$partialList

## Why composition doesn't suffice
$CompositionConsidered

## Evidence (source trails)
$evidenceListText

## Resolution
A gap record stays 'status: open' until a capability that actually covers
'Need' exists (installed provider, promoted composition, or newly
scaffolded skill) -- at which point set 'status: resolved' and
'resolved_by' to that capability's name, rather than deleting the record.
The gap's history — that this need went unmet for a time — is itself
evidence worth keeping.
"@
    Set-Content -Path $path -Value $body -NoNewline
    return [pscustomobject]@{ gap_id = $gapId; path = $path }
}

# ---------------------------------------------------------------------------
# Approvals
# ---------------------------------------------------------------------------

function Get-PmcroApprovals {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'approvals.jsonl'; if (-not (Test-Path $path)) { return @() }
    $items = @(); foreach ($line in (Get-Content $path)) { if (-not [string]::IsNullOrWhiteSpace($line)) { $items += ConvertFrom-Json $line } }
    return $items
}

function Save-PmcroApproval {
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$OperationId,
        [Parameter(Mandatory)][string]$Decision,
        [Parameter(Mandatory)][string]$Operation,
        [Parameter(Mandatory)][string[]]$Scope,
        [Parameter(Mandatory)][string]$Actor,
        [Parameter(Mandatory)][string]$Source,
        [string]$Expiry,
        [string]$TrailId,
        [switch]$Destructive
    )
    if ($Decision -notin @('approved','denied','needs-human-approval')) { throw 'Decision must be approved, denied, or needs-human-approval.' }
    if ($Destructive -and $Decision -eq 'approved' -and $Source -ne 'human') { throw 'Destructive operations require explicit human approval.' }
    if ($Decision -eq 'approved' -and [string]::IsNullOrWhiteSpace($TrailId)) { throw 'Approved operations require a trail reference.' }
    $record = [ordered]@{
        operation_id=$OperationId; decision=$Decision; operation=$Operation; scope=@($Scope); actor=$Actor
        source=$Source; destructive=[bool]$Destructive; approved_at=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        expiry=$Expiry; trail_id=$TrailId
    }
    $path = Join-Path $PmcroRoot 'approvals.jsonl'
    Add-Content -Path $path -Value (ConvertTo-Json $record -Compress)
    return [pscustomobject]$record
}

function Test-PmcroApproval {
    <#
    .SYNOPSIS
      Approval enforcement is unaffected by Run interruption/recovery: a
      stale lease or a recovery decision never substitutes for or extends
      an approval record. See run-recovery-lease.md "Approval boundary
      across interruption" -- this function does not special-case Runs at
      all, by design.
    #>
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][string]$OperationId,[Parameter(Mandatory)][string[]]$Targets,[string]$Actor)
    $matches = @(Get-PmcroApprovals -PmcroRoot $PmcroRoot | Where-Object { $_.operation_id -eq $OperationId -and $_.decision -eq 'approved' })
    if ($matches.Count -eq 0) { return $false }
    $approval = $matches[-1]
    if ($Actor -and $approval.actor -ne $Actor) { return $false }
    foreach ($target in $Targets) { if ($approval.scope -notcontains $target) { return $false } }
    if ($approval.expiry) {
        $expires = [datetimeoffset]::Parse([string]$approval.expiry)
        if ([datetimeoffset]::UtcNow -ge $expires) { return $false }
    }
    return $true
}

Export-ModuleMember -Function `
    Get-PmcroSessionState, Set-PmcroSessionState, `
    Get-PmcroQueue, Save-PmcroQueue, Add-PmcroQueueItem, `
    Add-PmcroIntake, Find-PmcroUnresolvedIntake, Resolve-PmcroIntake, `
    Get-PmcroRuntimeInstanceId, `
    Update-PmcroLease, Test-PmcroLeaseStale, Find-PmcroRecoverableRuns, `
    Set-PmcroCheckpoint, Get-PmcroCheckpoint, Remove-PmcroCheckpoint, Get-PmcroCheckpointPath, `
    Claim-PmcroTask, Complete-PmcroRun, `
    New-PmcroTrail, New-PmcroRetrospectiveTrail, `
    New-PmcroConstraint, New-PmcroTrailProduct, `
    New-PmcroCapabilityComposition, New-PmcroCapabilityGap, `
    Get-PmcroApprovals, Save-PmcroApproval, Test-PmcroApproval
