# ABH — publish BC 1.0.3.217 (draft delete + purchase line edit fix)
# Run in Business Central Administration Shell AS ADMINISTRATOR.
#
# Before running:
#   1) Copy this file and the .app to C:\TA\publish\
#      - Technology Associates EA Ltd_BC24_TA App_1.0.3.217.app
#      - PUBLISH-ABH-1.0.3.217.ps1
#   2) Then:
#      cd C:\TA\publish
#      .\PUBLISH-ABH-1.0.3.217.ps1

param(
    [string]$ServerInstance = 'BC240',
    [string]$AppPath = 'C:\TA\publish\Technology Associates EA Ltd_BC24_TA App_1.0.3.217.app',
    [string]$Publisher = 'Technology Associates EA Ltd',
    [string]$Name = 'BC24_TA App',
    [string]$Version = '1.0.3.217'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $AppPath)) {
    Write-Host "ERROR: App not found: $AppPath" -ForegroundColor Red
    Write-Host "Copy Technology Associates EA Ltd_BC24_TA App_1.0.3.217.app to C:\TA\publish\ first." -ForegroundColor Yellow
    exit 1
}

Write-Host "Publishing $Name $Version ..." -ForegroundColor Cyan
Publish-NAVApp -Path $AppPath -ServerInstance $ServerInstance -SkipVerification

Write-Host "Syncing ..." -ForegroundColor Cyan
Sync-NAVApp -ServerInstance $ServerInstance -Tenant default -Name $Name -Publisher $Publisher -Version $Version

Write-Host "Data upgrade ..." -ForegroundColor Cyan
Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant default -Name $Name -Publisher $Publisher -Version $Version

Write-Host "Restarting $ServerInstance (required so SOAP picks up DeletePortalDraftDocument) ..." -ForegroundColor Cyan
Restart-NAVServerInstance -ServerInstance $ServerInstance

Write-Host ""
Write-Host "DONE. Installed:" -ForegroundColor Green
Get-NAVAppInfo -ServerInstance $ServerInstance -Name $Name | Format-Table Name, Version, IsInstalled -AutoSize
Write-Host "Next: deploy portal zip ABH-Portal-COMPLETE-1.0.3.317.zip and restart the portal." -ForegroundColor Yellow
Write-Host "Confirm: http://127.0.0.1:4000/api/portal-build  (expect v166 / 1.0.3.317)" -ForegroundColor Yellow
