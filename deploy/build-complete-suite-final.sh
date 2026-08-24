#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.3.292"
AL_INSTALLED_VERSION="1.0.5.173"
AL_PATCH_VERSION="${AL_INSTALLED_VERSION}"
BUNDLE="HIJRA-${VERSION}-COMPLETE-SUITE-FINAL"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SUITE="$REPO_ROOT/SelfServiceSuite"
STAGE="$REPO_ROOT/deploy/.staging-${VERSION}-final"
ROOT="$STAGE/$BUNDLE"

echo "==> Building backend + on-prem portal..."
cd "$SUITE/SelfServiceBackend"
# dist is generated output; remove it so obsolete compiled tests/files cannot
# leak into the deployment ZIP.
rm -rf "$SUITE/SelfServiceBackend/dist"
npm run build
npm run build:portal
echo "hijra-portal-${VERSION}-FINAL-2026-08-21-same-origin-api" > dist/BUILD_ID.txt

echo "==> Staging $BUNDLE..."
rm -rf "$STAGE"
mkdir -p "$ROOT/SelfServiceSuite/SelfServiceBackend/logs"
mkdir -p "$ROOT/SelfServiceSuite/SelfServicePortal/self-service-portal"
mkdir -p "$ROOT/BC-AL"

cp -R "$SUITE/SelfServiceBackend/dist" "$SUITE/SelfServiceBackend/public" "$SUITE/SelfServiceBackend/deploy" "$ROOT/SelfServiceSuite/SelfServiceBackend/"
cp -R "$SUITE/SelfServiceBackend/src" "$ROOT/SelfServiceSuite/SelfServiceBackend/"
cp "$SUITE/SelfServiceBackend/package.json" "$SUITE/SelfServiceBackend/package-lock.json" "$ROOT/SelfServiceSuite/SelfServiceBackend/"
cp "$SUITE/SelfServiceBackend/README.md" "$SUITE/SelfServiceBackend/.env.example" "$ROOT/SelfServiceSuite/SelfServiceBackend/" 2>/dev/null || true

PORTAL="$SUITE/SelfServicePortal/self-service-portal"
cp -R "$PORTAL/dist" "$PORTAL/src" "$ROOT/SelfServiceSuite/SelfServicePortal/self-service-portal/"
cp "$PORTAL/package.json" "$PORTAL/package-lock.json" "$PORTAL/tsconfig.json" "$PORTAL/tsconfig.app.json" "$PORTAL/tsconfig.node.json" "$PORTAL/vite.config.ts" "$PORTAL/index.html" "$PORTAL/.env.onprem" "$ROOT/SelfServiceSuite/SelfServicePortal/self-service-portal/" 2>/dev/null || true

# BC AL — validated, path-aware patch. Do not include the obsolete duplicate
# PortalAttachmentsMgt.Codeunit.al or the old wrong-folder query copies.
FELIX_PATCH="$REPO_ROOT/deploy/HIJRA-FELIX-SAFE-PATCH-1.0.5.75"
if [[ ! -d "$FELIX_PATCH" ]]; then
  echo "ERROR: Felix AL patch base not found at: $FELIX_PATCH" >&2
  exit 1
fi
cp -R "$FELIX_PATCH/." "$ROOT/BC-AL/"
# Build the deploy patch from the current reviewed AL project so the package
# cannot silently omit Employee Exit, HR Letters, Training, Facility, Gate Pass,
# approval comments, or the department petty-cash limit.
AL_PROJECT="${HIJRA_AL_PROJECT:-}"
if [[ -z "$AL_PROJECT" ]]; then
  for candidate in "$HOME/Hijra Al ERP Apps V5/hijraERP/Hijra" "$HOME/Hijra Al ERP Apps V3/hijraERP/Hijra"; do
    if [[ -d "$candidate/src/staffPortal" ]]; then
      AL_PROJECT="$candidate"
      break
    fi
  done
fi
if [[ -z "$AL_PROJECT" || ! -d "$AL_PROJECT/src/staffPortal" ]]; then
  echo "ERROR: HIJRA AL project was not found. Set HIJRA_AL_PROJECT." >&2
  exit 1
fi
for folder in employeeExit hrLetter training facilityUat; do
  mkdir -p "$ROOT/BC-AL/FILES/staffPortal/$folder"
  cp -R "$AL_PROJECT/src/staffPortal/$folder/." "$ROOT/BC-AL/FILES/staffPortal/$folder/"
