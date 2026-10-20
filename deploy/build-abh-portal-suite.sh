#!/usr/bin/env bash
# Build a complete ABH portal Windows suite zip (dist + public + node_modules + launchers).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-1.0.3.374}"
BUILD_STAMP="${2:-v220 — ${VERSION} (Borrowing form, confirm receipt, contract dates)}"
OUT_NAME="ABH-Portal-COMPLETE-${VERSION}"
OUT_DIR="$ROOT/$OUT_NAME"
DESKTOP_ZIP="${DESKTOP_ZIP:-$HOME/Desktop/${OUT_NAME}.zip}"
SUITE_BC="$ROOT/SelfServiceSuite/SelfServiceBackend"
# Business Central assets ship from the repo, not the Desktop. Sourcing the .app
# from ~/Desktop silently pinned an older build, and the approval workflow XMLs
# were not copied at all — a package without them looks complete but leaves claim
# and store-requisition approvals dead, because no workflow listens for the event.
BC_ASSET_DIR="${BC_ASSET_DIR:-$ROOT/deploy/businesscentral}"
BC_APP_NAME="${BC_APP_NAME:-Technology Associates EA Ltd_BC24_TA App_1.0.3.310.app}"
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
# PORTAL_UI_DIR=<released public folder> ships that compiled UI unchanged (e.g. the 1.0.3.382
# UI, whose Windows-only source was never committed). Otherwise the fresh React build is used.
if [[ -n "${PORTAL_UI_DIR:-}" ]]; then
  rsync -a "$PORTAL_UI_DIR/" "$SUITE_BC/public/"
else
  rsync -a "$ROOT/public/" "$SUITE_BC/public/"
fi
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

# BC_PACKAGE_DIR=<released BusinessCentral folder> ships that folder unchanged (the .app the
# server actually runs, e.g. the 1.0.3.310 folder from ABH-Portal-COMPLETE-1.0.3.382) and adds
# not-yet-published AL changes beside it. Otherwise the folder is assembled from the AL project.
BC_SOURCE_ONLY="${BC_SOURCE_ONLY:-0}"
AL_ROOT="${ABH_AL_PROJECT:-/Users/abhishekbehera/ABH_UAT_LIVE_V2}"
if [[ -n "${BC_PACKAGE_DIR:-}" ]]; then
  rsync -a --exclude .DS_Store "$BC_PACKAGE_DIR/" "$OUT_DIR/BusinessCentral/"
  BC_APP_NAME="$(cd "$OUT_DIR/BusinessCentral" && ls *.app | head -1)"
  AL_SRC_DIR="$(ls -d "$OUT_DIR"/BusinessCentral/AL-Source-* | head -1)"
  AL_APP_VERSION="${AL_SRC_DIR##*AL-Source-}"
  PENDING_AL_DIR="$OUT_DIR/BusinessCentral/LocalPurchase-AL-NOT-YET-PUBLISHED"
  mkdir -p "$PENDING_AL_DIR"
  AL_NEW="$AL_ROOT/src/src/src/src/src/src/src/src/src/src/NEWCHANGES"
  cp "$AL_NEW/ProcurementProcess/PortalProcurementMgt.Codeunit.al" "$PENDING_AL_DIR/"
  cp "$AL_NEW/StaffPortalCodeunit.Codeunit.al" "$PENDING_AL_DIR/"
  cp "$AL_ROOT/src/src/Store/ABHLocalProcurement.Codeunit.al" "$PENDING_AL_DIR/"
  cp "$AL_ROOT/src/src/Store/ABHVendorQuote.Table.al" "$PENDING_AL_DIR/"
  # LPR Role Center menus (Nitish, ABH-LIVE-AL c613aa8) and setup/RC caption updates.
  for f in ABHCeoLprRC.PageExt.al ABHFundsMgmtLprRC.PageExt.al ABHPayrollFundsLprRC.PageExt.al \
           ABHLocalProcSetup.Page.al ABHLocalProcurementRC.Page.al ABHLocalRfqCard.PageExt.al \
           ABHLPROpsRfqQueue.Page.al ABHLPROpsPoQueue.Page.al ABHLPRFadPoQueue.Page.al ABHLPRPendingList.Page.al; do
    cp "$AL_ROOT/src/src/Store/$f" "$PENDING_AL_DIR/"
  done
  # 18 Oct workflow: Flow Stage / Ops fields, LPR card, Store Manager project-first prompt.
  cp "$AL_ROOT/src/src/tableextension/PurchaseHeaderExtension.TableExt.al" "$PENDING_AL_DIR/"
  cp "$AL_ROOT/src/src/Page/InternalRequisitionsU.Page.al" "$PENDING_AL_DIR/"
  cp "$AL_ROOT/src/src/Page/StoreReqHeaderApproved.Page.al" "$PENDING_AL_DIR/"
  # 20 Oct store requisition: store/project/UOM lists, store hand-off and BC forms for the portal.
  cp "$AL_ROOT/src/src/Store/StoreMgmt.Codeunit.al" "$PENDING_AL_DIR/"
  cp "$AL_ROOT/src/src/Query/StoreRequisitionsHeader.Query.al" "$PENDING_AL_DIR/"
  # Store offer line from the item card (Details/Specification, Brand / Model).
  cp "$AL_ROOT/src/src/Table/StoreRequistionLines.Table.al" "$PENDING_AL_DIR/"
  cp "$AL_ROOT/src/src/Query/Items.Query.al" "$PENDING_AL_DIR/"
  cat > "$PENDING_AL_DIR/README.txt" <<'PENDEOF'
