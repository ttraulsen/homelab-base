#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/packages.conf"

echo "Updating package lists"
apt-get update

echo "Removing unwanted packages"
apt-get purge -y "${REMOVE_PACKAGES[@]}" || true

echo "Installing required packages"
apt-get install -y --no-install-recommends "${INSTALL_PACKAGES[@]}"

echo "Autoremove"
apt-get autoremove -y
