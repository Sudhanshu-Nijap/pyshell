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
    if [ -x /usr/local/bin/zpyi ]; then
        if [ -e "$ARGS_FILE" ]; then
            "$PYTHON" /usr/local/bin/zpyi "$INPUT_PIPE" "$ARGS_FILE"
        else
            "$PYTHON" /usr/local/bin/zpyi "$INPUT_PIPE"
        fi
    elif [ -x /usr/local/bin/pyshell ]; then
        if [ -e "$ARGS_FILE" ]; then
            "$PYTHON" /usr/local/bin/pyshell "$INPUT_PIPE" "$ARGS_FILE"
        else
            "$PYTHON" /usr/local/bin/pyshell "$INPUT_PIPE"
        fi
    else
        echo "pyshell/zpyi not found at /usr/local/bin; ensure you ran the installer."
        cleanup
        return 127
    fi
    cleanup
}
# pyshell safe helper end