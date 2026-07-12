# HIJRA UAT — Master Runbook & Status (2026-07-11)

Servers: Portal `10.30.4.23:4000` · Business Central `10.30.7.14` (instance **BC240**, tenant `default`).
Extension: **BC24_TA App** by Technology Associates EA Ltd. Test employee: **E0083**.

---

## 1. STATUS AT A GLANCE

| Module | Status | Owner of remaining fix |
|---|---|---|
| Imprest Surrender (long name) | ✅ FIXED & LIVE in .335 | done |
| Staff Claims (long name) | ✅ FIXED & LIVE in .335 | done |
| Staff Claims – Hospital Category on TRAVEL | ⚠️ user: leave Hospital Category blank for non-medical | portal tweak (minor) |
| Salary Advance shows 0 | ℹ️ EXPECTED in UAT (payroll data removed) — works in prod | none |
| Petty Cash (PETTY account) | ❌ | BC admin (setting) |
| Petty Cash Replenishment (limit) | ❌ | BC admin (setting) |
| Transport Requisition (TR number) | ❌ | BC admin (setting) |
| Fuel Requisition (approval workflow) | ❌ | BC admin (setting) |
| Work Tickets (WorkTicketHeader) | ❌ | Felix (code) |
| Purchase Requisition (Requesting Dept) | ❌ | Felix (code) |
| Gate passes (Asset/Store/Transfer) | ❌ | Felix (code) |

