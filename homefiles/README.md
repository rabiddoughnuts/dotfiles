# Homefiles

This directory contains tracked shell configuration files and the installer that places them into their real locations on the current machine. In practice, it manages a Fish-based shell setup made of user-level config under `~/.config/fish` plus a couple of system-level CachyOS overrides under `/usr/share/cachyos-fish-config`.

See the repository overview in [../README.md](../README.md).

## What It Does

The `homefiles/` tree provides:

- A main Fish config layered on top of CachyOS defaults.
- An interactive `ssh-agent` helper for the private-state SSH key.
- A system-level CachyOS Fish config override with PATH setup, helper functions, and aliases.
- A vendored `done.fish` notification helper override.
- A bash installer that copies these files into place and creates timestamped backups first.

## Files

- `install-homefiles.sh`: Installs the tracked homefiles into `$HOME` and selected `/usr` paths with backup support.
- `.config/fish/config.fish`: Main user Fish config for greeting behavior, helpers, environment variables, and aliases.
- `.config/fish/conf.d/private-state-ssh-agent.fish`: Auto-load helper for a dedicated private-state SSH key.
- `usr/share/cachyos-fish-config/cachyos-config.fish`: System-level CachyOS Fish override used as the base layer for this machine.
- `usr/share/cachyos-fish-config/conf.d/done.fish`: Vendored notification helper sourced by the CachyOS Fish config.

## How It Works

1. `install-homefiles.sh` resolves its own directory and a timestamp for backups.
2. Each tracked file is copied into its real target path.
3. Existing destination files are backed up as `*.bak.<timestamp>` before replacement.
4. Writes under `/usr` use `sudo`; writes under `$HOME` do not.
5. After installation, Fish reads the system-level CachyOS config first and then the user-level Fish config.

## Usage

Preview the file operations first:

```bash
./homefiles/install-homefiles.sh --dry-run
```

Apply the changes:

```bash
./homefiles/install-homefiles.sh
```

Reload the current Fish config after installation:

```bash
source ~/.config/fish/config.fish
```

## Environment Assumptions

- Assumes `bash` for the installer and `fish` for the installed shell configuration.
- Assumes Fish is actually installed on the machine.
- Assumes a CachyOS-style layout under `/usr/share/cachyos-fish-config/`.
- Several aliases and helpers assume an Arch/CachyOS userland and local tools such as `pacman`, `paru`, `eza`, `fastfetch`, `singularity`, `gpg`, and `zoxide`.
- The private-state SSH helper assumes the key lives at `~/.ssh/id_ed25519_private_state`.

## Constraints And Caveats

- Installing the system-level files requires `sudo`.
- `config.fish` contains machine-specific paths such as `/home/brandon/containers/`, `/home/brandon/bin/...`, and an external package list path under `/run/media/...`.
- The CachyOS override files are intended for a distro-specific location and are not portable as-is to non-CachyOS Fish setups.
- `done.fish` is vendored third-party code, so edits there should stay minimal and preserve upstream behavior unless there is a strong reason to diverge.
