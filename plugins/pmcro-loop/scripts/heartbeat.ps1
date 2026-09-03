<#
.SYNOPSIS
  Refresh the lease/heartbeat on an actively-worked Run. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Any role
  actively working a claimed queue item should call this at meaningful
  boundaries (or use checkpoint.ps1, which refreshes the lease as a side
  effect of recording a checkpoint) so a stale heartbeat reliably means
  "no live runtime is attending to this Run" rather than "the runtime is
  just slow." See pmcro:foundation -> run-recovery-lease.md.
#>
param(
    [Parameter(Mandatory)][string]$PmcroRoot,
    [Parameter(Mandatory)][string]$TaskId,
    [string]$LeaseOwner,
    [int]$TtlMinutes = 30
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$engine = Join-Path $PSScriptRoot '..\engine\PmcroEngine.psm1'
Import-Module $engine -Force

$result = Update-PmcroLease -PmcroRoot $PmcroRoot -TaskId $TaskId -LeaseOwner $LeaseOwner -TtlMinutes $TtlMinutes
$result | ConvertTo-Json -Depth 5
