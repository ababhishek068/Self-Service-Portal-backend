# Paste this ENTIRE file to Desktop\Erp as List-And-Install-AbhBc.ps1
# OR copy-paste the block from the chat into PowerShell.
# Run AS ADMIN in BC Administration Shell:
#   cd $env:USERPROFILE\Desktop\Erp
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   .\List-And-Install-AbhBc.ps1

$ErrorActionPreference = "Stop"
$si = "BC240"
$name = "BC24_TA App"
$pub = "Technology Associates EA Ltd"
$erp = "$env:USERPROFILE\Desktop\Erp"

Write-Host "`n=== 1) What BC knows about (server) ===" -ForegroundColor Cyan
$all = @(Get-NAVAppInfo -ServerInstance $si -Name $name -Publisher $pub | Sort-Object Version -Descending)
if (-not $all) {
  Write-Host "Get-NAVAppInfo returned NOTHING — extension may never have been published on this instance." -ForegroundColor Red
} else {
  $all | Select-Object -First 25 Version, IsPublished, IsInstalled | Format-Table -AutoSize
}

Write-Host "`n=== 2) What is INSTALLED on tenant default ===" -ForegroundColor Cyan
$installed = @(Get-NAVAppInfo -ServerInstance $si -Tenant default -TenantSpecificProperties -Name $name |
  Where-Object { $_.IsInstalled })
if ($installed) { $installed | Format-List Name, Version, IsInstalled }
else { Write-Host "(nothing installed on tenant)" -ForegroundColor Yellow }

$published = @($all | Where-Object { $_.IsPublished } | Sort-Object Version -Descending)
if ($published) {
  $target = $published[0]
  $ver = $target.Version.ToString()
  Write-Host "`n=== 3) Highest PUBLISHED: $ver (installed=$($target.IsInstalled)) ===" -ForegroundColor Green
  if (-not $target.IsInstalled) {
    Write-Host "Sync + upgrade to $ver ..." -ForegroundColor Yellow
    Sync-NAVApp -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version $ver
    Start-NAVAppDataUpgrade -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version $ver
    Write-Host "DONE — installed $ver. Republish CuStaffPortal 50049." -ForegroundColor Green
    exit 0
  }
  Write-Host "Already on highest published $ver." -ForegroundColor Green
  exit 0
}

Write-Host "`n=== 3) Nothing published — try Felix 908.app ===" -ForegroundColor Yellow
$felix908 = Join-Path $erp "Technology Associates EA Ltd_BC24_TA App_1.0.2.908.app"
if (-not (Test-Path $felix908)) { throw "No published versions AND no 908.app in Erp. Ask Felix to publish from AL compile." }

Write-Host "Publish-NAVApp 908 ..." -ForegroundColor Yellow
Publish-NAVApp -Path $felix908 -ServerInstance $si -SkipVerification

$check = Get-NAVAppInfo -ServerInstance $si -Name $name -Publisher $pub |
  Where-Object { $_.Version -eq [version]"1.0.2.908" -and $_.IsPublished }
if (-not $check) {
  throw "Publish completed but 908 still not in Get-NAVAppInfo. Check Application event log for NAV errors. Mac/repack .app files do not register on this server."
}

Write-Host "Sync + upgrade 908 ..." -ForegroundColor Yellow
Sync-NAVApp -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version 1.0.2.908
Start-NAVAppDataUpgrade -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version 1.0.2.908
Write-Host "DONE — installed 908. Republish CuStaffPortal 50049." -ForegroundColor Green
