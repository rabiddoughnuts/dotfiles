# Linux Workstation and Private-State Automation

This repository contains the public, reusable half of my Linux workstation setup: Neovim configuration, Fish homefiles, package hooks, systemd units, and Bash tooling for capturing, restoring, validating, and backing up machine state.

The sensitive host data lives in a separate private repository and is intentionally not included here. This split lets the automation remain reviewable without publishing credentials, host inventories, or personal configuration state.

## Platform and Safety

- Primary platform: CachyOS/Arch Linux with Bash, Fish, pacman, systemd, and Neovim.
- The Neovim configuration is broadly portable; package hooks and system paths are Arch-oriented.
- Run installer and restore commands from a clone of this repository, not from an unreviewed pipe to a shell.
- Use `--dry-run` where offered. Installers create timestamped backups before replacing supported files.
- `scripts/check-public-commit-safety.sh` is a narrow staged-path guardrail, not a substitute for a full secret scanner.
- The default sibling path is `../private-state`; override it with `PRIVATE_STATE_ROOT` when needed.

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
- [sys-installs](sys-installs/README.md): System software installer scripts and assignment-ready documentation.

## Notes

- Recovery/re-setup runbook lives in the sibling private repository (`private-state`) and is intentionally not duplicated here.
- Most scripts default to using `../private-state` unless `PRIVATE_STATE_ROOT` is explicitly set.

## Validation

The shell scripts are syntax-checked with `bash -n`. The repository also includes:

```bash
./scripts/check-public-commit-safety.sh
./scripts/private-state-integrity-check.sh
./scripts/smoke-test-private-state.sh
```

The integrity and smoke tests require a configured private-state checkout and are not safe to treat as environment-independent unit tests.

## License

No reuse license has been selected. The repository is public for inspection and portfolio review; no permission to copy or redistribute the original scripts is granted by default. Third-party Neovim plugins retain their own licenses.
