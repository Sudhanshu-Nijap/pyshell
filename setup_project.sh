#!/usr/bin/env bash
# Creates a ready-to-use "pyshell" project in the current directory.
# Usage: ./setup_project.sh [target-dir]
set -euo pipefail

TARGET_DIR="${1:-my-pyshell}"
if [ -e "$TARGET_DIR" ]; then
  echo "Target $TARGET_DIR already exists. Remove it or choose another name." >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Write pyshell.py
cat > pyshell.py <<'PY'
#!/usr/bin/env python3
###########################################
# Python script for pyshell                  #
# Minimal, safe version                   #
# Author: you                             #
###########################################

import sys
import os

# Optional pre-imports: set PYSHELL_IMPORTS="math,random"
if 'PYSHELL_IMPORTS' in os.environ:
    for module in os.environ['PYSHELL_IMPORTS'].split(','):
        _module = __import__(module, globals(), locals())
        globals().update(_module.__dict__)

def cleanup(path):
    try:
        if path and os.path.exists(path):
            os.unlink(path)
    except Exception:
        pass

def main():
    if len(sys.argv) < 2:
        print("Usage: pyshell <fifo-path> [args-file]")
        return 2

    fifo_path = sys.argv[1]
    args_file = sys.argv[2] if len(sys.argv) > 2 else None

    # Read code from FIFO (blocking until writer writes and closes)
    try:
        with open(fifo_path, 'r') as fifo:
            codestr = fifo.read().splitlines()
    except Exception as e:
        print(f"Error reading fifo {fifo_path}: {e}", file=sys.stderr)
        return 3

    args = []
    if args_file:
        try:
            with open(args_file, 'r') as af:
                args = [line.rstrip('\n') for line in af.readlines()]
        except Exception as e:
            print(f"Error reading args file {args_file}: {e}", file=sys.stderr)
            cleanup(fifo_path)
            return 4

    # Populate sys.argv for the executed code (first element is script name)
    for i in range(len(args)):
        if i + 1 < len(sys.argv):
            sys.argv[i+1] = args[i]
        else:
            sys.argv.append(args[i])

    # Remove blank lines
    code_lines = [line for line in codestr if line.strip()]

    try:
        if len(code_lines) == 1 and not code_lines[0].strip().startswith('print'):
            # Evaluate single expression and print result
            try:
                result = eval(code_lines[0])
                print(result)
            except Exception:
                # Fallback to exec if eval fails (e.g., statements)
                exec("\n".join(code_lines), globals())
        else:
            exec("\n".join(code_lines), globals())
    except Exception as error:
        print("Python statement invalid:", file=sys.stderr)
        print(error.__class__.__name__ + ": " + str(error), file=sys.stderr)
        cleanup(fifo_path)
        return 1

    cleanup(fifo_path)
    return 0

if __name__ == "__main__":
    sys.exit(main())
PY

# Write install.sh
cat > install.sh <<'SH'
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
SH

# README.md
cat > README.md <<'MD'
````markdown
# my-pyshell

A minimal "pyshell" utility: evaluate small Python snippets from the shell using a safe explicit helper function.

Key pieces:
- `/usr/local/bin/pyshell` — the executable Python program that reads code from a FIFO and executes it.
- `py` — a safe zsh helper function (explicit invocation) that sends the snippet to pyshell via FIFO.

Why explicit is safer:
- The `py` helper does not override shell command-not-found behavior. It only runs when you call `py ...`.

Install (local)
1. Ensure prerequisites:
   sudo apt update
   sudo apt install -y python3 zsh

2. From the project root:
   sudo ./install.sh

3. Reload zsh:
   source ~/.zshrc

Usage
- Simple expression:
  py '1+2'
- Multi-line (use $'...' to include newline):
  py $'a=5\nprint(a*3)'
- Pass sys.argv values:
  py 'import sys; print(sys.argv)' arg1 arg2

Development
- Run tests:
  pytest

License
- MIT (see LICENSE)