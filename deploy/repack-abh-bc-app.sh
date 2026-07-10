#!/usr/bin/env bash
# Fix Mac AL .app where perm/[Content_Types] was URL-encoded. Updates NAVX zip-size header.
set -euo pipefail

SRC="${1:-/Users/abhishekbehera/Desktop/Technology Associates EA Ltd_BC24_TA App_1.0.2.920.app}"
VERSION="${2:-$(python3 -c "import json; print(json.load(open('/Users/abhishekbehera/ABH_UAT_LIVE/app.json'))['version'])")}"
OUT_DIR="${ABH_APP_OUT:-/Users/abhishekbehera/Desktop}"
OUT="$OUT_DIR/Technology Associates EA Ltd_BC24_TA App_${VERSION}.app"
OUT_AL="${ABH_AL_PROJECT:-/Users/abhishekbehera/ABH_UAT_LIVE}/Technology Associates EA Ltd_BC24_TA App_${VERSION}.app"

python3 - "$SRC" "$OUT" "$OUT_AL" "$VERSION" <<'PY'
import io, struct, sys, zipfile

src, out, out_al, version = sys.argv[1:5]
raw = open(src, "rb").read()
zip_off = raw.find(b"PK\x03\x04")
if zip_off != 40:
    raise SystemExit(f"Unexpected NAVX layout (zip at {zip_off}, expected 40)")
header = bytearray(raw[:40])

buf = io.BytesIO()
with zipfile.ZipFile(io.BytesIO(raw[zip_off:]), "r") as zin, zipfile.ZipFile(buf, "w") as zout:
    for item in zin.infolist():
        data = zin.read(item.filename)
        name = item.filename
        if name == "perm/file1_%5BContent_Types%5D.xml":
            name = "perm/file1_[Content_Types].xml"
        if name == "NavxManifest.xml":
            data = data.replace(
                b'<App Id="5b5c244a-59bb-4a49-a255-0757fe4470cd"',
                b'<App Id="5b5c244a-59bb-4a49-a255-0757fe4470cd"',
            )
            import re
            data = re.sub(
                rb'Version="1\.0\.2\.\d+"',
                f'Version="{version}"'.encode(),
                data,
                count=1,
            )
        item.filename = name
        zout.writestr(item, data, compress_type=item.compress_type)

new_zip = buf.getvalue()
struct.pack_into("<Q", header, 28, len(new_zip))
final = bytes(header) + new_zip
for path in (out, out_al):
    open(path, "wb").write(final)
    print(path, len(final))
size64 = struct.unpack("<Q", header[28:36])[0]
if size64 != len(new_zip):
    raise SystemExit("header zip size mismatch")
PY

echo "Built $OUT"
