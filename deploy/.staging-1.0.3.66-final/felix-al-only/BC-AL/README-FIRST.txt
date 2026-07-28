HIJRA BC — COPY-PASTE FILES FOR FELIX (26 Jul 2026)
===================================================

4 files only. Replace the matching file in the Hijra AL project, then Compile → Publish.

BC PROJECT (Felix):
  C:\Users\erp\Desktop\apps_erp\hijraERP\Hijra

COPY EACH FILE TO:
------------------

1) StaffPortalCodeunit.Codeunit.al
   → src\...\NEWCHANGES\StaffPortalCodeunit.Codeunit.al
   FIX: LV00127 — Insert BEFORE Validate on leave create

2) PortalEmployeeDataMgt.Codeunit.al
   → src\staffPortal\employeeExit\PortalEmployeeDataMgt.Codeunit.al
   FIX: GetLeaveBalance for portal leave balance

3) HrLeaveAllocationPortal.Query.al
   → src\staffPortal\query\HrLeaveAllocationPortal.Query.al
   FIX: Query ID 52133 (NOT 50095 — conflicts with LeaveApplications)

4) HRLeaveApplication.Table.al
   → src\...\HR3\HR\HRLeaveApplication.Table.al
   FIX: Calendar filter + employee card balance on Days Applied validate

PUBLISH (after 0 compile errors)
--------------------------------
1. VS Code AL: Package → copy .app to apps_erp
2. PowerShell ISE (Admin) — NOT PS7:
   Publish-NAVApp / Sync-NAVApp on BC240
3. Verify:
   Get-NAVAppInfo -ServerInstance BC240 -Tenant default -Name "BC24_TA App" | ? IsInstalled | fl Version

TEST AFTER PUBLISH
------------------
1. Portal → Leave Requisition → Create (start date, reliever, reason)
2. BC → HR Leave Applications (open) → new row with Start Date
3. Portal → Request Approval
4. Balance on portal matches BC for all leave types

NO PORTAL REDEPLOY NEEDED — AL only.
