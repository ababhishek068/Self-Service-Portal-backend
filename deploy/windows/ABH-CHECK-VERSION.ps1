# ABH — check BC + portal versions (run in Business Central Administration Shell)
param(
    [string]$ServerInstance = 'BC240',
    [string]$PortalUrl = 'http://146.161.102.7:4000'
)

Write-Host "`n=== BC SERVER ===" -ForegroundColor Cyan
Get-NAVServerInstance -ServerInstance $ServerInstance | Format-List ServerInstance, State, Version

Write-Host "`n=== BC24_TA App (INSTALLED only) ===" -ForegroundColor Cyan
$installedBcApp = Get-NAVAppInfo -ServerInstance $ServerInstance -Name 'BC24_TA App' |
    Where-Object { $_.IsInstalled -eq $true } |
    Sort-Object Version -Descending |
    Select-Object -First 1
$installedBcApp | Format-Table Name, Version, Published, Installed, IsInstalled -AutoSize
if (-not $installedBcApp -or $installedBcApp.Version -ne [version]'1.0.3.273') {
    Write-Host "WARNING: Expected installed BC24_TA App 1.0.3.273." -ForegroundColor Yellow
}

Write-Host "`n=== BC24_TA App (all published — old versions are normal) ===" -ForegroundColor DarkGray
Get-NAVAppInfo -ServerInstance $ServerInstance -Name 'BC24_TA App' |
    Sort-Object Version |
    Format-Table Version, Published, Installed, IsInstalled -AutoSize

Write-Host "`n=== PORTAL API ===" -ForegroundColor Cyan
try {
    $build = Invoke-RestMethod -Uri "$PortalUrl/api/portal-build" -TimeoutSec 10
    Write-Host "portalApiBuild: $($build.portalApiBuild)" -ForegroundColor Green
    if ($build.portalApiBuild -notlike '*v194*1.0.3.345*') {
        Write-Host "WARNING: Expected v194 / 1.0.3.345. Deploy ABH-Portal-COMPLETE-1.0.3.345.zip" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Portal not reachable at $PortalUrl — is node running?" -ForegroundColor Red
    Write-Host $_.Exception.Message
}

try {
    $health = Invoke-RestMethod -Uri "$PortalUrl/api/health" -TimeoutSec 10
    Write-Host "health: ok=$($health.ok) build=$($health.build)" -ForegroundColor Green
} catch {
    Write-Host "health check failed" -ForegroundColor Red
}

Write-Host "`nDone.`n" -ForegroundColor Cyan
