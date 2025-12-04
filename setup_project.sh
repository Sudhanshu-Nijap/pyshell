#!/usr/bin/env bash
set -euo pipefail

TARGET="/usr/local/bin/pyshell"

echo "[+] Installing pyshell..."

cp pyshell.py "$TARGET"
chmod +x "$TARGET"

# Add helper to shell config
SHELL_RC="$HOME/.zshrc"
[ -f "$HOME/.bashrc" ] && SHELL_RC="$HOME/.bashrc"

HELPER_TAG="# >>> pyshell helper >>>"

if ! grep -q "$HELPER_TAG" "$SHELL_RC"; then
    cat << 'EOF' >> "$SHELL_RC"

# >>> pyshell helper >>>
py() {
    PIPE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/pyshell"
    mkdir -p "$PIPE_DIR"
    chmod 700 "$PIPE_DIR"