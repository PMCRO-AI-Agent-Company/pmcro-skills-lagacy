[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string]$Template,
  [Parameter(Mandatory)] [string]$Output,
  [hashtable]$Tokens = @{}
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$text = Get-Content -Raw -LiteralPath $Template
foreach ($key in $Tokens.Keys) {
  $text = $text.Replace("{{$key}}", [string]$Tokens[$key])
}
if ($text -match '{{[^}]+}}') { throw 'Unknown template token remains after rendering.' }
$target = [IO.Path]::GetFullPath($Output)
$parent = Split-Path -Parent $target
if ($parent) { New-Item -ItemType Directory -Force $parent | Out-Null }
if (Test-Path $target) { throw "Refusing to overwrite existing file: $target" }
Set-Content -LiteralPath $target -Value $text -Encoding utf8NoBOM
Write-Output "RENDERED: $target"
