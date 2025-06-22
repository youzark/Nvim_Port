# 🐍 Python Environment & Tool Manager Guide

## 🚀 Quick Start

```vim
" Check current status
:PortableCheck

" Setup Python environment with miniconda
:PortableInstall python

" Install essential tools
:PortableInstall essentials

" Quick setup for specific use cases
:QuickSetup python
:QuickSetup web_dev
:QuickSetup data_science
```

## 📦 Python Environment Management

### Auto-detect and Setup Miniconda

The system automatically:
1. **Detects existing miniconda/anaconda** installations
2. **Creates dedicated `nvim` environment** with Python 3.11
3. **Installs essential packages** for nvim development
4. **Sets vim.g.python3_host_prog** to the nvim environment

### Python Packages Installed
```
pynvim              # Neovim Python support
black               # Code formatter
isort               # Import organizer
flake8              # Linting
pylsp-mypy          # Type checking
python-lsp-server   # LSP server with full features
jupyterlab          # Jupyter environment
ipython             # Enhanced Python shell
matplotlib          # Plotting
numpy               # Numerical computing
pandas              # Data manipulation
```

### Commands

```vim
:PythonEnvSetup     " Setup Python environment
:PythonEnvStatus    " Show Python environment status
:InstallMiniconda   " Auto-install miniconda (Linux/macOS)
```

## 🛠️ Tool Manager

### Supported Tools

**Core Development:**
- `npm` - Node.js package manager + essential packages
- `luarocks` - Lua package manager + utilities
- `ripgrep` - Fast text search
- `fd` - Fast file finder
- `fzf` - Fuzzy finder with shell integration

**Applications:**
- `ranger` - File manager with nvim integration
- `latex` - LaTeX document processing

### Tool Installation

```vim
" Install specific tools
:ToolInstall npm
:ToolInstall luarocks
:ToolInstall ranger

" Install packages for tools
:ToolPackages npm      " Installs LSP servers, formatters, etc.
:ToolPackages luarocks " Installs lua utilities

" Check tool status
:PortableCheck
```

### Presets for Different Workflows

```vim
:PortableInstall web_dev        " npm, fzf, ripgrep, fd
:PortableInstall data_science   " ranger, fzf, ripgrep  
:PortableInstall latex          " latex, fzf, ripgrep, fd
:PortableInstall minimal        " fzf, ripgrep only
:PortableInstall essentials     " All essential tools
```

## 🎯 Quick Setup Commands

### Complete Environment Setup
```vim
:QuickSetup full       " Everything: tools + python + dependencies
:QuickSetup python     " Python environment only
:QuickSetup web_dev    " Web development tools
:QuickSetup essentials " Essential tools only
```

### Manual Setup Process
```bash
# 1. Install miniconda (if not installed)
curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p ~/miniconda3

# 2. Start nvim and setup
nvim -c ":PortableInstall python" -c ":qa"
nvim -c ":PortableInstall essentials" -c ":qa"
```

## 📋 Package Details

### NPM Packages Installed
```
tree-sitter-cli              # Syntax parsing
neovim                       # Neovim Node.js support
typescript                   # TypeScript compiler
typescript-language-server   # TypeScript LSP
bash-language-server         # Bash LSP
yaml-language-server         # YAML LSP
vscode-langservers-extracted # HTML/CSS/JSON LSP
prettier                     # Code formatter
eslint                       # JavaScript linter
```

### Luarocks Packages Installed
```
luacheck        # Lua linter
luaformatter    # Lua formatter
lanes           # Threading
luasocket       # Networking
luafilesystem   # File operations
```

## 🔍 Status and Diagnostics

### Check Everything
```vim
:PortableCheck      " Complete status of all systems
:PortableInfo       " Environment information
:PythonEnvStatus    " Python-specific status
```

### Sample Status Output
```
Python Environment Status:
===============================
Conda installed: ✓
Conda path: /home/user/miniconda3/bin/conda
Nvim env exists: ✓
Python host: /home/user/miniconda3/envs/nvim/bin/python

Package Status:
  ✓ pynvim
  ✓ black
  ✓ python-lsp-server
  ...

Tool Manager Status:
===============================
  ✓ npm
  ✓ luarocks
  ✓ ranger
  ✓ ripgrep
  ✓ fzf
  ✗ latex
```

## 🚨 Troubleshooting

### Python Environment Issues
```vim
" If conda not detected
:InstallMiniconda

" If environment creation fails
" Check conda is in PATH, then retry:
:PythonEnvSetup

" If packages fail to install
" Manual installation:
" conda activate nvim
" pip install pynvim black isort flake8
```

### Tool Installation Issues
```vim
" Check if package manager is detected
:PortableInfo

" Install tools manually if needed
" Ubuntu: sudo apt install npm luarocks ranger
" Arch: sudo pacman -S npm luarocks ranger
" macOS: brew install node luarocks ranger
```

### Integration with Existing Config
The system integrates seamlessly:
- **Respects existing Python settings** - won't override if already configured
- **Works with current nvim config** - optional enhancement
- **Graceful fallbacks** - continues working even if some tools are missing

## 💡 Tips

1. **Run `:QuickSetup full`** for complete setup on new machines
2. **Use `:PortableCheck`** regularly to verify tool status
3. **Python environment is isolated** - won't affect system Python
4. **All tools are optional** - nvim works without them but with reduced features
5. **Conda environment persists** across nvim sessions and system restarts

Your nvim setup now has powerful dependency management! 🎉