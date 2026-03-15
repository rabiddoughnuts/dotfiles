# Neovim Configuration

This directory contains the full Neovim setup for this repository.

See the repository overview in [../README.md](../README.md).

## Contents

- `init.lua`: entrypoint that sets leaders/options and loads config modules.
- `bootstrap.sh`: installs system dependencies, syncs this folder to `~/.config/nvim`, and runs initial plugin/tool setup.
- `lazy-lock.json`: plugin lockfile.
- `lua/config/`: runtime configuration modules (lazy, mason, lint, conform, dap, snippets).
- `lua/plugins/`: plugin specs grouped by topic (core, UI, completion, editing, git, AI, DAP).

## Common Commands

Bootstrap this config:

```bash
./nvim/bootstrap.sh
```

This script installs required packages (via `paru`), backs up any existing `~/.config/nvim`, copies this configuration, and runs headless setup.

## Notes

If you only want to sync config files without full package install, copy this directory to `~/.config/nvim`.
