param([Parameter(Mandatory)][string]$Path)
$ErrorActionPreference='Stop'
Get-ChildItem -LiteralPath $Path -Recurse -File | ForEach-Object { $_.FullName.Substring($Path.TrimEnd('\').Length + 1) }