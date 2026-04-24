#!/usr/bin/env bash
#
# Run a lightweight end-to-end private-state validation pass using safe paths.
# General use:
# - Exercise the main workflows without writing package/firewall changes.
# - Catch missing dependencies, bad paths, or broken script wiring quickly.
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "Running private-state smoke test (dry-run only)..."

# Keep every sub-step non-destructive except the integrity check, which only reads state.
./capture/capture-system-state.sh --dry-run
PRIVATE_STATE_ROOT="$REPO_ROOT/../private-state" ./restore/restore-system.sh --dry-run --packages-only
./scripts/backup-sensitive-state.sh --dry-run --key-file /etc/hosts
./scripts/sync-private-state.sh --dry-run
./scripts/private-state-integrity-check.sh

echo "Smoke test complete."
