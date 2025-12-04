#!/usr/bin/env bash
set -euo pipefail

INSTALL_PATH="/usr/local/bin/pyshell"

echo "[*] Installing PyShell..."

# -----------------------------
# 1. Check for python3
# -----------------------------
if ! command -v python3 >/dev/null 2>&1; then
    echo "[!] python3 is required. Install using: sudo apt install python3" >&2
    exit 1
fi

# -----------------------------
# 2. Ensure pyshell.py exists
# -----------------------------
if [ ! -f pyshell.py ]; then
    echo "[!] pyshell.py not found. Run this script from the project root." >&2
    exit 1
fi

# -----------------------------
# 3. Install main executable
# -----------------------------
echo "[*] Copying pyshell.py to /usr/local/bin..."
sudo cp pyshell.py "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"
echo "[✓] Installed PyShell engine → $INSTALL_PATH"

# -----------------------------
# 4. Install Zsh plugin
# -----------------------------
echo "[*] Installing PyShell zsh support..."

mkdir -p "$HOME/.zsh_plugins"
cp ./zsh/pyshell.zsh "$HOME/.zsh_plugins/pyshell.zsh"

# Add to .zshrc if missing
if ! grep -q "source ~/.zsh_plugins/pyshell.zsh" "$HOME/.zshrc" 2>/dev/null; then
    echo "source ~/.zsh_plugins/pyshell.zsh" >> "$HOME/.zshrc"
    echo "[✓] Added PyShell plugin to .zshrc"
else
    echo "[✓] PyShell plugin already exists in .zshrc"
fi

echo
echo "[✓] Installation complete!"
echo "Restart terminal or run: source ~/.zshrc"
