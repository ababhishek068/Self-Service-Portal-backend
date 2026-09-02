# ABH — publish BC extension (run as Administrator in BC Administration Shell)
# Copy the .app to C:\TA\publish first so Desktop\Erp file lock does not block publish.
param(
    [string]$ServerInstance = 'BC240',
    [string]$AppPath = 'C:\TA\publish\Technology Associates EA Ltd_BC24_TA App_1.0.3.273.app',
    [string]$Publisher = 'Technology Associates EA Ltd',
    [string]$Name = 'BC24_TA App',
    [string]$Version = '1.0.3.273'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $AppPath)) {
    Write-Host "ERROR: App file not found: $AppPath" -ForegroundColor Red
    Write-Host "Copy the .app from Desktop\Erp to C:\TA\publish\ first." -ForegroundColor Yellow
    exit 1
}

Write-Host "Checking BC instance..." -ForegroundColor Cyan
$inst = Get-NAVServerInstance -ServerInstance $ServerInstance
if ($inst.State -ne 'Running') {
    Write-Host "Starting $ServerInstance ..." -ForegroundColor Yellow
    Start-NAVServerInstance -ServerInstance $ServerInstance
    Start-Sleep -Seconds 90
}

$installed = Get-NAVAppInfo -ServerInstance $ServerInstance -Name $Name |
    Where-Object { $_.IsInstalled -eq $true } |
    Select-Object -ExpandProperty Version -First 1

Write-Host "Currently installed: $installed" -ForegroundColor Cyan
if ($installed -eq $Version) {
    Write-Host "Version $Version already installed. Skipping publish." -ForegroundColor Green
    exit 0
}

Write-Host "Publishing $AppPath ..." -ForegroundColor Cyan
Publish-NAVApp -Path $AppPath -ServerInstance $ServerInstance -SkipVerification

Write-Host "Syncing $Name $Version ..." -ForegroundColor Cyan
Sync-NAVApp -ServerInstance $ServerInstance -Tenant default -Name $Name -Publisher $Publisher -Version $Version

Write-Host "Data upgrade $Name $Version ..." -ForegroundColor Cyan
Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant default -Name $Name -Publisher $Publisher -Version $Version

Write-Host "Restarting $ServerInstance ..." -ForegroundColor Cyan
Restart-NAVServerInstance -ServerInstance $ServerInstance
Start-Sleep -Seconds 120

Get-NAVServerInstance -ServerInstance $ServerInstance | Format-List State, Version
Get-NAVAppInfo -ServerInstance $ServerInstance -Name $Name |
    Where-Object { $_.IsInstalled -eq $true } |
    Format-Table Name, Version, Published, Installed -AutoSize

Write-Host "BC publish complete." -ForegroundColor Green
