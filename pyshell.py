#!/usr/bin/env python3
###########################################
# Python script for Pyshell               #                  
# Author: Sudhanshu Nijap                 #
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