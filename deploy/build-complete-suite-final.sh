#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.3.79"
AL_PATCH_VERSION="1.0.5.73"
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
echo "hijra-portal-${VERSION}-FINAL-2026-07-28-all-existing-modules-preserved-search-facility-workflow-fixes" > dist/BUILD_ID.txt

echo "==> Staging $BUNDLE..."
rm -rf "$STAGE"
mkdir -p "$ROOT/SelfServiceSuite/SelfServiceBackend/logs"
mkdir -p "$ROOT/SelfServiceSuite/SelfServicePortal/self-service-portal"
mkdir -p "$ROOT/BC-AL"

cp -R "$SUITE/SelfServiceBackend/dist" "$SUITE/SelfServiceBackend/public" "$SUITE/SelfServiceBackend/deploy" "$ROOT/SelfServiceSuite/SelfServiceBackend/"
cp "$SUITE/SelfServiceBackend/package.json" "$SUITE/SelfServiceBackend/package-lock.json" "$ROOT/SelfServiceSuite/SelfServiceBackend/"
cp "$SUITE/SelfServiceBackend/README.md" "$SUITE/SelfServiceBackend/.env.example" "$ROOT/SelfServiceSuite/SelfServiceBackend/" 2>/dev/null || true

PORTAL="$SUITE/SelfServicePortal/self-service-portal"
cp -R "$PORTAL/dist" "$PORTAL/src" "$ROOT/SelfServiceSuite/SelfServicePortal/self-service-portal/"
cp "$PORTAL/package.json" "$PORTAL/package-lock.json" "$PORTAL/tsconfig.json" "$PORTAL/tsconfig.app.json" "$PORTAL/tsconfig.node.json" "$PORTAL/vite.config.ts" "$PORTAL/index.html" "$PORTAL/.env.onprem" "$ROOT/SelfServiceSuite/SelfServicePortal/self-service-portal/" 2>/dev/null || true

# BC AL — validated, path-aware patch. Do not include the obsolete duplicate
# PortalAttachmentsMgt.Codeunit.al or the old wrong-folder query copies.
cp -R "$REPO_ROOT/deploy/HIJRA-FELIX-SAFE-PATCH-1.0.5.71/." "$ROOT/BC-AL/"
# Build the deploy patch from the current reviewed AL project so the package
# cannot silently omit Employee Exit, HR Letters, Training, Facility, Gate Pass,
# approval comments, or the department petty-cash limit.
AL_PROJECT="${HIJRA_AL_PROJECT:-$HOME/Hijra Al ERP Apps V3/hijraERP/Hijra}"
if [[ ! -d "$AL_PROJECT/src/staffPortal" ]]; then
  echo "ERROR: HIJRA AL project was not found at: $AL_PROJECT" >&2
  exit 1
fi
for folder in employeeExit hrLetter training facilityUat; do
  mkdir -p "$ROOT/BC-AL/FILES/staffPortal/$folder"
  cp -R "$AL_PROJECT/src/staffPortal/$folder/." "$ROOT/BC-AL/FILES/staffPortal/$folder/"
done
mkdir -p "$ROOT/BC-AL/FILES/staffPortal/query" "$ROOT/BC-AL/FILES/HR-DEEP" "$ROOT/BC-AL/FILES/BASE-DEEP"
cp "$AL_PROJECT/src/staffPortal/PortalHr.PermissionSet.al" "$ROOT/BC-AL/FILES/staffPortal/"
for query in ApprovalCommentLine PettyCashLimitDepartment TrainingApplicationHeader TrainingApplicationLInes TrainingNeeds HrLeaveAllocationPortal QyAssetTransfer QyPortalFuelMaintExtra QyProcurementPlanHeader QyProcurementPlanLines QyWorkTicketFlight; do
  cp "$AL_PROJECT/src/staffPortal/query/${query}.Query.al" "$ROOT/BC-AL/FILES/staffPortal/query/"
done
cp "$AL_PROJECT/src/src/src/src/src/src/src/src/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al" "$ROOT/BC-AL/FILES/HR-DEEP/"
cp "$AL_PROJECT/src/src/src/src/src/src/src/src/src/HR3/HR/HRLeaveApplication.Table.al" "$ROOT/BC-AL/FILES/HR-DEEP/"
cp "$AL_PROJECT/src/src/src/src/src/src/src/src/src/Fleet/GatePass.Table.al" "$ROOT/BC-AL/FILES/BASE-DEEP/"
cp "$AL_PROJECT/src/Query/GatePassAssetTransfers.Query.al" "$AL_PROJECT/src/Query/GatePassTransferShipments.Query.al" "$ROOT/BC-AL/FILES/Query/"

echo "HIJRA Self Service Suite v${VERSION} FINAL — 28 July 2026" > "$ROOT/SelfServiceSuite/VERSION.txt"
cp "$REPO_ROOT/deploy/HIJRA-UAT-ROW-BY-ROW-IMPLEMENTATION-REPORT-2026-07-28.md" "$ROOT/"
cp "$REPO_ROOT/outputs/hijra-uat-2026-07-28/HIJRA-SSP-UAT-ROW-BY-ROW-EVIDENCE-2026-07-28.xlsx" "$ROOT/"

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
findstr /M /C:"resolvePettyCashDefaultsFromEmployee" dist\portalApi.js >nul 2>&1 && echo [OK] Finance petty cash profile dims || echo [WARN] petty cash dims
findstr /M /C:"dailyRate" dist\portalApi.js >nul 2>&1 && echo [OK] Finance imprest daily rate || echo [WARN] imprest daily rate
findstr /M /C:"travel-destinations" dist\portalApi.js >nul 2>&1 && echo [OK] Finance travel destinations lookup || echo [WARN] travel destinations
findstr /M /C:"Search table records" public\assets\*.js >nul 2>&1 && echo [OK] shared list search || echo [WARN] shared list search
if exist "public\index.html" (echo [OK] public) else (echo [FAIL] public)
if exist ".env" (echo [OK] .env) else (echo [FAIL] .env MISSING)
if exist "dist\BUILD_ID.txt" (type dist\BUILD_ID.txt)
echo Check: http://10.30.4.23:4000/api/health
pause
BAT