done
mkdir -p "$ROOT/BC-AL/FILES/staffPortal/query" "$ROOT/BC-AL/FILES/HR-DEEP" "$ROOT/BC-AL/FILES/BASE-DEEP"
cp "$AL_PROJECT/src/staffPortal/PortalHr.PermissionSet.al" "$ROOT/BC-AL/FILES/staffPortal/"
for query in ApprovalCommentLine HrEmployee PettyCashLimitDepartment TrainingApplicationHeader TrainingApplicationLInes TrainingNeeds HrLeaveAllocationPortal QyAssetTransfer QyGatePassReturns QyPortalFuelMaintExtra QyProcurementPlanHeader QyProcurementPlanLines QyWorkTicketFlight; do
  cp "$AL_PROJECT/src/staffPortal/query/${query}.Query.al" "$ROOT/BC-AL/FILES/staffPortal/query/"
done
cp "$AL_PROJECT/src/src/src/src/src/src/src/src/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al" "$ROOT/BC-AL/FILES/HR-DEEP/"
cp "$AL_PROJECT/src/src/src/src/src/src/src/src/src/HR3/HR/HRLeaveApplication.Table.al" "$ROOT/BC-AL/FILES/HR-DEEP/"
cp "$AL_PROJECT/src/src/src/src/src/src/src/src/src/Fleet/GatePass.Table.al" "$ROOT/BC-AL/FILES/BASE-DEEP/"
cp "$AL_PROJECT/src/Query/GatePass.Query.al" "$AL_PROJECT/src/Query/GatePassAssetTransfers.Query.al" "$AL_PROJECT/src/Query/GatePassTransferShipments.Query.al" "$ROOT/BC-AL/FILES/Query/"
cp "$AL_PROJECT/src/Query/ImprestHeaders.Query.al" "$AL_PROJECT/src/Query/ImprestLines2.Query.al" "$AL_PROJECT/src/Query/ReceiptPaymentTypes.Query.al" "$ROOT/BC-AL/FILES/Query/"

AL_FIXES="$REPO_ROOT/HIJRA-AL-FIXES-2026-07-25"
if [[ -d "$AL_FIXES" ]]; then
  # Keep live Hijra V5 objects (CuPortalFacility 52161, CuPortalAssetTransfer).
  # Copy every reviewed AL file into the zip so Felix has the last-3-days set.
  mkdir -p "$ROOT/BC-AL/REVIEWED-AL-FIXES-16-19-AUG"
  cp -R "$AL_FIXES/." "$ROOT/BC-AL/REVIEWED-AL-FIXES-16-19-AUG/"
fi
mkdir -p "$ROOT/BC-AL/FILES/src/NEWCHANGES"
cp "$AL_PROJECT/src/src/src/src/src/src/src/src/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al" \
  "$ROOT/BC-AL/FILES/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al"

echo "HIJRA Self Service Suite v${VERSION} FINAL — 19 August 2026" > "$ROOT/SelfServiceSuite/VERSION.txt"
REPLACE_AL="$REPO_ROOT/HIJRA-FELIX-REPLACE-THESE-AL"
if [[ -d "$REPLACE_AL" ]]; then
  mkdir -p "$ROOT/FELIX-REPLACE-THESE-AL"
  cp -R "$REPLACE_AL/." "$ROOT/FELIX-REPLACE-THESE-AL/"
fi
cp "$REPO_ROOT/deploy/HIJRA-UAT-ROW-BY-ROW-IMPLEMENTATION-REPORT-2026-07-28.md" "$ROOT/" 2>/dev/null || true
cp "$REPO_ROOT/outputs/hijra-uat-2026-07-28/HIJRA-SSP-UAT-ROW-BY-ROW-EVIDENCE-2026-07-28.xlsx" "$ROOT/" 2>/dev/null || true

cat > "$ROOT/UNDEPLOYED-FIXES-16-19-AUG-2026.txt" << 'EOF'
HIJRA SSP — ALL UNDEPLOYED FIXES (16–19 August 2026)
===================================================
You have not deployed these yet. Deploy THIS zip once (v1.0.3.292).
Do not use 1.0.3.288–1.0.3.291 (291 still baked API ports 4000/4001).

PORTAL / BACKEND (already compiled into dist + public; source also in this zip)
------------------------------------------------------------------------------
Salary advance (v1.0.3.284)
  Approver amount = percentage × payroll salary (not BC Basic 40k).
  Files: src/salaryAdvanceAmount.ts, src/erpMappings.ts, src/employeeProfile.ts,
         src/portalApi.ts

