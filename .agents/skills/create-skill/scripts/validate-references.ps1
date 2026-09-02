param([Parameter(Mandatory)][string]$SkillPath)
$ErrorActionPreference='Stop'
$r=Join-Path $SkillPath 'references'
if(-not(Test-Path $r)){throw 'Missing references'}
$refs=Get-ChildItem $r -File
if($refs.Count -eq 0){throw 'No references found'}
$skill=Get-Content (Join-Path $SkillPath 'SKILL.md') -Raw
$paths=[regex]::Matches($skill,'(?:(?:assets|references|scripts)/[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*)')|ForEach-Object Value|Sort-Object -Unique
foreach($relative in $paths){
  if($relative -eq 'assets/templates'){continue}
  $target=Join-Path $SkillPath ($relative -replace '/','\')
  if(Test-Path $target -PathType Container){continue}
  if(-not(Test-Path $target -PathType Leaf)){throw "Missing documented artifact: $relative"}
}
Write-Host "PASS: references and documented artifact paths verified"
