#!/usr/bin/env bash
#
# Bootstrap this Neovim configuration onto the current machine.
# General use:
# - Install the package-level dependencies needed by this config.
# - Backup any existing ~/.config/nvim directory.
# - Sync this repo directory into place and run initial plugin/tool setup headlessly.
#
# Environment assumptions:
# - Assumes an Arch-family system with paru available.
# - Assumes headless nvim can run after package installation completes.
#
set -euo pipefail

# This bootstrap path is intentionally paru-based; fail early on other systems.
if ! command -v paru >/dev/null 2>&1; then
  echo "paru not found. Install paru first, then re-run this script." >&2
  exit 1
fi

# System dependencies for Neovim itself plus language/tooling providers used by plugins.
packages=(
  neovim
  git
  curl
  wget
  unzip
  rsync
  ripgrep
  fd
  nodejs
  npm
  python
  python-pynvim
  lua
  lua51
  luarocks
  ruby
  rubygems
  jdk-openjdk
  clang
  base-devel
  rust
  tree-sitter-cli-git
)

# Install or update the base toolchain non-interactively.
paru -Syyuu --needed --noconfirm "${packages[@]}"

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_src="$script_dir"
config_dest="$HOME/.config/nvim"

# Preserve any existing Neovim config before replacing it.
if [ -d "$config_dest" ]; then
  backup="${config_dest}.bak.$(date +%Y%m%d%H%M%S)"
  cp -a "$config_dest" "$backup"
fi

# Mirror the tracked config into the live Neovim config location.
mkdir -p "$config_dest"
rsync -a --delete \
  --exclude ".git" \
  --exclude ".github" \
  "$config_src"/ "$config_dest"/

# Prime plugins and Mason-managed tools in one headless run so the config is usable immediately.
nvim --headless \
  "+Lazy sync" \
  "+MasonInstall clangd html jdtls lua_ls ruby_lsp pyright rust_analyzer eslint ts_ls stylua prettier eslint_d black ruff" \
  "+qa"

echo "Done."
