[CmdletBinding()]
param([Parameter(Mandatory)][string]$Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
foreach($x in @('SKILL.md','assets','references','scripts')) { if(-not(Test-Path (Join-Path $Path $x))){ throw "Missing $x" } }
foreach($x in @('assets','references','scripts')) { if(@(Get-ChildItem (Join-Path $Path $x) -Directory).Count -gt 0){ throw "Non-flat $x" } }
Write-Output 'PASS'
