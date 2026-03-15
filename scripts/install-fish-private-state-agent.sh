#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./scripts/install-fish-private-state-agent.sh [--dry-run]

Installs fish conf.d helper to auto-start ssh-agent and auto-load
~/.ssh/id_ed25519_private_state for interactive shells.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
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
SRC="$REPO_ROOT/homefiles/.config/fish/conf.d/private-state-ssh-agent.fish"
DEST_DIR="$HOME/.config/fish/conf.d"
DEST="$DEST_DIR/private-state-ssh-agent.fish"

if [[ ! -f "$SRC" ]]; then
  echo "Source helper not found: $SRC" >&2
  exit 1
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] mkdir -p $DEST_DIR"
  echo "[dry-run] cp -f $SRC $DEST"
  exit 0
fi

mkdir -p "$DEST_DIR"
cp -f "$SRC" "$DEST"

echo "Installed fish helper: $DEST"
echo "Open a new fish shell to apply it."
