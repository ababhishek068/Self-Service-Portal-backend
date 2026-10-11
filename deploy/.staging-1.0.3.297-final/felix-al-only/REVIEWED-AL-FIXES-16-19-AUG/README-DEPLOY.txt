HIJRA AL FIXES — 2026-07-25
============================

Target: BC24_TA App on server 10.30.7.14 (BC240)
Bump app.json to 1.0.2.345 (or next free version after your current publish)

FIXES IN THIS PACKAGE
---------------------
1. Training list — FnTrainingRequest now sets Employee No. on the header so new
   drafts appear in QyTrainingApplicationHeader list (filtered by EmployeeNo).
2. Profile Employment Type — QyHREmployee query exposes EmployeeContractType
   (readable text) instead of ambiguous EmployeesType numeric index.
3. Imprest Surrender — ImprestSurrenderHeader SOAP calls Validate("Imprest Issue Doc. No")
   so amounts and surrender lines copy from Imprest Header (portal was showing ETB 0).

APPLY
-----
1. Open the REAL AL project on the BC server:
   C:\Users\erp\Desktop\apps_erp\hijraERP\Hijra
   (Do NOT build from Desktop\Hijra or Mac copies — see HIJRA-UAT-MASTER-RUNBOOK.md)

2. Apply the changes in PATCH-NOTES.txt to:
   - StaffPortalCodeunit.Codeunit.al  (FnTrainingRequest + ImprestSurrenderHeader)
   - QyHREmployee.Query.al (or your employee OData query file)
   - QyImprestSurrenderHeader query (confirm amount fields published — see PATCH 3)

3. Bump version in app.json (e.g. 1.0.2.344 → 1.0.2.345)

4. VS Code: AL Package → copy .app to apps_erp folder

5. Publish via PowerShell ISE (Administrator) — Felix's script on BC server.
   NOT PowerShell 7 / VS Code terminal.

6. Verify:
   Get-NAVAppInfo -ServerInstance BC240 -Tenant default -Name "BC24_TA App" | ? IsInstalled | fl Version

7. Redeploy portal zip HIJRA-1.0.3.44-FULL-SUITE-2026-07-25.zip (same steps as before)

TEST AFTER REPUBLISH
--------------------
- Create NEW training request (TR0024 was saved before fix — will stay missing from list)
- New draft should appear in Training list
- Open detail → Request Approval button top-right next to Edit
- Profile → Employment Type shows "—" or real text (not "0")
- Create NEW Imprest Surrender for an issued imprest (e.g. IMP_0006)
  → Imprest Amount / Balance should NOT be ETB 0
  → Surrender lines should appear (not "No surrender lines")
