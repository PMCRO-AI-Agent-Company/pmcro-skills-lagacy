[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [Parameter(Mandatory = $true)]
    [ValidateSet('txt','zip','directory','gemini','agents')]
    [string]$Target,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [string[]]$Exclude = @('.git','node_modules','bin','obj','.venv','__pycache__','secrets','credentials','.env','.env.*','.pmcro/approvals.jsonl','.pmcro/secrets','.pmcro/credentials')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourcePath = (Resolve-Path -LiteralPath $Source).Path
if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) { throw "Source must be a directory: $Source" }

$destination = [IO.Path]::GetFullPath($OutputPath)
$parent = Split-Path -Parent $destination
if ($parent -and $parent -ne (Split-Path -Qualifier $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
}

$packageScriptRoot = Split-Path -Parent $PSCommandPath
$dumpScript = Join-Path $packageScriptRoot '..\..\source-dump\scripts\export-source-dump.ps1'

if ($Target -eq 'txt') {
    & $dumpScript -Root $sourcePath -Exclude $Exclude -OutputPath $destination
    exit $LASTEXITCODE
}

if ($Target -eq 'zip') {
    if (Test-Path -LiteralPath $destination) { throw "Output path already exists: $destination" }
    $staging = Join-Path ([IO.Path]::GetTempPath()) ("pmcro-package-" + [Guid]::NewGuid().ToString('N'))
    try {
        & (Join-Path $packageScriptRoot 'package-directory.ps1') -Source $sourcePath -Target directory -OutputPath $staging
        Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $destination -CompressionLevel Optimal
    }
    finally {
        if (Test-Path -LiteralPath $staging) { Remove-Item -LiteralPath $staging -Recurse -Force }
    }
    Write-Output "Package written to $destination"
    exit 0
}

& (Join-Path $packageScriptRoot 'package-directory.ps1') -Source $sourcePath -Target $Target -OutputPath $destination
exit $LASTEXITCODE
