# HIJRA AL CHANGES — 25 Jul 2026 (UAT sync with Self Service Portal)

Everything below is ALREADY EDITED in this repo. Felix only needs to:

1. Open this folder (`hijraERP/Hijra`) in VS Code
2. `AL: Package` (Ctrl+Shift+B) — fix nothing unless it reports an error
3. `AL: Publish extension` (F5) to the HIJRA UAT server
4. BC web client → "Portal Employee Transfer Setup" → set **HR Approver User ID**
   (this HR user also decides the new HR letter requests)

The install/upgrade codeunits register every web service automatically —
no manual Web Services page entries are needed.

---

## NEW files (folder `src/staffPortal/hrLetters/`)

| File | Object | Purpose |
|------|--------|---------|
| PortalHrLetterRequest.Table.al | table 52140 | Stores portal letter requests (guarantee, experience, mortgage, emergency loan, embassy, external company) |
| PortalHrLettersMgt.Codeunit.al | codeunit 52141 | SOAP service `CuPortalHrLetters` — the portal's 5 methods (GetHrLetterRequests, SaveHrLetterRequest, CancelHrLetterRequest, GetHrLetterApprovals, DecideHrLetterApproval) |
| PortalHrLetterRequests.Page.al | page 52140 | HR list page with Approve / Reject / Ready for Collection / Complete actions (type HR Remarks first) |
| PortalHrLettersInstall.Codeunit.al | codeunit 52142 | Auto-registers `CuPortalHrLetters`, `CuPortalTraining`, `QyApprovalCommentLine` (query 50091), `QyPettyCashLimitDepartment` (query 52132) |
| PortalHrLettersUpgrade.Codeunit.al | codeunit 52143 | Re-runs the registration on upgrades |

This closes UAT item: “HR Service Request Letters … not integrated with ERP”.

## EDITED files

### `src/staffPortal/query/HrEmployee.Query.al` (query 50090 = QyHREmployee)
- Added `DateOfBirth` ("Date Of Birth") and `MaritalStatus` ("Marital Status") columns.
- Fixes UAT: “Employee Important Dates — some dates are still missing”.

### `src/staffPortal/employeeExit/PortalEmployeeExitRequest.Table.al`
- Exit Interview validation no longer requires Transfer Type (UAT 22-07: “transfer type should be removed”).
- Transfer validation now accepts Permanent / Temporary / **Secondment** (the portal offers all three).

### `src/staffPortal/employeeExit/PortalEmployeeExitMgt.Codeunit.al`
- Transfer details map the portal's new `typeOfTransfer` key (falls back to legacy `transferType`).
- Exit Interview no longer stores/emits a transfer type.
- Request JSON now includes `decisionRemarks` so the requester sees WHY a transfer/resignation was rejected.

### `src/src/.../NEWCHANGES/StaffPortalCodeunit.Codeunit.al`
- `ClaimRequisitionHeader` now accepts `claimDate` + `department` (the portal has always sent them; sets header Date + Global Dimension 1 Code).
- `ImprestRequisitionLine` now accepts `employeeNo` (portal always sent it).
- `ImprestSurrenderLine` now accepts `accountNo` (portal always sent it).
- `CancelPettyCashRequest` now accepts `docNo` alongside `requisitionNo` (portal sends both).
- **`LeaveApplication` (UAT 25 Jul)** — sets `Select Whether Half Day = Normal` for full-day leave (fixes 0.5 deduction on approval); maps half-day option correctly in `GetLeaveDates`; **create** calls `Validate("Days Applied")`; document numbers use `LV00001` format; Status := Open on insert.

### `HR3/HR/HRLeaveApplication.Table.al` (table 50532 — **full file included**)
- Calendar Code filter on all leave allocation queries.
- Annual leave uses employee-card `"Annual Leave balance"` as earned-days ceiling.
- Fixes LV00125: blank Days Applied, balances 0.00, error *"earned days -0.328767…"*.
- See `LEAVE-PRODUCTION-CHECKLIST.md` for full smoke test.

### `src/staffPortal/PortalHr.PermissionSet.al`
- Grants for the new HR letters objects.

---

## After publish — 2-minute smoke test

1. Portal → HR → Service Request Letters → submit a Guarantee letter → appears in list
2. BC → “Portal HR Letter Requests” → type HR Remarks → Reject → portal shows Rejected + reason
3. Portal → Profile → Bio Data shows Marital Status; Contract tab shows Date of Birth
4. Portal → HR → Employee Exit → Transfer Request with Type of transfer = Secondment → submits
5. Portal → Employee Exit → Employee Exit Form (no transfer type on the form) → submits
6. Reject an imprest in BC WITH a comment → portal detail shows “Rejection Reason”
7. Petty Cash Request above the department limit (after limits are filled in
   “Petty Cash Limit-Department”) → portal blocks it with a clear message
