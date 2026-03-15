# Scripts

This directory contains operational scripts for private-state sync, integrity checks, installation helpers, and encrypted backups.

See the repository overview in [../README.md](../README.md).

## Core Operations

- `sync-private-state.sh`: capture host state, commit changes in private-state, optionally push.
- `private-state-maintenance.sh`: wrapper workflow for capture, integrity check, and sync.
- `private-state-integrity-check.sh`: validates expected private-state structure and key files.
- `smoke-test-private-state.sh`: lightweight end-to-end verification.

## Install Helpers

- `install-git-hooks.sh`: installs local repository hooks.
- `install-pacman-private-state-hook.sh`: installs the pacman hook generated from template files.
- `install-private-state-integrity-timer.sh`: installs/updates and enables user systemd timer units.
- `install-fish-private-state-agent.sh`: installs Fish SSH-agent helper config.
- `check-public-commit-safety.sh`: checks for likely private/sensitive artifacts before committing.

## Sensitive Backup Helpers

- `backup-sensitive-state.sh`: creates a GPG-encrypted archive of sensitive state.
- `restore-sensitive-state.sh`: decrypts and restores from an encrypted backup archive.

## Common Commands

Dry-run maintenance:

```bash
./scripts/private-state-maintenance.sh --dry-run
```

Capture and sync private-state with push:

```bash
./scripts/sync-private-state.sh --push --message "Update host state"
```

Run integrity checks:

```bash
./scripts/private-state-integrity-check.sh
./scripts/smoke-test-private-state.sh
```
