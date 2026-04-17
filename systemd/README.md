# Systemd Units

This directory contains systemd unit templates related to private-state maintenance.

See the repository overview in [../README.md](../README.md).

## Contents

- `private-state-integrity.service`: service template for integrity checks.
- `private-state-integrity.generated.service`: generated service with rendered absolute script path.
- `private-state-integrity.timer`: timer template to run integrity checks on a schedule.

The generated service is host/path specific and is re-rendered by the installer.

## Common Commands

Use the installer in scripts to render and install these units safely:

```bash
./scripts/install-private-state-integrity-timer.sh --dry-run
./scripts/install-private-state-integrity-timer.sh --apply
```
