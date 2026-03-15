#!/usr/bin/env bash
set -euo pipefail

APPLY=0
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./scripts/install-pacman-private-state-hook.sh [--apply] [--dry-run]

Generates a pacman hook from template with your dotfiles capture script path.
  --dry-run  Print actions only.
  --apply    Install generated hook into /etc/pacman.d/hooks using sudo.

Without --apply, writes generated hook to:
  hooks/pacman/95-private-state-capture.hook
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1 ;;
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
TEMPLATE="$REPO_ROOT/hooks/pacman/95-private-state-capture.hook.template"
GENERATED="$REPO_ROOT/hooks/pacman/95-private-state-capture.hook"
CAPTURE_SCRIPT="$REPO_ROOT/capture/capture-system-state.sh"
TARGET_DIR="/etc/pacman.d/hooks"
TARGET_FILE="$TARGET_DIR/95-private-state-capture.hook"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE" >&2
  exit 1
fi

if [[ ! -x "$CAPTURE_SCRIPT" ]]; then
  echo "Capture script is not executable: $CAPTURE_SCRIPT" >&2
  exit 1
fi

escaped_capture_script="${CAPTURE_SCRIPT//\//\/}"
sed "s|/path/to/public/dotfiles/capture/capture-system-state.sh|$escaped_capture_script|g" "$TEMPLATE" > "$GENERATED"

echo "Generated hook: $GENERATED"

if [[ $APPLY -eq 1 ]]; then
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "[dry-run] sudo install -d -m 755 $TARGET_DIR"
    echo "[dry-run] sudo install -m 644 $GENERATED $TARGET_FILE"
  else
    sudo install -d -m 755 "$TARGET_DIR"
    sudo install -m 644 "$GENERATED" "$TARGET_FILE"
    echo "Installed hook: $TARGET_FILE"
  fi
else
  echo "To install system-wide, run with: --apply"
fi
