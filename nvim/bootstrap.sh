#!/usr/bin/env bash
set -euo pipefail

if ! command -v paru >/dev/null 2>&1; then
  echo "paru not found. Install paru first, then re-run this script." >&2
  exit 1
fi

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

paru -Syyuu --needed --noconfirm "${packages[@]}"

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_src="$script_dir"
config_dest="$HOME/.config/nvim"

if [ -d "$config_dest" ]; then
  backup="${config_dest}.bak.$(date +%Y%m%d%H%M%S)"
  cp -a "$config_dest" "$backup"
fi

mkdir -p "$config_dest"
rsync -a --delete \
  --exclude ".git" \
  --exclude ".github" \
  "$config_src"/ "$config_dest"/

nvim --headless \
  "+Lazy sync" \
  "+MasonInstall clangd html jdtls lua_ls ruby_lsp pyright rust_analyzer eslint ts_ls stylua prettier eslint_d black ruff" \
  "+qa"

echo "Done."
