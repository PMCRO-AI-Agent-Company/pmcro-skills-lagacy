[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(Mandatory)] [string]$Name,
  [Parameter(Mandatory)] [string]$DisplayName,
  [Parameter(Mandatory)] [string]$Description,
  [string]$OutputPath,
  [Parameter(Mandatory)] [string]$PluginsJson,
  [switch]$EnablePmcro,
  [switch]$AllowExisting
)
& (Join-Path $PSScriptRoot 'generate-project-flat.ps1') @PSBoundParameters
