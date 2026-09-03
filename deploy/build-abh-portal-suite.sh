#!/usr/bin/env bash
# Build a complete ABH portal Windows suite zip (dist + public + node_modules + launchers).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-1.0.3.344}"
BUILD_STAMP="${2:-v193 — ${VERSION} (Leave approval notifications through BC)}"
OUT_NAME="ABH-Portal-COMPLETE-${VERSION}"
OUT_DIR="$ROOT/$OUT_NAME"
DESKTOP_ZIP="${DESKTOP_ZIP:-$HOME/Desktop/${OUT_NAME}.zip}"
SUITE_BC="$ROOT/SelfServiceSuite/SelfServiceBackend"
# Business Central assets ship from the repo, not the Desktop. Sourcing the .app
# from ~/Desktop silently pinned an older build, and the approval workflow XMLs
# were not copied at all — a package without them looks complete but leaves claim
# and store-requisition approvals dead, because no workflow listens for the event.
BC_ASSET_DIR="${BC_ASSET_DIR:-$ROOT/deploy/businesscentral}"
BC_APP_NAME="${BC_APP_NAME:-Technology Associates EA Ltd_BC24_TA App_1.0.3.273.app}"
BC_APP="${BC_APP:-$BC_ASSET_DIR/$BC_APP_NAME}"
BC_WORKFLOW_DIR="$BC_ASSET_DIR/Workflows"

echo "==> ABH portal suite build $VERSION"
echo "    Repo: $ROOT"

echo "==> Sync backend source into suite layout"
bash "$ROOT/SelfServiceSuite/SelfServicePortal/deploy/sync-backend-from-repo.sh"

echo "==> Verify portal build stamp"
if ! grep -Fq "export const PORTAL_API_BUILD = '$BUILD_STAMP'" "$ROOT/src/portalApi.ts"; then
  echo "FATAL: src/portalApi.ts does not match requested build stamp: $BUILD_STAMP" >&2
  exit 1
fi
bash "$ROOT/SelfServiceSuite/SelfServicePortal/deploy/sync-backend-from-repo.sh"

echo "==> Compile backend + React UI"
(cd "$ROOT" && npm run build:all)
printf '%s\n' "$BUILD_STAMP" > "$ROOT/dist/BUILD_ID.txt"

echo "==> Stage suite backend"
rm -rf "$SUITE_BC/dist" "$SUITE_BC/public"
rsync -a "$ROOT/dist/" "$SUITE_BC/dist/"
rsync -a "$ROOT/public/" "$SUITE_BC/public/"
rsync -a "$ROOT/src/" "$SUITE_BC/src/"

echo "==> Production node_modules"
(cd "$SUITE_BC" && npm ci --omit=dev --no-audit --no-fund)

echo "==> Assemble deployable folder"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/deploy/windows" "$OUT_DIR/SelfServiceSuite" "$OUT_DIR/BusinessCentral"

rsync -a \
  --exclude node_modules \
  --exclude .env \
  --exclude .DS_Store \
  --exclude '*.log' \
  --exclude '*.app' \
  --exclude '*.tmp' \
  --exclude '*.bak-*' \
  --exclude '*hijra*' \
  "$SUITE_BC/" "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/"

rsync -a "$SUITE_BC/node_modules/" "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/node_modules/"
rsync -a --exclude '*hijra*' "$ROOT/deploy/windows/" "$OUT_DIR/deploy/windows/"
rsync -a --exclude '*hijra*' "$ROOT/deploy/windows/" "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/deploy/windows/"

cp "$OUT_DIR/deploy/windows/START-ABH-PORTAL.bat" "$OUT_DIR/START-ABH-PORTAL.bat"
cp "$OUT_DIR/deploy/windows/STOP-ABH-PORTAL.bat" "$OUT_DIR/STOP-ABH-PORTAL.bat"
cp "$OUT_DIR/deploy/windows/VERIFY-SUITE.bat" "$OUT_DIR/VERIFY-SUITE.bat"
cp "$OUT_DIR/deploy/windows/ABH-DIAGNOSE.bat" "$OUT_DIR/ABH-DIAGNOSE.bat"

cat > "$OUT_DIR/INSTALL-AUTOSTART.ps1" <<'PSEOF'
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'deploy\windows\install-startup-task.ps1')
PSEOF

