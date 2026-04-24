# Systemd Units

This directory contains the systemd service and timer files used to schedule private-state integrity checks. It includes both the path-agnostic source template and the generated service file that points at the current checkout.

See the repository overview in [../README.md](../README.md).

## What It Does

The units define a user-level `oneshot` service that runs `scripts/private-state-integrity-check.sh`, plus a daily timer that triggers that service with a small randomized delay.

## Files

- `private-state-integrity.service`: Template service file with a placeholder `ExecStart` path.
- `private-state-integrity.generated.service`: Generated service file with the real absolute path for the current checkout.
- `private-state-integrity.timer`: Timer file that schedules the integrity service daily.

## How It Works

1. `scripts/install-private-state-integrity-timer.sh` renders `private-state-integrity.service`.
2. The rendered service is written to `private-state-integrity.generated.service`.
3. With `--apply`, the generated service and timer are installed into `~/.config/systemd/user/`.
4. `systemctl --user enable --now private-state-integrity.timer` activates the schedule.

## Usage

Use the installer in scripts to render and install these units safely:

```bash
./scripts/install-private-state-integrity-timer.sh --dry-run
./scripts/install-private-state-integrity-timer.sh --apply
```

## Environment Assumptions

- Assumes a user systemd instance is available and `systemctl --user` works.
- Assumes the private-state repository lives at `%h/../private-state` unless the installed service is edited.
- Assumes the rendered `ExecStart` path remains valid for the current checkout.

## Constraints And Caveats

- `private-state-integrity.generated.service` is generated output and must be re-rendered if the repo moves.
- The service and timer are user-level units, not system-wide units.
- The timer only checks integrity; it does not run capture or sync on its own.
