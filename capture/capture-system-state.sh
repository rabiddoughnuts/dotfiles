#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
FORCE=0
DEBOUNCE_SECONDS="${CAPTURE_DEBOUNCE_SECONDS:-300}"

usage() {
  cat <<'EOF'
Usage: ./capture/capture-system-state.sh [--dry-run] [--force]

Captures package and firewall state into sibling private-state.
  --dry-run  Print planned actions only.
  --force    Bypass debounce interval guard.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
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

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE_STATE_ROOT="${PRIVATE_STATE_ROOT:-$REPO_ROOT/../private-state}"
HOSTNAME_SAFE="$(cat /etc/hostname 2>/dev/null | head -n 1 | tr -d '[:space:]')"
if [[ -z "$HOSTNAME_SAFE" ]]; then
  HOSTNAME_SAFE="$(uname -n 2>/dev/null || echo unknown-host)"
fi
HOST_DIR="$PRIVATE_STATE_ROOT/hosts/$HOSTNAME_SAFE"
META_DIR="$PRIVATE_STATE_ROOT/meta"
LAST_CAPTURE_EPOCH_FILE="$META_DIR/last-capture.epoch"
LAST_CAPTURE_JSON_FILE="$META_DIR/last-capture.json"
LOCK_FILE="/tmp/private-state-capture.lock"

echo "Capture target: $HOST_DIR"

mkdir -p "$META_DIR"

if [[ $FORCE -eq 0 && -f "$LAST_CAPTURE_EPOCH_FILE" ]]; then
  now_epoch="$(date +%s)"
  last_epoch="$(cat "$LAST_CAPTURE_EPOCH_FILE" 2>/dev/null || echo 0)"
  elapsed="$((now_epoch - last_epoch))"
  if [[ "$elapsed" -lt "$DEBOUNCE_SECONDS" ]]; then
    echo "Skipping capture: last capture was ${elapsed}s ago (debounce ${DEBOUNCE_SECONDS}s)."
    echo "Use --force to bypass debounce."
    exit 0
  fi
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] mkdir -p $HOST_DIR/packages $HOST_DIR/firewall $HOST_DIR/services"
  echo "[dry-run] capture pacman explicit packages"
  echo "[dry-run] capture AUR explicit packages"
  echo "[dry-run] capture flatpak user packages when available"
  echo "[dry-run] capture firewall exports when available"
  echo "[dry-run] write capture metadata in $META_DIR"
  exit 0
fi

if [[ -f "$LOCK_FILE" ]]; then
  echo "Capture lock exists: $LOCK_FILE"
  echo "Another capture may be running; remove lock if stale."
  exit 1
fi

trap 'rm -f "$LOCK_FILE"' EXIT
touch "$LOCK_FILE"

mkdir -p "$HOST_DIR/packages" "$HOST_DIR/firewall" "$HOST_DIR/services"

if command -v pacman >/dev/null 2>&1; then
  pacman -Qqe > "$HOST_DIR/packages/pacman-explicit.txt"
fi

if command -v paru >/dev/null 2>&1; then
  paru -Qqem > "$HOST_DIR/packages/aur-explicit.txt"
elif command -v pacman >/dev/null 2>&1; then
  pacman -Qqem > "$HOST_DIR/packages/aur-explicit.txt" || true
fi

if command -v flatpak >/dev/null 2>&1; then
  flatpak list --app --columns=application --user > "$HOST_DIR/packages/flatpak-explicit.txt" 2>/dev/null || true
fi

if command -v iptables-save >/dev/null 2>&1; then
  iptables-save > "$HOST_DIR/firewall/iptables.rules" 2>/dev/null || true
fi

if command -v nft >/dev/null 2>&1; then
  nft list ruleset > "$HOST_DIR/firewall/nft.rules" 2>/dev/null || true
fi

capture_iso="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
capture_epoch="$(date +%s)"
echo "$capture_epoch" > "$LAST_CAPTURE_EPOCH_FILE"
cat > "$LAST_CAPTURE_JSON_FILE" <<EOF
{
  "host": "$HOSTNAME_SAFE",
  "capturedAtUtc": "$capture_iso",
  "hostDir": "$HOST_DIR"
}
EOF

echo "Capture complete."
