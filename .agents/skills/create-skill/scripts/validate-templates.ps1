param([Parameter(Mandatory)][string]$SkillPath)
$ErrorActionPreference='Stop'
$t=Join-Path $SkillPath 'assets\templates'
if(-not(Test-Path $t)){throw 'Missing assets/templates'}
$templates=Get-ChildItem $t -File
if($templates.Count -eq 0){throw 'No templates found'}
foreach($f in $templates){if([string]::IsNullOrWhiteSpace((Get-Content $f.FullName -Raw))){throw "Empty template: $($f.Name)"}}
Write-Host "PASS: $($templates.Count) non-empty templates"