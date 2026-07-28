#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REFERENCE="$ROOT/deployment-suite-2026-06-20/SelfServiceSuite"
SUITE="$ROOT/SelfServiceSuite"
BC="$SUITE/SelfServiceBackend"
PORTAL="$SUITE/SelfServicePortal"
FRONTEND="$PORTAL/self-service-portal"
STAMP="2026-07-25"
BUILD_ID="hijra-uat-1.0.3.44-${STAMP}"
ZIP_NAME="SelfServiceSuite-HIJRA-UAT-${STAMP}-v1.0.3.44-full-offline.zip"
DEPLOY_WIN="$ROOT/deploy/windows"
HIJRA_ENV="$ROOT/SelfServiceSuite/SelfServiceBackend/deploy/windows/host.env.hijra-uat-ip.example"
FINAL_CHECKLIST="$ROOT/HIJRA-UAT-FINAL-FIX-CHECKLIST-2026-07-10.md"
AL_FIXES="$ROOT/deploy/al-fixes-2026-07-25"
STAGING="$ROOT/.suite-bundle-staging"
OUTPUT="$ROOT/$ZIP_NAME"

if [[ ! -d "$REFERENCE" ]]; then
  echo "ERROR: Reference bundle missing at $REFERENCE"
  exit 1
fi

if [[ ! -f "$FINAL_CHECKLIST" ]]; then
  echo "ERROR: Final checklist missing at $FINAL_CHECKLIST"
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
if [[ ! -f "$HIJRA_ENV" ]]; then
  echo "ERROR: Working HIJRA UAT env missing at $HIJRA_ENV"
  exit 1
fi
if ! grep -q '^BC_NAV_PASSWORD=.' "$HIJRA_ENV" || grep -Eq '^BC_NAV_PASSWORD=(CHANGE_ME_ON_SERVER|REPLACE-WITH)' "$HIJRA_ENV"; then
  echo "ERROR: Working HIJRA UAT env does not contain the configured BC service password"
  exit 1
fi
awk '
  !/^(HOST|CORS_ORIGIN|PORTAL_STATIC_DIR|BC_DISCOVER_ODATA_SERVICES|BC_SALARY_BASE_FIELD|BC_SALARY_LOOKUP_SERVICE)=/
' "$HIJRA_ENV" | sed 's/erp-app-uat/10.30.7.14/g' > "$STAGING/SelfServiceSuite/SelfServiceBackend/.env"
cat >> "$STAGING/SelfServiceSuite/SelfServiceBackend/.env" <<EOF
HOST=0.0.0.0
CORS_ORIGIN=http://10.30.4.23:4000
PORTAL_STATIC_DIR=public
BC_DISCOVER_ODATA_SERVICES=false
BC_SALARY_BASE_FIELD=Basic_Pay
BC_SALARY_LOOKUP_SERVICE=
EOF
cp "$DEPLOY_WIN/host.env.example" "$STAGING/SelfServiceSuite/SelfServiceBackend/.env.example"
cp "$DEPLOY_WIN/host.env.hijra-uat.example" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/host.env.hijra-uat.example"
cp "$DEPLOY_WIN/host.env.hijra-uat-ip.example" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/host.env.hijra-uat-ip.example"
cp "$DEPLOY_WIN/host.env.example" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/host.env.example"
cp "$DEPLOY_WIN/ENV-ON-NEW-HOST.txt" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/ENV-ON-NEW-HOST.txt"
cp "$DEPLOY_WIN/prepare-host-env.bat" "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/prepare-host-env.bat"
rm -f "$STAGING/SelfServiceSuite/SelfServiceBackend/deploy/windows/host.env.abh-uat"*
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

cp "$FINAL_CHECKLIST" "$STAGING/SelfServiceSuite/HIJRA-UAT-FINAL-FIX-CHECKLIST-2026-07-10.md"

