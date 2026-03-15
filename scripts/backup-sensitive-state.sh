#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
KEY_FILE="${KEY_FILE:-$HOME/.ssh/id_ed25519_private_state}"
PRIVATE_STATE_ROOT="${PRIVATE_STATE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/../private-state}"
OUT_DIR="$PRIVATE_STATE_ROOT/encrypted/ssh-key-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OUT_FILE="$OUT_DIR/$(basename "$KEY_FILE").$TIMESTAMP.gpg"
LATEST_FILE="$OUT_DIR/$(basename "$KEY_FILE").latest.gpg"

usage() {
  cat <<'EOF'
Usage: ./scripts/backup-sensitive-state.sh [--dry-run] [--key-file /path/to/key]

Creates a password-protected GPG symmetric backup of a sensitive key file
into the sibling private-state repository.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --key-file)
      KEY_FILE="${2:-}"
      if [[ -z "$KEY_FILE" ]]; then
        echo "Missing value for --key-file" >&2
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

if [[ ! -f "$KEY_FILE" ]]; then
  echo "Sensitive key file not found: $KEY_FILE" >&2
  exit 1
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] mkdir -p $OUT_DIR"
  echo "[dry-run] gpg --symmetric --cipher-algo AES256 --output $OUT_FILE $KEY_FILE"
  echo "[dry-run] cp -f $OUT_FILE $LATEST_FILE"
  exit 0
fi

mkdir -p "$OUT_DIR"

gpg --symmetric --cipher-algo AES256 --output "$OUT_FILE" "$KEY_FILE"
cp -f "$OUT_FILE" "$LATEST_FILE"

chmod 600 "$OUT_FILE" "$LATEST_FILE"

echo "Encrypted backup written to: $OUT_FILE"
echo "Latest pointer updated: $LATEST_FILE"
