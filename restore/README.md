# Restore

This directory contains scripts that restore host state from a sibling `private-state` repository.

See the repository overview in [../README.md](../README.md).

## Contents

- `restore-system.sh`: restores package and firewall state for the current host, with optional Flatpak restore.

## Common Commands

Dry run:

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

Restore packages and apply firewall rules:

```bash
./restore/restore-system.sh --apply-firewall
```

By default, input is read from `../private-state`. You can override that with `PRIVATE_STATE_ROOT`.
