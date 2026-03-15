# Dotfiles Repository

This repository contains my local environment setup, centered on Neovim configuration, shell homefiles, and private-state capture/restore tooling.

## Start Here

1. Review directory-specific docs below.
2. Bootstrap Neovim if needed:

```bash
./nvim/bootstrap.sh
```

3. Install shell homefiles:

```bash
./homefiles/install-homefiles.sh --dry-run
./homefiles/install-homefiles.sh
```

4. Validate private-state setup:

```bash
./scripts/private-state-integrity-check.sh
./scripts/smoke-test-private-state.sh
```

## Directory Guide

- [nvim](nvim/README.md): Neovim config and bootstrap script.
- [homefiles](homefiles/README.md): Fish and shell-related files mirrored by real install path.
- [capture](capture/README.md): Host-state capture scripts for private-state.
- [restore](restore/README.md): Host-state restore scripts from private-state.
- [hooks](hooks/README.md): Hook templates used by install helpers (for example pacman capture hook).
- [scripts](scripts/README.md): Operational helpers (sync, maintenance, installers, encrypted backups).
- [state-templates](state-templates/README.md): Templates and notes for private-state bootstrap.
- [systemd](systemd/README.md): Service and timer templates used by install scripts.

## Notes

- Recovery/re-setup runbook lives in the sibling private repository (`private-state`) and is intentionally not duplicated here.
- Most scripts default to using `../private-state` unless `PRIVATE_STATE_ROOT` is explicitly set.
