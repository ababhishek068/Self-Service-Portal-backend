# One-shot publish + sync + upgrade for ABH BC24_TA App (leave cancel + portal approve fixes).
# Run in Business Central Administration Shell AS ADMINISTRATOR.
param(
    [string]$ErpFolder = "$env:USERPROFILE\Desktop\Erp",
    [string]$ServerInstance = "BC240",
    [string]$TargetVersion = "1.0.2.924",
    [string]$Publisher = "Technology Associates EA Ltd",
    [string]$AppName = "BC24_TA App"
)

$ErrorActionPreference = "Stop"
$AppFile = Join-Path $ErpFolder ("Technology Associates EA Ltd_BC24_TA App_{0}.app" -f $TargetVersion)

Set-Location $ErpFolder
Write-Host "=== ABH BC publish $TargetVersion ===" -ForegroundColor Cyan
Write-Host "Folder: $ErpFolder"

if (-not (Test-Path $AppFile)) {
    throw @"
Missing: $AppFile
Copy from Mac Desktop\Erp via AnyDesk:
  Technology Associates EA Ltd_BC24_TA App_1.0.2.924.app
Expected size ~7,613,500 bytes.
"@
}

$size = (Get-Item $AppFile).Length
Write-Host "App file: $size bytes"
if ($size -lt 7000000) { throw "File too small — copy was truncated. Re-copy from Mac." }

$before = Get-NAVAppInfo -ServerInstance $ServerInstance -Name $AppName -Publisher $Publisher |
    Sort-Object Version -Descending | Select-Object -First 3 Version, IsPublished, IsInstalled
Write-Host "`nBefore:"; $before | Format-Table -AutoSize

Write-Host "Publishing $TargetVersion ..." -ForegroundColor Yellow
Publish-NAVApp -Path $AppFile -ServerInstance $ServerInstance -SkipVerification

$pub = Get-NAVAppInfo -ServerInstance $ServerInstance -Name $AppName -Publisher $Publisher |
    Where-Object { $_.Version -eq [version]$TargetVersion }
if (-not $pub -or -not $pub.IsPublished) {
    throw "Publish failed — $TargetVersion not in published apps. Re-copy the .app file from Mac."
}
Write-Host "Published OK." -ForegroundColor Green

Write-Host "Syncing tenant default ..." -ForegroundColor Yellow
Sync-NAVApp -ServerInstance $ServerInstance -Tenant default -Name $AppName -Publisher $Publisher -Version $TargetVersion

Write-Host "Data upgrade ..." -ForegroundColor Yellow
Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant default -Name $AppName -Publisher $Publisher -Version $TargetVersion

$after = Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant default -TenantSpecificProperties -Name $AppName |
    Where-Object { $_.Version -eq [version]$TargetVersion }
if (-not $after -or -not $after.IsInstalled) {
    throw "Upgrade failed — $TargetVersion not installed on tenant default."
}

Write-Host "`n=== SUCCESS ===" -ForegroundColor Green
$after | Format-List Name, Publisher, Version, IsPublished, IsInstalled
Write-Host "Next: BC client -> Web Services -> CuStaffPortal (50049) -> Published = Yes"
Write-Host "Portal ZIP: purchase-leave-cancel-fix-v4 (BUILD_ID purchase-leave-cancel-fix-2026-07-10-v4)"