NOT PUBLISHED YET — keep running the BC app in the parent folder.
These are the Local Purchase and Store Requisition files changed for the portal; the full
source is ABH-LIVE-AL main (compiled: Technology Associates EA Ltd_BC24_TA App_1.0.3.558.app,
publish with docs/ERP-Publish-1.0.3.558.ps1).
Store requisition (meeting 20 Oct), all in the portal: the requester picks the Issuing
Store, Is Project / Project Code and the Unit of Measure; the Store Keeper adds the item
to issue (in-stock list) and submits, or sends Request for LPR; the Store Manager accepts
the item or starts the LPR; the requester opens the Item Borrowing Form and accepts (GIV,
In Transit) or declines (Offer Another Item / Close Request); then Confirm Receipt.
The Procurement Officer prepares the Draft LPR lines in the portal (step 7).
Workflow = "ERP & BC – Staff Item/Asset
Request to Payment Workflow" (meeting 18 Oct): Store Keeper Request for LPR -> Store
Manager Start LPR (project, then officer) -> Procurement Officer submits -> Operations
Manager -> FAD -> RFQ (Operations Manager) -> quotes -> evaluation (Operations Manager,
Technical if required) -> FAD final -> PO (Operations Manager, FAD) -> Store Keeper GRN ->
invoice (Operations Manager, Finance verify) -> F&A payment -> Finance pays and closes.
The portal turns Local Purchase on by itself once these methods exist in BC;
until then purchase/store behave exactly as in 1.0.3.382.
After publish: fill ABH Local Proc Setup user IDs, turn OFF Using Temporary Users.
PENDEOF
else
if [[ -f "$BC_APP" ]]; then
  cp "$BC_APP" "$OUT_DIR/BusinessCentral/$BC_APP_NAME"
elif [[ "$BC_SOURCE_ONLY" == "1" ]]; then
  echo "WARN: no compiled Business Central app — packaging AL source only."
  BC_APP_NAME="(compile from AL source — no .app in this package)"
else
  echo "FATAL: Business Central app not found: $BC_APP (set BC_SOURCE_ONLY=1 to ship AL source only)"
  exit 1
fi
cp "$BC_ASSET_DIR/ABH-PUBLISH-BC.ps1" "$OUT_DIR/BusinessCentral/ABH-PUBLISH-BC.ps1"
cp "$BC_ASSET_DIR/ABH-PRODUCTION-SETUP.txt" "$OUT_DIR/BusinessCentral/ABH-PRODUCTION-SETUP.txt"
cp "$BC_ASSET_DIR/STORE-UAT-GO-LIVE-CHECKLIST.txt" "$OUT_DIR/BusinessCentral/STORE-UAT-GO-LIVE-CHECKLIST.txt"

if [[ -f "$AL_ROOT/app.json" ]]; then
  AL_APP_VERSION="${AL_APP_VERSION:-$(python3 -c "import json; print(json.load(open('$AL_ROOT/app.json'))['version'])")}"
elif [[ -z "${AL_APP_VERSION:-}" ]]; then
  echo "FATAL: $AL_ROOT/app.json not found — set AL_APP_VERSION"
  exit 1
fi
AL_SRC_DIR="$OUT_DIR/BusinessCentral/AL-Source-$AL_APP_VERSION"
mkdir -p "$AL_SRC_DIR"
if [[ -f "$AL_ROOT/app.json" ]]; then cp "$AL_ROOT/app.json" "$AL_SRC_DIR/app.json"; fi
cp "$AL_ROOT/src/src/Store/ABHLocalProcurement.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Store/ABHVendorQuote.Table.al" "$AL_SRC_DIR/"
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
cp "$AL_ROOT/src/src/staffPortal/PortalEmployeeProfile.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/staffPortal/ABHStaffServicesUAT.PermissionSet.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/NEWCHANGES/Employee.Page.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Table/StaffClaimLines.Table.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/src/src/src/src/src/src/src/src/HR3/HR/MedicalClaimManagement.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Table/StoreRequistionHeader.Table.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Table/StoreRequistionLines.Table.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Query/StoreRequisitionsHeader.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Query/StoreRequisitionLines.Query.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Page/StoreRequisitionHeaderUP.Page.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Store/StoreMgmt.Codeunit.al" "$AL_SRC_DIR/"
cp "$AL_ROOT/src/src/Store/StoreSetupChecklist.Page.al" "$AL_SRC_DIR/"
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
- Local Purchase (LPR -> RFQ -> PO -> pay) runs from the portal: Request for LPR, Approve (FAD),
  Convert to RFQ, Vendor Quotes + attachments, Auto Select Winner, optional Technical review,
  Approve Winner (FAD Final), Create PO, Finance Checker + FAD PO approval, Prepare/Post Local
  Receive (GRN), Issue after LPR receive, Local Invoice, Verify, CEO Approve Payment, Close LPR
  (ProcurementProcess/PortalProcurementMgt + StaffPortal PortalLocalPurchaseAction/Chain/AttachVendorQuoteFile)
