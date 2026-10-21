#!/usr/bin/env bash
# Build ABH BC extension (.app) on Mac from ABH_UAT_LIVE.
# Requires: VS Code/Cursor + AL Language extension, symbols downloaded for BC240.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AL_PROJECT="${ABH_AL_PROJECT:-/Users/abhishekbehera/ABH_UAT_LIVE_V2}"
OUT_DIR="${ABH_APP_OUT:-/Users/abhishekbehera/Desktop}"

if [[ ! -f "$AL_PROJECT/app.json" ]]; then
  echo "Missing app.json in $AL_PROJECT" >&2
  exit 1
fi

VERSION="$(python3 -c "import json; print(json.load(open('$AL_PROJECT/app.json'))['version'])")"
PUBLISHER="$(python3 -c "import json; print(json.load(open('$AL_PROJECT/app.json'))['publisher'])")"
NAME="$(python3 -c "import json; print(json.load(open('$AL_PROJECT/app.json'))['name'])")"
OUT_APP="$OUT_DIR/${PUBLISHER}_${NAME}_${VERSION}.app"

# Find alc from AL Language extension
ALC=""
for base in "$HOME/.vscode/extensions" "$HOME/.cursor/extensions"; do
  [[ -d "$base" ]] || continue
  found="$(find "$base" \( -path "*microsoft.al-*" -o -path "*ms-dynamics-smb.al-*" \) -path "*/bin/darwin/alc" -type f 2>/dev/null | head -1)"
  if [[ -z "$found" ]]; then
    found="$(find "$base" \( -path "*microsoft.al-*" -o -path "*ms-dynamics-smb.al-*" \) -name alc -type f 2>/dev/null | head -1)"
  fi
  if [[ -n "$found" ]]; then ALC="$found"; break; fi
done

if [[ -z "$ALC" ]]; then
  cat >&2 <<EOF
alc not found. Install "AL Language" extension in Cursor/VS Code, then:
  1. Open $AL_PROJECT
  2. AL: Download symbols (server http://146.161.102.7:8080/BC240)
  3. AL: Package
Or run: Ctrl+Shift+P -> AL: Package, copy .app from .alpackages/output folder.
EOF
  exit 1
fi

ALC_DIR="$(cd "$(dirname "$ALC")" && pwd)"
DEFAULT_ASSEMBLY_PROBING_PATHS="$ALC_DIR"
for netfx_dir in \
  "$AL_PROJECT/.netfxrefs/pkg/build/.NETFramework/v4.8" \
  /Users/abhishekbehera/ABH_UAT_LIVE_V2/.netfxrefs/pkg/build/.NETFramework/v4.8 \
  /Users/abhishekbehera/SelfServiceBackend-ABH/build/BC24_TA_App_1.0.2.934/.netframework/package/build/.NETFramework/v4.8 \
  /System/Volumes/Data/private/tmp/netfx-ref/build/.NETFramework/v4.8 \
  /private/tmp/netfx-ref/build/.NETFramework/v4.8 \
  /System/Volumes/Data/private/tmp/netfx40/pkg/build/.NETFramework/v4.0 \
  /private/tmp/netfx40/pkg/build/.NETFramework/v4.0
do
  if [[ -d "$netfx_dir" ]]; then
    DEFAULT_ASSEMBLY_PROBING_PATHS="$netfx_dir"
    break
  fi
done
ASSEMBLY_PROBING_PATHS="${ABH_AL_ASSEMBLY_PROBING_PATHS:-$DEFAULT_ASSEMBLY_PROBING_PATHS}"

echo "Building $NAME $VERSION with $ALC"
"$ALC" /project:"$AL_PROJECT" /packagecachepath:"$AL_PROJECT/.alpackages" /assemblyprobingpaths:"$ASSEMBLY_PROBING_PATHS" /out:"$OUT_APP"

echo "Built: $OUT_APP"

# Keep the verified app beside the workflow/setup assets consumed by the
# matched portal-suite builder. This is a generated release artifact, not a
# source edit, and prevents the suite from silently embedding an older app.
BC_ASSET_DIR="$ROOT/deploy/businesscentral"
mkdir -p "$BC_ASSET_DIR"
cp "$OUT_APP" "$BC_ASSET_DIR/$(basename "$OUT_APP")"
echo "Staged: $BC_ASSET_DIR/$(basename "$OUT_APP")"

echo "Deploy on BC server:"
cat <<EOF

cd "\$env:USERPROFILE\\Desktop\\Erp"
Publish-NAVApp -Path ".\\$(basename "$OUT_APP")" -ServerInstance BC240 -SkipVerification
Sync-NAVApp -ServerInstance BC240 -Tenant default -Name "$NAME" -Publisher "$PUBLISHER" -Version $VERSION
Start-NAVAppDataUpgrade -ServerInstance BC240 -Tenant default -Name "$NAME" -Publisher "$PUBLISHER" -Version $VERSION
Restart-NAVServerInstance -ServerInstance BC240

EOF
