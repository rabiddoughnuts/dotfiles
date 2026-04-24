#!/usr/bin/env bash
#
# Install tracked shell-related homefiles into their real system locations.
# General use:
# - Copy the Fish config files in this repo into $HOME and selected /usr paths.
# - Create timestamped backups before replacing existing files.
# - Use --dry-run first to preview both user-space and sudo-protected writes.
#
# Environment assumptions:
# - Assumes bash plus standard coreutils.
# - Assumes Fish is the target shell.
# - Assumes CachyOS-style Fish config files live under /usr/share/cachyos-fish-config/.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

usage() {
  cat <<'EOF'
Usage: ./install-homefiles.sh [--dry-run]

Installs shell-related config files from this homefiles directory into their
real target paths on the current machine.

Options:
  --dry-run   Show what would be copied without making changes.
  -h, --help  Show this help message.
EOF
}

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
elif [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
elif [[ $# -gt 0 ]]; then
  echo "Unknown option: $1" >&2
  usage
  exit 1
fi

copy_with_backup() {
  local src="$1"
  local dest="$2"

  # Skip optional files cleanly so one missing source does not abort the full install pass.
  if [[ ! -f "$src" ]]; then
    echo "[skip] source missing: $src"
    return 0
  fi

  local dest_dir
  dest_dir="$(dirname "$dest")"

  # Writes under /usr require sudo and use sudo for both the backup and the copy.
  if [[ "$dest" == /usr/* ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[dry-run] sudo mkdir -p $dest_dir"
      if [[ -f "$dest" ]]; then
        echo "[dry-run] sudo cp -f $dest $dest.bak.$TIMESTAMP"
      fi
      echo "[dry-run] sudo cp -f $src $dest"
      return 0
    fi

    sudo mkdir -p "$dest_dir"
    if [[ -f "$dest" ]]; then
      sudo cp -f "$dest" "$dest.bak.$TIMESTAMP"
      echo "[backup] $dest.bak.$TIMESTAMP"
    fi
    sudo cp -f "$src" "$dest"
    echo "[copied] $src -> $dest"
  else
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[dry-run] mkdir -p $dest_dir"
      if [[ -f "$dest" ]]; then
        echo "[dry-run] cp -f $dest $dest.bak.$TIMESTAMP"
      fi
      echo "[dry-run] cp -f $src $dest"
      return 0
    fi

    mkdir -p "$dest_dir"
    if [[ -f "$dest" ]]; then
      cp -f "$dest" "$dest.bak.$TIMESTAMP"
      echo "[backup] $dest.bak.$TIMESTAMP"
    fi
    cp -f "$src" "$dest"
    echo "[copied] $src -> $dest"
  fi
}

echo "Installing homefiles from: $SCRIPT_DIR"

# Install both user-scoped Fish config and the system-level CachyOS overrides.
copy_with_backup "$SCRIPT_DIR/.config/fish/config.fish" "$HOME/.config/fish/config.fish"
copy_with_backup "$SCRIPT_DIR/.config/fish/conf.d/private-state-ssh-agent.fish" "$HOME/.config/fish/conf.d/private-state-ssh-agent.fish"
copy_with_backup "$SCRIPT_DIR/usr/share/cachyos-fish-config/cachyos-config.fish" "/usr/share/cachyos-fish-config/cachyos-config.fish"
copy_with_backup "$SCRIPT_DIR/usr/share/cachyos-fish-config/conf.d/done.fish" "/usr/share/cachyos-fish-config/conf.d/done.fish"

echo "Done. Either run: source ~/.config/fish/config.fish, or log out and back in for it to take effect."
