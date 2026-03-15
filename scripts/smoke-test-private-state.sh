#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "Running private-state smoke test (dry-run only)..."

./capture/capture-system-state.sh --dry-run
PRIVATE_STATE_ROOT="$REPO_ROOT/../private-state" ./restore/restore-system.sh --dry-run --packages-only
./scripts/backup-sensitive-state.sh --dry-run --key-file /etc/hosts
./scripts/sync-private-state.sh --dry-run
./scripts/private-state-integrity-check.sh

echo "Smoke test complete."
