# Homefiles

This directory contains shell-related dotfiles and an installer that copies them into their real system locations.

See the repository overview in [../README.md](../README.md).

## Contents

- `.config/fish/config.fish`: main Fish shell config.
- `.config/fish/conf.d/private-state-ssh-agent.fish`: helper for loading a dedicated SSH key for private-state operations.
- `usr/share/cachyos-fish-config/cachyos-config.fish`: CachyOS Fish config override.
- `usr/share/cachyos-fish-config/conf.d/done.fish`: CachyOS `done.fish` override.
- `install-homefiles.sh`: installer with backup support.

## Common Commands

Dry run:

```bash
./homefiles/install-homefiles.sh --dry-run
```

Apply changes:

```bash
./homefiles/install-homefiles.sh
```

The installer automatically creates timestamped backups before replacing existing files.
