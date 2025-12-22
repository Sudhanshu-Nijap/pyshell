#!/usr/bin/env bash

# Fix Windows CRLF line endings
sed -i 's/\r$//' "$0" 2>/dev/null || true

echo "[+] Installing PyShell..."

INSTALL_PATH="/usr/local/bin/pyshell"
SOURCE_FILE="pyshell.py"

# Ensure script runs from project root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 0

# Check source file
if [ ! -f "$SOURCE_FILE" ]; then
    echo "[!] pyshell.py not found (run install.sh from project folder)"
    exit 0
fi

# Copy file
sudo cp "$SOURCE_FILE" "$INSTALL_PATH" 2>/dev/null || true

# Fix CRLF
sudo sed -i 's/\r$//' "$INSTALL_PATH" 2>/dev/null || true

# Make executable
sudo chmod +x "$INSTALL_PATH" 2>/dev/null || true

# Verify
if command -v pyshell >/dev/null 2>&1; then
    echo "[✓] PyShell installed"
else
    echo "[i] Installation incomplete"
fi

exit 0
