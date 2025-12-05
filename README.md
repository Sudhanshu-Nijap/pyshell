# PyShell

PyShell makes your terminal smarter. Run Python code directly in your shell, mix Python with shell commands, and even use multi-line scripts - all without creating separate files.

```
 ____        ____  _          _ _ 
|  _ \ _   _/ ___|| |__   ___| | |
| |_) | | | \___ \| '_ \ / _ \ | |
|  __/| |_| |___) | | | |  __/ | |
|_|    \__, |____/|_| |_|\___|_|_|
       |___/        
```

<p align="center"> 

<!-- Version Badge --> 
<img src="https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge" />

<!-- Shell Badge --> 
<img src="https://img.shields.io/badge/shell-zsh%20%7C%20bash-green?style=for-the-badge"/> 

<!-- Python Badge -->
<img src="https://img.shields.io/badge/python-3.10%2B-yellow?style=for-the-badge" /> 

<!-- License Badge --> 
<img src="https://img.shields.io/badge/license-MIT-orange?style=for-the-badge" /> 

<!-- Made With Badge --> 
<img src="https://img.shields.io/badge/made%20with-%E2%9D%A4-red?style=for-the-badge" />
</p>

---

## Features

- Run Python expressions and scripts directly in your terminal.
- Pipe shell output into Python code.
- Use shell commands inside Python with `!`.
- Works with multi-line Python scripts.
- Zsh plugin support for easy usage with `py "code"`.

---

## Installation

1. Clone the repo:

```
git clone https://github.com/yourusername/pyshell.git
cd pyshell
```

2. Run the installer:
```
chmod +x install.sh
./install.sh
```

3. Reload your shell:
```
source ~/.zshrc
```

---

## Usage
1. One liners
```
py '2 + 3'
py 'print("Hello from PyShell!")'
echo "hello" | py 'print(input().upper())'
```
2. Multi-lines
```
py '
a = 10
b = 20
print(a + b)
'
```
## Uninstallation
```
chmod +x uninstall.sh
./uninstall.sh
```

















