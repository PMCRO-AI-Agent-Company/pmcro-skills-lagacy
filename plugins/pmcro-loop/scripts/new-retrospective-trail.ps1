<#
.SYNOPSIS
  Allocate a trail skeleton for reconstructing accountability from a
  historical/third-party LLM export. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Writes the
  skeleton file only -- an agent must then read the actual export and fill
  in each Frame, marking every claim evidenced or inferred. See
  pmcro:foundation -> retrospective-trail-reconstruction.md.
#>
param(
    [string]$PmcroRoot,
    [Parameter(Mandatory)][string]$Slug,
    [Parameter(Mandatory)][string]$SourceExport,
    [Parameter(Mandatory)][string]$ReconstructionBasis,
    [string]$RelatedTaskId = ''
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

$trailPath = New-PmcroRetrospectiveTrail -PmcroRoot $PmcroRoot -Slug $Slug -SourceExport $SourceExport -ReconstructionBasis $ReconstructionBasis -RelatedTaskId $RelatedTaskId
Write-Host "Retrospective trail skeleton written: $trailPath"
Write-Host 'STOP: reading the export and filling each Frame requires model reasoning, not run by this script.'