Imprest surrender travel days (v1.0.3.285)
  Multi-day travel no longer stamps 1 day. Portal syncs travel start from source imprest.
  Files: src/staffModules.ts, src/financeRequestEnrichment.ts, src/imprestSurrenderLines.ts
         portal: components/finance/ImprestSurrenderLinesEditor.tsx
  AL: StaffPortalCodeunit — EnsureImprestSurrenderTravelStartDate,
      DeduplicateImprestSurrenderLines

Petty cash limit warning (v1.0.3.286)
  Branch users no longer get a false “no positive petty-cash limit” amber warning.
  Files: src/staffModules.ts (getPortalPettyCashDepartmentLimit), src/employeeProfile.ts
         portal: pages/finance/PettyCashReplenishment.tsx

Petty cash Limit Source / Responsibility Center (v1.0.3.287)
  Branch staff: Limit Source = branch name; Responsibility Center = branch (not CENTRAL).
  Files: src/portalApi.ts, src/financeRequestEnrichment.ts
         portal: pages/finance/PettyCashReplenishment.tsx

Finance org display — all finance modules (v1.0.3.288)
  Branch (district-line): District + Branch; hide Department/Division.
  HQ (department-line): Department + Division; hide District/Branch.
  Responsibility Center: branch name for branch staff; division/department for HQ.
  Modules: Petty Cash Settlement, Petty Cash Request, Imprest, Imprest Surrender, Staff Claim.
  Files: src/financeRequestEnrichment.ts, src/employeeProfile.ts, src/portalApi.ts
         portal: data/financeOrgDetailFields.ts, utils/financeOrgDisplay.ts,
                 data/approvalDetailFields.ts, components/finance/FinanceEmployeeOrgBanner.tsx,
                 pages/finance/PettyCash.tsx, pages/finance/PettyCashReplenishment.tsx,
                 components/shared/RequestFormPage.tsx, MultiStepRequestPage.tsx,
                 pages/approvals/ApprovalDetail.tsx

Procurement Individual Budget (v1.0.3.289–290) — UAT R59–R61
  Department OR district opens their own template (org from employee card).
  Itemise lines against that unit. Submit itemised plan.
  Files: src/portalApi.ts, src/employeeProfile.ts
         portal: pages/facility/ProcurementPlan.tsx, api/endpoints/procurementPlan.ts
  AL: PortalFacilityMgt.Codeunit.al (52161) Save/SubmitProcurementPlan*
      PortalProcurementPlanHeader.Table.al, PortalProcurementPlanLine.Table.al

AL FELIX MUST PUBLISH (from BC-AL/FILES — live object IDs)
----------------------------------------------------------
  FILES/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al
    imprest surrender travel start, surrender line dedupe, petty cash Insert-before-Validate
  FILES/staffPortal/facilityUat/PortalFacilityMgt.Codeunit.al   (codeunit 52161)
    procurement budget template enter / itemise / submit
  FILES/staffPortal/facilityUat/PortalAssetTransferMgt.Codeunit.al
    vehicle tools on asset transfer
  FILES/staffPortal/facilityUat/PortalProcurementPlanHeader.Table.al
  FILES/staffPortal/facilityUat/PortalProcurementPlanLine.Table.al

Extra reviewed AL copies (do not overwrite live IDs blindly):
  BC-AL/REVIEWED-AL-FIXES-16-19-AUG/

DEPLOY ORDER
------------
1. Felix: APPLY-HIJRA-PATCH.ps1 → AL: Package → publish (keep AL 1.0.5.173)
2. TA: extract this zip to C:\TA\SelfServiceSuite, restore .env, START-HIJRA-PORTAL.bat
3. Verify: http://10.30.4.23:4000/api/health → v1.0.3.292 then Ctrl+F5
   (UI + /api share one PORT from .env — clear browser site data once after upgrade)
EOF

cat > "$ROOT/START-HIJRA-PORTAL.bat" << BAT
@echo off
setlocal
title Hijra Self Service Portal v${VERSION}
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"

if not exist ".env" (
  echo.
  echo  [!] .env NOT FOUND — copy your existing .env from backup
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo Installing backend dependencies ^(first run only^)...
  call npm install --omit=dev --no-audit --no-fund
)

echo.
echo ==========================================================
echo   HIJRA SELF SERVICE PORTAL  v${VERSION} FINAL
echo   http://YOUR-SERVER-IP:4000
echo ==========================================================
echo.
node dist\server.js
pause
BAT