if [[ ! -f "$BC_APP" ]]; then
  echo "FATAL: Business Central app not found: $BC_APP"
  exit 1
fi
cp "$BC_APP" "$OUT_DIR/BusinessCentral/$BC_APP_NAME"
cp "$BC_ASSET_DIR/ABH-PUBLISH-BC.ps1" "$OUT_DIR/BusinessCentral/ABH-PUBLISH-BC.ps1"
cp "$BC_ASSET_DIR/ABH-PRODUCTION-SETUP.txt" "$OUT_DIR/BusinessCentral/ABH-PRODUCTION-SETUP.txt"

AL_ROOT="${ABH_AL_PROJECT:-/Users/abhishekbehera/ABH_UAT_LIVE_V2}"
AL_APP_VERSION="$(python3 -c "import json; print(json.load(open('$AL_ROOT/app.json'))['version'])")"
AL_SRC_DIR="$OUT_DIR/BusinessCentral/AL-Source-$AL_APP_VERSION"
mkdir -p "$AL_SRC_DIR"
cp "$AL_ROOT/app.json" "$AL_SRC_DIR/app.json"
cp "$AL_ROOT/src/src/tableextension/PurchaseHeaderExtension.TableExt.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/tableextension/PurchaseLineExt.TableExt.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Query/PurchaseHeader2.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Query/PurchaseLines2.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Query/ApprovalEntries.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Page/PurchaseRequisitionCard.Page.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/staffPortal/query/QyPortalPurchaseLines.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/NEWCHANGES/PortalWorkflowApprovalAuth.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/NewChangeA/CustomApprovalsCodeunit.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/NewChangeA/PortalWorkflowSetupUpgrade.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/NewChangeA/PortalWorkflowSetupInstall.Codeunit.al" "$AL_SRC_DIR/"
mkdir -p "$AL_SRC_DIR/ProcurementProcess"
rsync -a "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/NEWCHANGES/ProcurementProcess/" "$AL_SRC_DIR/ProcurementProcess/"
cp "$AL_ROOT/src/src/staffPortal/query/HrEmployee.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/NEWCHANGES/Employee.Page.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Table/StaffClaimLines.Table.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/HR/MedicalClaimManagement.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Table/StoreRequistionHeader.Table.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Query/StoreRequisitionsHeader.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Page/StoreRequisitionHeaderUP.Page.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/HR/HRLeaveApplication.Table.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/HR/HRLeaveAppCard.Page.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/HR/HRLeaveApplicationCard.Page.al" "$AL_SRC_DIR/"
mkdir -p "$AL_SRC_DIR/LeaveStatement/Layouts"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/Payslip/Leavestatements.Report.al" "$AL_SRC_DIR/LeaveStatement/"
cp "$AL_ROOT/Layouts/Leavestatements.rdl" "$AL_SRC_DIR/LeaveStatement/Layouts/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/Funds/StaffClaims.Page.al" "$AL_SRC_DIR/"
mkdir -p "$AL_SRC_DIR/Payrollreports"
cp "$AL_ROOT/src/Layouts/Payrollreports/IndividualPayslipsmst.Report.al" "$AL_SRC_DIR/Payrollreports/"
cp "$AL_ROOT/Layouts/Payrollreports/payslip-standard.rdl" "$AL_SRC_DIR/Payrollreports/"
mkdir -p "$AL_SRC_DIR/EmployeeExit"
rsync -a "$AL_ROOT/src/src/staffPortal/employeeExit/" "$AL_SRC_DIR/EmployeeExit/"
mkdir -p "$AL_SRC_DIR/HrServiceLetters"
rsync -a "$AL_ROOT/src/src/staffPortal/hrLetter/" "$AL_SRC_DIR/HrServiceLetters/"
mkdir -p "$AL_SRC_DIR/ExternalHRPayroll"
rsync -a "$AL_ROOT/src/src/ExternalHRPayroll/" "$AL_SRC_DIR/ExternalHRPayroll/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/Coporate/JobExt.TableExt.al" \
  "$AL_SRC_DIR/ExternalHRPayroll/TableExt/JobExt.TableExt.al"
