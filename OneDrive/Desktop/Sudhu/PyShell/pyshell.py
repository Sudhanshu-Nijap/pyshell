#!/usr/bin/env python3

# Working

# 1. Reads what you type: either from command line or piped input.
# 2. Checks what kind of command it is:
#    Starts with ! → run as shell command
#    Contains $(...) → run shell inside Python and replace with output
#    Single expression → calculate with Python eval()
#    Multi-line statements → run with Python exec()
# 3. Runs the command safely.
# 4. Prints the result if needed.
# 5. Catches all errors so it never crashes.
# 6. Handles Ctrl+C (KeyboardInterrupt) gracefully

import sys
import subprocess
import traceback
import re
import pprint

# Isolated environment for running Python code
ENV = {
    "__name__": "__main__",
    "__builtins__": __builtins__
}

# Run a shell command safely
def run_shell(cmd: str) -> str:
    try:
        completed = subprocess.run(
            cmd,
            shell=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        )
        return (completed.stdout or "").rstrip()
    except Exception as e:
        return f"[shell error] {e}"

# Regex to detect $(...) shell substitution
_SHELL_PATTERN = re.compile(r"\$\(([^()]*)\)", re.DOTALL)

# Replace $(...) with shell output
def shell_substitution(code: str) -> str:
    def repl(match):
        output = run_shell(match.group(1))
        return repr(output)
    return _SHELL_PATTERN.sub(repl, code)

# Check if code is a single expression
def is_expression(code: str) -> bool:
    try:
        compile(code, "<pyshell>", "eval")
        return True
    except Exception:
        return False

# Read code from CLI args only
def read_code() -> str:
    """Get code from command-line arguments (not from stdin)."""
    try:
        return " ".join(sys.argv[1:])  # Python code comes from CLI args
    except Exception:
        return ""


# Main function
def main():
    try:
        code = read_code().strip()

        if not code:
            print("[i] Usage: pyshell <python | !shell | mixed>")
            sys.exit(0)

        if code in ("-v", "--version"):
            print("PyShell v2.2")
            sys.exit(0)

        # Pure shell mode
        if code.startswith("!"):
            subprocess.run(code[1:], shell=True)
            sys.exit(0)

        # Hybrid Python + shell
        code = shell_substitution(code)

        # FIX: Use exec() if input is piped or code is multi-line
        if not sys.stdin.isatty() or "\n" in code or not is_expression(code):
            # Run as statements
            exec(code, ENV, ENV)
        else:
            # Single expression → eval
            result = eval(code, ENV, ENV)
            if result is not None:
                pprint.pprint(result)

        sys.exit(0)

    except KeyboardInterrupt:
        print("\n[!] Interrupted")
        sys.exit(130)

    except SystemExit:
        raise

    except Exception:
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()
