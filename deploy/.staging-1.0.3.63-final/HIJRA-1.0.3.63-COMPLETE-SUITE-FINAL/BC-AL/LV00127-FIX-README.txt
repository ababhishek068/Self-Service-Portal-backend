LV00127 — "HR Leave Application does not exist" — FIX FOR FELIX
================================================================
26 July 2026

WHAT YOU SEE IN PORTAL
----------------------
Leave not submitted
Business Central rejected the request: The HR Leave Application does not exist.
Application Code='LV00127'

WHY (not a portal bug — BC AL order bug)
----------------------------------------
StaffPortalCodeunit.LeaveApplication (create) called:
  Validate("Start Date") and Validate("Days Applied") BEFORE Insert()

HRLeaveApplication.Table OnValidate runs Modify — but the record is NOT in the
database yet → BC throws "does not exist" for the next number (LV00127).

Portal is fine. Backend is fine. Felix must publish AL fix.

FILE TO CHANGE
--------------
src/.../NEWCHANGES/StaffPortalCodeunit.Codeunit.al
Procedure LeaveApplication — action = 'create' only

See: StaffPortalCodeunit-LEAVE-CREATE-FIX.al (exact replacement block)

ALSO REQUIRED (if not already published)
----------------------------------------
- HRLeaveApplication.Table.al PATCH 4 (calendar + card balance)
- PortalEmployeeDataMgt.Codeunit.al (GetLeaveBalance)
- HrLeaveAllocationPortal.Query.al (ID 52133)

PUBLISH STEPS
-------------
1. Apply StaffPortalCodeunit-LEAVE-CREATE-FIX.al in VS Code AL project
2. Compile — 0 errors
3. Package → copy .app to apps_erp
4. PowerShell ISE (Admin): Publish-NAVApp / Sync-NAVApp
5. Verify: create leave from portal → LV00xxx appears in BC open list with Start Date

TEST AFTER PUBLISH
------------------
Portal → Leave Requisition → Create (no attachment first)
BC → HR Leave Applications → new row with Start Date filled
Then Request Approval from portal

No portal redeploy needed for this fix — AL only.
