#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning up"

systemctl disable --now apt-daily.timer apt-daily-upgrade.timer || true
