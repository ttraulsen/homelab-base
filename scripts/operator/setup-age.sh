#!/usr/bin/env bash
set -euo pipefail

AGE_DIR="/etc/age"
AGE_KEY_FILE="${AGE_DIR}/age.key"
AGE_PUB_FILE="${AGE_DIR}/age.pub"

echo "[age] setting up age key infrastructure"

# 1. age installieren (falls nicht vorhanden)
if ! command -v age >/dev/null 2>&1; then
  echo "[age] installing age"
  sudo apt update
  sudo apt install -y age
else
  echo "[age] age already installed"
fi

# 2. Verzeichnis anlegen
if [ ! -d "$AGE_DIR" ]; then
  echo "[age] creating $AGE_DIR"
  sudo mkdir -p "$AGE_DIR"
  sudo chmod 700 "$AGE_DIR"
fi

# 3. Key erzeugen (nur wenn nicht vorhanden)
if [ ! -f "$AGE_KEY_FILE" ]; then
  echo "[age] generating new age key"
  sudo age-keygen -o "$AGE_KEY_FILE"
  sudo chmod 600 "$AGE_KEY_FILE"
else
  echo "[age] age key already exists, skipping generation"
fi

# 4. Public Key extrahieren
if [ ! -f "$AGE_PUB_FILE" ]; then
  echo "[age] extracting public key"
  sudo grep -E "^# public key:" "$AGE_KEY_FILE" \
    | sed 's/^# public key: //' \
    | sudo tee "$AGE_PUB_FILE" > /dev/null
  sudo chmod 644 "$AGE_PUB_FILE"
fi

echo "[age] setup complete"
echo "[age] public key:"
sudo cat "$AGE_PUB_FILE"
