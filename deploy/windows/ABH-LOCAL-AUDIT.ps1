# Build, start, audit, test, and optionally package the ABH portal on this PC.
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\deploy\windows\ABH-LOCAL-AUDIT.ps1
#   powershell -ExecutionPolicy Bypass -File .\deploy\windows\ABH-LOCAL-AUDIT.ps1 -SkipBuild
#   powershell -ExecutionPolicy Bypass -File .\deploy\windows\ABH-LOCAL-AUDIT.ps1 -Package
param(
    [switch]$SkipBuild,
    [switch]$Package,
    [switch]$FullTest,
    [int]$Port = 4010
)

$ErrorActionPreference = 'Stop'
$Root = Resolve-Path (Join-Path $PSScriptRoot '..\..')
Set-Location $Root

$nodeHome = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\OpenJS.NodeJS.LTS_Microsoft.Winget.Source_8wekyb3d8bbwe\node-v24.19.0-win-x64'
if (Test-Path (Join-Path $nodeHome 'node.exe')) {
    $env:Path = "$nodeHome;" + $env:Path
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw 'Node.js is not on PATH. Install Node.js LTS, then run this script again.'
}

$failures = @()
function Pass([string]$Name) { Write-Host "[OK]   $Name" -ForegroundColor Green }
function Fail([string]$Name, [string]$Detail) {
    Write-Host "[FAIL] $Name — $Detail" -ForegroundColor Red
    $script:failures += "$Name — $Detail"
}

Write-Host ""
Write-Host "ABH local audit" -ForegroundColor Cyan
Write-Host "Root: $Root"
Write-Host "Node: $(node -v)"
Write-Host ""

if (-not $SkipBuild) {
    Write-Host "Building backend and portal..." -ForegroundColor Cyan
    npm run build
    if ($LASTEXITCODE -ne 0) { throw 'Backend build failed.' }
    npm --prefix 'SelfServiceSuite/SelfServicePortal/self-service-portal' run build:onprem
    if ($LASTEXITCODE -ne 0) { throw 'Portal build failed.' }
    $env:PORTAL_PROJECT_DIR = Join-Path $Root 'SelfServiceSuite\SelfServicePortal\self-service-portal'
    node scripts/copy-portal.mjs
    if ($LASTEXITCODE -ne 0) { throw 'Copying the portal build failed.' }
    $portalApi = Get-Content (Join-Path $Root 'src\portalApi.ts') -Raw
    if ($portalApi -match "PORTAL_API_BUILD = '([^']+)'") {
        Set-Content -Path (Join-Path $Root 'dist\BUILD_ID.txt') -Value $Matches[1] -NoNewline
    }
}

$logo = Join-Path $Root 'public\brand\abh-logo.png'
if (-not (Test-Path $logo)) {
    Fail 'Login logo file' 'public\brand\abh-logo.png is missing'
} else {
    $bytes = [System.IO.File]::ReadAllBytes($logo)
    $isPng = $bytes.Length -gt 8 -and $bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50 -and $bytes[2] -eq 0x4E -and $bytes[3] -eq 0x47
    if (-not $isPng) {
        Fail 'Login logo file' 'abh-logo.png is not a PNG'
    } else {
        Add-Type -AssemblyName System.Drawing
        $img = [System.Drawing.Bitmap]::FromFile($logo)
        $corner = $img.GetPixel(2, 2)
        $img.Dispose()
        if ($corner.A -ne 0) {
            Fail 'Login logo background' 'corner pixel is opaque, so the logo will show a box on the sign-in gradient'
        } else {
            Pass 'Login logo is a transparent PNG'
        }
    }
}

$portalJs = Get-ChildItem (Join-Path $Root 'public\assets\index-*.js') -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $portalJs) {
    Fail 'Portal bundle' 'public\assets\index-*.js was not found'
} else {
    $js = [System.IO.File]::ReadAllText($portalJs.FullName)
    if ($js -match 'Sign in as Application User') {
        Fail 'Login methods' 'Application User is still in the sign-in screen'
    } else {
        Pass 'Application User is not on the sign-in screen'
    }
    if ($js -notmatch 'Sign in as BC365 User') {
        Fail 'Login methods' 'BC365 sign-in is missing'
    } else {
        Pass 'BC365 sign-in is present'
    }
    if ($js -notmatch 'My Requests - Operations') {
        Fail 'Portal menu' 'the organisation-sheet menu is missing from the portal bundle'
    } else {
        Pass 'Portal menu matches the organisation sheet'
    }
}

Write-Host "Running backend tests..." -ForegroundColor Cyan
$env:BC_AUTH_MODE = 'none'
if ($FullTest) {
    node --test dist/approvalTableIds.test.js
} else {
    node --test --test-name-pattern "restricts Store actions" dist/approvalTableIds.test.js
}
if ($LASTEXITCODE -ne 0) {
    Fail 'Backend tests' 'node --test dist/approvalTableIds.test.js failed'
} else {
    Pass $(if ($FullTest) { 'Full backend tests' } else { 'Store workflow tests' })
}

