py() {
    # Capture piped input safely
    if [ ! -t 0 ]; then
        STDIN_DATA="$(cat)"
    else
        STDIN_DATA=""
    fi

    python3 - "$@" <<EOF
import sys, subprocess, re, traceback, builtins, io

# Full code passed in arguments
code = " ".join(sys.argv[1:]).strip()

# Prepare stdin
stdin_data = """$STDIN_DATA"""
if stdin_data:
    sys.stdin = io.StringIO(stdin_data)

# ---------------------------------------------
# SAFE SHELL EXECUTION FOR !commands
# ---------------------------------------------
def shell_sub(match):
    cmd = match.group(1).strip()
    try:
        out = subprocess.check_output(cmd, shell=True, text=True, stderr=subprocess.STDOUT)
        return repr(out)
    except subprocess.CalledProcessError as e:
        return repr(e.output)

# Shell substitution like !ls
code = re.sub(r"!([^!]+)", shell_sub, code)

# ---------------------------------------------
# Run Python code safely
# ---------------------------------------------
try:
    result = eval(code, globals(), globals())
    if result is not None:
        print(result)
except SyntaxError:
    try:
        exec(code, globals(), globals())
    except Exception:
        traceback.print_exc()
except Exception:
    traceback.print_exc()
EOF
}
