#!/usr/bin/env python3
###########################################
# PyShell: minimal Python executor        #
# Author: Sudhanshu Nijap                 #
###########################################

import sys
import os

# Optional pre-imports via environment variable
if 'PYSHELL_IMPORTS' in os.environ:
    for module in os.environ['PYSHELL_IMPORTS'].split(','):
        _mod = __import__(module, globals(), locals())
        globals().update(_mod.__dict__)

def cleanup(path):
    if path and os.path.exists(path):
        try:
            os.unlink(path)
        except:
            pass

def main():
    if len(sys.argv) < 2:
        print("Usage: pyshell <fifo-path> [args-file]")
        return 2
