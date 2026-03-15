#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE_STATE_ROOT="${PRIVATE_STATE_ROOT:-$REPO_ROOT/../private-state}"
DRY_RUN=0
PUSH=0
FORCE_CAPTURE=0
SYNC_MSG="${SYNC_MSG:-private-state maintenance $(date +%Y-%m-%dT%H:%M:%S)}"

usage() {
  cat <<'EOF'
Usage: ./scripts/private-state-maintenance.sh [--dry-run] [--push] [--force-capture] [--message "..."]

Runs the private-state maintenance chain:
  1) capture system state
  2) integrity check
  3) sync (commit), optionally push

Options:
  --dry-run        Dry-run capture and sync steps.
  --push           Push private-state after commit.
  --force-capture  Bypass capture debounce interval.
  --message        Commit message for sync step.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --push) PUSH=1 ;;
    --force-capture) FORCE_CAPTURE=1 ;;
    --message)
      SYNC_MSG="${2:-}"
      if [[ -z "$SYNC_MSG" ]]; then
        echo "Missing value for --message" >&2
        exit 1
      fi
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

cd "$REPO_ROOT"

capture_args=()
if [[ $DRY_RUN -eq 1 ]]; then
  capture_args+=(--dry-run)
fi
if [[ $FORCE_CAPTURE -eq 1 ]]; then
  capture_args+=(--force)
fi

sync_args=()
if [[ $DRY_RUN -eq 1 ]]; then
  sync_args+=(--dry-run)
fi
if [[ $PUSH -eq 1 ]]; then
  sync_args+=(--push)
fi
sync_args+=(--message "$SYNC_MSG")

echo "[maintenance] capture step"
./capture/capture-system-state.sh "${capture_args[@]}"

echo "[maintenance] integrity check step"
MAX_CAPTURE_AGE_DAYS=30 PRIVATE_STATE_ROOT="$PRIVATE_STATE_ROOT" ./scripts/private-state-integrity-check.sh

echo "[maintenance] sync step"
PRIVATE_STATE_ROOT="$PRIVATE_STATE_ROOT" ./scripts/sync-private-state.sh "${sync_args[@]}"

echo "[maintenance] done"
