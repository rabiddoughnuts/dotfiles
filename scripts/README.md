# Scripts

This directory contains the operational glue around the private-state workflow. These scripts are the day-to-day entrypoints for capture follow-up, integrity validation, sync/commit automation, helper installs, and encrypted recovery backups.

See the repository overview in [../README.md](../README.md).

## What It Does

The directory breaks down into three groups:

- Core maintenance and validation scripts that operate on the sibling `private-state` repo.
- Install helpers that wire this public repo into Fish, Git, pacman, or user systemd.
- Encrypted backup helpers for recovering especially sensitive files such as the dedicated private-state SSH key.

Most scripts assume the companion private repository lives at `../private-state`, though nearly all of the repo-touching ones allow `PRIVATE_STATE_ROOT` to override that.

## Files

### Core Operations

- `private-state-maintenance.sh`: Runs capture, integrity check, and sync as one chain.
- `sync-private-state.sh`: Stages and commits private-state changes, with optional push.
- `private-state-integrity-check.sh`: Validates expected private-state structure and capture freshness.
- `smoke-test-private-state.sh`: Runs a safe smoke test across the major workflows.

### Install Helpers

- `install-git-hooks.sh`: Configures this repo to use the tracked `.githooks/` directory.
- `check-public-commit-safety.sh`: Blocks staged commits that look like private-state or secret material.
- `install-pacman-private-state-hook.sh`: Generates and optionally installs the pacman capture hook.
- `install-private-state-integrity-timer.sh`: Generates and installs a user-level systemd integrity timer.
- `install-fish-private-state-agent.sh`: Installs the Fish helper that auto-loads the private-state SSH key.

### Sensitive Backup Helpers

- `backup-sensitive-state.sh`: Creates a symmetric GPG backup of a sensitive key file.
- `restore-sensitive-state.sh`: Decrypts a stored backup into a local destination path.

## How It Works

1. `private-state-maintenance.sh` is the high-level wrapper for the normal workflow.
2. Capture writes host state into the private repo, then integrity validation checks the expected structure and metadata.
3. Sync stages and commits private-state changes, optionally pushing them.
4. Helper installers render templates or copy helper files into the system/user locations where the surrounding tooling expects them.
5. Sensitive backup helpers use GPG symmetric encryption plus a stable `latest` file for easier restore operations.

## Common Commands

Dry-run maintenance:

```bash
./scripts/private-state-maintenance.sh --dry-run
```

Sync private-state with push:

```bash
./scripts/sync-private-state.sh --push --message "Update host state"
```

Run integrity checks:

```bash
./scripts/private-state-integrity-check.sh
./scripts/smoke-test-private-state.sh
```

## Environment Assumptions

- Assumes `bash`.
- Most workflows assume a sibling git repository at `../private-state`.
- The package-management helper paths assume an Arch-style system when pacman hooks are involved.
- Some installers assume user systemd is available (`systemctl --user`) or that Fish is installed.
- GPG is required for encrypted backup and restore helpers.
- Git is required for sync, commit-safety checks, and hook installation.

## Constraints And Caveats

- Several scripts are intentionally wrappers around other repo scripts, so a failure in a lower-level command aborts the higher-level workflow.
- `install-pacman-private-state-hook.sh` writes the generated hook into the repo even without `--apply`, which is useful for inspection but does modify the working tree.
- `private-state-integrity-check.sh` treats stale capture metadata as a hard failure.
- The commit-safety hook only checks staged file paths against obvious patterns; it is a guardrail, not a full secret scanner.