cat > "$ROOT/VERIFY-DEPLOY.bat" << BAT
@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo VERIFY DEPLOY - HIJRA v${VERSION} COMPLETE SUITE FINAL
if exist "dist\server.js" (echo [OK] dist\server.js) else (echo [FAIL] dist\server.js)
findstr /M /C:"${VERSION}" dist\portalApi.js >nul 2>&1 && echo [OK] backend v${VERSION} || echo [FAIL] backend version
findstr /M /C:"preferPageOriginWhenRemote" public\assets\*.js >nul 2>&1 && echo [OK] login network fix || echo [WARN] portal build
findstr /M /C:"leave-request?application=" public\assets\*.js >nul 2>&1 && echo [OK] leave View action || echo [WARN] leave View
findstr /M /C:"cannot apply a new leave while another" dist\staff.js >nul 2>&1 && echo [FAIL] duplicate block present || echo [OK] duplicate block removed
findstr /M /C:"countResolvedPendingLeaveApplications" dist\staff.js >nul 2>&1 && echo [OK] HR leave pending fix || echo [WARN] HR leave pending fix
findstr /M /C:"leaveTypeDescriptionForDisplay" dist\portalApi.js >nul 2>&1 && echo [OK] Leave approval type description || echo [WARN] Leave type description
findstr /M /C:"Leave quantity" public\assets\*.js >nul 2>&1 && echo [OK] Leave approval quantity display || echo [WARN] Leave quantity display
findstr /M /C:"Business Central has marked this application as pending" public\assets\*.js >nul 2>&1 && echo [OK] Pending leave approval workflow fallback || echo [WARN] Leave approval workflow fallback
findstr /M /C:"Location / Coordinates" public\assets\*.js >nul 2>&1 && echo [FAIL] Attendance location column present || echo [OK] Attendance location column removed
findstr /M /C:"trainingCourseLookupOption" dist\portalApi.js >nul 2>&1 && echo [OK] Training course code/title relation || echo [WARN] Training course relation
findstr /M /C:"resolvePettyCashDefaultsFromEmployee" dist\portalApi.js >nul 2>&1 && echo [OK] Finance petty cash profile dims || echo [WARN] petty cash dims
findstr /M /C:"dailyRate" dist\portalApi.js >nul 2>&1 && echo [OK] Finance imprest daily rate || echo [WARN] imprest daily rate
findstr /M /C:"ERP returned no daily rate" public\assets\*.js >nul 2>&1 && echo [OK] Fresh ERP rate calculation per draft || echo [WARN] ERP rate draft reset
findstr /M /C:"surrender-preview" dist\portalApi.js >nul 2>&1 && echo [OK] Finance imprest surrender preview || echo [WARN] surrender preview
findstr /M /C:"enrichImprestSurrenderFromSourceImprest" dist\portalApi.js >nul 2>&1 && echo [OK] Finance surrender enrichment || echo [WARN] surrender enrichment
findstr /M /C:"01 Jan 0001" public\assets\*.js >nul 2>&1 && echo [OK] Imprest surrender unavailable details hidden || echo [WARN] surrender empty-detail filter
findstr /M /C:"employeeFinanceSectorFromRecord" dist\employeeProfile.js >nul 2>&1 && echo [OK] Staff Claim employee sector fallback || echo [WARN] Staff Claim sector fallback
findstr /M /C:"Hospital Category" public\assets\*.js >nul 2>&1 && echo [OK] Staff Claim flow-aware line columns || echo [WARN] Staff Claim line columns
findstr /M /C:"enrichApprovalStepsWithCommentLines" dist\leaveApprovalSteps.js >nul 2>&1 && echo [OK] Approval rejection notes || echo [WARN] rejection notes
findstr /M /C:"profile/trainings" dist\portalApi.js >nul 2>&1 && echo [OK] HR profile trainings tab || echo [WARN] profile trainings
findstr /M /C:"yearsOfService" dist\portalApi.js >nul 2>&1 && echo [OK] HR profile important dates || echo [WARN] profile dates
findstr /M /C:"listStatusFilter" public\assets\*.js >nul 2>&1 && echo [OK] Finance list status filter || echo [WARN] list status filter
findstr /M /C:"Requisition_Type" public\assets\*.js >nul 2>&1 && echo [OK] Facility fuel BC field aliases || echo [WARN] fuel field aliases
findstr /M /C:"travel-destinations" dist\portalApi.js >nul 2>&1 && echo [OK] Finance travel destinations lookup || echo [WARN] travel destinations
findstr /M /C:"QyGatePassReturns" dist\portalApi.js >nul 2>&1 && echo [OK] Gate Pass actual return details || echo [WARN] Gate Pass return details
findstr /M /C:"Source document" public\assets\*.js >nul 2>&1 && echo [OK] Complete Gate Pass Log columns || echo [WARN] Gate Pass Log columns
findstr /M /C:"PURCHASE_ITEM_NOT_IN_FINALIZED_BUDGET" dist\staffModules.js >nul 2>&1 && echo [OK] Purchase finalized-budget correction || echo [WARN] Purchase budget correction
findstr /M /C:"Receipt confirmation" public\assets\*.js >nul 2>&1 && echo [OK] Complete Store Requisition flow || echo [WARN] Store Requisition flow
findstr /M /C:"Search table records" public\assets\*.js >nul 2>&1 && echo [OK] shared list search || echo [WARN] shared list search
if exist "public\index.html" (echo [OK] public) else (echo [FAIL] public)
if exist ".env" (echo [OK] .env) else (echo [FAIL] .env MISSING)
if exist "dist\BUILD_ID.txt" (type dist\BUILD_ID.txt)
echo Check: http://10.30.4.23:4000/api/health
pause
BAT

