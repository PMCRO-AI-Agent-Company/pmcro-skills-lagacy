param(
 [Parameter(Mandatory)][string]$SkillPath,
 [Parameter(Mandatory)][ValidateSet('rule','command','agent')][string]$Type,
 [Parameter(Mandatory)][string]$Name
)
$ErrorActionPreference='Stop'
$map=@{rule=@('rules','rule.md.template');command=@('commands','command.md.template');agent=@('agents','agent.md.template')}
$dir,$template=$map[$Type]
$targetDir=Join-Path $SkillPath $dir;New-Item -ItemType Directory -Force -Path $targetDir|Out-Null
$out=Join-Path $targetDir $Name
if(Test-Path $out){throw "Refusing to overwrite existing artifact: $out"}
Copy-Item (Join-Path $SkillPath "assets\templates\$template") $out
Write-Host "Scaffolded $Type: $out"