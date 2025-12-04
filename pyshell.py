#!/usr/bin/env python3

import os
import sys
import traceback

def load_pre_imports(env):
    """Load optional user-defined imports."""
    pre = os.environ.get("PYSHELL_IMPORTS")
    if pre:
        try:
            exec(pre, env)
        except Exception as e:
            print(f"[PyShell Import Error] {e}")

def main():
    if len(sys.argv) != 2:
        sys.stderr.write("Usage: pyshell <pipe_path>\n")
        sys.exit(1)

    pipe_path = sys.argv[1]

    try:
        with open(pipe_path, "r") as fifo:
            lines = fifo.read().splitlines()
    except Exception as e:
        print(f"[PyShell] FIFO Read Error: {e}")
        sys.exit(1)

    if not lines:
        print()
        sys.exit(0)

    code = "\n".join(lines)

    # ➤ Isolated sandbox per execution
    env = {"__builtins__": __builtins__}

    # ➤ Load optional imports (doesn’t contaminate host env)
    load_pre_imports(env)

    try:
        # Auto-eval only if safe
        stripped = code.strip()
        if ("\n" not in code) and not stripped.startswith("print("):
            try:
                print(eval(stripped, env))
                return
            except Exception:
                pass

        exec(code, env)

    except SyntaxError:
        print("SyntaxError: Cannot evaluate expression.")
    except Exception:
        print(f"[PyShell Error] {traceback.format_exc().strip()}")

if __name__ == "__main__":
    main()
