param([Parameter(Mandatory)][string]$SkillPath)
$ErrorActionPreference='Stop'
$r=Join-Path $SkillPath 'references'
if(-not(Test-Path $r)){throw 'Missing references'}
$refs=Get-ChildItem $r -File -Recurse
if($refs.Count -eq 0){throw 'No references found'}
$skill=Get-Content (Join-Path $SkillPath 'SKILL.md') -Raw
$paths=[regex]::Matches($skill,'(?:(?:assets/templates|references|scripts)/[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*)')|ForEach-Object Value|Sort-Object -Unique
foreach($relative in $paths){$target=Join-Path $SkillPath ($relative -replace '/','\');if(-not(Test-Path $target)){throw "Missing documented artifact: $relative"}}
Write-Host "PASS: references and documented artifact paths verified"