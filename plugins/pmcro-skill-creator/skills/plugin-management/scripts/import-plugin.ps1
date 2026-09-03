[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(Mandatory)][string]$Source,
  [Parameter(Mandatory)][string]$Destination,
  [string]$Ref,
  [ValidateSet('first-party','third-party','local','generated')][string]$Trust='third-party'
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
if($Destination -match '(^|[\\/])\.\.([\\/]|$)'){throw 'Destination traversal is not allowed.'}
if(Test-Path -LiteralPath $Destination){throw "Destination exists: $Destination"}
$stage=Join-Path ([IO.Path]::GetTempPath()) ('agent-skills-'+[guid]::NewGuid())
New-Item -ItemType Directory -Force -Path $stage|Out-Null
try {
  $gitSource=$Source
  if($Source -match '^github:([^/]+)/([^/]+)$'){$gitSource="https://github.com/$($Matches[1])/$($Matches[2]).git"}
  if($gitSource -match '^https://'){
    $args=@('clone','--depth','1');if($Ref){$args+=@('--branch',$Ref)};$args+=@($gitSource,$stage)
    if(-not $WhatIfPreference){& git @args;if($LASTEXITCODE-ne 0){throw 'git clone failed.'}}
  } else {
    $resolved=(Resolve-Path -LiteralPath $Source).Path
    Copy-Item -LiteralPath (Join-Path $resolved '*') -Destination $stage -Recurse -Force
  }
  if(-not $WhatIfPreference){& (Join-Path $PSScriptRoot 'validate-plugin.ps1') -Path $stage}
  if($PSCmdlet.ShouldProcess($Destination,'Register plugin')){
    New-Item -ItemType Directory -Force -Path (Split-Path $Destination -Parent)|Out-Null
    Copy-Item -LiteralPath (Join-Path $stage '*') -Destination $Destination -Recurse -Force
  }
  Write-Output "VALIDATED: $Source [$Trust]"
} finally {if(Test-Path $stage){Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue}}
