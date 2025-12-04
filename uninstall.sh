#!/usr/bin/env bash
set -euo pipefail

echo "[+] Uninstalling pyshell..."

rm -f /usr/local/bin/pyshell

SHELL_RC="$HOME/.zshrc"
[ -f "$HOME/.bashrc" ] && SHELL_RC="$HOME/.bashrc"

sed -i '/# >>> pyshell helper >>>/,/# <<< pyshell helper <<</d' "$SHELL_RC"

echo "[✔] PyShell removed."
