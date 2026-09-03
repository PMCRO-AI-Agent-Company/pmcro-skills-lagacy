<#
.SYNOPSIS
  Rewrite an intake item once it has been classified. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Call this
  after Orchestrator has decided the disposition (enqueued | informational
  | split) -- the decision itself is not made here. The original raw
  message is always preserved in messy_seed_text for provenance. See
  pmcro:foundation -> seed-intent-contract.md.
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

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$engine = Join-Path $PSScriptRoot '..\engine\PmcroEngine.psm1'
Import-Module $engine -Force

$params = @{ PmcroRoot = $PmcroRoot; TaskId = $TaskId; Disposition = $Disposition }
if ($RefinedSeedIntent) { $params.RefinedSeedIntent = $RefinedSeedIntent }
if ($PSBoundParameters.ContainsKey('Priority')) { $params.Priority = $Priority }
if ($PSBoundParameters.ContainsKey('Domain')) { $params.Domain = $Domain }
if ($ResolutionNote) { $params.ResolutionNote = $ResolutionNote }

$result = Resolve-PmcroIntake @params
$result | ConvertTo-Json -Depth 5
