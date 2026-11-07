$ErrorActionPreference = 'Stop'
$si = 'BC240'
$tenant = 'default'
Set-Location $PSScriptRoot

Write-Host '1) Publish EMPTY stub (same App Id as compile dependency — no Base App field clashes)...' -ForegroundColor Cyan
Publish-NAVApp -Path '.\Technology Associates EA Ltd_ABH Compile Stubs_1.0.0.0.app' -ServerInstance $si -SkipVerification
Sync-NAVApp -ServerInstance $si -Tenant $tenant -Name 'ABH Compile Stubs' -Publisher 'Technology Associates EA Ltd' -Version 1.0.0.0
Install-NAVApp -ServerInstance $si -Tenant $tenant -Name 'ABH Compile Stubs' -Publisher 'Technology Associates EA Ltd' -Version 1.0.0.0 -ErrorAction SilentlyContinue

Write-Host '2) Publish BC24_TA App 1.0.3.624...' -ForegroundColor Cyan
Publish-NAVApp -Path '.\Technology Associates EA Ltd_BC24_TA App_1.0.3.624.app' -ServerInstance $si -SkipVerification
Sync-NAVApp -ServerInstance $si -Tenant $tenant -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.624 -Mode Force
Start-NAVAppDataUpgrade -ServerInstance $si -Tenant $tenant -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.624
Restart-NAVServerInstance -ServerInstance $si
Write-Host 'Done.' -ForegroundColor Green
