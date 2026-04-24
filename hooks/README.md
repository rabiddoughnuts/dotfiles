# Hooks

This directory contains hook definitions used by installer scripts. In practice, it currently holds the pacman hook that triggers a post-transaction state capture, plus the template used to generate a path-specific copy for the current checkout.

See the repository overview in [../README.md](../README.md).

## What It Does

The pacman hook watches package install, upgrade, and removal transactions. After pacman completes, it calls `capture/capture-system-state.sh` so the private-state repository reflects the package-manager change.

## Files

- `pacman/95-private-state-capture.hook.template`: Template with a placeholder capture-script path.
- `pacman/95-private-state-capture.hook`: Generated hook with the absolute path for the current checkout.

## How It Works

1. `scripts/install-pacman-private-state-hook.sh` reads the template.
2. It replaces the placeholder path with the absolute path to `capture/capture-system-state.sh`.
3. The rendered hook is written into `hooks/pacman/95-private-state-capture.hook`.
4. With `--apply`, that rendered file is installed into `/etc/pacman.d/hooks/`.

## Usage

Generate hook from template:

```bash
./scripts/install-pacman-private-state-hook.sh
```

Preview install actions:

```bash
./scripts/install-pacman-private-state-hook.sh --dry-run --apply
```

Install system-wide (requires sudo):

```bash
./scripts/install-pacman-private-state-hook.sh --apply
```

## Environment Assumptions

- Assumes an Arch-family system using pacman hooks.
- Assumes `bash` is available because the hook depends on the capture script.
- Assumes this repository stays at a stable path, or the generated hook is regenerated after moves.

## Constraints And Caveats

- `95-private-state-capture.hook` is generated output, not a path-agnostic source file.
- The generated hook is checkout-specific, so copying it between machines or repo locations can break the `Exec` path.
- System-wide installation requires `sudo` because `/etc/pacman.d/hooks/` is root-owned.
