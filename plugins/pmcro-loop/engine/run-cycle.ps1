<#
.SYNOPSIS
  Deterministic PMCR-O cycle driver. No LLM calls.

.DESCRIPTION
  Implements the non-reasoning half of skills/orchestrate/SKILL.md:
  discover any unresolved intake (unclassified message) first, then any
  interrupted Run -> read state -> claim from queue if idle -> allocate a
  trail skeleton. It then STOPS. It does not write Plan/Make/Check/Reflect
  content, does not classify an intake message into a canonical Seed
  Intent, and does not classify a stale Run as resume/compensate/retry --
  all three require a model, which this script deliberately does not call
  (see PmcroEngine.psm1 header). A human or a future LLM-driving layer
  fills the PENDING sections, makes the classification/recovery decision,
  and seals the trail.

.PARAMETER PmcroRoot
  Path to the .pmcro directory of the target project. Optional: when
  omitted, resolved by walking upward from the current location via
  Find-PmcroRoot (resolve-pmcro-root.ps1). Never silently guessed.

.PARAMETER LeaseTtlMinutes
  Lease duration written on claim / checkpoint. Default 30, per the example
  in run-recovery-lease.md.
#>
param(
    [string]$PmcroRoot,
    [int]$LeaseTtlMinutes = 30
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'PmcroEngine.psm1') -Force
. (Join-Path $PSScriptRoot 'resolve-pmcro-root.ps1')

if ([string]::IsNullOrEmpty($PmcroRoot)) {
    $PmcroRoot = Find-PmcroRoot
    Write-Host "PmcroRoot not supplied; resolved to: $PmcroRoot"
}

# --- Step -1: discover unresolved intake (messages received but never classified) ---
# Mirrors foundation/references/session-bootstrap.md step 3.4. A message durably
# captured by /send-message's Add-PmcroIntake but never resolved (session
# interrupted mid-classification) must be surfaced before anything else --
# never silently skipped in favor of grinding through the rest of the backlog.
$unresolvedIntake = @(Find-PmcroUnresolvedIntake -PmcroRoot $PmcroRoot)
if ($unresolvedIntake.Count -gt 0) {
    Write-Host '=== UNRESOLVED INTAKE: message(s) awaiting classification ==='
    Write-Host 'Refusing to claim new work while a durably-captured message has not yet been'
    Write-Host 'classified. Resolve each item below via Resolve-PmcroIntake (enqueued | informational'
    Write-Host '| split) before claiming anything else.'
    Write-Host ''
    foreach ($intake in $unresolvedIntake) {
        Write-Host "--- Intake: $($intake.id) ---"
        Write-Host "  source:      $($intake.created_by)"
        Write-Host "  created_at:  $($intake.created_at)"
        Write-Host "  raw message: $($intake.seed_intent)"
        Write-Host ''
    }
    Write-Host 'STOP: classification requires model/human reasoning, not run by this script.'
    exit 0
}

# --- Step 0: discover interrupted/expired Runs before doing anything else ---
# Mirrors foundation/references/session-bootstrap.md step 3.5. This is
# evidence-gathering only: it never decides resume/compensate/retry, and it
# never reclaims or retries a stale Run on its own.
$recoverable = @(Find-PmcroRecoverableRuns -PmcroRoot $PmcroRoot)
if ($recoverable.Count -gt 0) {
    Write-Host '=== RECOVERY REQUIRED: interrupted Run(s) detected ==='
    Write-Host 'Refusing to claim new work while an unresolved Run exists. Per run-recovery-lease.md,'
    Write-Host 'an interrupted operation is never retried blindly -- inspect actual state, then'
    Write-Host 'classify each Run below as resume | compensate | retry before touching it further.'
    Write-Host ''
    $repoRoot = Split-Path -Parent $PmcroRoot
    foreach ($run in $recoverable) {
        Write-Host "--- Run: $($run.id) ---"
        Write-Host "  lease_owner:      $($run.lease_owner)"
        Write-Host "  heartbeat_at:     $($run.heartbeat_at)"
        Write-Host "  lease_expires_at: $($run.lease_expires_at)"
        $checkpoint = Get-PmcroCheckpoint -PmcroRoot $PmcroRoot -TaskId $run.id
        if ($checkpoint) {
            Write-Host "  checkpoint.phase:                  $($checkpoint.phase)"
            Write-Host "  checkpoint.last_completed_step:     $($checkpoint.last_completed_step)"
            Write-Host "  checkpoint.in_progress_operation:   $($checkpoint.in_progress_operation)"
            Write-Host "  checkpoint.external_state_expected: $($checkpoint.external_state_expected)"
            Write-Host "  checkpoint.updated_at:              $($checkpoint.updated_at)"
        } else {
            Write-Host '  checkpoint: none found (predates run-recovery-lease.md, or never written)'
        }
        # Deterministic, generic external-state evidence -- gathering only, no interpretation.
        if (Test-Path (Join-Path $repoRoot '.git')) {
            try {
                $gitStatus = & git -C $repoRoot status --porcelain 2>&1
                $gitStatusCount = @($gitStatus | Where-Object { $_ }).Count
                Write-Host "  git status: $gitStatusCount changed path(s) (run 'git -C $repoRoot status' for detail)"
            } catch {
                Write-Host "  git status: unavailable ($($_.Exception.Message))"
            }
        } else {
            Write-Host "  git status: not a git repo at $repoRoot; no generic external-state evidence gathered"
        }
        Write-Host ''
    }
    Write-Host 'STOP: recovery classification requires model/human reasoning, not run by this script.'
    exit 0
}

$state = Get-PmcroSessionState -PmcroRoot $PmcroRoot
Write-Host "Session status: $($state.status)"

if ($state.status -ne 'idle') {
    Write-Host "Not idle (status=$($state.status)); refusing to claim a new task. Current trail: $($state.last_cycle_id)"
    exit 0
}

$task = Claim-PmcroTask -PmcroRoot $PmcroRoot -LeaseTtlMinutes $LeaseTtlMinutes
if ($null -eq $task) {
    Write-Host 'Queue empty. Remaining idle.'
    exit 0
}

Write-Host "Claimed: $($task.id) (priority $($task.priority)) -- $($task.seed_intent)"
Write-Host "  run_id (= task_id): $($task.id)"
Write-Host "  lease_owner:        $($task.lease_owner)"
Write-Host "  lease_expires_at:   $($task.lease_expires_at)"
Write-Host "  checkpoint_ref:     $($task.checkpoint_ref)"
$trailPath = New-PmcroTrail -PmcroRoot $PmcroRoot -Task $task
Write-Host "Trail skeleton written: $trailPath"
Write-Host 'STOP: Plan/Make/Check/Reflect require model reasoning, not run by this script.'
