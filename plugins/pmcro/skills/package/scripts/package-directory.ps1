[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [Parameter(Mandatory = $true)]
    [ValidateSet('directory','gemini','agents')]
    [string]$Target,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourcePath = (Resolve-Path -LiteralPath $Source).Path
if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
    throw "Source must be a directory: $Source"
}

$destination = [IO.Path]::GetFullPath($OutputPath)
if (Test-Path -LiteralPath $destination) {
    throw "Output path already exists: $destination"
}

function Copy-SafeTree {
    param(
        [string]$From,
        [string]$To
    )

    $protected = @('.git', '.env', '.env.*', 'secrets', 'credentials', '.pmcro/approvals.jsonl')
    New-Item -ItemType Directory -Path $To -Force | Out-Null

    Get-ChildItem -LiteralPath $From -Recurse -Force | ForEach-Object {
        $relative = [IO.Path]::GetRelativePath($From, $_.FullName) -replace '\\', '/'
        foreach ($pattern in $protected) {
            if ($relative -eq $pattern -or $relative.StartsWith("$pattern/", [StringComparison]::OrdinalIgnoreCase)) {
                return
            }
        }

        $target = Join-Path $To $relative
        if ($_.PSIsContainer) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        }
        elseif ((Get-Item -LiteralPath $_.FullName).Length -gt 0) {
            $bytes = [IO.File]::ReadAllBytes($_.FullName)
            if ($bytes -contains 0) { return }
            New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
            [IO.File]::WriteAllBytes($target, $bytes)
        }
    }
}

switch ($Target) {
    'directory' { $projectionRoot = $destination }
    'gemini'    { $projectionRoot = Join-Path $destination '.gemini/skills' }
    'agents'    { $projectionRoot = Join-Path $destination '.agents/skills' }
}

Copy-SafeTree -From $sourcePath -To $projectionRoot
Write-Output "Package projection written to $destination"
