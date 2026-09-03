<#
.SYNOPSIS
  Durably persist a raw message as an intake queue item. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). This is the
  first action /send-message must take -- before any classification
  reasoning -- so the message survives even if the session is interrupted
  immediately after. See pmcro:foundation -> seed-intent-contract.md and
  .agents/commands/send-message.md.
#>
param(
    [Parameter(Mandatory)][string]$PmcroRoot,
    [Parameter(Mandatory)][string]$Message,
    [ValidateSet('human','agent','external','system')][string]$Source = 'human',
    [int]$Priority = 2,
    $Domain = $null
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$engine = Join-Path $PSScriptRoot '..\engine\PmcroEngine.psm1'
Import-Module $engine -Force

$result = Add-PmcroIntake -PmcroRoot $PmcroRoot -Message $Message -Source $Source -Priority $Priority -Domain $Domain
$result | ConvertTo-Json -Depth 5
