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

    PIPE_FILE="$PIPE_DIR/in.$$"
    mkfifo "$PIPE_FILE"

    {
        if [ $# -eq 0 ]; then
            cat -
        else
            printf "%s\n" "$*"
        fi
    } > "$PIPE_FILE" &

    python3 /usr/local/bin/pyshell "$PIPE_FILE"
    rm -f "$PIPE_FILE"
}
# <<< pyshell helper <<<
EOF
    echo "[+] Added helper to $SHELL_RC"
else
    echo "[i] Helper already installed in $SHELL_RC"
fi

echo "[✔] PyShell installed successfully."
