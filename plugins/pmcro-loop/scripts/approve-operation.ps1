param(
    [string]$PmcroRoot,
    [Parameter(Mandatory)][string]$OperationId,
    [Parameter(Mandatory)][ValidateSet('approved','denied','needs-human-approval')][string]$Decision,
    [Parameter(Mandatory)][string]$Operation,
    [Parameter(Mandatory)][string[]]$Scope,
    [Parameter(Mandatory)][string]$Actor,
    [Parameter(Mandatory)][string]$Source,
    [string]$Expiry,
    [string]$TrailId,
    [switch]$Destructive
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

if ($Decision -eq 'approved' -and $Destructive -and $Source -ne 'human') {
    throw 'Destructive operations require explicit human approval (Source=human).'
}

$record = Save-PmcroApproval -PmcroRoot $PmcroRoot -OperationId $OperationId -Decision $Decision `
    -Operation $Operation -Scope $Scope -Actor $Actor -Source $Source -Expiry $Expiry `
    -TrailId $TrailId -Destructive:$Destructive

$record | ConvertTo-Json -Depth 5
