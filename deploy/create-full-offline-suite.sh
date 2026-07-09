#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REFERENCE="$ROOT/deployment-suite-2026-06-20/SelfServiceSuite"
SUITE="$ROOT/SelfServiceSuite"
BC="$SUITE/SelfServiceBackend"
PORTAL="$SUITE/SelfServicePortal"
FRONTEND="$PORTAL/self-service-portal"
STAMP="$(date +%Y-%m-%d)"
BUILD_ID="store-requisition-approval-2026-07-09-v1"
ZIP_NAME="SelfServiceSuite-ABH-UAT-${STAMP}-store-requisition-approval-v1-full-offline.zip"
ABH_ENV="$ROOT/deploy/windows/host.env.abh-uat-ip.example"
STAGING="$ROOT/.suite-bundle-staging"
OUTPUT="$ROOT/$ZIP_NAME"

if [[ ! -d "$REFERENCE" ]]; then
  echo "ERROR: Reference bundle missing at $REFERENCE"
  exit 1
fi

echo "==> Building BC backend..."
cd "$ROOT"
npm run build

echo "==> Building React portal (on-prem)..."
if [[ ! -d "$FRONTEND/node_modules" ]]; then
  npm --prefix "$FRONTEND" ci
fi
npm --prefix "$FRONTEND" run build:onprem

echo "==> Syncing latest builds into SelfServiceSuite..."
rm -rf "$BC/dist" "$BC/public" "$BC/deploy/deploy" "$BC/src"
mkdir -p "$BC/dist" "$BC/public" "$BC/src" "$BC/logs"
cp -R "$ROOT/dist/." "$BC/dist/"
echo "$BUILD_ID" > "$BC/dist/BUILD_ID.txt"
cp -R "$FRONTEND/dist/." "$BC/public/"
rsync -a \
  --exclude '*.tmp' \
  "$ROOT/src/" "$BC/src/"
cp "$ROOT/package.json" "$BC/package.json"
cp "$ROOT/package-lock.json" "$BC/package-lock.json"

echo "==> Staging full offline bundle from reference package..."
rm -rf "$STAGING"
mkdir -p "$STAGING"
rsync -a \
  --exclude '.DS_Store' \
  --exclude 'logs/*' \
  --exclude 'self-service-portal/node_modules/' \
  --exclude 'self-service-portal/dist/' \
  --exclude 'deploy/deploy/' \
  "$REFERENCE/" "$STAGING/SelfServiceSuite/"

echo "==> Overlaying latest backend build + env files..."
rsync -a \
  "$BC/dist/" "$STAGING/SelfServiceSuite/SelfServiceBackend/dist/"
echo "$BUILD_ID" > "$STAGING/SelfServiceSuite/SelfServiceBackend/dist/BUILD_ID.txt"
rsync -a \
  "$BC/public/" "$STAGING/SelfServiceSuite/SelfServiceBackend/public/"
rsync -a \
  "$BC/src/" "$STAGING/SelfServiceSuite/SelfServiceBackend/src/"
cp "$BC/package.json" "$STAGING/SelfServiceSuite/SelfServiceBackend/package.json"
cp "$BC/package-lock.json" "$STAGING/SelfServiceSuite/SelfServiceBackend/package-lock.json"
if [[ ! -f "$ABH_ENV" ]]; then
  echo "ERROR: ABH env template missing at $ABH_ENV"
  exit 1
fi
cp "$ABH_ENV" "$STAGING/SelfServiceSuite/SelfServiceBackend/.env"
cp "$ABH_ENV" "$BC/.env"
cp "$BC/.env.example" "$STAGING/SelfServiceSuite/SelfServiceBackend/.env.example"
cp "$ROOT/deploy/windows/host.env.abh-uat.example" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/host.env.abh-uat.example"
cp "$ABH_ENV" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/host.env.abh-uat-ip.example"
cp "$ROOT/deploy/windows/ENV-ON-NEW-HOST.txt" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/ENV-ON-NEW-HOST.txt"
cp "$BC/deploy/windows/prepare-host-env.bat" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/prepare-host-env.bat"
cp "$BC/deploy/windows/prepare-host-env.bat" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/prepare-host-env.bat"
cp "$BC/deploy/windows/start-self-service.bat" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/start-self-service.bat"
cp "$ROOT/deploy/windows/client-mac-helper.ps1" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/client-mac-helper.ps1"
cp "$ROOT/deploy/windows/start-client-mac-helper.bat" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/start-client-mac-helper.bat"
cp "$ROOT/deploy/windows/install-client-mac-helper.ps1" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/install-client-mac-helper.ps1"
cp "$ROOT/deploy/windows/install-client-mac-helper.bat" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/install-client-mac-helper.bat"
cp "$ROOT/deploy/windows/install-client-mac-helper-user.bat" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/install-client-mac-helper-user.bat"
cp "$ROOT/deploy/windows/uninstall-client-mac-helper.ps1" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/uninstall-client-mac-helper.ps1"
cp "$ROOT/deploy/windows/CLIENT-MAC-HELPER.txt" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/CLIENT-MAC-HELPER.txt"
cp "$PORTAL/db/.env" "$STAGING/SelfServiceSuite/SelfServicePortal/db/.env"
cp "$PORTAL/server/.env" "$STAGING/SelfServiceSuite/SelfServicePortal/server/.env"

mkdir -p \
  "$STAGING/SelfServiceSuite/SelfServiceBackend/logs" \
  "$STAGING/SelfServiceSuite/SelfServicePortal/server/logs"

cat > "$STAGING/SelfServiceSuite/IMPORTANT-UPDATE.txt" <<EOF
SELF SERVICE SUITE - FULL OFFLINE CLIENT PACKAGE
================================================

