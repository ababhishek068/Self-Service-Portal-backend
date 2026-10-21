#!/usr/bin/env bash
# Single publishable .app — same repack method as 920/921/922 (NAVX header + Content_Types fix).
# Injects leave-cancel + portal-approve StaffPortal AL, bumps version.
set -euo pipefail

SRC="${1:-/Users/abhishekbehera/Desktop/Technology Associates EA Ltd_BC24_TA App_1.0.2.922.app}"
AL_SRC="${2:-/Users/abhishekbehera/ABH_UAT_LIVE/src/src/src/src/src/src/src/src/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al}"
VERSION="${3:-1.0.2.925}"
OUT_DIR="${ABH_APP_OUT:-/Users/abhishekbehera/Desktop/Erp}"
OUT="$OUT_DIR/Technology Associates EA Ltd_BC24_TA App_${VERSION}.app"

[[ -f "$SRC" ]] || { echo "Missing base app: $SRC" >&2; exit 1; }
[[ -f "$AL_SRC" ]] || { echo "Missing AL: $AL_SRC" >&2; exit 1; }
grep -q "action = 'delete'" "$AL_SRC" || { echo "AL missing leave cancel branch" >&2; exit 1; }

mkdir -p "$OUT_DIR"

python3 - "$SRC" "$AL_SRC" "$OUT" "$VERSION" <<'PY'
import io, re, struct, sys, zipfile

src, al_src, out, version = sys.argv[1:5]
new_al = open(al_src, "rb").read()
raw = open(src, "rb").read()
zip_off = raw.find(b"PK\x03\x04")
if zip_off != 40:
    raise SystemExit(f"Unexpected NAVX layout (zip at {zip_off}, expected 40)")
header = bytearray(raw[:40])

with zipfile.ZipFile(io.BytesIO(raw[zip_off:]), "r") as zin:
    al_paths = [n for n in zin.namelist() if n.endswith("NEWCHANGES/StaffPortalCodeunit.Codeunit.al")]
    if not al_paths:
        raise SystemExit("StaffPortalCodeunit.Codeunit.al not found in base app")
    target_al = al_paths[0]

replaced = False
buf = io.BytesIO()
with zipfile.ZipFile(io.BytesIO(raw[zip_off:]), "r") as zin, zipfile.ZipFile(buf, "w") as zout:
    for item in zin.infolist():
        data = zin.read(item.filename)
        name = item.filename
        if name == "perm/file1_%5BContent_Types%5D.xml":
            name = "perm/file1_[Content_Types].xml"
        if name == target_al:
            data = new_al
            replaced = True
        if name == "NavxManifest.xml":
            data = re.sub(
                rb'Version="1\.0\.2\.\d+"',
                f'Version="{version}"'.encode(),
                data,
                count=1,
            )
        item.filename = name
        zout.writestr(item, data, compress_type=item.compress_type)

if not replaced:
    raise SystemExit(f"Failed to replace {target_al}")

new_zip = buf.getvalue()
struct.pack_into("<Q", header, 28, len(new_zip))
final = bytes(header) + new_zip
open(out, "wb").write(final)

z = zipfile.ZipFile(io.BytesIO(new_zip))
check = z.read(target_al)
assert b"action = 'delete'" in check
manifest = z.read("NavxManifest.xml").decode("utf-8", "replace")
assert f'Version="{version}"' in manifest
size64 = struct.unpack("<Q", header[28:36])[0]
if size64 != len(new_zip):
    raise SystemExit("header zip size mismatch")
print(out, len(final), "al=", target_al)
PY

echo ""
echo "Built: $OUT"
echo ""
echo "Server (Business Central Administration Shell):"
cat <<EOF
cd "\$env:USERPROFILE\\Desktop\\Erp"
Publish-NAVApp -Path ".\\Technology Associates EA Ltd_BC24_TA App_${VERSION}.app" -ServerInstance BC240 -SkipVerification
Sync-NAVApp -ServerInstance BC240 -Tenant default -Name "BC24_TA App" -Publisher "Technology Associates EA Ltd" -Version ${VERSION}
Start-NAVAppDataUpgrade -ServerInstance BC240 -Tenant default -Name "BC24_TA App" -Publisher "Technology Associates EA Ltd" -Version ${VERSION}
Get-NAVAppInfo -ServerInstance BC240 -Tenant default -TenantSpecificProperties -Name "BC24_TA App" | Where-Object { \$_.Version -eq [version]"${VERSION}" } | Format-List Version, IsInstalled
EOF
