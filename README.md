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
- Use shell commands inside Python with $(...) or !.
- Works with multi-line Python scripts.
- Hybrid Python + Shell support.
- Works in bash on Linux and WSL.

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

3. Verify installation:
```
pyshell --version
```

---

## Usage
1. One liners
```
pyshell '2 + 3'
pyshell 'print("Hello from PyShell!")'
echo "hello" | pyshell 'print(input().upper())'
```
2. Multi-lines
```
pyshell '
a = 10
b = 20
print(a + b)
'
```
3. Hybrid (Python + Shell)
```
pyshell '
files = $(ls)
print("Files in folder:", files.split())
'
```
---

## Uninstallation
```
chmod +x uninstall.sh
./uninstall.sh
```

