cat > "$AL_SRC_DIR/README.txt" <<'ALEOF'
ABH AL source — production portal/ERP sync
============================================
Publish this .app (or merge sources) on Windows BC, then restart.

Key fixes:
- Purchase and Store Requisition fields/lines follow the approved ABH templates
- Portal approval decisions use Business Central's native workflow responses; hierarchy is never advanced in portal code
- Rejection notes are entered separately from the request reason and remain visible to the requester
- Purchase procurement continues through stock, LPR/RFQ, finance, delivery, GRN, and auditor completion
- Portal and Business Central enforce role-appropriate procurement/store actions
- Purchase/Store requests remain controlled by Business Central approval workflows
- Employee Transfer, Resignation, and Employee Exit Form with Supervisor/HR routing
- Transfer and Resignation resolve the HR approver from the explicit setup override first, then an unambiguous active ABH HR owner; Employee Exit Form remains information-only
- Sick leave and every Staff Claim require a document attachment before submission
- Attendance grace rules: 08:50 arrival, 17:20 departure, automatic 19:00 sign-out
- Imprest Surrender portal flow uses the existing Business Central accounting document
- Purchase Header.Department ValidateTableRelation=false
- PurchaseRequisitionHeader assigns Department without Dimension Validate
- Currency only set when Currency master exists
- Purchase Request template fields + QyPortalPurchaseLines
- Store Requisition Priority / Justification SOAP params
- Medical dependant claims use the employee's pooled DEPENDANT ledger balance
- Medical dependant selection uses the HR Employee Kin SystemId so duplicate short numbers cannot resolve to the wrong person
- Medical claim Staff No uses the claim header Employee No, not customer account
- Staff Claims shows the live SELF and DEPENDANT medical balances from the Employee Card
- Leave final approval consumes carry forward first and creates unique allocation entries
- BC leave card pencil Edit safely cancels and archives active approvals before saving changes
- BC leave card Status is a dropdown whose Open/Pending transitions use the approval workflow
- Leave final approval remains restricted to the assigned approver through Business Central Approvals
- Purchase Requested By stores and displays the Employee Card full name, with Employee No kept separately
- Annual leave exposes the six Employee Card figures and validates applications only against Available Leave Balance
- Annual leave statement PDFs use Available = (Carry Forward + Accrued Days) - Taken To-Date
- Every rejected portal approval requires and preserves a requester-visible reason
- Marriage Leave is hidden and rejected when the Employee Card is already marked Married
- Sick Leave can start only today or tomorrow
- Duplicate/overlapping leave dates are blocked in the portal backend and Business Central
- Pending leave approval cancellation reopens a draft; only drafts can be permanently deleted
- Approved leave applications cannot be cancelled or deleted
- Leave End/Return dates respect the BC leave calendar, weekends, and holidays
- Payslips use the ABH_PARTNERS display name, two-decimal ETB amounts, and the standard A4 payroll layout
- Store Requisition omits Job Grade and District from the requester organisation summary
- Cancelled HR service requests can be permanently deleted by their owner; all other statuses are protected
- Nitish External HR organisation masters, employee history, PO fields, and SAF-EMN numbering are preserved
- Employee Job Group is exposed as JobGrade, and District can be maintained on the HR Employee Card
- HOD Department Staff and Staff on Leave are live, department-scoped functions
- HR Policies & Forms supports Business Central-backed upload/delete only for authenticated HR employees
ALEOF

if [[ ! -d "$BC_WORKFLOW_DIR" ]]; then
  echo "FATAL: Business Central workflow definitions not found: $BC_WORKFLOW_DIR"
  exit 1
fi
rsync -a "$BC_WORKFLOW_DIR/" "$OUT_DIR/BusinessCentral/Workflows/"

cat > "$OUT_DIR/README.txt" <<EOF
ABH SMART ESSP ENTERPRISE HUB — ${VERSION}
====================================

1) Extract this ENTIRE zip to C:\\${OUT_NAME}\\
   (You must see SelfServiceSuite\\SelfServiceBackend\\dist\\server.js)

2) Run VERIFY-SUITE.bat first — it must say ALL CHECKS PASSED.

3) Copy your working .env to:
   SelfServiceSuite\\SelfServiceBackend\\.env

