#!/usr/bin/env bash

# Auto-fix Windows line endings
sed -i 's/\r$//' "$0" 2>/dev/null || true

echo "[+] Uninstalling PyShell (no-error mode)..."

INSTALL_PATH="/usr/local/bin/pyshell"

# Try to remove PyShell executable
sudo rm -f "$INSTALL_PATH" 2>/dev/null || true

# Verify removal
if [ -f "$INSTALL_PATH" ]; then
    echo "[i] PyShell still exists (permission issue)"
else
    echo "[✓] PyShell removed or not present"
fi

exit 0
