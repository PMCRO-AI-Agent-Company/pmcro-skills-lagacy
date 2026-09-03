<#
.SYNOPSIS
  Write/update the durable Checkpoint for an active Run, and refresh its
  lease as a side effect. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Call this
  at appropriate execution boundaries (phase transitions, before/after a
  risky or long-running operation) so a resuming runtime can reconstruct
  in-flight state without the chat transcript. See pmcro:foundation ->
  run-recovery-lease.md for the Checkpoint contract and the mandatory
  inspect-before-retry Recovery procedure that consumes it.
#>
param(
    [string]$PmcroRoot,
    [Parameter(Mandatory)][string]$TaskId,
    [Parameter(Mandatory)][ValidateSet('orchestrator','planner','maker','checker','reflector')][string]$Phase,
    [string]$LastCompletedStep = '',
    [string]$InProgressOperation = '',
    [string]$ExternalStateExpected = 'unknown - not yet observed',
    [string]$LastFrameId = '',
    [string]$LeaseOwner,
    [int]$TtlMinutes = 30
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$engine = Join-Path $PSScriptRoot '..\engine\PmcroEngine.psm1'
Import-Module $engine -Force
. (Join-Path $PSScriptRoot '..\engine\resolve-pmcro-root.ps1')
if ([string]::IsNullOrEmpty($PmcroRoot)) {
    $PmcroRoot = Find-PmcroRoot
    Write-Host "PmcroRoot not supplied; resolved to: $PmcroRoot"
}

$result = Set-PmcroCheckpoint -PmcroRoot $PmcroRoot -TaskId $TaskId -Phase $Phase `
    -LastCompletedStep $LastCompletedStep -InProgressOperation $InProgressOperation `
    -ExternalStateExpected $ExternalStateExpected -LastFrameId $LastFrameId `
    -LeaseOwner $LeaseOwner -TtlMinutes $TtlMinutes

$result | ConvertTo-Json -Depth 5
