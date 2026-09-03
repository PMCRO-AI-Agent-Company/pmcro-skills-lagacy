<#
.SYNOPSIS
  Deterministic PMCR-O cycle driver. No LLM calls.

.DESCRIPTION
  Implements the non-reasoning half of skills/orchestrate/SKILL.md:
  read state -> claim from queue if idle -> allocate a trail skeleton.
  It then STOPS. It does not write Plan/Make/Check/Reflect content --
  that requires a model, which this script deliberately does not call
  (see PmcroEngine.psm1 header). A human or a future LLM-driving layer
  fills the PENDING sections and seals the trail.

.PARAMETER PmcroRoot
  Path to the .pmcro directory of the target project. Optional: when
  omitted, resolved by walking upward from the current location via
  Find-PmcroRoot (resolve-pmcro-root.ps1). Never silently guessed.
#>
param(
    [string]$PmcroRoot
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'PmcroEngine.psm1') -Force
. (Join-Path $PSScriptRoot 'resolve-pmcro-root.ps1')

if ([string]::IsNullOrEmpty($PmcroRoot)) {
    $PmcroRoot = Find-PmcroRoot
    Write-Host "PmcroRoot not supplied; resolved to: $PmcroRoot"
}

$state = Get-PmcroSessionState -PmcroRoot $PmcroRoot
Write-Host "Session status: $($state.status)"

if ($state.status -ne 'idle') {
    Write-Host "Not idle (status=$($state.status)); refusing to claim a new task. Current trail: $($state.last_cycle_id)"
    exit 0
}

$task = Claim-PmcroTask -PmcroRoot $PmcroRoot
if ($null -eq $task) {
    Write-Host 'Queue empty. Remaining idle.'
    exit 0
}

Write-Host "Claimed: $($task.id) (priority $($task.priority)) -- $($task.seed_intent)"
$trailPath = New-PmcroTrail -PmcroRoot $PmcroRoot -Task $task
Write-Host "Trail skeleton written: $trailPath"
Write-Host 'STOP: Plan/Make/Check/Reflect require model reasoning, not run by this script.'
