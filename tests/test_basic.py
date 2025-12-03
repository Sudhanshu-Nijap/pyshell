import os
import subprocess
import sys

def test_eval_simple(tmp_path):
    fifo = tmp_path / "pyshell_in"
    os.mkfifo(str(fifo))
    proc = subprocess.Popen([sys.executable, "pyshell.py", str(fifo)],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    # write expression and close writer so reader proceeds
    with open(str(fifo), "w") as f:
        f.write("1+2\n")
    out, err = proc.communicate(timeout=5)
    assert "3" in out.strip()