$startedByScript = $false
$server = $null
try {
    $busy = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    if ($busy) {
        Fail 'Audit server' "Port $Port is already in use"
    } else {
        if (-not (Test-Path (Join-Path $Root '.env'))) {
            Copy-Item (Join-Path $Root '.env.example') (Join-Path $Root '.env')
        }
        $env:PORT = "$Port"
        $server = Start-Process -FilePath 'node' -ArgumentList 'dist/server.js' -WorkingDirectory $Root -PassThru -WindowStyle Hidden
        $startedByScript = $true
        $ready = $false
        for ($i = 0; $i -lt 30; $i++) {
            try {
                $health = Invoke-RestMethod "http://127.0.0.1:$Port/api/health" -TimeoutSec 2
                if ($health.ok) { $ready = $true; break }
            } catch { Start-Sleep -Seconds 1 }
        }
        if (-not $ready) {
            Fail 'API health' "http://127.0.0.1:$Port/api/health did not become ready"
        } else {
            Pass "API health on http://127.0.0.1:$Port/api/health"
            $build = Invoke-RestMethod "http://127.0.0.1:$Port/api/portal-build" -TimeoutSec 5
            Pass "Portal build: $($build.portalApiBuild)"
            $logoResponse = Invoke-WebRequest "http://127.0.0.1:$Port/brand/abh-logo.png" -UseBasicParsing -TimeoutSec 5
            $contentType = [string]$logoResponse.Headers['Content-Type']
            if ($contentType -notmatch 'image/png') {
                Fail 'Served logo' "expected image/png, got $contentType"
            } else {
                Pass 'Login logo is served as image/png'
            }
            $login = Invoke-WebRequest "http://127.0.0.1:$Port/login" -UseBasicParsing -TimeoutSec 5
            if ($login.Content -notmatch 'ABH Partners') {
                Fail 'Login page' 'sign-in page did not include ABH Partners'
            } else {
                Pass 'Login page opens'
            }
        }
    }
} finally {
    if ($startedByScript -and $server -and -not $server.HasExited) {
        Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
    }
}

if ($Package -and $failures.Count -eq 0) {
    $ssp = Join-Path $env:USERPROFILE 'OneDrive\Desktop\ssp'
    New-Item -ItemType Directory -Force -Path $ssp | Out-Null
    $stampText = ''
    $buildId = Join-Path $Root 'dist\BUILD_ID.txt'
    if (Test-Path $buildId) { $stampText = Get-Content $buildId -Raw }
    $version = 'local'
    if ($stampText -match '(\d+\.\d+\.\d+\.\d+)') { $version = $Matches[1] }
    $name = "ABH-Portal-COMPLETE-$version"
    $out = Join-Path $ssp $name
    if (Test-Path $out) { Remove-Item $out -Recurse -Force }
    New-Item -ItemType Directory -Force -Path (Join-Path $out 'SelfServiceSuite\SelfServiceBackend') | Out-Null
    robocopy (Join-Path $Root 'public') (Join-Path $out 'SelfServiceSuite\SelfServiceBackend\public') /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    robocopy (Join-Path $Root 'dist') (Join-Path $out 'SelfServiceSuite\SelfServiceBackend\dist') /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    robocopy (Join-Path $Root 'node_modules') (Join-Path $out 'SelfServiceSuite\SelfServiceBackend\node_modules') /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    Copy-Item (Join-Path $Root 'package.json') (Join-Path $out 'SelfServiceSuite\SelfServiceBackend\package.json')
    Copy-Item (Join-Path $Root 'deploy\windows') (Join-Path $out 'deploy\windows') -Recurse
    Copy-Item (Join-Path $Root 'deploy\windows\START-ABH-PORTAL.bat') (Join-Path $out 'START-ABH-PORTAL.bat')
    Copy-Item (Join-Path $Root 'deploy\windows\STOP-ABH-PORTAL.bat') (Join-Path $out 'STOP-ABH-PORTAL.bat')
    Copy-Item (Join-Path $Root 'deploy\windows\VERIFY-SUITE.bat') (Join-Path $out 'VERIFY-SUITE.bat')
    Copy-Item (Join-Path $Root 'deploy\windows\INSTALL-AUTOSTART.bat') (Join-Path $out 'INSTALL-AUTOSTART.bat')
    Copy-Item (Join-Path $Root 'deploy\windows\INSTALL-AUTOSTART.ps1') (Join-Path $out 'INSTALL-AUTOSTART.ps1')
    Copy-Item (Join-Path $Root 'deploy\windows\UNINSTALL-AUTOSTART.bat') (Join-Path $out 'UNINSTALL-AUTOSTART.bat')
    $zip = Join-Path $ssp "$name.zip"
    if (Test-Path $zip) { Remove-Item $zip -Force }
    tar.exe -a -c -f $zip -C $ssp $name
    if ($LASTEXITCODE -ne 0) { Fail 'Package' 'tar failed' } else { Pass "Package $zip" }
}

Write-Host ""
if ($failures.Count -gt 0) {
    Write-Host "AUDIT FAILED ($($failures.Count))" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host "AUDIT PASSED" -ForegroundColor Green
exit 0
