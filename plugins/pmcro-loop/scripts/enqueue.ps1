<#
.SYNOPSIS
  Append one fully-scoped work item to the shared colony queue. No LLM
  calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). For a
  raw, not-yet-classified message use intake-message.ps1 instead -- this
  is for Reflector follow-ups, CEO/CoS directed work, or a human handing
  off an item that already has a clear seed_intent (queue-enqueue's own
  contract). Refuses a duplicate id rather than silently overwriting.
#>
param(
    [string]$PmcroRoot,
    [Parameter(Mandatory)][string]$Id,
    [Parameter(Mandatory)][string]$SeedIntent,
    [ValidateRange(0,4)][int]$Priority = 3,
    $Domain = $null,
    [string]$CreatedBy = 'human',
    [string[]]$BlockedBy = @()
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

$item = Add-PmcroQueueItem -PmcroRoot $PmcroRoot -Id $Id -SeedIntent $SeedIntent -Priority $Priority `
    -Domain $Domain -CreatedBy $CreatedBy -BlockedBy $BlockedBy
$item | ConvertTo-Json -Depth 5
