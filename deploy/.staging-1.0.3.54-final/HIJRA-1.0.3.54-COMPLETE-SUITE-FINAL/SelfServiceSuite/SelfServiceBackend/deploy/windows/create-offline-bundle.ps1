param(
    [string]$OutputDirectory = "SelfServicePortal-Windows"
)

$ErrorActionPreference = "Stop"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$outputPath = Join-Path $projectRoot $OutputDirectory
$zipPath = "$outputPath.zip"

Push-Location $projectRoot
try {
    npm ci
    npm --prefix ..\SelfServicePortal\self-service-portal ci
    npm run build:all
} finally {
    Pop-Location
}

Remove-Item $outputPath -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
New-Item $outputPath -ItemType Directory | Out-Null

Copy-Item (Join-Path $projectRoot "dist") $outputPath -Recurse
Copy-Item (Join-Path $projectRoot "public") $outputPath -Recurse
Copy-Item (Join-Path $projectRoot "deploy") $outputPath -Recurse
Copy-Item (Join-Path $projectRoot "package.json") $outputPath
Copy-Item (Join-Path $projectRoot "package-lock.json") $outputPath

Push-Location $outputPath
try {
    npm ci --omit=dev
} finally {
    Pop-Location
}

Compress-Archive -Path (Join-Path $outputPath "*") -DestinationPath $zipPath -Force
Write-Host "Offline Windows bundle created at $zipPath"
