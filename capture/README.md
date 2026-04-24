# Capture

This directory holds the public-side capture logic for the private-state workflow. Its job is to inspect the current machine, extract a few reproducible system inventories, and write them into a sibling `private-state` repository organized by hostname.

See the repository overview in [../README.md](../README.md).

## What It Does

`capture-system-state.sh` collects:

- Explicit `pacman` packages.
- Explicit AUR packages, preferring `paru` when available.
- User Flatpak app IDs when Flatpak is installed.
- Firewall exports from `iptables-save` and `nft` when those commands exist.
- Simple metadata describing the last successful capture.

Output defaults to `../private-state`, inside:

```text
hosts/<hostname>/
meta/
```

The script also maintains a debounce timestamp so repeated runs or hooks do not constantly rewrite the same state.

## Files

- `capture-system-state.sh`: Main capture entrypoint for package, firewall, and metadata exports.

## How It Works

1. Resolves the repo root and the target private-state path.
2. Detects the current hostname and builds a host-specific output directory.
3. Checks the debounce timer unless `--force` is used.
4. In `--dry-run`, prints planned work and exits without writing files.
5. Creates a simple lock file to avoid overlapping capture runs.
6. Writes package and firewall snapshots for the tools available on the current machine.
7. Updates capture metadata used for later inspection and debounce checks.

## Usage

Preview the actions without writing anything:

```bash
./capture/capture-system-state.sh --dry-run
```

Run a normal capture:

```bash
./capture/capture-system-state.sh
```

Bypass the debounce guard:

```bash
./capture/capture-system-state.sh --force
```

Write to a non-default private-state location:

```bash
PRIVATE_STATE_ROOT=/path/to/private-state ./capture/capture-system-state.sh
```

## Environment Assumptions

- Assumes `bash`.
- Package capture is Arch-oriented because it expects `pacman`, and optionally `paru`, for the primary inventories.
- Flatpak capture is optional and only runs when `flatpak` is installed.
- Firewall capture is best-effort and depends on `iptables-save` and/or `nft` being present.
- The default layout assumes a sibling private repository at `../private-state`.
- The script uses `/tmp/private-state-capture.lock` for a simple host-local lock file.

## Constraints And Caveats

- A stale lock file will block future captures until it is removed.
- Firewall exports may be empty or skipped on hosts where those commands are unavailable or require privileges the current user does not have.
- The script creates a `services/` directory in the host output tree even though it does not currently write service data there yet.