4) Double-click START-ABH-PORTAL.bat

5) Confirm: http://127.0.0.1:4000/api/portal-build
   Expected: ${BUILD_STAMP}

6) To start the portal automatically after every Windows restart, open
   Administrator PowerShell in this folder and run:
   powershell -ExecutionPolicy Bypass -File .\INSTALL-AUTOSTART.ps1

BUSINESS CENTRAL APP
====================
Publish ${BC_APP_NAME} from BusinessCentral (or AL-Source-${AL_APP_VERSION}).
Portal ${VERSION} expects BC ${AL_APP_VERSION}; keep this generated pair together.

After publish, restart BC240. The existing StaffPortal SOAP endpoint stays the
same and exposes the new HR policy create/delete operations after app upgrade,
so no SOAP web-service refresh is required.
The new CuPortalEmployeeExit codeunit web service is published automatically
by the extension install/upgrade code.
Publish the QyPortalPurchaseLines query once as described in
BusinessCentral\ABH-PRODUCTION-SETUP.txt, and keep Purchase/Store number
series distinct.

Copy the .app to C:\TA\publish and run ABH-PUBLISH-BC.ps1 from an
Administrator Business Central Administration Shell.

Complete Business Central setup using BusinessCentral\ABH-PRODUCTION-SETUP.txt.
The supplied workflow XML files provide the correct document events; actual
ABH approver users and approval limits must be selected in Business Central.

IF ANYTHING IS NOT WORKING
==========================
Run ABH-DIAGNOSE.bat (portal must be started first).
It writes ABH-PORTAL-DIAGNOSTIC.txt to the Desktop showing which BC
endpoints answered, which failed, and why. Send that file back.

You can also open http://127.0.0.1:4000/api/bc-diagnostics directly
in a browser on the server - no login needed.
EOF

cat > "$OUT_DIR/AUDIT-NOTES.txt" <<'EOF'
ABH REFERENCE AUDIT — SIMPLE RESULT
===================================

- There is one Purchase Request only; Currency is not shown on the requester form.
- Purchase header includes profile identity, Budget Type, conditional Project Name / Code,
  Purchase Type, Required Date, Priority, Purpose / Justification, and optional technical notes.
- Each purchase line keeps Type, Name, Category, Description, Specification, Brand / Model,
  UOM, Quantity, estimates, Required Date, Supplier, and Remarks separate.
- Purchase attachments require a type and description; allowed files are PDF, DOC, DOCX,
  JPG, or PNG up to 10 MB.
- Item name, description, specification, estimate, and remarks are kept separately.
- Requester organisation details come from the employee profile in Business Central.
- Purchase and Store screens show the exact approved process flows.
- Store requesters state the required item/asset in free text; inventory masters and stock balances are not exposed.
- Operations/Store assigns the fulfillment location internally after approval.
- Store, Procurement, Finance, and Auditor actions are role protected.
- Requested By shows the employee name; Employee No remains a separate field.
- Annual leave shows Leave Entitlement, Carry Forward, Total Available Leave Balance,
  Leave Accrued To-Date, Total Leave Taken To-Date, and Available Leave Balance.
- Staff can apply only against Available Leave Balance, never Total Available Leave Balance.
- Annual leave PDF Current Balance uses the same Available Leave Balance formula as the portal and Employee Card.
- Every rejection requires a reason, which is shown in requester approval history.
- Marriage Leave is not offered to employees whose Employee Card is already marked Married.
- Sick Leave may start today or tomorrow only; duplicate and overlapping leave ranges are rejected.
- Cancelling a pending leave approval reopens the draft, which can then be permanently deleted.
- Approved leave is view-only, and Return Date is the next configured working day.
- Payslips display ABH_PARTNERS and use the standard A4 employee/pay-period/payroll format.
- Store Requisition does not display or require Job Grade and District.
- Cancelled HR service requests show Delete; pending, approved, and completed requests cannot be deleted.
- HOD users can open their department roster and current approved staff leave only.
- HR policy upload/delete is server-authorized for HR employees; other staff remain download-only.
- External HR employee, project, setup, organisation-master, and Job extension schema is upgrade-compatible.
- Login identifies the system as Smart ESSP | Employee Self-Service Portal.
- Business Central remains the source of truth for balances, approvals, documents, and process completion.

