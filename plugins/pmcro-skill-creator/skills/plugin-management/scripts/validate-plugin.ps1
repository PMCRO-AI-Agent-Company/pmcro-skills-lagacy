[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$Path)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
if(-not(Test-Path -LiteralPath $Path -PathType Container)){throw "Plugin path not found: $Path"}
$m=Join-Path $Path 'plugin.json'
if(-not(Test-Path -LiteralPath $m -PathType Leaf)){throw 'Missing plugin.json'}
$j=Get-Content -Raw $m|ConvertFrom-Json
if([string]$j.'$schema' -ne 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json'){throw 'plugin.json must target Agent Plugins 1.0.0.'}
$allowed=@('$schema','name','version','description','author','homepage','repository','license','keywords','extensions')
foreach($prop in $j.PSObject.Properties.Name){if($prop -notin $allowed){throw "Unsupported root plugin.json field: $prop"}}
if([string]$j.name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$'){throw "Invalid plugin name: $($j.name)"}
if([string]::IsNullOrWhiteSpace([string]$j.version)){throw 'Missing plugin version'}
if([string]::IsNullOrWhiteSpace([string]$j.description)){throw 'Missing plugin description'}
if(-not(Test-Path (Join-Path $Path 'version.json') -PathType Leaf)){throw 'Missing version.json'}
if(Test-Path (Join-Path $Path '.codex-plugin\plugin.json')){
  $c=Get-Content -Raw (Join-Path $Path '.codex-plugin\plugin.json')|ConvertFrom-Json
  if([string]$c.name -ne [string]$j.name){throw 'Codex manifest name mismatch'}
  if([string]$c.version -ne [string]$j.version){throw 'Codex manifest version mismatch'}
}
$skills=Join-Path $Path 'skills'
if(-not(Test-Path $skills -PathType Container)){throw 'Missing skills directory'}
$found=@(Get-ChildItem $skills -Directory);if($found.Count-eq 0){throw 'Plugin contains no skills'}
foreach($s in $found){
  if($s.Name-notmatch'^[a-z0-9]+(?:-[a-z0-9]+)*$'){throw "Invalid skill name: $($s.Name)"}
  $skill=Join-Path $s.FullName 'SKILL.md';if(-not(Test-Path $skill -PathType Leaf)){throw "Missing SKILL.md: $($s.Name)"}
  foreach($d in 'assets','references','scripts'){
    $p=Join-Path $s.FullName $d;if(-not(Test-Path $p -PathType Container)){throw "Missing $d directory: $($s.Name)"}
    if(@(Get-ChildItem $p -Directory).Count-gt 0){throw "Non-flat $d directory: $($s.Name)"}
  }
}
Write-Output "PASS plugin: $($j.name)"
