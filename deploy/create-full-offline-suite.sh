#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REFERENCE="$ROOT/deployment-suite-2026-06-20/SelfServiceSuite"
SUITE="$ROOT/SelfServiceSuite"
BC="$SUITE/SelfServiceBackend"
PORTAL="$SUITE/SelfServicePortal"
FRONTEND="$PORTAL/self-service-portal"
STAMP="$(date +%Y-%m-%d)"
ZIP_NAME="SelfServiceSuite-UAT-${STAMP}-client-full-offline.zip"
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
rsync -a \
  "$BC/public/" "$STAGING/SelfServiceSuite/SelfServiceBackend/public/"
rsync -a \
  "$BC/src/" "$STAGING/SelfServiceSuite/SelfServiceBackend/src/"
cp "$BC/package.json" "$STAGING/SelfServiceSuite/SelfServiceBackend/package.json"
cp "$BC/package-lock.json" "$STAGING/SelfServiceSuite/SelfServiceBackend/package-lock.json"
cp "$BC/.env" "$STAGING/SelfServiceSuite/SelfServiceBackend/.env"
cp "$BC/.env.example" "$STAGING/SelfServiceSuite/SelfServiceBackend/.env.example"
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

5. Open http://10.30.4.23:4000 and press Ctrl+F5 once.

If .env is ever missing, copy the template for YOUR client:
   ABH:  SelfServiceBackend\deploy\windows\host.env.abh-uat.example
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
