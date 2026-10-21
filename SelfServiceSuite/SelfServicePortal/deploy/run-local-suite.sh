#!/usr/bin/env bash
# Run the Self Service suite locally (same layout as the Windows server ZIP).
#
#   SelfServiceBackend  :4000  BC365 login + React UI + BC API  (HIJRA uses this)
#   server              :4001  Application User + MySQL            (optional)
#
# Usage (from anywhere):
#   SelfServiceSuite/SelfServicePortal/deploy/run-local-suite.sh
#   SelfServiceSuite/SelfServicePortal/deploy/run-local-suite.sh --dev
#   SelfServiceSuite/SelfServicePortal/deploy/run-local-suite.sh --full
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORTAL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SUITE_ROOT="$(cd "$PORTAL_ROOT/.." && pwd)"
BC="$SUITE_ROOT/SelfServiceBackend"
FRONTEND="$PORTAL_ROOT/self-service-portal"
APP_SERVER="$PORTAL_ROOT/server"
MODE="${1:-}"

bash "$SCRIPT_DIR/sync-backend-from-repo.sh"

if [[ ! -f "$BC/.env" ]]; then
  if [[ -f "$SCRIPT_DIR/local-bc.env.example" ]]; then
    echo "==> Creating $BC/.env from local-bc.env.example"
    cp "$SCRIPT_DIR/local-bc.env.example" "$BC/.env"
    echo "    Edit BC_NAV_PASSWORD in $BC/.env"
  else
    echo "ERROR: Missing $BC/.env"
    exit 1
  fi
fi

kill_port() {
  local port="$1"
  if lsof -ti:"$port" >/dev/null 2>&1; then
    echo "==> Stopping process on port $port"
    lsof -ti:"$port" | xargs kill -9 2>/dev/null || true
    sleep 1
  fi
}

start_application_server() {
  if [[ ! -f "$APP_SERVER/dist/index.js" ]]; then
    echo "WARN: Application User server build missing at $APP_SERVER/dist/index.js"
    echo "      The server/ source is not in this repo — HIJRA dry-test uses BC365 on port 4000 only."
    return 1
  fi
  if [[ ! -f "$APP_SERVER/.env" ]]; then
    echo "WARN: $APP_SERVER/.env missing — skipping port 4001"
    return 1
  fi
  kill_port 4001
  echo "==> Starting Application User API on http://localhost:4001"
  mkdir -p "$APP_SERVER/logs"
  (cd "$APP_SERVER" && NODE_ENV=production node dist/index.js >> logs/application-api.log 2>&1) &
}

if [[ "$MODE" == "--dev" ]]; then
  cat > "$FRONTEND/.env" <<'EOF'
VITE_AUTH_API_URL=http://localhost:4000
VITE_BC_API_URL=http://localhost:4000
VITE_APP_NAME=Self Service Portal
EOF
  kill_port 4000
  if [[ "$2" == "--full" ]]; then
    start_application_server || true
  fi
  echo "==> DEV: BC backend http://localhost:4000 | Vite UI http://localhost:5173"
  echo "    In another terminal: cd SelfServiceSuite/SelfServicePortal/self-service-portal && npm run dev"
  cd "$BC"
  npm run dev
  exit 0
fi

echo "==> Installing / building suite package..."
if [[ ! -d "$BC/node_modules" ]]; then
  npm --prefix "$BC" ci
fi
if [[ ! -d "$FRONTEND/node_modules" ]]; then
  npm --prefix "$FRONTEND" ci
fi
npm --prefix "$BC" run build:all

kill_port 4000
if [[ "$MODE" == "--full" ]]; then
  start_application_server || true
fi

echo ""
echo "============================================================"
echo "  Self Service Portal — local dry-run (server package layout)"
echo "============================================================"
echo "  Open:        http://localhost:4000"
echo "  BC health:   http://localhost:4000/api/health"
echo "  Login:       BC365 User → E0083 + portal password"
echo "  Stop:        Ctrl+C"
echo "============================================================"
echo ""

cd "$BC"
NODE_ENV=production npm start