cat > "$ROOT/README-FIRST.txt" << EOF
HIJRA COMPLETE SUITE FINAL v${VERSION} — 29 July 2026
*** DEPLOY THIS ZIP ONCE — ALL MODULES INCLUDED ***

Do NOT use older zips (including 1.0.3.70 through 1.0.3.79).
This build restores all UAT regression fixes from v1.0.3.54 portal + v1.0.3.44 backend.
HR + Finance + Facility row-by-row spreadsheet fixes included.

TWO-PART DEPLOY (order matters):
  1. Felix runs BC-AL/APPLY-HIJRA-PATCH.ps1, then packages/publishes the AL app
  2. TA extracts this zip to C:\\TA\\SelfServiceSuite on UAT (10.30.4.23)

Read ALL-FIXES-MANIFEST.txt for the full list mapped to UAT spreadsheets.
EOF

cat > "$ROOT/ALL-FIXES-MANIFEST.txt" << EOF
HIJRA SSP — FULL ALL-MODULES FIX MANIFEST (v${VERSION})
=====================================================
Deploy ONCE. Felix publishes BC-AL ONCE. Then portal zip ONCE.
Regression restore: portal baseline v1.0.3.54 + backend baseline v1.0.3.44 merged with current ahead-of-staging fixes.

ALL MODULES — PORTAL LIST SEARCH
---------------------------------
  [x] Shared list search filters request/document number, employee, description,
      department, date, and status across HR, Finance, Facility, and reports
  [x] Multiple search words work together; formatted document numbers match
  [x] No-match result, record count, and Clear Search restore the full list
  [x] Approval workspace search includes all returned request fields
  [x] Approved and rejected approval lists also have search
  [x] Detail line, editable line, attachment, report, profile and diagnostics lists
      have the same search behavior, including one-record and empty lists

HR — SSP HR HB Update Jul 26 2026 (column J = HB Status July 27)
-----------------------------------------------------------------
  Leave R10   [x] Canceled leave excluded from pending; modify on Open/Draft (staff.ts resolveLeaveStatus)
  Leave R14   [x] Statement balance aligned with request form (leaveBalance.ts + shared resolver)
  Leave R31   [x] Form vs statement balance mismatch fixed (same pending-leave counter)
  Approval    [x] Leave approval shows requested days instead of ETB 0, plus
                   leave type description, dates, reliever and department
              [x] Pending Paternity Leave always shows the approval workflow;
                  it displays BC's approver chain or an explicit assignment-pending step
  Attend R21  [x] HOD team attendance roster scoped to supervisor department (/attendance/team)
              [x] Location/coordinate columns removed from employee and HOD attendance tables
  Profile R23 [x] Job details: dept/division from QyHREmployee + dimension codes (portalApi /profile/details)
  Profile R24 [x] Important dates: years of service, last promotion, retirement (portalApi importantDates)
  Profile R26 [x] Next of kin name from QyHREmployeeKin OData (expanded name field paths)
  Profile R28 [x] Experience letter self-service (/hr/request-letters/experience + CuPortalHrLetters)
  HOD R32     [x] Staff on leave scoped to HOD department only (StaffOnLeave + fetchHodDepartmentStaff)
  Obs R33     [x] Medical claim types Govt / Non Govt / Online (essOptions + staff claim line — Finance module)
  Train R37   [x] Department dropdown from BC; ERP course list (TrainingRequest + CuPortalTraining)
              [x] Training lookup submits CourseCode to BC while displaying CourseTittle;
                  closed/individual courses are excluded and Other stays outside the relation
  Train R39   [x] Assessment captures full training need card fields (CuPortalTraining companion store)
  Train R40   [x] Training application list columns (period, provider, cost, department)
  Exit R41-43 [x] Transfer cancel, resignation, exit interview (EmployeeExit + CuPortalEmployeeExit)
               [x] HR sidebar routes and API endpoints restored for all staff
  Docs R28     [x] Existing Request Letters menu retained with BC-backed forms
               [x] Existing standalone Emergency Staff Loan entry retained
               [x] Guarantee, external, experience, mortgage, emergency loan, embassy

