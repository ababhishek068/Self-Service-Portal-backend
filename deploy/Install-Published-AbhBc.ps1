# Install highest ALREADY-PUBLISHED BC24_TA App (no new Publish needed).
# Felix / earlier deploys may have published 918-922 — only Install was missing.
# Run in BC Administration Shell AS ADMIN:
#   cd $env:USERPROFILE\Desktop\Erp
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   .\Install-Published-AbhBc.ps1

$ErrorActionPreference = "Stop"
$si = "BC240"
$name = "BC24_TA App"
$pub = "Technology Associates EA Ltd"

Write-Host "=== Published BC24_TA App versions on this server ===" -ForegroundColor Cyan
$all = Get-NAVAppInfo -ServerInstance $si -Name $name -Publisher $pub |
  Sort-Object Version -Descending
$all | Select-Object -First 20 Version, IsPublished, IsInstalled | Format-Table -AutoSize

$published = $all | Where-Object { $_.IsPublished } | Sort-Object Version -Descending
if (-not $published) { throw "No published BC24_TA App on server. Need Felix/AL compile publish — Mac repacks do not work here." }

$target = $published | Select-Object -First 1
$ver = $target.Version.ToString()
Write-Host "`nHighest PUBLISHED version: $ver (installed=$($target.IsInstalled))" -ForegroundColor Yellow

if ($target.IsInstalled) {
  Write-Host "Version $ver is already installed. No upgrade needed from this script." -ForegroundColor Green
  Get-NAVAppInfo -ServerInstance $si -Tenant default -TenantSpecificProperties -Name $name |
    Where-Object { $_.Version -eq $target.Version } | Format-List Version, IsInstalled
  exit 0
}

Write-Host "Sync + upgrade to $ver (no Publish step)..." -ForegroundColor Yellow
Sync-NAVApp -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version $ver
Start-NAVAppDataUpgrade -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version $ver

$installed = Get-NAVAppInfo -ServerInstance $si -Tenant default -TenantSpecificProperties -Name $name |
  Where-Object { $_.Version -eq $target.Version -and $_.IsInstalled }
if (-not $installed) { throw "Upgrade to $ver failed" }

Write-Host "`nSUCCESS — installed $ver" -ForegroundColor Green
$installed | Format-List Name, Version, IsInstalled
Write-Host "Republish CuStaffPortal 50049 in Web Services."
Write-Host "NOTE: Leave cancel AL needs 928+ from Felix/AL compile — Mac repacks cannot Publish on this server."
