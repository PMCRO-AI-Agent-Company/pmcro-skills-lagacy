<#
.SYNOPSIS
  Record that 2+ existing capabilities, used together, cover a need no
  single installed provider covers alone. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Deciding
  WHETHER the composition actually works is Reflector/model reasoning
  done before calling this script -- see
  pmcro:foundation -> capability-gap-and-composition.md. `proven` is
  derived automatically from the evidence trail count, never asserted.
#>
param(
    [Parameter(Mandatory)][string]$PmcroRoot,
    [Parameter(Mandatory)][string]$Slug,
    [Parameter(Mandatory)][string]$Need,
    [Parameter(Mandatory)][string[]]$ComposedOf,
    [Parameter(Mandatory)][string]$HowItComposes,
    [Parameter(Mandatory)][string[]]$EvidenceTrailIds,
    [ValidateSet('candidate','promoted','superseded')][string]$Status = 'candidate'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$engine = Join-Path $PSScriptRoot '..\engine\PmcroEngine.psm1'
Import-Module $engine -Force

$result = New-PmcroCapabilityComposition -PmcroRoot $PmcroRoot -Slug $Slug -Need $Need -ComposedOf $ComposedOf -HowItComposes $HowItComposes -EvidenceTrailIds $EvidenceTrailIds -Status $Status
$result | ConvertTo-Json -Depth 5
