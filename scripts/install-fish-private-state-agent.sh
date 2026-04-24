#!/usr/bin/env bash
#
# Copy the Fish ssh-agent helper into the user's conf.d directory.
# General use:
# - Reuse the tracked helper from homefiles/ without installing the full homefiles set.
# - Useful when only the private-state ssh-agent behavior is needed.
#
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

# Reuse the canonical helper under homefiles/ so there is one source of truth.
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

# Install into the per-user Fish conf.d location so new shells load it automatically.
mkdir -p "$DEST_DIR"
cp -f "$SRC" "$DEST"

echo "Installed fish helper: $DEST"
echo "Open a new fish shell to apply it."
