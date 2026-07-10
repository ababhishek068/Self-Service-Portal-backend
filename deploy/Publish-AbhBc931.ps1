# Publish compiled 931.app (sick/non-annual leave + leave cancel fix)
# Copy "Technology Associates EA Ltd_BC24_TA App_1.0.2.931.app" to Desktop\Erp first.
# Run Business Central Administration Shell AS ADMIN:
#   cd $env:USERPROFILE\Desktop\Erp
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   .\Publish-AbhBc931.ps1

$ErrorActionPreference = "Stop"
$si = "BC240"
$name = "BC24_TA App"
$pub = "Technology Associates EA Ltd"
$ver = "1.0.2.931"
$tenant = "default"
$serviceName = "CuStaffPortal"
$serviceObjectId = 50049
$app = Join-Path $env:USERPROFILE "Desktop\Erp\Technology Associates EA Ltd_BC24_TA App_$ver.app"

if (-not (Test-Path $app)) {
    throw "Copy 931.app to: $app"
}

$published = Get-NAVAppInfo -ServerInstance $si -Name $name -Publisher $pub -ErrorAction SilentlyContinue |
  Where-Object { $_.Version -eq [version]$ver -and $_.IsPublished }

if ($published) {
  Write-Host "$ver is already published; continuing with Sync + DataUpgrade..." -ForegroundColor Yellow
} else {
  Write-Host "Publishing compiled $ver..." -ForegroundColor Cyan
  Publish-NAVApp -Path $app -ServerInstance $si -SkipVerification
}

$check = Get-NAVAppInfo -ServerInstance $si -Name $name -Publisher $pub |
  Where-Object { $_.Version -eq [version]$ver -and $_.IsPublished }
if (-not $check) {
  throw "Publish finished but $ver not in Get-NAVAppInfo. Try: Get-EventLog Application -Newest 5 -EntryType Error | where Message -match NAV"
}

Write-Host "Sync + upgrade..." -ForegroundColor Yellow
Sync-NAVApp -ServerInstance $si -Tenant $tenant -Name $name -Publisher $pub -Version $ver
Start-NAVAppDataUpgrade -ServerInstance $si -Tenant $tenant -Name $name -Publisher $pub -Version $ver

Get-NAVAppInfo -ServerInstance $si -Tenant $tenant -TenantSpecificProperties -Name $name |
  Where-Object { $_.Version -eq [version]$ver } |
  Format-List Name, Version, IsInstalled

Write-Host "Republishing $serviceName web service ($serviceObjectId)..." -ForegroundColor Yellow
$existingServices = Get-NAVWebService -ServerInstance $si |
  Where-Object { $_.ServiceName -eq $serviceName -and $_.ObjectType -eq "CodeUnit" }

foreach ($svc in $existingServices) {
  Remove-NAVWebService -ServerInstance $si -ServiceName $svc.ServiceName -ObjectType $svc.ObjectType -Force
}

New-NAVWebService `
  -ServerInstance $si `
  -ObjectType CodeUnit `
  -ObjectId $serviceObjectId `
  -ServiceName $serviceName `
  -Published $true `
  -ValidateAgainstTenant $tenant `
  -Force

Get-NAVWebService -ServerInstance $si |
  Where-Object { $_.ServiceName -eq $serviceName -and $_.ObjectType -eq "CodeUnit" } |
  Format-List ObjectType, ObjectId, ServiceName, Published

Write-Host "DONE. $ver installed and $serviceName 50049 published." -ForegroundColor Green