FINANCE — SSP Finance HB Update July 27 2026 (20 fail rows → code mapped)
--------------------------------------------------------------------------
  Imprest R07  [x] Duration, dept, job title, place of duty, total net, employee account on detail
               [x] Daily rate populated from BC line amount/days and shown to requester/approver
               [x] Rate preview/save resolves the portal employee's own Customer/Imprest
                   account and job group instead of the SOAP service account
               [x] Every new draft performs a fresh ERP-rate request and clears stale amounts
  Imprest R11  [x] Approver sees duration, destination, rejection reason (approvalDetailFields)
  Imprest R13  [x] Remaining unsettled amount on imprest list + detail (enrichment + list column)
  Surrender R19 [x] Duration + travel destination on surrender detail (source imprest enrichment)
  Surrender R23 [x] List status filter/search; send-for-approval on Open/Pending BC status
  Claim R24    [x] Create claim — Sector/GD1 resolved from every employee-card shape,
                   including users whose department parameter was previously null
  Claim R25    [x] Claim date = ERP working date (frontend schema + backend assert)
  Claim R26-27 [x] Header detail: dept, job title, place of duty, total net, employee account
  Claim R28    [x] Medical: hospital category + coverage % (BC validate + line column)
  Claim R29    [x] Claim type auto-links GL account on line add
  Claim R30    [x] Attachments (staffClaim in PORTAL_ATTACHMENT_MODULES)
  Claim R31-32 [x] Pending / approved list with status filter chips
  Claim R33    [x] Delete claim lines (Draft/Open — canDeleteRequestItems)
  Claim R34    [x] Cancel before approval (FINANCE_CANCEL_STATUSES on StaffClaim)
  Claim R35    [x] Multiple claim lines (MultiStepRequestPage)
  Petty R38    [x] Settlement detail enriched from employee profile (dept, RC, account, total)
  Petty R40    [x] BC department petty-cash limit displayed and enforced before approval
  Petty R41    [x] Cancel petty cash settlement before approval (PettyCash cancelStatuses)

FACILITY — SSP Facility HB July 21 2026
----------------------------------------
  [x] Purchase spec + file attachments; Store receive; Fuel detail fields
  [x] Transport Field Trip; Maintenance template + technician assign
  [x] Work ticket flight booking; Asset Transfer (separate from Transfer Order)
  [x] Gate Pass references Store Issue, Transfer Order, Asset Transfer, and Maintenance
  [x] Clear Gate Pass labels; actual Asset Transfer module is separately visible
  [x] Gate Pass Log visible only to its authorized roles
  [x] Gate Pass Log shows source document, real asset/vehicle number,
      description, from/to locations, date/time out, returnability, employee,
      actual return date from QyGatePassReturns, and status
  [x] Business Central unset dates no longer display as 01 Jan 0001
  [x] Store Issue Gate Pass department/sector fall back to the employee profile
  [x] Store Requisition detail follows Request, Items, Approval, Store Issue,
      and Receipt Confirmation with requested/issued/received quantities,
      item availability, requester/organisation fields, SRN, dates and values
  [x] Store and Purchase list totals fall back to saved BC line values when
      header FlowFields return zero; Fuel cost falls back to litres x price
  [x] Non-financial Facility lists show passenger, quantity, asset, or
      maintenance metrics instead of misleading ETB 0
  [x] Maintenance detail translates BC type codes, reads NextServiceKM, keeps
      vehicle odometers conditional, and explains each workflow state
  [x] Asset Transfer accepts Business Central New/Open status and uses the
      same Custom Approvals workflow as card 50584, creating real approval entries
  [x] BC-backed password reset/email and approval operations allow the complete
      sequential BC call window instead of failing at the browser's old 20-second limit
  [x] Transfer Order and Asset Transfer Gate Pass rows resolve each owner's
      department/sector from that employee's Business Central profile
  [x] The same owner-specific Department/Sector values appear in View details
  [x] Work Tickets / Flight Booking restored to Facility navigation
  [x] Maintenance Request restored to Facility navigation
  [x] Asset / Vehicle / Tool Transfer restored to Facility navigation
  [x] Work Ticket approval mapped to Business Central table 50866
  [x] Asset Transfer approval mapped to Business Central table 50278
  [x] All 17 Facility rows marked Out Of Scope are excluded from the pass count
      (including Procurement Individual Budget Preparation rows 59-61)
  [x] Purchase approval explains finalized-budget failures using the real item
      number and requesting department; Business Central budget control remains enforced
  [x] Transport Request Type displays City / Field Trip instead of raw 0 / 1
  [x] Field Trip remains distinct through the Business Central SOAP mapping
  [x] Internal and external passenger names/organization appear on requester
      and approver detail screens
  [x] Transport lists use Transport_Requisition_No (TRxxxx), not the unrelated
      generic No (Axxxxx), and refresh immediately after creation/Back

