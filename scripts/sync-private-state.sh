#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
PUSH=0
MSG="${SYNC_MSG:-private-state sync $(date +%Y-%m-%dT%H:%M:%S)}"
PRIVATE_STATE_ROOT="${PRIVATE_STATE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/../private-state}"

usage() {
  cat <<'EOF'
Usage: ./scripts/sync-private-state.sh [--dry-run] [--push] [--message "..."]

Stages and commits changes in sibling private-state repo.
Use --push to also push to the remote emergency backup.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --push) PUSH=1 ;;
    --message)
      MSG="${2:-}"
      if [[ -z "$MSG" ]]; then
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

if [[ ! -d "$PRIVATE_STATE_ROOT/.git" ]]; then
  echo "Not a git repo: $PRIVATE_STATE_ROOT" >&2
  exit 1
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] git -C $PRIVATE_STATE_ROOT status --short"
  echo "[dry-run] git -C $PRIVATE_STATE_ROOT add -A"
  echo "[dry-run] git -C $PRIVATE_STATE_ROOT commit -m \"$MSG\""
  if [[ $PUSH -eq 1 ]]; then
    echo "[dry-run] git -C $PRIVATE_STATE_ROOT push"
  fi
  exit 0
fi

if [[ -z "$(git -C "$PRIVATE_STATE_ROOT" status --porcelain)" ]]; then
  echo "No private-state changes to sync."
  exit 0
fi

git -C "$PRIVATE_STATE_ROOT" add -A
git -C "$PRIVATE_STATE_ROOT" commit -m "$MSG"

if [[ $PUSH -eq 1 ]]; then
  git -C "$PRIVATE_STATE_ROOT" push
fi

echo "Private-state sync complete."
