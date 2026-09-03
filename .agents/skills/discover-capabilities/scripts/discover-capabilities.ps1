[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $ProjectsRoot,
    [string] $OutputPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RelativePath([string] $Base, [string] $Target) {
    $baseUri = New-Object System.Uri(($Base.TrimEnd('\') + '\'))
    $targetUri = New-Object System.Uri($Target)
    return [Uri]::UnescapeDataString($baseUri.MakeRelativeUri($targetUri).ToString()).Replace('/', '\')
}

$root = (Resolve-Path -LiteralPath $ProjectsRoot).Path
if (-not $OutputPath) {
    $repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
    $OutputPath = Join-Path $repoRoot '.pmcro/capability-registry.json'
}
$manifests = @(Get-ChildItem -LiteralPath $root -Filter 'plugin.json' -File -Recurse |
    Where-Object { $_.FullName -notmatch '[\\/]\.git([\\/]|$)' -and
        $_.FullName -notmatch '[\\/]\.(codex|claude|cursor)-plugin[\\/]' -and
        $_.FullName -notmatch '[\\/]docs[\\/]legacy([\\/]|$)' })
$providers = @()
foreach ($file in $manifests) {
    try { $manifest = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json }
    catch { continue }
    if (-not $manifest.name) { continue }
    $pluginRoot = $file.Directory.FullName
    $relativeRoot = Get-RelativePath $root $pluginRoot
    $artifacts = @()
    foreach ($kind in @('skills','agents','commands','workflows')) {
        if (-not ($manifest.PSObject.Properties.Name -contains $kind)) { continue }
        foreach ($entry in @($manifest.$kind)) {
            if (-not $entry) { continue }
            $candidate = Join-Path $pluginRoot ([string]$entry)
            $exists = Test-Path -LiteralPath $candidate
            $resolved = if ($exists) { (Resolve-Path -LiteralPath $candidate).Path } else { $candidate }
            $artifacts += [ordered]@{
                kind = $kind
                declared = [string]$entry
                exists = $exists
                path = Get-RelativePath $root $resolved
            }
        }
    }
    $capabilities = @([ordered]@{ type='plugin'; name=[string]$manifest.name; description=[string]$manifest.description })
    foreach ($artifact in @($artifacts | Where-Object { $_.exists })) {
        $label = Split-Path -Leaf ($artifact.path.TrimEnd('\/'))
        $capabilities += [ordered]@{ type=$artifact.kind.TrimEnd('s'); name=$label; description="Declared by $($manifest.name)" }
    }
    $parts = $relativeRoot -split '[\\/]'
    $providers += [ordered]@{
        name=[string]$manifest.name
        version=if ($manifest.version) { [string]$manifest.version } else { $null }
        description=if ($manifest.description) { [string]$manifest.description } else { '' }
        project=$parts[0]
        root=$relativeRoot
        manifest=Get-RelativePath $root $file.FullName
        capabilities=$capabilities
        artifacts=$artifacts
    }
}
$registry = [ordered]@{
    schema_version='1.0'
    generated_at=[DateTime]::UtcNow.ToString('o')
    projects_root='.'
    provider_count=$providers.Count
    providers=$providers
}
$outDir=Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$registry | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Output "Discovered $($providers.Count) plugin providers."
Write-Output "Registry: $OutputPath"