**Do NOT touch payroll** (Felix's instruction; payroll data was removed from UAT).

---

## 2. WHAT WAS DONE (AL .334 → .335)

Wrapped the long department/branch/division name assignments in `CopyStr(value, 1, MaxStrLen(field))`
so BC trims to fit instead of crashing:
- `src\Table\ImprestSurrenderHeader.Table.al` (5 assignments)
- `src\Table\StaffClaimsHeader.Table.al` (4 assignments)

Compiled and published **1.0.2.335** to BC240. Backups saved in the project as `_backup-before-335-*`.

---

## 3. HOW TO PUBLISH A NEW AL VERSION (the reliable way)

Real source lives ONLY at `C:\Users\erp\Desktop\apps_erp\hijraERP\Hijra` on server 10.30.7.14.
(The `Desktop\Hijra` and any Mac copies are STALE — never build from them.)

**A. Edit the code** in that folder (or apply a patch script), then bump `app.json` version.

**B. Compile** — open the folder in VS Code → `Ctrl+Shift+P`:
- **AL: Download Symbols** (skip if `.alpackages` already has the Microsoft_* packages — it does)
- **AL: Package** → produces `Technology Associates EA Ltd_BC24_TA App_<version>.app`
- Copy that `.app` into `C:\Users\erp\Desktop\apps_erp`
- If it errors "object already declared", MOVE any `_backup-*` folder OUT of the project first.

**C. Publish — ONLY via Windows PowerShell ISE (v5.1), run as Administrator.**
Felix's saved script: `C:\Users\erp\Documents\BC Publishing Shell Scripts.ps1` — Find/Replace the version
number and press F5. It runs: load 240 NavAdminTool → Publish-NAVApp → Sync → DataUpgrade → import license → Restart.

⚠️ Publishing FAILS in PowerShell 7 / VS Code terminal / plain PowerShell
(error: `Could not load type 'System.ServiceModel.ServiceSecurityContext'`). **Use ISE only.**

**D. Verify:**
```
Get-NAVAppInfo -ServerInstance BC240 -Tenant default -TenantSpecificProperties -Name "BC24_TA App" | ? IsInstalled | fl Version
```

---

## 4. REMAINING — FELIX (code, non-payroll). Full detail in HIJRA-334-FIX-SPEC.md

1. **Work Tickets** — add `WorkTicketHeader` + `WorkTicketLine` procedures to `StaffPortalCodeunit.Codeunit.al`
   (they don't exist). Insert into `FLT-Daily Work Ticket Header/Lines`; field blueprint in the spec.
2. **Purchase Requisition** — in `PurchaseRequisitionHeader`, add:
   `TbPurchaseHeader."Requesting Department" := TbEmployee."Global Dimension 1 Code";`
3. **Gate passes** — portal posts to `QyGatePass` (a read-only Query → "Entity does not support insert").
   Expose an insertable Gate Pass page/codeunit, or auto-generate the gate pass on posting the source doc.

---

## 5. REMAINING — BC ADMIN (settings, no code)

1. **PETTY account** — Alt+Q → Payment Types → code `PETTY` → replace invalid G/L account `101006` with a valid one.
2. **Petty cash limit** — Alt+Q → Petty Cash Limits-Branches (or -Departments) → add E0083's branch/dept + approved limit.
3. **Transport TR number** — Alt+Q → No. Series → repair the TR series, delete the blank-number record.
4. **Fuel approval workflow** — enable the approval workflow for the Fuel Requisition document type.

---

## 6. OPTIONAL — deploy the newer PORTAL (10.30.4.23)

Not needed for the .335 BC fix. Do it later, in an **elevated PowerShell** (Explorer fails on permissions),
preserving the 3 `.env` files:
```
# stop → save envs → rename old → extract new → restore envs → start
powershell -File C:\TA\SelfServiceSuite\SelfServicePortal\deploy\windows\stop-suite.ps1
Copy-Item C:\TA\SelfServiceSuite\SelfServiceBackend\.env $env:TEMP\a.env -Force
Copy-Item C:\TA\SelfServiceSuite\SelfServicePortal\server\.env $env:TEMP\b.env -Force
Copy-Item C:\TA\SelfServiceSuite\SelfServicePortal\db\.env $env:TEMP\c.env -Force
Rename-Item C:\TA\SelfServiceSuite C:\TA\SelfServiceSuite-backup-<date>
Expand-Archive <the correct final-finance-fixes zip> -DestinationPath C:\TA -Force
Copy-Item $env:TEMP\a.env C:\TA\SelfServiceSuite\SelfServiceBackend\.env -Force
Copy-Item $env:TEMP\b.env C:\TA\SelfServiceSuite\SelfServicePortal\server\.env -Force
Copy-Item $env:TEMP\c.env C:\TA\SelfServiceSuite\SelfServicePortal\db\.env -Force
C:\TA\SelfServiceSuite\SelfServicePortal\deploy\windows\start-suite.bat
```
Then check `http://10.30.4.23:4000/api/health`.

---

## 7. "WHAT TO DO IF…"

- **Publish says `Publish-NAVApp is not recognized`** → you're not in PowerShell ISE. Open Windows PowerShell ISE as admin (or `Start-Process powershell -Verb RunAs` for a v5.1 window), then run Felix's script.
- **Publish says `System.ServiceModel` error** → you're in PowerShell 7. Same fix: use ISE / v5.1.
- **Compile says "object already declared"** → a `_backup-*` folder is inside the project. Move it out, rebuild.
- **`Get-NAVAppInfo` says "Access is denied"** → the shell isn't elevated. Run as administrator.
- **Portal still shows old behavior after a BC fix** → in the portal press `Ctrl+F5` once.
- **Salary Advance shows 0** → expected in UAT (payroll data removed). Not a bug.
- **A module errors "must have a value / not setup / could not allocate"** → it's a BC setting (section 5) or Felix (section 4), NOT the portal.
- **Need to confirm which .app is installed** → run the Get-NAVAppInfo verify command in section 3D.

---

## 8. HANDOFF MESSAGES (ready to paste)

**To Felix:** send HIJRA-334-FIX-SPEC.md + "For .336: Work Tickets (add WorkTicketHeader/WorkTicketLine),
Purchase Requisition (set Requesting Department), gate-pass insertable endpoint. All non-payroll. .335 long-name fix already live."

**To BC admin/Finance:** the 4 settings in section 5.
