# Restore

This directory contains the public-side restore logic for rebuilding a machine from previously captured private-state data. It reads host-scoped package and firewall snapshots, selects the current host by hostname, and replays the restore steps that make sense for the tools available on that system.

See the repository overview in [../README.md](../README.md).

## What It Does

`restore-system.sh` can restore:

- Explicit `pacman` packages.
- Explicit AUR packages through `paru`.
- User Flatpak apps from the `flathub` remote.
- Firewall rules from saved `iptables` and `nft` exports when firewall application is explicitly requested.

Input defaults to `../private-state`, under:

```text
hosts/<hostname>/
```

The script restores packages by default. Firewall rules are intentionally not applied unless you opt in with `--apply-firewall` or `--firewall-only`.

## Files

- `restore-system.sh`: Main restore entrypoint for host package lists and optional firewall application.

## How It Works

1. Resolves the repo root and the private-state source path.
2. Detects the current hostname and selects the matching host directory.
3. Fails early if there is no captured state for the current host.
4. In `--dry-run`, prints the commands it would execute.
5. Restores `pacman`, AUR, and Flatpak inventories when the corresponding snapshot files exist.
6. Applies firewall exports only when explicitly requested.

## Usage

Preview the restore without making changes:

```bash
./restore/restore-system.sh --dry-run
```

Restore packages only:

```bash
./restore/restore-system.sh --packages-only
```

Restore firewall rules only:

```bash
./restore/restore-system.sh --firewall-only
```

Restore packages and also apply firewall rules:

```bash
./restore/restore-system.sh --apply-firewall
```

Read from a non-default private-state location:

```bash
PRIVATE_STATE_ROOT=/path/to/private-state ./restore/restore-system.sh --dry-run
```

## Environment Assumptions

- Assumes `bash`.
- Package restore is Arch-oriented because it uses `pacman` and expects `paru` for AUR restores.
- Flatpak restore expects `flatpak` and installs from the `flathub` remote.
- Firewall restore expects `iptables-restore` and/or `nft` when firewall snapshots are present.
- Package and firewall application may require `sudo` authentication.
- The default source layout assumes a sibling private repository at `../private-state`.

## Constraints And Caveats

- Restore is hostname-scoped; if the current hostname does not match a captured directory, the script exits.
- `--packages-only` and `--firewall-only` are mutually exclusive.
- AUR restore does not currently check whether `paru` exists before running it, so systems without `paru` need that tool installed first or need manual intervention.
- Applying saved firewall rules on a live system can disrupt networking, which is why firewall restore is opt-in.