ROW-BY-ROW EVIDENCE
-------------------
  [x] 142 source test rows included in HIJRA-SSP-UAT-ROW-BY-ROW-EVIDENCE-2026-07-28.xlsx
  [x] All HB remark/comment columns included
  [x] Eight non-empty Facility legacy Excel comments included
  [x] 59 in-scope remark-driven code/comment fixes mapped
  [!] Those 59 rows remain Pending live BC UAT until Felix publishes and TA retests

BC AL REQUIRED (Felix — before portal deploy)
----------------------------------------------
  StaffPortalCodeunit — ImprestRequisitionLine Validate("No of Days") for daily rate in ERP
                        ClaimRequisitionHeader claimDate + department params
                        FetchMedicalClaimAmount; Imprest surrender PrepareSurrender
  CuPortalAttachments — staff claim / imprest / petty cash document uploads
  CuPortalFacility, CuPortalAssetTransfer + Facility OData queries
  Safe path-aware apply script: BC-AL/APPLY-HIJRA-PATCH.ps1

VERIFY AFTER DEPLOY
-------------------
  http://10.30.4.23:4000/api/health → v${VERSION}
  Run VERIFY-DEPLOY.bat — all [OK]
  Finance smoke: create staff claim, imprest line shows daily rate, petty cash cancel
EOF

cat > "$ROOT/INSTALL.txt" << EOF
HIJRA ${VERSION} COMPLETE SUITE FINAL — ONE-TIME DEPLOY (ALL MODULES)
=====================================================================

*** STEP 0 — FELIX FIRST (Business Central) ***
Send Felix the BC-AL/ folder from this zip (or the standalone Felix ZIP).
He should run BC-AL/APPLY-HIJRA-PATCH.ps1 as explained in BC-AL/README-FIRST.txt,
then compile and upload the .app. The install/upgrade codeunits publish the new services.

See ALL-FIXES-MANIFEST.txt — this zip includes HR + Finance + Facility fixes.

Critical SOAP: CuStaffPortal, CuPortalFacility, CuPortalAssetTransfer, CuPortalAttachments,
  CuPortalEmployeeExit, CuPortalEmployeeData, CuPortalHrLetters, CuPortalTraining
Critical OData: QyAssetTransfer, QyPortalFuelMaintExtra, QyWorkTicketFlight,
  QyProcurementPlanHeader, QyProcurementPlanLines, QyGatePassTransferShipments,
  QyGatePassAssetTransfers, QyGatePassReturns, QyPettyCashLimitDepartment, QyApprovalCommentLine,
  PgDepartmentsList, QyTravelDestinations

Felix smoke test (must not 404) before portal deploy:
  .../QyPortalFuelMaintExtra?\$top=1
  .../WS/HIJRA%20BANK/Codeunit/CuPortalFacility

*** STEP 1 — STOP portal on UAT ***

*** STEP 2 — BACKUP C:\\TA\\SelfServiceSuite ***

*** STEP 3 — EXTRACT zip ***
Copy SelfServiceSuite\\ to C:\\TA\\SelfServiceSuite\\
RESTORE your .env from backup — do NOT overwrite with .env.example

*** STEP 4 — START ***
Run START-HIJRA-PORTAL.bat

*** STEP 5 — VERIFY ***
Run VERIFY-DEPLOY.bat — all [OK]
Browser: http://10.30.4.23:4000/api/health → v${VERSION}
Ctrl+F5 on login page

