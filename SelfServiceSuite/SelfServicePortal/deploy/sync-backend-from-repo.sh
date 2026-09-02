#!/usr/bin/env bash
# Copy latest BC backend logic from repo root into the suite package layout.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORTAL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SUITE_ROOT="$(cd "$PORTAL_ROOT/.." && pwd)"
REPO_ROOT="$(cd "$SUITE_ROOT/.." && pwd)"
BC="$SUITE_ROOT/SelfServiceBackend"

echo "==> Syncing backend source: $REPO_ROOT -> $BC"

for item in src package.json package-lock.json tsconfig.json; do
  if [[ -e "$REPO_ROOT/$item" ]]; then
    if [[ -d "$REPO_ROOT/$item" ]]; then
      # Preserve local diagnostics/backups that may exist in the suite tree;
      # release synchronization updates canonical files but must not delete
      # unrelated working-tree material.
      rsync -a "$REPO_ROOT/$item/" "$BC/$item/"
    else
      cp "$REPO_ROOT/$item" "$BC/$item"
    fi
  fi
done

if [[ -f "$REPO_ROOT/scripts/copy-portal.mjs" ]]; then
  mkdir -p "$BC/scripts"
  cp "$REPO_ROOT/scripts/copy-portal.mjs" "$BC/scripts/copy-portal.mjs"
fi

if [[ -f "$REPO_ROOT/deploy/local.env.hijra-mac.example" ]]; then
  cp "$REPO_ROOT/deploy/local.env.hijra-mac.example" "$BC/deploy/local.env.hijra-mac.example" 2>/dev/null || true
fi

echo "==> Backend sync complete."
