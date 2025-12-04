#!/usr/bin/env bash
set -euo pipefail

echo "[+] Starting PyShell uninstall..."

# ----------------------------------------
# 1. Remove main executable
# ----------------------------------------
if [ -f /usr/local/bin/pyshell ]; then
    sudo rm -f /usr/local/bin/pyshell
    echo "[✓] Removed /usr/local/bin/pyshell"
else
    echo "[i] /usr/local/bin/pyshell not found"
fi

# ----------------------------------------
# 2. Remove Zsh plugin
# ----------------------------------------
if [ -d "$HOME/.zsh_plugins" ] && [ -f "$HOME/.zsh_plugins/pyshell.zsh" ]; then
    rm -f "$HOME/.zsh_plugins/pyshell.zsh"
    echo "[✓] Removed ~/.zsh_plugins/pyshell.zsh"
else
    echo "[i] No plugin file found in ~/.zsh_plugins/"
fi

# ----------------------------------------
# 3. Remove source line from .zshrc / .bashrc
# ----------------------------------------
for SHELL_RC in "$HOME/.zshrc" "$HOME/.bashrc"; do
    if [ -f "$SHELL_RC" ]; then
        # Remove plugin source line
        sed -i '/source ~/.zsh_plugins\/pyshell.zsh/d' "$SHELL_RC"

        # Remove old helper block if present
        sed -i '/# >>> pyshell helper >>>/,/# <<< pyshell helper <<</d' "$SHELL_RC"

        echo "[✓] Cleaned $SHELL_RC"
    fi
done

# ----------------------------------------
# 4. Optional: Remove empty plugin folder
# ----------------------------------------
if [ -d "$HOME/.zsh_plugins" ] && [ -z "$(ls -A $HOME/.zsh_plugins)" ]; then
    rmdir "$HOME/.zsh_plugins"
    echo "[✓] Removed empty ~/.zsh_plugins folder"
fi

echo "[✔] PyShell fully uninstalled. Restart your terminal."
