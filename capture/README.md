# Capture

This directory contains scripts that collect host state and write it to a sibling `private-state` repository.

See the repository overview in [../README.md](../README.md).

## Contents

- `capture-system-state.sh`: captures package lists, firewall rules, metadata, and optional Flatpak state.

## Common Commands

Dry run:

```bash
./capture/capture-system-state.sh --dry-run
```

Force capture even if debounce window is active:

```bash
./capture/capture-system-state.sh --force
```

By default, output is written to `../private-state`. You can override that with `PRIVATE_STATE_ROOT`.
