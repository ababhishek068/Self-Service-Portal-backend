# HIJRA SSP UAT — row-by-row implementation report

Date: 28 July 2026  
Release: `1.0.3.79`  
AL patch: `1.0.5.73` safe patch

## What was checked

- Finance workbook: 20 latest-fail rows, including the normal `comment` column.
- HR workbook: 12 latest-fail rows, including `HB Remark`/comment content.
- Facility workbook: 22 in-scope latest-fail rows plus five Pass rows with unresolved comment-driven defects. Seventeen rows marked `Out Of Scope` by the source workbook are excluded from the required pass count.
- Total in-scope remark-driven fixes: 59 rows (12 HR, 20 Finance, 27 Facility).
- All ordinary remark/comment columns were checked. The eight non-empty legacy Excel comments in the Facility workbook were also extracted and mapped.

The original workbooks were not overwritten. Their latest status remains the bank's pre-deployment UAT result. “Implemented” below means the release contains the code path and the local build/tests pass. Every row still needs a live UAT retest after Felix publishes the AL app and the portal release is deployed.

## Finance — 20 rows

| Excel row | Bank issue/comment checked | Release implementation | Retest |
|---:|---|---|---|
| 7 | Imprest duration/profile details; daily rate missing in portal and ERP | Imprest header/detail enrichment plus a daily-rate field populated from the BC line amount/days and displayed to requester/approver | Pending live UAT |
| 11 | Approver needs travel duration/destination; requester needs rejection reason | Approval detail fields include dates, destination, and approval remarks | Pending live UAT |
| 13 | Display the remaining unsettled imprest amount | Remaining/outstanding balance is derived and displayed on list/detail | Pending live UAT |
| 19 | Surrender must show duration and destination | Surrender detail is enriched from its source imprest | Pending live UAT |
| 23 | Search approved/rejected surrender documents; approver needs trip detail | Status/search list behavior and enriched approval detail are included | Pending live UAT |
| 24 | Cannot create a staff claim | Claim header creation and department-code resolution are wired to BC | Pending live UAT |
| 25 | Claim date must equal ERP working date | Frontend schema and backend working-date validation block back/future dates | Pending live UAT |
| 26 | Staff claim duration/profile/total/account details missing | Claim header detail enrichment is included | Pending live UAT |
| 27 | Staff claim department/job title/total/account details missing | Claim header detail enrichment is included | Pending live UAT |
| 28 | Medical hospital category and coverage percent missing | Government, non-government/private, and online categories plus coverage/refund fields are included | Pending live UAT |
| 29 | Claim type and account number must be linked | Claim type drives the BC account selection/mapping | Pending live UAT |
| 30 | Staff claim document attachment | Claim attachments are enabled through the single codeunit 52106 | Pending live UAT |
| 31 | Pending claim list | BC status mapping and status-filtered list are included | Pending live UAT |
| 32 | Approved claim list | BC status mapping and status-filtered list are included | Pending live UAT |
| 33 | Delete claim lines | Draft/Open claim line deletion is included | Pending live UAT |
| 34 | Cancel a wrong claim before approval | Pre-approval cancellation is included | Pending live UAT |
| 35 | Multiple claim lines | Multi-line add/edit/delete flow is included | Pending live UAT |
| 38 | Petty-cash employee information must align with employee profile | Petty-cash detail uses authenticated employee profile dimensions/account | Pending live UAT |
| 40 | Petty-cash limit depends on department | The BC department limit is displayed and enforced before approval submission | Pending live UAT |
| 41 | Cancel a wrong petty-cash request before approval | Pre-approval cancellation is included | Pending live UAT |

Primary code: `financeRequestEnrichment.ts`, `portalApi.ts`, `staffModules.ts`, `ImprestRequest.tsx`, `ImprestSurrender.tsx`, `StaffClaim.tsx`, and `PettyCash.tsx`.

## HR — 12 rows

| Excel row | Bank issue/comment checked | Release implementation | Retest |
|---:|---|---|---|
| 10 | Cancelled leave counted as pending; requested leave cannot be modified | Leave status is driven by BC; Cancelled is excluded from pending and Open/Draft remains editable | Pending live UAT |
| 14 | Incorrect leave-statement balance | Request and statement use the shared BC leave-balance resolver | Pending live UAT |
| 21 | HOD staff attendance | Team attendance is scoped through the HOD/supervisor department | Pending live UAT |
| 23 | Wrong employee department/division | Profile resolves BC HR employee and dimension fields | Pending live UAT |
| 24 | Years of service wrong; last promotion/retirement dates missing | Important-date calculation and BC field aliases are included | Pending live UAT |
| 26 | Comment says next-of-kin name is missing | Next-of-kin name aliases are included in profile mapping | Pending live UAT |
| 28 | Employee cannot request own experience letter | The existing Request Letters module is retained and Experience Letter is wired to `CuPortalHrLetters` | Pending live UAT |
| 32 | HOD should see active leave only under their supervision | Staff-on-leave list is department/supervisor scoped | Pending live UAT |
| 33 | Medical claim types Government/Non-Government/Online | The three medical categories are included in claim options and BC mapping | Pending live UAT |
| 37 | Training needs must integrate with ERP; department must be a dropdown | BC department/course lookups and training controller integration are included | Pending live UAT |
| 39 | Include more than one training per request | Training assessment/request data supports the complete training card data | Pending live UAT |
| 40 | Training application list | Period, provider, cost, department, and status list fields are included | Pending live UAT |

