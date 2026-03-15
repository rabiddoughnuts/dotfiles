#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
PRIVATE_STATE_ROOT="${PRIVATE_STATE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/../private-state}"
IN_FILE="${IN_FILE:-$PRIVATE_STATE_ROOT/encrypted/ssh-key-backups/id_ed25519_private_state.latest.gpg}"
OUT_FILE="${OUT_FILE:-$HOME/.ssh/id_ed25519_private_state}"

usage() {
  cat <<'EOF'
Usage: ./scripts/restore-sensitive-state.sh [--dry-run] [--input /path/to/file.gpg] [--output /path/to/restore]

Restores a password-protected GPG symmetric backup from private-state.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --input)
      IN_FILE="${2:-}"
      if [[ -z "$IN_FILE" ]]; then
        echo "Missing value for --input" >&2
        exit 1
      fi
      shift
      ;;
    --output)
      OUT_FILE="${2:-}"
      if [[ -z "$OUT_FILE" ]]; then
        echo "Missing value for --output" >&2
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

if [[ ! -f "$IN_FILE" ]]; then
  echo "Encrypted backup not found: $IN_FILE" >&2
  exit 1
fi

OUT_DIR="$(dirname "$OUT_FILE")"

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] mkdir -p $OUT_DIR"
  echo "[dry-run] gpg --decrypt --output $OUT_FILE $IN_FILE"
  echo "[dry-run] chmod 600 $OUT_FILE"
  exit 0
fi

mkdir -p "$OUT_DIR"

gpg --decrypt --output "$OUT_FILE" "$IN_FILE"
chmod 600 "$OUT_FILE"

echo "Restored sensitive file to: $OUT_FILE"
