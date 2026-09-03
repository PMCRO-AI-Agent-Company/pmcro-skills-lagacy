[CmdletBinding()]
param([Parameter(Mandatory)] [string]$Path)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath($Path)
if (-not (Test-Path $root -PathType Container)) { throw "Project not found: $root" }
[ordered]@{
  root = $root
  agents = @(Get-ChildItem (Join-Path $root '.agents') -Recurse -File -ErrorAction SilentlyContinue).Count
  plugins = @(Get-ChildItem (Join-Path $root 'plugins') -Directory -ErrorAction SilentlyContinue).Count
  tests = @(Get-ChildItem (Join-Path $root 'tests') -File -Recurse -ErrorAction SilentlyContinue).Count
} | ConvertTo-Json
