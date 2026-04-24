#!/usr/bin/env bash
#
# Validate that the sibling private-state repo has the expected structure and
# that the last capture is recent enough to trust.
#
set -euo pipefail

MAX_CAPTURE_AGE_DAYS="${MAX_CAPTURE_AGE_DAYS:-7}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE_STATE_ROOT="${PRIVATE_STATE_ROOT:-$REPO_ROOT/../private-state}"
HOSTNAME_SAFE="$(cat /etc/hostname 2>/dev/null | head -n 1 | tr -d '[:space:]')"
if [[ -z "$HOSTNAME_SAFE" ]]; then
  HOSTNAME_SAFE="$(uname -n 2>/dev/null || echo unknown-host)"
fi
HOST_DIR="$PRIVATE_STATE_ROOT/hosts/$HOSTNAME_SAFE"
META_EPOCH_FILE="$PRIVATE_STATE_ROOT/meta/last-capture.epoch"
NOW_EPOCH="$(date +%s)"
MAX_AGE_SECONDS="$((MAX_CAPTURE_AGE_DAYS * 86400))"

fail() {
  echo "[integrity] FAIL: $*" >&2
  exit 1
}

echo "[integrity] checking private-state at: $PRIVATE_STATE_ROOT"

# Check the minimum directory and metadata structure needed by the rest of the workflow.
[[ -d "$PRIVATE_STATE_ROOT" ]] || fail "missing private-state root"
[[ -d "$PRIVATE_STATE_ROOT/.git" ]] || fail "private-state is not a git repository"
[[ -d "$HOST_DIR/packages" ]] || fail "missing packages directory for host $HOSTNAME_SAFE"
[[ -d "$HOST_DIR/firewall" ]] || fail "missing firewall directory for host $HOSTNAME_SAFE"
[[ -d "$PRIVATE_STATE_ROOT/encrypted/ssh-key-backups" ]] || fail "missing encrypted ssh backup directory"
[[ -f "$META_EPOCH_FILE" ]] || fail "missing capture epoch metadata: $META_EPOCH_FILE"

LAST_EPOCH="$(cat "$META_EPOCH_FILE" 2>/dev/null || echo 0)"
if ! [[ "$LAST_EPOCH" =~ ^[0-9]+$ ]]; then
  fail "invalid epoch value in $META_EPOCH_FILE"
fi

# Treat an old capture as an integrity failure so stale state is visible immediately.
AGE_SECONDS="$((NOW_EPOCH - LAST_EPOCH))"
if [[ "$AGE_SECONDS" -gt "$MAX_AGE_SECONDS" ]]; then
  fail "capture metadata is stale (${AGE_SECONDS}s old, max ${MAX_AGE_SECONDS}s)"
fi

echo "[integrity] capture age: ${AGE_SECONDS}s (max ${MAX_AGE_SECONDS}s)"

# Report git dirtiness as useful operator context without failing on it.
if [[ -z "$(git -C "$PRIVATE_STATE_ROOT" status --porcelain)" ]]; then
  echo "[integrity] git status: clean"
else
  echo "[integrity] git status: dirty"
  git -C "$PRIVATE_STATE_ROOT" status --short
fi

echo "[integrity] PASS"