Release date: ${STAMP}

SUMMARY (${STAMP})
------------------
- Store Requisition: approval detail now shows a clear success/failure toast after
  Approve/Reject instead of looking stuck after the BC call
- Store Requisition: approval detail shows Quantity requested instead of ETB 0
- Approvals: source document maker is preferred over BC approval sender when BC
  has a real source document, so ADMIN does not overwrite maker details
- Leave: form now shows the same three balances as the BC leave application card —
  Allocated Days, Current Leave Balance, Earned Leave Days (removed portal-only
  Entitlement / Available Days labels)
- Leave: balance API reads BC OData leave-application fields first, then matches BC
  card math when OData fields are missing (fixes 0 balance block when BC shows 16)
- Leave: Open leaves no longer show a fake pending approver in the workflow stepper
- Leave: fixed excessive Business Central calls after "Request Approval" — the
  sender-side lookup and status polling no longer repeat every second; approval
  responds faster and the page settles instead of fetching continuously
- Leave: verbose per-leave status logging is now OFF by default (set
  LOG_LEAVE_STATUS=true only when diagnosing)
- Leave: added extra pending detection (scans leave header status fields) and,
  when approval can't be confirmed, records a ground-truth diagnostic to the log
  and browser console (shows whether BC actually created an approval entry)
- UI: background status reconcile after "Request Approval" is now SILENT — it no
  longer flashes the "Fetching data" loader every few seconds
- UI: modern loading — gradient top progress bar with shimmer, glass status pill with animated ring, improved skeleton loaders
- Leave: workflow codes stamped from employee card (Division/Department) so BC LEAVE-IT workflow runs
- Leave: status is now read 100% live from Business Central (no local cache) — Pending Approval reflects BC exactly
- ENV: bundled .env uses ABH WS/Page OData on 7047 + BC_JOB_TITLE_BY_CODE=ITM:IT Manger
- Profile: job title from Employee Card OData (7047 Page/) and job-code lookup — header shows IT Manger instead of STAFF
- Leave: approver name now resolves from approval entries, leave header, manager, user setup, or department HOD
- Leave: annual leave balance now reads Earned Leave Days / Annual Leave balance from BC OData (fixes 0 balance when BC card shows 16)
- Leave: job title shown instead of HOD role badge in header and reliever list
- Leave: submit now sends for approval in one step (no stuck Open status)
- Leave: attachment upload fixed (correct document number after create)
- Leave Planner: new calendar view under HR Services
- Fuel request list: fixed BC OData 500 error
- Store requisition: asset lines clear wrong item when type changes
- Transfer orders: approval history lookup (doc no, gate pass, record ID) + pending placeholder
- Work tickets: New ticket + add line on open tickets
- Pending Approval status, Cancel on list/detail (all modules)
- Finance attachments, imprest lines, staff claim medical, petty cash replenishment fields
- HOD staff list, on-leave, attendance pages
- Attendance MAC: run client helper on each employee PC (see below)

BC ADMIN STILL REQUIRED (not portal bugs)
-----------------------------------------
- Transport: TR number series must exist in BC
- Fuel/maintenance: approval workflow must be configured in BC (table 50865)
- Transfer order full approver chain: only if BC creates QyApprovalEntry rows

ATTENDANCE MAC (each employee PC)
---------------------------------
Run once on every PC that signs attendance (see deploy\windows\CLIENT-MAC-HELPER.txt):
  SelfServiceBackend\deploy\windows\install-client-mac-helper.bat

INSTALL / UPDATE ON CLIENT HOST
-------------------------------
1. Stop services:
   powershell -ExecutionPolicy Bypass -File C:\TA\SelfServiceSuite\SelfServicePortal\deploy\windows\stop-suite.ps1

2. Backup existing folder:
   C:\TA\SelfServiceSuite -> C:\TA\SelfServiceSuite-backup

3. Extract this ZIP to C:\TA so the folder is exactly:
   C:\TA\SelfServiceSuite

4. Start all services:
   C:\TA\SelfServiceSuite\SelfServicePortal\deploy\windows\start-suite.bat

5. Open http://146.161.102.7:4000 and press Ctrl+F5 once.

If .env is ever missing, copy the template for YOUR client:
   ABH (146.161.102.7): SelfServiceBackend\deploy\windows\host.env.abh-uat-ip.example
   ABH (abh-erp-ml):      SelfServiceBackend\deploy\windows\host.env.abh-uat.example
   HIJRA: SelfServiceBackend\deploy\windows\host.env.hijra-uat.example
   See SelfServiceBackend\deploy\windows\ENV-ON-NEW-HOST.txt
EOF

if [[ -f "$ROOT/SelfServiceSuite/RELEASE-NOTES-${STAMP}.txt" ]]; then
  cp "$ROOT/SelfServiceSuite/RELEASE-NOTES-${STAMP}.txt" "$STAGING/SelfServiceSuite/RELEASE-NOTES-${STAMP}.txt"
elif [[ -f "$ROOT/SelfServiceSuite/RELEASE-NOTES-2026-06-25.txt" ]]; then
  cp "$ROOT/SelfServiceSuite/RELEASE-NOTES-2026-06-25.txt" "$STAGING/SelfServiceSuite/RELEASE-NOTES-2026-06-25.txt"
fi

echo "==> Creating zip: $OUTPUT"
rm -f "$OUTPUT"
(cd "$STAGING" && zip -r -q "$OUTPUT" SelfServiceSuite)
rm -rf "$STAGING"

SIZE="$(du -h "$OUTPUT" | awk '{print $1}')"
echo "Done: $OUTPUT ($SIZE)"
