#!/usr/bin/env bash
set -euo pipefail

echo "Running preflight checks"

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

command -v apt >/dev/null
command -v systemctl >/dev/null

echo "Preflight checks passed"
