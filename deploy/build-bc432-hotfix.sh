#!/usr/bin/env bash
# Rebuild the extracted 431 source with the Store header patch.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOTNET="${ABH_DOTNET:-$ROOT/tmp/dotnet-arm64/dotnet}"
COMPILER="${ABH_ALC_DLL:-$ROOT/tmp/altool-portable/tools/net8.0/any/alc.dll}"
PROJECT="$ROOT/build/BC24_TA_App_1.0.3.432"
OUT="$ROOT/output/bc432"
mkdir -p "$OUT"
"$DOTNET" "$COMPILER" /generatereportlayout- \
  /project:"$PROJECT" /packagecachepath:"$PROJECT/.alpackages" \
  /assemblyprobingpaths:"${ABH_NETFX_REFS:-/Users/abhishekbehera/ABH_UAT_LIVE_V2/.netfxrefs/pkg/build/.NETFramework/v4.8}" \
  /out:"$OUT/Technology Associates EA Ltd_BC24_TA App_1.0.3.432.app"