Before go-live:
- Publish QyPortalPurchaseLines in Business Central Web Services.
- Publish Hr Document Downloads as PgHrDownloads and Document Attachments query
  50108 as QyDocumentAttachments; configure Human Resources Setup > HR Document Nos.
- Keep Purchase Request and Store Requisition number series different.
- Use a restricted portal service account; do not expose SOAP/OData to ordinary users.
EOF

REQUIRED=(
  "$OUT_DIR/START-ABH-PORTAL.bat"
  "$OUT_DIR/VERIFY-SUITE.bat"
  "$OUT_DIR/ABH-DIAGNOSE.bat"
  "$OUT_DIR/INSTALL-AUTOSTART.ps1"
  "$OUT_DIR/AUDIT-NOTES.txt"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/dist/server.js"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/public/index.html"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/package.json"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/node_modules/express/package.json"
  "$OUT_DIR/deploy/windows/host.env.abh-uat-ip.example"
  "$OUT_DIR/BusinessCentral/$BC_APP_NAME"
  "$OUT_DIR/BusinessCentral/ABH-PUBLISH-BC.ps1"
  "$OUT_DIR/BusinessCentral/ABH-PRODUCTION-SETUP.txt"
  "$OUT_DIR/BusinessCentral/Workflows/Staff-Medical-Claim-Approval-Workflow.xml"
  "$OUT_DIR/BusinessCentral/Workflows/Store-Requisition-Approval-Workflow.xml"
  "$OUT_DIR/BusinessCentral/Workflows/Purchase-Requisition-Approval-Workflow.xml"
  "$AL_SRC_DIR/StaffPortalCodeunit.Codeunit.al"
  "$AL_SRC_DIR/PortalWorkflowApprovalAuth.Codeunit.al"
  "$AL_SRC_DIR/CustomApprovalsCodeunit.Codeunit.al"
  "$AL_SRC_DIR/PortalWorkflowSetupUpgrade.Codeunit.al"
  "$AL_SRC_DIR/StaffClaimLines.Table.al"
  "$AL_SRC_DIR/MedicalClaimManagement.Codeunit.al"
  "$AL_SRC_DIR/HRLeaveApplication.Table.al"
  "$AL_SRC_DIR/HRLeaveAppCard.Page.al"
  "$AL_SRC_DIR/HRLeaveApplicationCard.Page.al"
  "$AL_SRC_DIR/StaffClaims.Page.al"
  "$AL_SRC_DIR/EmployeeExit/PortalEmployeeExitMgt.Codeunit.al"
  "$AL_SRC_DIR/EmployeeExit/PortalEmployeeExitRequest.Table.al"
  "$AL_SRC_DIR/PurchaseHeaderExtension.TableExt.al"
  "$AL_SRC_DIR/PurchaseRequisitionCard.Page.al"
  "$AL_SRC_DIR/HrEmployee.Query.al"
  "$AL_SRC_DIR/QyPortalPurchaseLines.Query.al"
  "$AL_SRC_DIR/ProcurementProcess/PortalProcurementMgt.Codeunit.al"
  "$AL_SRC_DIR/ProcurementProcess/PortalProcurementProcess.Table.al"
  "$AL_SRC_DIR/ProcurementProcess/PortalProcurementProcesses.Page.al"
)

echo "==> Validating required files"
for f in "${REQUIRED[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "FATAL: missing $f"
    exit 1
  fi
done

echo "==> Creating zip: $DESKTOP_ZIP"
rm -f "$DESKTOP_ZIP"
(
  cd "$ROOT"
  zip -rq "$DESKTOP_ZIP" "$OUT_NAME"
)

BYTES="$(wc -c < "$DESKTOP_ZIP" | tr -d ' ')"
if [[ "$BYTES" -lt 5000000 ]]; then
  echo "FATAL: zip too small (${BYTES} bytes) — likely incomplete."
  exit 1
fi

echo "==> DONE"
echo "    Folder: $OUT_DIR"
echo "    Zip:    $DESKTOP_ZIP ($(du -h "$DESKTOP_ZIP" | awk '{print $1}'))"
echo "    Build:  $BUILD_STAMP"