Primary code: `staff.ts`, `leaveBalance.ts`, `employeeProfile.ts`, `portalApi.ts`, `hrServiceLetters.ts`, `LeaveRequest.tsx`, `LeaveStatement.tsx`, `StaffOnLeave.tsx`, `Profile.tsx`, `HrServiceRequestLetters.tsx`, and `TrainingRequest.tsx`.

## Facility — 27 in-scope remark-driven fixes

| Excel row | Bank issue/comment checked | Release implementation | Retest |
|---:|---|---|---|
| 4 | Purchase specification becomes description; no specification attachment | Dedicated specification field and request attachments are included | Pending live UAT |
| 7 | Approver cannot see the PR / cancellation appears as Purchase Quote | PR cancellation remains mapped to the Purchase Requisition document | Pending live UAT |
| 8 | Pending PR appears as Purchase Quote and details change | Approval detail uses the PR mapping and preserves PR lines/details | Pending live UAT |
| 9 | Approver cannot approve the PR as the correct document | PR approval actions retain PR number, lines, requester, and attachments | Pending live UAT |
| 10 | Requisitioner cannot see requested-item detail | Purchase request detail/lines are included; formal report remains an ERP output | Pending live UAT |
| 15 | No recipient confirmation for issued store item | Line receive confirmation and post-receipt action are included | Pending live UAT |
| 18 | Requisitioner needs request-versus-issue detail | Store detail shows requested, issued, received, and outstanding quantities | Pending live UAT |
| 21 | Compare requested fuel/km with vehicle standard | Vehicle fuel rating, current odometer, and requested litres are saved/read from BC and displayed together | Pending live UAT |
| 20 | Excel comment: vehicle plate must be linked to the fuel card | Fuel-card lookup/readback includes the assigned vehicle plate and vendor | Pending live UAT |
| 22 | Issued-fuel detail missing; approver sees maintenance type | Fuel and maintenance documents are separated by request/document type | Pending live UAT |
| 23 | Fuel approval detail/type wrong | Fuel approval mapping and full request detail are included | Pending live UAT |
| 24 | Pending fuel request detail/type wrong | Fuel list/detail status mapping is included | Pending live UAT |
| 26 | Fuel approval detail/type wrong | Fuel approval mapping and full request detail are included | Pending live UAT |
| 27 | Excel comment: trip origin and employee name are missing | Transport captures trip origin and resolves the passenger employee name | Pending live UAT |
| 28 | Field trip changes to City when submitted | Transport request type is explicitly mapped to the correct BC option | Pending live UAT |
| 30 | Approver sees Field request as City | Transport approval detail preserves the request type | Pending live UAT |
| 34 | Duplicate vehicle request not prevented | The backend blocks another active request for the same employee, trip date, origin, and destination before BC creation | Pending live UAT |
| 49 | Portal used Transfer Order instead of Asset Transfer for vehicle/tool handover | Separate Asset Transfer module and `CuPortalAssetTransfer` controller are included | Pending live UAT |
| 50 | Approve vehicle/tool handover | Asset Transfer table 50278 approval mapping is included | Pending live UAT |
| 51 | Temporary asset transfer to employee | Permanent/temporary option, employee, and expiry fields are included | Pending live UAT |
| 52 | Approve temporary transfer | Asset Transfer approval workflow is included | Pending live UAT |
| 53 | Cancel temporary transfer | Asset Transfer cancellation action is included | Pending live UAT |
| 54 | Post asset transfer | Approved-only `PostAssetTransfer` action is included end to end | Pending live UAT |
| 55 | Gate pass lacks specific Store/Transfer/Maintained Asset reference | Gate Pass supports Store Issue, Transfer Order, Asset Transfer, and Maintenance source references | Pending live UAT |
| 56 | Approve referenced gate pass | Gate Pass approval retains source document linkage | Pending live UAT |
| 57 | Reject referenced gate pass | Gate Pass rejection retains source document linkage | Pending live UAT |
| 58 | Gate Pass Log/report | Portal log view is included; formal printable report remains an ERP output | Pending live UAT |

Facility rows 35–48 (Maintenance and Work Ticket) and 59–61 (Procurement Individual Budget Preparation) are marked `Out Of Scope` in the source workbook and are excluded from the required pass count. The release retains the Maintenance and Work Ticket modules as supplementary functionality, but it does not claim a UAT Pass for those excluded rows.

Primary code: `staffModules.ts`, `portalApi.ts`, `PurchaseRequisition.tsx`, `StoreRequisition.tsx`, `FuelRequest.tsx`, `TransportRequest.tsx`, `MaintenanceRequest.tsx`, `WorkTickets.tsx`, `AssetTransfer.tsx`, `GatePass.tsx`, and the complete staged safe AL patch.

## Verification evidence

- Backend TypeScript build: passed.
- Portal on-prem TypeScript/Vite build: passed.
- Backend tests: 75 passed, 0 failed.
- Portal build ID: `hijra-portal-1.0.3.79-FINAL-2026-07-28-all-existing-modules-preserved-search-facility-workflow-fixes`.
- Release and Felix ZIP integrity: passed.
- Compiled JavaScript syntax checks: passed.
- AL duplicate checks: 3,806 AL objects scanned with zero duplicate object-type/ID pairs; complete Employee Exit, HR Documents, Training, and Facility UAT folders are retained.
- Mac AL compile: 3,817 files were checked. The added UAT objects produced no new compiler error. The full legacy project remains blocked by 31 pre-existing errors in three legacy files: one Windows report-layout path and OnPrem DotNet aliases unavailable to the macOS compiler. Felix must run the final `AL: Package` on Windows.
- Live UAT deployment/retest: not performed because `10.30.4.23` was unreachable from this Mac and the AnyDesk UI could not be controlled reliably.
