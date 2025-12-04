py() {
    # capture piped data if present
    if [ ! -t 0 ]; then
        STDIN_DATA="$(cat)"
    else
        STDIN_DATA=""
    fi

    python3 - "$@" <<EOF
import sys, subprocess, re, traceback, builtins

code = " ".join(sys.argv[1:]).strip()

stdin_data = """$STDIN_DATA"""

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

# Replace !command inside Python
code = re.sub(r"!(.+)", shell_sub, code)

# ---------------------------------------------
# PIPE INPUT → sys.stdin
# ---------------------------------------------
if stdin_data:
    sys.stdin = iter(stdin_data.splitlines(keepends=True))

# ---------------------------------------------
# TRY eval() FIRST (expressions)
# ---------------------------------------------
try:
    result = eval(code)
    if result is not None:
        print(result)
    sys.exit(0)
except SyntaxError:
    pass
except Exception as e:
    print("Error in expression:", e)
    sys.exit(1)

# ---------------------------------------------
# THEN TRY exec() FOR FULL PROGRAMS
# ---------------------------------------------
try:
    exec(code, globals(), locals())
except Exception:
    print("Error in script:")
    traceback.print_exc()
EOF
}