<#
.SYNOPSIS
  Package one or more validated trails into a Trail Product manifest
  under .pmcro/products/. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Deciding
  WHETHER the source trail(s) actually validate reuse is Reflector/model
  reasoning done before calling this script -- see
  pmcro:foundation -> trail-as-product.md. evidence_class is derived
  automatically from the source trail id naming convention (cycle- vs.
  retro-), never asserted by the caller.
#>
param(
    [Parameter(Mandatory)][string]$PmcroRoot,
    [Parameter(Mandatory)][string]$Slug,
    [Parameter(Mandatory)][string[]]$SourceTrailIds,
    [Parameter(Mandatory)][string]$Scope,
    [string]$Version = '0.1.0',
    [string]$Assumptions = '',
    [string]$KnownLimitations = '',
    [string[]]$ReusableSkillReferences = @()
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$engine = Join-Path $PSScriptRoot '..\engine\PmcroEngine.psm1'
Import-Module $engine -Force

$result = New-PmcroTrailProduct -PmcroRoot $PmcroRoot -Slug $Slug -SourceTrailIds $SourceTrailIds -Scope $Scope -Version $Version -Assumptions $Assumptions -KnownLimitations $KnownLimitations -ReusableSkillReferences $ReusableSkillReferences
$result | ConvertTo-Json -Depth 5
