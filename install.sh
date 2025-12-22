#!/usr/bin/env bash

# Working

# 1. Prints: Installing PyShell (no-error mode)
# 2. Sets where PyShell will be installed (/usr/local/bin/pyshell)
# 3. Checks if the source file pyshell.py exists.
#    If not, it prints a warning and stops.
# 4. Copies pyshell.py to /usr/local/bin/pyshell
#    Ignores any errors (so it never fails).
# 5. Fixes CRLF line endings (Windows → Linux) using sed.
# 6. Makes the file executable (chmod +x)
# 7. Checks if the file exists in /usr/local/bin → prints success or failure.
# 8. Exits safely.

echo "[+] Installing PyShell (no-error mode)..."  # Inform user

INSTALL_PATH="/usr/local/bin/pyshell"  # Where PyShell will be installed
SOURCE_FILE="pyshell.py"               # Source Python file

# Check if the source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "[!] pyshell.py not found (skipping install)"
    exit 0  # Stop if file not found
fi

# Copy file to /usr/local/bin
sudo cp "$SOURCE_FILE" "$INSTALL_PATH" 2>/dev/null || true
# 2>/dev/null -> ignore errors
# || true -> never fail

# Fix Windows line endings (CRLF -> LF)
sudo sed -i 's/\r$//' "$INSTALL_PATH" 2>/dev/null || true

# Make file executable
sudo chmod +x "$INSTALL_PATH" 2>/dev/null || true

# Verify installation
if [ -f "$INSTALL_PATH" ]; then
    echo "[✓] PyShell installed"
else
    echo "[i] PyShell not installed (permission or sudo issue)"
fi

exit 0  # End script