*** STEP 6 — SMOKE TEST (all modules) ***
HR: Leave request → cancel does not block new leave; Profile shows division/dates/kin
HR: Leave approval → leave type name and requested number of days are visible
HR: HOD → staff on leave shows own department only; Training list shows applications
HR: Training submits the selected BC Course Code even when an older cached form sends its title
All modules: stale dropdown captions normalize to BC keys; removed lookup values are blocked before SOAP
Finance: Imprest daily rate + travel destination dropdown; Petty cash profile dims
Finance: Imprest Surrender hides unavailable fields and does not repeat organisation details
Finance: Staff claim creation for users with Sector-only employee profiles + medical refund
Finance: Staff Claim hides medical-only columns for non-medical claims and resolves G/L account names
Facility: Purchase spec attach, Asset Transfer post
Facility: Store/Purchase/Fuel list totals; Transport/Transfer/Asset list metrics
Facility: Store line table shows core fields plus only populated issue/receipt-stage values

BUILD_ID=hijra-portal-${VERSION}-FINAL-2026-07-29-select-relation-guard
EOF

cat > "$ROOT/FIX-NETWORK-ERROR.txt" << 'EOF'
If login shows Network Error after deploy:
1. Ctrl+F5
2. F12 Console: localStorage.setItem('ssp.apiBaseUrl', window.location.origin)
3. Check http://10.30.4.23:4000/api/health loads JSON
EOF

OLD_ZIP="$HOME/Desktop/HIJRA-1.0.3.45-COMPLETE-SUITE.zip"
if [[ -f "$OLD_ZIP" ]]; then
  unzip -p "$OLD_ZIP" "HIJRA-1.0.3.45-COMPLETE-SUITE/BC-ADMIN-STEPS.txt" > "$ROOT/BC-ADMIN-STEPS.txt" 2>/dev/null || true
fi

cat > "$ROOT/README-COMPLETE-SUITE.txt" << EOF
HIJRA Complete Suite FINAL v${VERSION} — 29 Jul 2026
FULL ALL MODULES — HR + Finance + Facility — deploy once.
See ALL-FIXES-MANIFEST.txt inside the zip.
EOF

DESKTOP_ZIP="$HOME/Desktop/${BUNDLE}.zip"
DESKTOP_FELIX="$HOME/Desktop/HIJRA-FELIX-AL-BUNDLE-${VERSION}.zip"
cd "$STAGE"
rm -f "$DESKTOP_ZIP" "$DESKTOP_FELIX"
zip -r "$DESKTOP_ZIP" "$BUNDLE" -x "*.DS_Store"
# Standalone AL zip for Felix — script and README are at the ZIP root.
mkdir -p "$STAGE/felix-al-only"
cp -R "$ROOT/BC-AL/." "$STAGE/felix-al-only/"
cp "$ROOT/UNDEPLOYED-FIXES-16-19-AUG-2026.txt" "$STAGE/felix-al-only/"
if [[ -d "$ROOT/FELIX-REPLACE-THESE-AL" ]]; then
  mkdir -p "$STAGE/felix-al-only/FELIX-REPLACE-THESE-AL"
  cp -R "$ROOT/FELIX-REPLACE-THESE-AL/." "$STAGE/felix-al-only/FELIX-REPLACE-THESE-AL/"
  # Also drop the 8 replace files at the Felix zip root.
  cp "$ROOT/FELIX-REPLACE-THESE-AL/"*.al "$STAGE/felix-al-only/" 2>/dev/null || true
  cp "$ROOT/FELIX-REPLACE-THESE-AL/REPLACE-THESE.txt" "$STAGE/felix-al-only/" 2>/dev/null || true
fi
cat > "$STAGE/felix-al-only/FELIX-NOTES-${VERSION}.txt" << EOF
HIJRA Felix REPLACE files v${VERSION} — keep AL ${AL_INSTALLED_VERSION}
=======================================================================
Overwrite the .al files at the ZIP ROOT (same file names). Then AL: Package.

  StaffPortalCodeunit.Codeunit.al
  PortalFacilityMgt.Codeunit.al
  PortalProcurementPlanHeader.Table.al
  PortalProcurementPlanLine.Table.al
  PortalAssetTransferMgt.Codeunit.al
  QyProcurementPlanHeader.Query.al
  QyProcurementPlanLines.Query.al
  QyAssetTransfer.Query.al

See REPLACE-THESE.txt for the Hijra project paths.
Publish BEFORE the portal zip ${VERSION}.
EOF
cd "$STAGE/felix-al-only"
zip -r "$DESKTOP_FELIX" . -x "*.DS_Store"

echo ""
echo "Created (Desktop only): $DESKTOP_ZIP"
echo "Created (Desktop only): $DESKTOP_FELIX  (Felix — publish BEFORE portal)"
ls -lh "$DESKTOP_ZIP" "$DESKTOP_FELIX"
unzip -l "$DESKTOP_ZIP" | tail -3
