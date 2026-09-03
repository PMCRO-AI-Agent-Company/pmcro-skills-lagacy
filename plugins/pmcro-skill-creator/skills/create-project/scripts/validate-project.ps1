[CmdletBinding()]
param([Parameter(Mandatory)] [string]$Path)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$root=(Resolve-Path $Path).Path
$required=@('.agents\README.md','.agents\plugins\marketplace.json','.claude-plugin\marketplace.json','.github\plugin\marketplace.json','.cursor-plugin\marketplace.json','AGENTS.md','README.md')
foreach($item in $required){if(-not(Test-Path(Join-Path $root $item)-PathType Leaf)){throw "Missing required file: $item"}}
$manifests=@('.agents\plugins\marketplace.json','.claude-plugin\marketplace.json','.github\plugin\marketplace.json','.cursor-plugin\marketplace.json')
$canonical=Get-Content -Raw(Join-Path $root $manifests[0])|ConvertFrom-Json
foreach($m in $manifests[1..3]){if((Get-Content -Raw(Join-Path $root $m)|ConvertFrom-Json|ConvertTo-Json -Depth 8) -ne ($canonical|ConvertTo-Json -Depth 8)){throw "Marketplace manifests are not synchronized: $m"}}
$plugins=@($canonical.plugins);if($plugins.Count-eq 0){throw 'Marketplace contains no plugins.'}
foreach($p in $plugins){
  $name=[string]$p.name;$source=[string]$p.source
  if($name-notmatch'^[a-z0-9]+(?:-[a-z0-9]+)*$'){throw "Invalid plugin name: $name"}
  if([string]::IsNullOrWhiteSpace($source)){throw "Missing plugin source: $name"}
  $external=$source -match '^(https://|github:|external:)'
  if($external){continue}
  $dir=Join-Path $root "plugins\$name"
  foreach($file in @('plugin.json','version.json')){if(-not(Test-Path(Join-Path $dir $file)-PathType Leaf)){throw "Missing $file for plugin $name"}}
  $skills=Join-Path $dir 'skills';if(-not(Test-Path $skills -PathType Container)){throw "Missing skills directory for $name"}
  $skillDirs=@(Get-ChildItem $skills -Directory);if($skillDirs.Count-eq 0){throw "Plugin contains no skills: $name"}
  foreach($sd in $skillDirs){
    if($sd.Name-notmatch'^[a-z0-9]+(?:-[a-z0-9]+)*$'){throw "Invalid skill name: $($sd.Name)"}
    if(-not(Test-Path(Join-Path $sd.FullName 'SKILL.md')-PathType Leaf)){throw "Missing SKILL.md: $($sd.Name)"}
    foreach($support in @('assets','references','scripts')){if(-not(Test-Path(Join-Path $sd.FullName $support)-PathType Container)){throw "Missing ${support}: $($sd.Name)"};if(@(Get-ChildItem(Join-Path $sd.FullName $support)-Directory).Count-gt 0){throw "Support directory must be flat: $($sd.Name)\$support"}}
    $eval=Join-Path $root "tests\$name\$($sd.Name)\eval.yaml";if(-not(Test-Path $eval -PathType Leaf)){throw "Missing evaluation contract: tests\$name\$($sd.Name)\eval.yaml"}
  }
}
Write-Output "PASS: Agent Skills project structure is valid: $root"
