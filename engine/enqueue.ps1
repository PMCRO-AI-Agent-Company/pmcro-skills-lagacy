<#
.SYNOPSIS
  Append one fully-scoped work item to this repo's own queue.jsonl. No
  LLM calls.

.DESCRIPTION
  Implements the non-reasoning half of skills/queue-enqueue/SKILL.md.
  Refuses a duplicate id or an out-of-range priority rather than writing
  either silently. See PmcroEngine.psm1's Add-PmcroQueueItem.

.PARAMETER PmcroRoot
  Path to the .pmcro directory of this project.
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
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'PmcroEngine.psm1') -Force

$item = Add-PmcroQueueItem -PmcroRoot $PmcroRoot -Id $Id -SeedIntent $SeedIntent -Priority $Priority `
    -Domain $Domain -CreatedBy $CreatedBy -BlockedBy $BlockedBy
$item | ConvertTo-Json -Depth 5
