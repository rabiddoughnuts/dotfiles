# Neovim Configuration

This directory contains the full Neovim setup used by this repository. It includes the bootstrap script that installs the surrounding toolchain, the runtime entrypoint, the plugin manager setup, and plugin specs grouped by responsibility.

See the repository overview in [../README.md](../README.md).

## What It Does

This setup provides:

- `lazy.nvim`-managed plugins.
- Mason-managed LSP servers and external formatting/linting tools.
- Completion through `nvim-cmp`, `LuaSnip`, and Copilot integration.
- Treesitter, Telescope, Neo-tree, Gitsigns, Comment, autopairs, surround, and DAP support.
- A gruvbox-material themed UI with bufferline and indentation guides.

## Files

- `bootstrap.sh`: Installs package dependencies, syncs this directory to `~/.config/nvim`, and primes plugins/tools.
- `init.lua`: Main Neovim entrypoint for providers, basic options, and config module loading.
- `lazy-lock.json`: Plugin version lockfile used by `lazy.nvim`.
- `lua/config/`: Small runtime config modules for plugin manager setup and tool configuration.
- `lua/plugins/`: Plugin specs grouped into `core`, `ui`, `completion`, `editing`, `git`, `ai`, and `dap`.
- `lua/jsregexp.lua`: Compatibility shim for the `jsregexp` native module.

## How It Works

1. `bootstrap.sh` installs the external packages this config depends on.
2. It backs up any existing `~/.config/nvim` and copies this directory into place.
3. `init.lua` sets providers/options, then loads `config.lazy`.
4. `config.lazy` bootstraps `lazy.nvim` and imports every plugin spec from `lua/plugins/`.
5. The config modules wire up Mason, formatting, linting, DAP, and snippets around that plugin set.

## Usage

Bootstrap the full config on an Arch-style machine:

```bash
./nvim/bootstrap.sh
```

If you only want to inspect the live config after installation:

```bash
nvim
```

If you only want to sync the files manually:

```bash
mkdir -p ~/.config
cp -a nvim ~/.config/nvim
```

## Environment Assumptions

- Assumes Neovim is being installed on an Arch-family system with `paru`.
- Assumes package names such as `tree-sitter-cli-git`, `python-pynvim`, and `jdk-openjdk` are valid on the target system.
- Assumes the Node and Python provider paths in `init.lua` match the local system (`/usr/lib/node_modules/neovim/bin/cli.js` and `/usr/bin/python3`).
- Assumes Mason can install the requested LSP servers and tools once Neovim is running.
- Assumes the user wants this config at `~/.config/nvim`.

## Constraints And Caveats

- `bootstrap.sh` is not distro-agnostic; it is tightly coupled to `paru` and Arch package names.
- LSP setup currently exists in two places: `lua/config/lsp.lua` and the active config block inside `lua/plugins/core.lua`; `init.lua` currently uses the plugin-spec path.
- `lazy-lock.json` is generated lock data and is not hand-documented like the runtime files.
