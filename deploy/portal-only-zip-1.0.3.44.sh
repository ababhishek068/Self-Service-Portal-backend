#!/usr/bin/env bash
# Lean portal deploy zip (~1–3 MB) — dist + public only, like Claude HIJRA-1.0.3.44 bundle.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date +%Y-%m-%d)"
VERSION="1.0.3.44"
BUILD_ID="hijra-portal-${VERSION}-${STAMP}"
ZIP_NAME="HIJRA-${VERSION}-FULL-SUITE-${STAMP}.zip"
STAGING="$ROOT/.portal-bundle-${VERSION}"
OUT="$ROOT/$ZIP_NAME"

echo "==> Building backend..."
cd "$ROOT"
npm run build

echo "==> Building portal..."
npm --prefix "$ROOT/SelfServiceSuite/SelfServicePortal/self-service-portal" run build:onprem
PORTAL_PROJECT_DIR=SelfServiceSuite/SelfServicePortal/self-service-portal node "$ROOT/scripts/copy-portal.mjs"

echo "$BUILD_ID" > "$ROOT/dist/BUILD_ID.txt"

echo "==> Staging $ZIP_NAME ..."
rm -rf "$STAGING"
mkdir -p "$STAGING/SelfServiceBackend/dist" "$STAGING/SelfServiceBackend/public"
cp -R "$ROOT/dist/." "$STAGING/SelfServiceBackend/dist/"
cp -R "$ROOT/public/." "$STAGING/SelfServiceBackend/public/"

cat > "$STAGING/INSTALL.txt" <<EOF
HIJRA PORTAL UPDATE ${VERSION} (${STAMP})
=====================================

Contains: SelfServiceBackend/dist + public (compiled portal + API)

ON THE UAT SERVER (10.30.4.23):
1. Stop portal: deploy\\windows\\stop-suite.ps1
2. Backup: C:\\TA\\SelfServiceSuite -> C:\\TA\\SelfServiceSuite-backup-${STAMP}
3. Copy dist\\*  -> C:\\TA\\SelfServiceSuite\\SelfServiceBackend\\dist\\
4. Copy public\\* -> C:\\TA\\SelfServiceSuite\\SelfServiceBackend\\public\\
5. Start: deploy\\windows\\start-suite.bat
6. Browser: Ctrl+F5 on http://10.30.4.23:4000
7. Profile page should show build text containing: imprest surrender amounts

Also republish AL fixes from HIJRA-AL-FIXES-2026-07-25.zip (training + imprest surrender)

BUILD_ID=${BUILD_ID}
PORTAL_API_BUILD=v1.0.3.44 — imprest surrender amounts + training + employment type
EOF

rm -f "$OUT"
(cd "$STAGING" && zip -rq "$OUT" .)
rm -rf "$STAGING"

echo "==> Created: $OUT ($(du -h "$OUT" | awk '{print $1}'))"