- My Profile reads the whole Employee Card through SOAP CuStaffPortal.GetEmployeeProfileDetails (codeunit 50997 "Portal Employee Profile", schema 2):
  card groups (personal, contact, organisation, job, employment, leave summary, benefits, payment, salary, separation) plus
  next of kin / beneficiaries / dependants, qualifications, external + internal employment history, training, memberships,
  rewards, assigned assets and current-period salary allowances. Empty values are never emitted; passwords/OTP/tokens/user ids never leave BC.
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
fi

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

   Local Purchase roles come from BC ABH Local Proc Setup (no .env setting). Local Purchase
   turns on automatically once BC has the LPR portal methods. See LOCAL-PURCHASE-LPR-RUNBOOK.md.

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

cp "$ROOT/LOCAL-PURCHASE-LPR-RUNBOOK.md" "$OUT_DIR/LOCAL-PURCHASE-LPR-RUNBOOK.md"

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
- Local Purchase: each LPR/RFQ/PO step is offered only to its owner (Store Keeper, FAD, Procurement,
  Technical, Finance Checker, CEO); BC re-checks stage and ABH Local Proc Setup user on every call.
- Local PO Currency Code stays blank; min quotes + one attachment per vendor before Auto Select Winner;
  FAD Final before Create PO; Finance Checker + FAD before Post Receive.
- Store approval cancellation is verified against Business Central after the SOAP
  call; BC 1.0.3.307 also reconciles incomplete legacy workflow cancel responses.
- Multiple unresolved free-text Store lines retain schema-compatible unique keys
  until Store assigns the final Item or Fixed Asset number.
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
  "$OUT_DIR/LOCAL-PURCHASE-LPR-RUNBOOK.md"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/dist/server.js"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/public/index.html"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/package.json"
  "$OUT_DIR/SelfServiceSuite/SelfServiceBackend/node_modules/express/package.json"
  "$OUT_DIR/deploy/windows/host.env.abh-uat-ip.example"
  "$OUT_DIR/BusinessCentral/ABH-PUBLISH-BC.ps1"
  "$OUT_DIR/BusinessCentral/ABH-PRODUCTION-SETUP.txt"
  "$OUT_DIR/BusinessCentral/STORE-UAT-GO-LIVE-CHECKLIST.txt"
  "$OUT_DIR/BusinessCentral/Workflows/Staff-Medical-Claim-Approval-Workflow.xml"
  "$OUT_DIR/BusinessCentral/Workflows/Store-Requisition-Approval-Workflow.xml"
  "$OUT_DIR/BusinessCentral/Workflows/Purchase-Requisition-Approval-Workflow.xml"
  "$AL_SRC_DIR/StaffPortalCodeunit.Codeunit.al"
  "$AL_SRC_DIR/PortalWorkflowApprovalAuth.Codeunit.al"
  "$AL_SRC_DIR/CustomApprovalsCodeunit.Codeunit.al"
  "$AL_SRC_DIR/PortalWorkflowSetupUpgrade.Codeunit.al"
  "$AL_SRC_DIR/StaffClaimLines.Table.al"
  "$AL_SRC_DIR/MedicalClaimManagement.Codeunit.al"
  "$AL_SRC_DIR/StoreRequistionHeader.Table.al"
  "$AL_SRC_DIR/StoreRequistionLines.Table.al"
  "$AL_SRC_DIR/StoreRequisitionsHeader.Query.al"
  "$AL_SRC_DIR/StoreRequisitionLines.Query.al"
  "$AL_SRC_DIR/StoreMgmt.Codeunit.al"
  "$AL_SRC_DIR/StoreSetupChecklist.Page.al"
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

if [[ "$BC_SOURCE_ONLY" != "1" ]]; then REQUIRED+=("$OUT_DIR/BusinessCentral/$BC_APP_NAME"); fi
if [[ -n "${BC_PACKAGE_DIR:-}" ]]; then
  REQUIRED+=("$PENDING_AL_DIR/PortalProcurementMgt.Codeunit.al")
else
  REQUIRED+=("$AL_SRC_DIR/ABHLocalProcurement.Codeunit.al")
fi

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
MIN_ZIP_BYTES=5000000
if [[ "$BC_SOURCE_ONLY" == "1" ]]; then MIN_ZIP_BYTES=2000000; fi
if [[ "$BYTES" -lt "$MIN_ZIP_BYTES" ]]; then
  echo "FATAL: zip too small (${BYTES} bytes) — likely incomplete."
  exit 1
fi

echo "==> DONE"
echo "    Folder: $OUT_DIR"
echo "    Zip:    $DESKTOP_ZIP ($(du -h "$DESKTOP_ZIP" | awk '{print $1}'))"
echo "    Build:  $BUILD_STAMP"
