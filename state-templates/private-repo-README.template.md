# Private State Repository

> Sensitive repository. Do not mirror this repository publicly.

## Purpose

This repository stores migration-critical private state that is intentionally excluded from the public dotfiles repository.

## Required Bootstrap Flow (SSH)

1. Install prerequisites on fresh machine:

```bash
sudo pacman -Syu git openssh base-devel gnupg
```

2. Generate host-specific SSH key and register it in your git host.
3. Verify SSH access to this repo.
4. Clone this repo to canonical private-state path.
5. Install paru.
6. Run restore packages-first; apply firewall in a separate explicit step.

## Canonical Path

`/run/media/brandon/EEB0F0D1B0F0A0EF/Classes/CEG2410/private-state`

## Directory Layout

- `meta/`
- `hosts/<hostname>/packages/`
- `hosts/<hostname>/firewall/`
- `hosts/<hostname>/services/`
- `hosts/<hostname>/snapshots/`
- `encrypted/ssh-key-backups/`
- `encrypted/secrets-backups/`

## Encryption and Recovery

### Encryption tool
- Preferred: `gpg --symmetric`.

### Example (gpg symmetric)

```bash
gpg --symmetric --cipher-algo AES256 \
	--output encrypted/ssh-key-backups/id_ed25519_private_state.gpg \
	~/.ssh/id_ed25519_private_state
```

### Example recovery (gpg symmetric)

```bash
gpg --decrypt --output ~/.ssh/id_ed25519_private_state \
	encrypted/ssh-key-backups/id_ed25519_private_state.gpg
chmod 600 ~/.ssh/id_ed25519_private_state
```

## Key Rotation

- Use machine-labeled keys (`<hostname>-private-state`).
- Revoke/remove old keys when device is retired.
- Update this document when key policy changes.

## Restore Order

1. Packages only
2. Validate network/services
3. Firewall apply (explicit/opt-in)
4. Verification and snapshot
