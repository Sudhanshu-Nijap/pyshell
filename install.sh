#!/usr/bin/env bash
set -euo pipefail

INSTALL_PATH="/usr/local/bin/pyshell"
HELPER_MARK="# pyshell safe helper start"

if ! command -v python3 >/dev/null 2>&1; then
    echo "Please install python3 first: sudo apt install python3" >&2
    exit 1
fi

if [ ! -f pyshell.py ]; then
    echo "pyshell.py not found in current directory. Run this script from project root." >&2
    exit 1
fi

sudo cp pyshell.py "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"
echo "Installed $INSTALL_PATH"

if ! grep -q "$HELPER_MARK" "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" <<'SHHELPER'

# pyshell safe helper start
# Safe pyshell helper function — explicit invocation only.
py() {
    PIPE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}
    mkdir -p "$PIPE_DIR"
    INPUT_PIPE="$PIPE_DIR/.pyshell_in.$$"
    ARGS_FILE="$PIPE_DIR/.pyshell_args.$$"
    cleanup() { rm -f "$INPUT_PIPE" "$ARGS_FILE"; }
    trap cleanup EXIT INT TERM
    rm -f "$INPUT_PIPE" "$ARGS_FILE"
    mkfifo "$INPUT_PIPE"
    if [ "$#" -gt 1 ]; then
        : > "$ARGS_FILE"
        shift
        for arg in "$@"; do
            printf '%s\n' "$arg" >> "$ARGS_FILE"
        done
    fi
    printf '%s\n' "$1" > "$INPUT_PIPE" &
    if command -v python3 >/dev/null 2>&1; then
        PYTHON=python3
    elif command -v python >/dev/null 2>&1; then
        PYTHON=python
    else
        echo "Install python3 first (sudo apt install python3)."
        cleanup
        return 127
    fi
    if [ -x /usr/local/bin/pyshell ]; then
        if [ -e "$ARGS_FILE" ]; then
            "$PYTHON" /usr/local/bin/pyshell "$INPUT_PIPE" "$ARGS_FILE"
        else
            "$PYTHON" /usr/local/bin/pyshell "$INPUT_PIPE"
        fi
    else
        echo "pyshell not found at /usr/local/bin/pyshell"
        cleanup
        return 127
    fi
    cleanup
}
# pyshell safe helper end

SHHELPER
    echo "Appended py() helper to ~/.zshrc"
else
    echo "Helper already present in ~/.zshrc, skipping append"
fi

echo "Install complete. Run: source ~/.zshrc"