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
rm -rf "$BC/dist" "$BC/public" "$BC/deploy/deploy"
mkdir -p "$BC/dist" "$BC/public" "$BC/logs"
cp -R "$ROOT/dist/." "$BC/dist/"
cp -R "$FRONTEND/dist/." "$BC/public/"
cp -R "$ROOT/src" "$BC/src"
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
cp "$PORTAL/db/.env" "$STAGING/SelfServiceSuite/SelfServicePortal/db/.env"
cp "$PORTAL/server/.env" "$STAGING/SelfServiceSuite/SelfServicePortal/server/.env"

mkdir -p \
  "$STAGING/SelfServiceSuite/SelfServiceBackend/logs" \
  "$STAGING/SelfServiceSuite/SelfServicePortal/server/logs"

cat > "$STAGING/SelfServiceSuite/IMPORTANT-UPDATE.txt" <<'EOF'
SELF SERVICE SUITE - FULL OFFLINE CLIENT PACKAGE
================================================

Release date: 2026-06-25
See RELEASE-NOTES-2026-06-25.txt for per-module guidance and testing notes.

SUMMARY
-------
- Pending Approval status and Cancel on list/detail
- Finance attachments: upload on Draft/Open only
- Imprest lines: auto-calculated amount with manual entry fallback
- Staff claims: medical amount and hospital category auto-fill
- Petty cash replenishment detail fields (accounts and amounts)
- Transfer order status correct after request approval
- Vehicle Transfer: coming soon (disabled)

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

cp "$ROOT/SelfServiceSuite/RELEASE-NOTES-2026-06-25.txt" "$STAGING/SelfServiceSuite/RELEASE-NOTES-2026-06-25.txt"

echo "==> Creating zip: $OUTPUT"
rm -f "$OUTPUT"
(cd "$STAGING" && zip -r -q "$OUTPUT" SelfServiceSuite)
rm -rf "$STAGING"

SIZE="$(du -h "$OUTPUT" | awk '{print $1}')"
echo "Done: $OUTPUT ($SIZE)"
