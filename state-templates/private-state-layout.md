# Private-State Layout Template

Use this structure in the sibling private repository (`../private-state`).

```text
private-state/
  meta/
    last-capture.epoch
    last-capture.json
  hosts/
    <hostname>/
      packages/
        pacman-explicit.txt
        aur-explicit.txt
        flatpak-explicit.txt
      firewall/
        iptables.rules
        nft.rules
      services/
  encrypted/
    ssh-key-backups/
    secrets-backups/
```

## Notes

- `flatpak-explicit.txt` is optional and appears only when `flatpak` is present.
- Firewall files may be absent when commands are unavailable or insufficient privileges are present.
- `meta/last-capture.*` is updated after successful captures.
