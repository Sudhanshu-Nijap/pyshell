#!/usr/bin/env bash

# Working

# 1. Prints: [+] Uninstalling PyShell (no-error mode)...
# 2. Sets the path where PyShell is installed: /usr/local/bin/pyshell
# 3. Tries to remove the file safely using sudo rm -f
#    Ignores errors (never fails)
# 4. Checks if the file still exists → prints success or warning
# 5. Exits safely

echo "[+] Uninstalling PyShell (no-error mode)..."  # Inform user

INSTALL_PATH="/usr/local/bin/pyshell"  # Path of installed PyShell

# Try to remove the PyShell executable
sudo rm -f "$INSTALL_PATH" 2>/dev/null || true
# - -f → force removal
# - 2>/dev/null → ignore errors
# - || true → never fail

# Verify removal
if [ -f "$INSTALL_PATH" ]; then
    echo "[i] PyShell still exists (permission issue)"  # Could not remove
else
    echo "[✓] PyShell removed or not present"  # Success
fi

exit 0  # End script
