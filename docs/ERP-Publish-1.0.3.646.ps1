# Publish BC24_TA App 1.0.3.646 (Imprest workflow: Create approval request + Workflow User Group options).
# Run as admin on ERP (BC240). After publish, reopen ADVANCE PAYMENT IT workflow and re-pick responses.
Set-Location (Join-Path $env:USERPROFILE 'Desktop\Erp')
Publish-NAVApp -Path '.\Technology Associates EA Ltd_BC24_TA App_1.0.3.646.app' -ServerInstance BC240 -SkipVerification -PassThru
Get-NAVAppInfo -ServerInstance BC240 -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.646 | Format-List Name, Version, IsPublished, IsInstalled
Sync-NAVApp -ServerInstance BC240 -Tenant default -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.646 -Mode Force
Start-NAVAppDataUpgrade -ServerInstance BC240 -Tenant default -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.646
