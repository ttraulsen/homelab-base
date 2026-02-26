#!/usr/bin/env bash
set -euo pipefail

SOPS_CONFIG_DIR="/etc/sops"
SOPS_CONFIG_FILE="${SOPS_CONFIG_DIR}/sops.yaml"
AGE_KEY_FILE="/etc/age/age.key"
AGE_PUB_FILE="/etc/age/age.pub"

echo "[sops] setting up sops configuration"

# 1. sops installieren
if ! command -v sops >/dev/null 2>&1; then
  echo "[sops] installing sops"

  LATEST_RELEASE=$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | grep '"browser_download_url":' | grep 'amd64.deb' | grep -vE '(\.pem|\.sig)' | grep -o 'https://[^"]*') 
  LATEST_FILE=$(basename "$LATEST_RELEASE")

  # Download the binary
  curl -LO $LATEST_RELEASE

  # Install the binary
  sudo dpkg -i $LATEST_FILE
else
  echo "[sops] sops already installed"
fi

# 2. Vorbedingungen prüfen
if [ ! -f "$AGE_KEY_FILE" ] || [ ! -f "$AGE_PUB_FILE" ]; then
  echo "[sops] ERROR: age keys not found. Run setup-age first."
  exit 1
fi

AGE_RECIPIENT=$(sudo cat "$AGE_PUB_FILE")

# 3. Config-Verzeichnis
if [ ! -d "$SOPS_CONFIG_DIR" ]; then
  sudo mkdir -p "$SOPS_CONFIG_DIR"
  sudo chmod 755 "$SOPS_CONFIG_DIR"
fi

# 4. sops.yaml anlegen (idempotent)
if [ ! -f "$SOPS_CONFIG_FILE" ]; then
  echo "[sops] creating sops.yaml"
  sudo tee "$SOPS_CONFIG_FILE" > /dev/null <<EOF
creation_rules:
  - encrypted_regex: '^(data|stringData)$'
    age: [$AGE_RECIPIENT]
EOF
else
  echo "[sops] sops.yaml already exists, skipping"
fi

echo "[sops] setup complete"
echo "[sops] config: $SOPS_CONFIG_FILE"
