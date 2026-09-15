#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

install -m 644 "$DIR/boot-clean-pacman.service" /etc/systemd/system/boot-clean-pacman.service
install -m 644 "$DIR/boot-clean-user.service"   /etc/systemd/system/boot-clean-user.service

systemctl daemon-reload
systemctl enable boot-clean-pacman.service boot-clean-user.service

echo "Installed and enabled. Test now with:"
echo "  sudo systemctl start boot-clean-pacman.service"
echo "  sudo systemctl start boot-clean-user.service"
