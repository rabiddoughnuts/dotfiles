#!/usr/bin/env bash
#
# Restore host-scoped package and firewall state from a sibling private-state repo.
# General use:
# - Rebuild a machine from previously captured package and firewall inventories.
# - Default input comes from ../private-state unless PRIVATE_STATE_ROOT is set.
# - Package restore runs by default; firewall restore only runs when explicitly requested.
#
# What this script restores:
# - pacman packages from the host's explicit package snapshot.
# - AUR packages via paru when an AUR package list exists.
# - User Flatpak apps when a Flatpak snapshot exists.
# - iptables/nft rules only when the caller opts into firewall application.
#
set -euo pipefail

PACKAGES_ONLY=0
APPLY_FIREWALL=0
FIREWALL_ONLY=0
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./restore/restore-system.sh [--packages-only] [--apply-firewall] [--firewall-only] [--dry-run]

Restores host-scoped package and firewall state from sibling private-state.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --packages-only) PACKAGES_ONLY=1 ;;
    --apply-firewall) APPLY_FIREWALL=1 ;;
    --firewall-only) FIREWALL_ONLY=1 ;;
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

# These modes are mutually exclusive because one disables package work while the
# other explicitly requests package-only behavior.
if [[ $PACKAGES_ONLY -eq 1 && $FIREWALL_ONLY -eq 1 ]]; then
  echo "Conflicting options: --packages-only and --firewall-only" >&2
  exit 1
fi

# Resolve the matching host directory inside the private-state repository.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE_STATE_ROOT="${PRIVATE_STATE_ROOT:-$REPO_ROOT/../private-state}"
HOSTNAME_SAFE="$(cat /etc/hostname 2>/dev/null | head -n 1 | tr -d '[:space:]')"
if [[ -z "$HOSTNAME_SAFE" ]]; then
  HOSTNAME_SAFE="$(uname -n 2>/dev/null || echo unknown-host)"
fi
HOST_DIR="$PRIVATE_STATE_ROOT/hosts/$HOSTNAME_SAFE"
PKG_DIR="$HOST_DIR/packages"
FW_DIR="$HOST_DIR/firewall"

# Restore is host-specific, so fail early if there is no captured state for the
# current machine unless the caller only wants a dry-run path preview.
if [[ ! -d "$HOST_DIR" ]]; then
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "[dry-run] host state directory would be: $HOST_DIR"
  else
    echo "Host state directory missing: $HOST_DIR" >&2
    exit 1
  fi
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] using host directory: $HOST_DIR"
fi

# Package restore is the default path. Each section only runs when the matching
# captured package file exists, so partial inventories are tolerated.
if [[ $FIREWALL_ONLY -eq 0 ]]; then
  if [[ -f "$PKG_DIR/pacman-explicit.txt" ]]; then
    mapfile -t pacman_pkgs < "$PKG_DIR/pacman-explicit.txt"
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[dry-run] sudo pacman -S --needed --noconfirm <pacman package list>"
    else
      if [[ ${#pacman_pkgs[@]} -gt 0 ]]; then
        sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
      fi
    fi
  fi

  # AUR restore assumes paru is installed when an AUR package list is present.
  if [[ -f "$PKG_DIR/aur-explicit.txt" ]]; then
    mapfile -t aur_pkgs < "$PKG_DIR/aur-explicit.txt"
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[dry-run] paru -S --needed --noconfirm <AUR package list>"
    else
      if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
        paru -S --needed --noconfirm "${aur_pkgs[@]}"
      fi
    fi
  fi

  # Flatpak restore is optional and skipped gracefully when the runtime is absent.
  if [[ -f "$PKG_DIR/flatpak-explicit.txt" ]]; then
    mapfile -t flatpak_apps < "$PKG_DIR/flatpak-explicit.txt"
    if [[ ${#flatpak_apps[@]} -gt 0 ]]; then
      if [[ $DRY_RUN -eq 1 ]]; then
        echo "[dry-run] flatpak install --user -y flathub <flatpak app list>"
      else
        if command -v flatpak >/dev/null 2>&1; then
          flatpak install --user -y flathub "${flatpak_apps[@]}" || true
        else
          echo "flatpak not found; skipping flatpak restore." >&2
        fi
      fi
    fi
  fi
fi

# Firewall restore is intentionally opt-in because applying saved rules can
# disrupt connectivity on a live machine.
if [[ $PACKAGES_ONLY -eq 0 && ( $APPLY_FIREWALL -eq 1 || $FIREWALL_ONLY -eq 1 ) ]]; then
  if [[ -f "$FW_DIR/iptables.rules" ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[dry-run] sudo iptables-restore < $FW_DIR/iptables.rules"
    else
      sudo iptables-restore < "$FW_DIR/iptables.rules"
    fi
  fi

  if [[ -f "$FW_DIR/nft.rules" ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "[dry-run] sudo nft -f $FW_DIR/nft.rules"
    else
      sudo nft -f "$FW_DIR/nft.rules"
    fi
  fi
fi

echo "Restore complete."
