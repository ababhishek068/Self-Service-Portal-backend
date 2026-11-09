# BC24_TA App 1.0.3.633 (clean publish)

Combines:

- **1.0.3.631** — Medical claim / reimbursement policy (80% capped by Self/Dependant budget)
- **1.0.3.632** — Petty Cash Request expense categories (not vendor Payment Types) + portal API
- Plus earlier Advance Payment work already on main (rename, LM→FAD/COO/CEO, purpose-by-division)

## File

`Technology Associates EA Ltd_BC24_TA App_1.0.3.633.app`

## Server publish (copy into Desktop\Erp first)

```powershell
cd C:\Users\Administrator\Desktop\Erp
# SPACE after BC240!
Publish-NAVApp -Path '.\Technology Associates EA Ltd_BC24_TA App_1.0.3.633.app' -ServerInstance BC240 -SkipVerification -PassThru
Get-NAVAppInfo -ServerInstance BC240 -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.633 | Format-List Name, Version, IsPublished, IsInstalled
Sync-NAVApp -ServerInstance BC240 -Tenant default -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.633 -Mode Force
Start-NAVAppDataUpgrade -ServerInstance BC240 -Tenant default -Name 'BC24_TA App' -Publisher 'Technology Associates EA Ltd' -Version 1.0.3.633
Restart-NAVServerInstance -ServerInstance BC240
```

PassThru / Get-NAVAppInfo must show **Version = 1.0.3.633** before Sync.
