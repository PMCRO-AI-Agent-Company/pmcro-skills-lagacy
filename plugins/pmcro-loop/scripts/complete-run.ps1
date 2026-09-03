<#
.SYNOPSIS
  Close out a Run at terminal Trail disposition. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Sets the
  queue item's terminal status (done|blocked), clears live Run bookkeeping
  (lease_owner/heartbeat_at/lease_expires_at/checkpoint_ref), and deletes
  the checkpoint file. Call this from reflect-and-seed once the Trail for
  this cycle is sealed -- the Trail persists, the Run does not. See
  pmcro:foundation -> run-recovery-lease.md "Relationship to Trail/Frame".
#>
param(
    [string]$PmcroRoot,
    [Parameter(Mandatory)][string]$TaskId,
    [Parameter(Mandatory)][ValidateSet('done','blocked')][string]$FinalStatus
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

Complete-PmcroRun -PmcroRoot $PmcroRoot -TaskId $TaskId -FinalStatus $FinalStatus
Write-Host "Run closed: $TaskId -> $FinalStatus (lease/checkpoint cleared)"
