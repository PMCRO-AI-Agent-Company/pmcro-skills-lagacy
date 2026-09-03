<#
.SYNOPSIS
  Write an earned-knowledge record (constraint | rule-policy |
  strategy-preference | skill-candidate | training-example |
  audit-record) under .pmcro/constraints/. No LLM calls.

.DESCRIPTION
  Deterministic bookkeeping only (see PmcroEngine.psm1 header). Deciding
  WHETHER the cited evidence justifies this record is Reflector/model
  reasoning done before calling this script -- see
  pmcro:foundation -> knowledge-promotion.md. This script only enforces
  that at least one trail is cited as evidence.
#>
param(
    [string]$PmcroRoot,
    [Parameter(Mandatory)][string]$Slug,
    [Parameter(Mandatory)][ValidateSet('constraint','rule-policy','strategy-preference','skill-candidate','training-example','audit-record')][string]$Kind,
    [Parameter(Mandatory)][string]$Scope,
    [Parameter(Mandatory)][string]$Statement,
    [Parameter(Mandatory)][string[]]$EvidenceTrailIds,
    [ValidateSet('provisional','active','superseded')][string]$Status = 'provisional',
    [string]$SupersededBy = ''
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

$result = New-PmcroConstraint -PmcroRoot $PmcroRoot -Slug $Slug -Kind $Kind -Scope $Scope -Statement $Statement -EvidenceTrailIds $EvidenceTrailIds -Status $Status -SupersededBy $SupersededBy
$result | ConvertTo-Json -Depth 5
