#!/usr/bin/env bash
#
# Generate and install a user-level systemd timer for integrity checks.
# General use:
# - Rewrite the service template with the absolute integrity-check script path.
# - Preview the install with --dry-run.
# - Use --apply to copy the units into ~/.config/systemd/user and enable the timer.
#
set -euo pipefail

APPLY=0
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./scripts/install-private-state-integrity-timer.sh [--apply] [--dry-run]

Installs a user-level systemd service/timer for daily private-state integrity checks.
Without --apply, it only prints what would happen.
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

# Keep the source templates in-repo, but install the runnable units into the
# user's systemd directory where systemctl --user can manage them.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_SERVICE="$REPO_ROOT/systemd/private-state-integrity.service"
SRC_TIMER="$REPO_ROOT/systemd/private-state-integrity.timer"
GENERATED_SERVICE="$REPO_ROOT/systemd/private-state-integrity.generated.service"
DEST_DIR="$HOME/.config/systemd/user"
DEST_SERVICE="$DEST_DIR/private-state-integrity.service"
DEST_TIMER="$DEST_DIR/private-state-integrity.timer"
INTEGRITY_SCRIPT="$REPO_ROOT/scripts/private-state-integrity-check.sh"

if [[ ! -f "$SRC_SERVICE" || ! -f "$SRC_TIMER" ]]; then
  echo "Missing systemd unit templates under $REPO_ROOT/systemd" >&2
  exit 1
fi

if [[ ! -x "$INTEGRITY_SCRIPT" ]]; then
  echo "Integrity script is not executable: $INTEGRITY_SCRIPT" >&2
  exit 1
fi

# Render the service file so ExecStart points at the current checkout path.
escaped_integrity_script="${INTEGRITY_SCRIPT//\//\/}"
sed "s|/path/to/public/dotfiles/scripts/private-state-integrity-check.sh|$escaped_integrity_script|g" "$SRC_SERVICE" > "$GENERATED_SERVICE"

# Without --apply, this command behaves as an inspection tool rather than an installer.
if [[ $DRY_RUN -eq 1 || $APPLY -eq 0 ]]; then
  echo "[info] source service template: $SRC_SERVICE"
  echo "[info] generated service: $GENERATED_SERVICE"
  echo "[info] source timer:   $SRC_TIMER"
  echo "[info] destination dir: $DEST_DIR"
  echo "[info] to install, run with --apply"
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "[dry-run] mkdir -p $DEST_DIR"
    echo "[dry-run] install -m 644 $GENERATED_SERVICE $DEST_SERVICE"
    echo "[dry-run] install -m 644 $SRC_TIMER $DEST_TIMER"
    echo "[dry-run] systemctl --user daemon-reload"
    echo "[dry-run] systemctl --user enable --now private-state-integrity.timer"
    echo "[dry-run] systemctl --user list-timers private-state-integrity.timer"
  fi
  exit 0
fi

# The actual install is user-scoped, so it does not require sudo.
mkdir -p "$DEST_DIR"
install -m 644 "$GENERATED_SERVICE" "$DEST_SERVICE"
install -m 644 "$SRC_TIMER" "$DEST_TIMER"

systemctl --user daemon-reload
systemctl --user enable --now private-state-integrity.timer
systemctl --user list-timers private-state-integrity.timer

echo "Installed user timer: private-state-integrity.timer"
