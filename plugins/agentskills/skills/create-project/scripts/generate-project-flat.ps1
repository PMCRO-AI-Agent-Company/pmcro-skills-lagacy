[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(Mandatory)][string]$Name,
  [Parameter(Mandatory)][string]$DisplayName,
  [Parameter(Mandatory)][string]$Description,
  [string]$OutputPath,
  [Parameter(Mandatory)][string]$PluginsJson,
  [switch]$EnablePmcro,
  [switch]$AllowExisting
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($Name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw "Invalid project name: $Name" }
if ([string]::IsNullOrWhiteSpace($DisplayName) -or [string]::IsNullOrWhiteSpace($Description)) { throw 'DisplayName and Description are required.' }
$plugins = @(ConvertFrom-Json -InputObject (Get-Content -Raw $PluginsJson) | ForEach-Object { $_ })
if ($EnablePmcro -and -not @($plugins | Where-Object { [string]$_.name -eq 'pmcro-loop' })) {
  $plugins += [pscustomobject]@{ name='pmcro-loop'; description='Canonical PMCR-O cognitive loop: Orchestrator → Planner → Maker → Checker → Reflector with one shared colony priority queue.'; source='./plugins/pmcro-loop'; trust='first-party' }
}
if ($plugins.Count -eq 0) { throw 'PluginsJson must contain at least one plugin.' }
$seen = @{}
foreach ($p in $plugins) {
  $pn = [string]$p.name
  if ($pn -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw "Invalid plugin name: $pn" }
  if ($seen.ContainsKey($pn)) { throw "Duplicate plugin name: $pn" }
  $seen[$pn] = $true
}
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..')).Path
if ([string]::IsNullOrWhiteSpace($OutputPath)) { $OutputPath = Join-Path $repoRoot "projects\$Name" }
elseif (-not [IO.Path]::IsPathRooted($OutputPath)) { $OutputPath = Join-Path $repoRoot $OutputPath }
$root = [IO.Path]::GetFullPath($OutputPath)
if ((Test-Path $root) -and -not $AllowExisting -and @(Get-ChildItem $root -Force).Count -gt 0) { throw "Destination is not empty: $root" }
if ($PSCmdlet.ShouldProcess($root,'Generate Agent Skills project')) {
  New-Item -ItemType Directory -Force -Path $root | Out-Null
  foreach ($d in @('.agents\plugins','.claude-plugin','.github\plugin','.cursor-plugin','plugins','tests')) { New-Item -ItemType Directory -Force -Path (Join-Path $root $d) | Out-Null }
  $render = { param($file,$tokens); $text=Get-Content -Raw $file; foreach($k in $tokens.Keys){$text=$text.Replace("{{$k}}",[string]$tokens[$k])}; $text }
  $asset = Join-Path $PSScriptRoot '..\assets'
  $tokens=@{PROJECT_NAME=$Name;DISPLAY_NAME=$DisplayName;DESCRIPTION=$Description}
  foreach($f in @('AGENTS.md.template','README.md.template')) { Set-Content (Join-Path $root ($f -replace '\.template$','')) (&$render (Join-Path $asset $f) $tokens) -NoNewline }
  $market=&$render (Join-Path $asset 'marketplace.json.template') $tokens | ConvertFrom-Json
  $market.plugins=@()
  foreach($p in $plugins) {
    $pn=[string]$p.name
    $src=if($p.PSObject.Properties.Name -contains 'source' -and $p.source){[string]$p.source}else{"./plugins/$pn"}
    $desc=[string]$p.description
    $market.plugins += [pscustomobject]@{name=$pn;source=$src;description=$desc}
    if($src -match '^(https://|github:|external:)'){continue}
    $pd=Join-Path $root "plugins\$pn"
    if($pn -eq 'pmcro-loop' -and (Test-Path (Join-Path $repoRoot 'plugins\pmcro-loop'))) {
      Copy-Item (Join-Path $repoRoot 'plugins\pmcro-loop') $pd -Recurse -Force
      $pmcroTests=Join-Path $repoRoot 'tests\pmcro-loop'
      if(Test-Path $pmcroTests) { Copy-Item $pmcroTests (Join-Path $root 'tests\pmcro-loop') -Recurse -Force }
      continue
    }
    $sd=Join-Path $pd 'skills\starter'
    New-Item -ItemType Directory -Force -Path $sd | Out-Null
    foreach($d in 'assets','references','scripts') {
      $dd=Join-Path $sd $d
      New-Item -ItemType Directory -Force -Path $dd | Out-Null
      Set-Content (Join-Path $dd '.gitkeep') '' -NoNewline
    }
    $pluginJson=@{
      '$schema'='https://agent-plugins.org/schemas/1.0.0/plugin.schema.json'
      name=$pn; version='0.1.0'; description=$desc; license='MIT'
    } | ConvertTo-Json -Depth 8
    Set-Content (Join-Path $pd 'plugin.json') $pluginJson -NoNewline
    @{name=$pn;version='0.1.0'} | ConvertTo-Json | Set-Content (Join-Path $pd 'version.json') -NoNewline
    Set-Content (Join-Path $pd 'README.md') "# $pn`n`n$desc`n" -NoNewline
    $skill="---`nname: starter`ndescription: Generated starter skill for $pn.`nlicense: MIT`n---`n`n# starter`n`n$desc`n"
    Set-Content (Join-Path $sd 'SKILL.md') $skill -NoNewline
    $td=Join-Path $root "tests\$pn\starter"
    New-Item -ItemType Directory -Force -Path $td | Out-Null
    "name: starter`nskill: starter`n`ndefaults:`n  timeout: 5m`n  runs: 1`n`nstimuli:`n  - name: smoke`n    prompt: Validate the generated starter skill.`n    graders:`n      - type: exit-success`n" | Set-Content (Join-Path $td 'eval.yaml') -NoNewline
  }
  $json=$market|ConvertTo-Json -Depth 8
  foreach($m in @('.agents\plugins\marketplace.json','.claude-plugin\marketplace.json','.github\plugin\marketplace.json','.cursor-plugin\marketplace.json')) { Set-Content (Join-Path $root $m) $json -NoNewline }
  Set-Content (Join-Path $root '.agents\README.md') "# $DisplayName`n`nProject-local Agent Skills environment.`n" -NoNewline
  if($EnablePmcro) {
    $pmcroTemplate=Join-Path $repoRoot 'project\.pmcro'
    if(-not (Test-Path $pmcroTemplate)) { throw "PMCR-O template missing: $pmcroTemplate" }
    Copy-Item $pmcroTemplate (Join-Path $root '.pmcro') -Recurse -Force
  }
  $lock=@{version=1;plugins=@($plugins|ForEach-Object{$src=if($_.PSObject.Properties.Name -contains 'source' -and $_.source){[string]$_.source}else{"./plugins/$([string]$_.name)"};[pscustomobject]@{name=[string]$_.name;source=$src;trust=if($_.PSObject.Properties.Name -contains 'trust' -and $_.trust){[string]$_.trust}else{'generated'}}})}
  $pmcroLock=@($lock.plugins | Where-Object name -eq 'pmcro-loop')
  if($pmcroLock.Count -eq 1) {
    $pmcroLock[0] | Add-Member -NotePropertyName version -NotePropertyValue '0.1.0'
    $pmcroLock[0] | Add-Member -NotePropertyName upstream -NotePropertyValue 'https://github.com/ShawnDelaineBellazanLoop/pmcro-loop'
    $pmcroLock[0] | Add-Member -NotePropertyName pinnedCommit -NotePropertyValue '43779e337c1225ecf408348fc71b99a087db62b7'
  }
  $lock|ConvertTo-Json -Depth 8|Set-Content (Join-Path $root '.agents\plugins\plugins.lock.json') -NoNewline
  Write-Output "GENERATED: $root"
}
