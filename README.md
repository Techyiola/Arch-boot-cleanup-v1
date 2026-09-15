# Arch Boot Cleanup v1

Runs automatic cleanup on boot for Arch Linux. Two `systemd` oneshot services clear the pacman package cache, remove orphaned packages, and wipe user caches before you log in.

## What it does

| Service | Action |
| --- | --- |
| `boot-clean-pacman.service` | Empties the pacman package cache (`paccache -rk0`) and removes all orphaned packages (`pacman -Rns`) |
| `boot-clean-user.service` | Deletes `~/.cache` contents and runs `uv clean cache --force` for the user |

Both units run right after local filesystems are mounted and before `systemd-user-sessions.service`, so cleanup happens every boot before you reach your desktop session.

> **Warning:** `paccache -rk0` deletes **all** cached package versions, not just old ones. `pacman -Rns` removes orphaned packages and their dependencies/config without confirmation. Run these carefully.

## Requirements

- Arch Linux (or an Arch-based distro using `pacman`)
- `paccache` (part of the `pacman-contrib` package)
- `uv` (only required for the user-cache service)

## Install

```bash
git clone https://github.com/Techyiola/Arch-boot-cleanup-v1.git
cd Arch-boot-cleanup-v1
sudo ./install.sh
```

The installer copies both unit files to `/etc/systemd/system`, reloads systemd, and enables the services to run at boot.

## Test

The installer enables the services, but you can start them immediately to verify:

```bash
sudo systemctl start boot-clean-pacman.service
sudo systemctl start boot-clean-user.service
```

Check their status with:

```bash
systemctl status boot-clean-pacman.service boot-clean-user.service
```

## Uninstall

```bash
sudo systemctl disable --now boot-clean-pacman.service boot-clean-user.service
sudo rm /etc/systemd/system/boot-clean-pacman.service /etc/systemd/system/boot-clean-user.service
sudo systemctl daemon-reload
```

## Customization

- **Orphans only, keep cache:** change `paccache -rk0` to `paccache -rk2` to keep the two most recent versions of each package in the cache instead of deleting everything.
- **Different user:** `boot-clean-user.service` hard-codes the `techyiola` user. Edit the `User=`, `Group=`, and cache paths in that unit to target your own account.

## License

This project is provided as-is. See the [repository](https://github.com/Techyiola/Arch-boot-cleanup-v1) for the latest version.