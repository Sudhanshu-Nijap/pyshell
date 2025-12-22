#!/usr/bin/env bash

# Fix Windows CRLF line endings
sed -i 's/\r$//' "$0" 2>/dev/null || true

echo "[+] Uninstalling PyShell..."

BIN_PATH="/usr/local/bin/pyshell"
SHARE_DIR="/usr/local/share/pyshell"
CONFIG_DIR="$HOME/.config/pyshell"

# Remove binary
sudo rm -f "$BIN_PATH" 2>/dev/null || true

# Remove system folder (if exists)
sudo rm -rf "$SHARE_DIR" 2>/dev/null || true

# Remove user config
rm -rf "$CONFIG_DIR" 2>/dev/null || true

# Verify
if [ -f "$BIN_PATH" ] || [ -d "$SHARE_DIR" ] || [ -d "$CONFIG_DIR" ]; then
    echo "[i] Some PyShell files still exist (permission issue)"
else
    echo "[✓] PyShell completely removed"
fi

exit 0
