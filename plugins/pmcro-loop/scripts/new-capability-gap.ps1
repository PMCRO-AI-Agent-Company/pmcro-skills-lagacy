<#
.SYNOPSIS
  Durably record that neither a single installed capability nor a
  composition of existing ones covers a genuine need. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). See
  pmcro:foundation -> capability-gap-and-composition.md and
  discover-capabilities/SKILL.md's Resolution contract step 5.
  -CompositionConsidered is required: a gap cannot be recorded without
  first explaining why composition didn't suffice.
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

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$engine = Join-Path $PSScriptRoot '..\engine\PmcroEngine.psm1'
Import-Module $engine -Force

$result = New-PmcroCapabilityGap -PmcroRoot $PmcroRoot -Slug $Slug -Need $Need -CompositionConsidered $CompositionConsidered -EvidenceTrailIds $EvidenceTrailIds -DiscoveryQuery $DiscoveryQuery -PartialMatches $PartialMatches -Status $Status -ResolvedBy $ResolvedBy
$result | ConvertTo-Json -Depth 5
