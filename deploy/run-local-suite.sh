#!/usr/bin/env bash
# Delegates to the Self Service Portal server package (suite layout).
exec "$(cd "$(dirname "$0")/.." && pwd)/SelfServiceSuite/SelfServicePortal/deploy/run-local-suite.sh" "$@"