cat > "$ROOT/README-FIRST.txt" << EOF
HIJRA COMPLETE SUITE FINAL v${VERSION} — 28 July 2026
*** DEPLOY THIS ZIP ONCE — ALL MODULES INCLUDED ***

Do NOT use older zips (including 1.0.3.70 through 1.0.3.78).
This build stacks HR (Jul 27) + Finance (Jul 28) + Facility (Jul 21) in ONE package.

TWO-PART DEPLOY (order matters):
  1. Felix runs BC-AL/APPLY-HIJRA-PATCH.ps1, then packages/publishes the AL app
  2. TA extracts this zip to C:\\TA\\SelfServiceSuite on UAT (10.30.4.23)

Read ALL-FIXES-MANIFEST.txt for the full list mapped to UAT spreadsheets.
EOF

cat > "$ROOT/ALL-FIXES-MANIFEST.txt" << 'EOF'
HIJRA SSP — FULL ALL-MODULES FIX MANIFEST (v1.0.3.79)
=====================================================
Deploy ONCE. Felix publishes BC-AL ONCE. Then portal zip ONCE.
No partial labels — HR Jul 27 + Finance Jul 27 + Facility Jul 21 checked off below.

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
  Attend R21  [x] HOD team attendance roster scoped to supervisor department (/attendance/team)
  Profile R23 [x] Job details: dept/division from QyHREmployee + dimension codes (portalApi /profile/details)
  Profile R24 [x] Important dates: years of service, last promotion, retirement (portalApi importantDates)
  Profile R26 [x] Next of kin name from QyHREmployeeKin OData (expanded name field paths)
  Profile R28 [x] Experience letter self-service (/hr/request-letters/experience + CuPortalHrLetters)
  HOD R32     [x] Staff on leave scoped to HOD department only (StaffOnLeave + fetchHodDepartmentStaff)
  Obs R33     [x] Medical claim types Govt / Non Govt / Online (essOptions + staff claim line — Finance module)
  Train R37   [x] Department dropdown from BC; ERP course list (TrainingRequest + CuPortalTraining)
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
  Imprest R11  [x] Approver sees duration, destination, rejection reason (approvalDetailFields)
  Imprest R13  [x] Remaining unsettled amount on imprest list + detail (enrichment + list column)
  Surrender R19 [x] Duration + travel destination on surrender detail (source imprest enrichment)
  Surrender R23 [x] List status filter/search; send-for-approval on Open/Pending BC status
  Claim R24    [x] Create claim — dept resolution soft-fail (no 422 on long dept name)
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
  [x] Business Central unset dates no longer display as 01 Jan 0001
  [x] Store Issue Gate Pass department/sector fall back to the employee profile
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
  http://10.30.4.23:4000/api/health → v1.0.3.79
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
  QyGatePassAssetTransfers, QyPettyCashLimitDepartment, QyApprovalCommentLine,
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
HR: HOD → staff on leave shows own department only; Training list shows applications
Finance: Imprest daily rate + travel destination dropdown; Petty cash profile dims
Finance: Staff claim medical refund; Facility: Purchase spec attach, Asset Transfer post

BUILD_ID=hijra-portal-${VERSION}-FINAL-2026-07-28-all-existing-modules-preserved-search-facility-workflow-fixes
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
HIJRA Complete Suite FINAL v${VERSION} — 28 Jul 2026
FULL ALL MODULES — HR + Finance + Facility — deploy once.
See ALL-FIXES-MANIFEST.txt inside the zip.
EOF

DEPLOY_ZIP="$REPO_ROOT/deploy/${BUNDLE}.zip"
FELIX_ZIP="$REPO_ROOT/deploy/HIJRA-FELIX-SAFE-PATCH-${AL_PATCH_VERSION}.zip"
DESKTOP_ZIP="$HOME/Desktop/${BUNDLE}.zip"
DESKTOP_FELIX="$HOME/Desktop/HIJRA-FELIX-SAFE-PATCH-${AL_PATCH_VERSION}.zip"
cd "$STAGE"
rm -f "$DEPLOY_ZIP" "$FELIX_ZIP"
zip -r "$DEPLOY_ZIP" "$BUNDLE" -x "*.DS_Store"
# Standalone AL zip for Felix — script and README are at the ZIP root.
mkdir -p "$STAGE/felix-al-only"
cp -R "$ROOT/BC-AL/." "$STAGE/felix-al-only/"
cd "$STAGE/felix-al-only"
zip -r "$FELIX_ZIP" . -x "*.DS_Store"
cp "$DEPLOY_ZIP" "$DESKTOP_ZIP" 2>/dev/null || true
cp "$FELIX_ZIP" "$DESKTOP_FELIX" 2>/dev/null || true

echo ""
echo "Created: $DEPLOY_ZIP"
echo "Created: $FELIX_ZIP  (Felix only — publish BEFORE portal)"
ls -lh "$DEPLOY_ZIP" "$FELIX_ZIP"
[[ -f "$DESKTOP_ZIP" ]] && ls -lh "$DESKTOP_ZIP"
unzip -l "$DEPLOY_ZIP" | tail -3
