# Hooks

This directory contains hook templates used by setup scripts.

See the repository overview in [../README.md](../README.md).

## Contents

- `pacman/95-private-state-capture.hook.template`: template used to generate a host-specific pacman post-transaction capture hook.
- `pacman/95-private-state-capture.hook`: generated hook with the rendered absolute capture-script path.

The generated hook is host/path specific and should be regenerated if this repo moves.

## Common Commands

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