if [[ -d "$AL_FIXES" ]]; then
  rsync -a "$AL_FIXES/" "$STAGING/SelfServiceSuite/deploy/al-fixes-2026-07-25/"
fi

cat > "$STAGING/SelfServiceSuite/IMPORTANT-UPDATE.txt" <<'EOF'
SELF SERVICE SUITE - FULL OFFLINE CLIENT PACKAGE
================================================

Release: v1.0.3.44 (2026-07-25)
Portal API build: v1.0.3.44 — 2026-07-25 (training list + employment type)
Backend BUILD_ID: hijra-uat-1.0.3.44-2026-07-25

SUMMARY (2026-07-25)
--------------------
TRAINING
- Training drafts now appear in My Requests (Employee No. passed on save)
- Request Approval button on detail when status is Open
- Employment Type shows label (Permanent/Contract) instead of BC option index "0"
- BC AL fix required: deploy/al-fixes-2026-07-25 (set Employee No. on header)

FINANCE
- Imprest Requisition: job title, free-text destination, amount/days bidirectional calc, cancel draft
- Imprest Surrender: duration, travel destination, outstanding balance, job title, cancel draft
- Petty Cash Settlement + Petty Cash Request: renamed labels, cancel draft
- Staff Claim: job title separated from RC, cancel draft
- Search bar on finance list pages; rejection reason on detail

PRIOR RELEASES (still included)
-------------------------------
- Leave: end/return date, pending approval list, approver chain, gender leave types
- HR: salary advance, fuel, store requisition, transfer orders, work tickets, HOD pages
- Global loading bar; HIJRA branding; attendance MAC helper

BC ADMIN STILL REQUIRED (not portal bugs)
-----------------------------------------
- Training: publish FnTrainingRequest AL patch (see deploy/al-fixes-2026-07-25)
- Staff claim types: add Receipts & Payment Types in BC
- Petty cash limit: table 51043 not on OData
- Transport TR number series; fuel approval workflow (table 50865)

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

5. Open http://10.30.4.23:4000 and press Ctrl+F5 once.

If .env is ever missing, copy:
   HIJRA (BC IP 10.30.7.14):  SelfServiceBackend\deploy\windows\host.env.hijra-uat-ip.example
   HIJRA (erp-app-uat):         SelfServiceBackend\deploy\windows\host.env.hijra-uat.example
   See SelfServiceBackend\deploy\windows\ENV-ON-NEW-HOST.txt
EOF

cat > "$STAGING/SelfServiceSuite/RELEASE-NOTES-2026-07-25.txt" <<'EOF'
HIJRA UAT Self Service Suite — Release v1.0.3.44 (2026-07-25)
=============================================================

WHAT'S NEW
----------
1. Training module
   - Draft training requests visible in portal list
   - Request Approval on Open status (detail page, top-right)
   - Profile Employment Type displays readable text

2. Finance module (HB remarks Jul 2026)
   - Imprest requisition/surrender field enrichment and cancel-on-draft
   - Petty cash module renaming and cancel-on-draft
   - Staff claim job title + cancel-on-draft
   - List search and rejection comments on detail

3. BC AL patch (separate — not auto-applied)
   - Folder: deploy/al-fixes-2026-07-25/
   - FnTrainingRequest: set TrainingHeader."Employee No." := EmployeeNo

VERIFY AFTER DEPLOY
-------------------
- Login http://10.30.4.23:4000 — check footer/build shows v1.0.3.44
- GET /api/portal/build — portalApiBuild matches
- Training: create draft → appears in list → Request Approval
- Finance: open draft → Cancel Request works
EOF

echo "==> Creating zip: $OUTPUT"
rm -f "$OUTPUT"
(cd "$STAGING" && zip -r -q "$OUTPUT" SelfServiceSuite)
rm -rf "$STAGING"

SIZE="$(du -h "$OUTPUT" | awk '{print $1}')"
echo "Done: $OUTPUT ($SIZE)"
echo "BUILD_ID=$BUILD_ID"
