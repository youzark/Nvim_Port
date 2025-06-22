# Neovim Portable Bootup System

A self-contained, cross-platform Neovim configuration with automatic dependency management and environment setup.

## 🚀 Quick Start

### New Installation
```bash
# 1. Clone or copy your nvim config
git clone <your-repo> ~/.config/nvim

# 2. Run the installation script
cd ~/.config/nvim
./install.sh

# 3. Start Neovim - everything else is automatic!
nvim
```

### Existing System
```bash
# Copy the bootstrap script and run it
./bootstrap.sh
nvim
```

## ✨ Features

- **🔧 Automatic Dependency Detection**: Checks for and installs missing tools
- **🌍 Cross-Platform**: Works on Linux, macOS, and Windows
- **📦 Package Manager Agnostic**: Supports apt, yum, pacman, brew, and more
- **🔑 Environment Separation**: No hardcoded paths, everything configurable
- **🛠️ Self-Healing**: Missing dependencies are auto-installed when possible
- **🎯 Zero Configuration**: Works out of the box with sensible defaults

## 🗂️ File Structure

```
~/.config/nvim/
├── lua/bootup/           # Bootup system core
│   ├── init.lua         # Main bootup coordinator
│   ├── env.lua          # Environment management
│   └── deps.lua         # Dependency management
├── install.sh           # Full installation script
├── bootstrap.sh         # Quick setup for new systems
├── .nvimrc.example      # Environment configuration template
└── README_BOOTUP.md     # This file
```

## ⚙️ Environment Configuration

### Quick Setup
Copy and customize the environment template:
```bash
cp ~/.config/nvim/.nvimrc.example ~/.nvimrc
# Edit ~/.nvimrc to customize your environment
source ~/.nvimrc
```

### Key Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NVIM_ROOT` | Nvim config directory | `~/.config/nvim` |
| `NVIM_BIN_DIR` | Directory for binaries | `~/.local/bin` |
| `NVIM_TOOLS_DIR` | Tools installation dir | `~/.local/nvim-tools` |
| `NVIM_AUTO_INSTALL` | Auto-install dependencies | `true` |
| `NVIM_BROWSER` | Default browser | Auto-detected |
| `NVIM_PDF_VIEWER` | PDF viewer | Auto-detected |

### API Keys
```bash
export DEEPSEEK_API="your_key_here"
export GEMINI_API="your_key_here"
export OPENAI_API_KEY="your_key_here"
```

### Network Configuration
```bash
# Enable proxy
export NVIM_PROXY_ENABLED="true"
export NVIM_PROXY_HOST="127.0.0.1"
export NVIM_PROXY_PORT="7890"
```

## 🔧 Dependency Management

### Automatic Installation
Dependencies are automatically detected and installed on first run:

**Core Tools**: git, curl, unzip, make, gcc
**Languages**: Python 3, Node.js, Rust (optional)
**File Tools**: fzf, ripgrep, fd, ranger
**Clipboard**: xclip (Linux), pbcopy (macOS), win32yank (Windows)

### Manual Management
```vim
" Check dependency status
:NvimCheckDeps

" Install missing dependencies
:NvimInstallDeps

" Install specific categories
:NvimInstallDeps core languages file_tools

" Show environment info
:NvimEnvInfo

" Reinstall bootup system
:NvimReinstall
```

### Health Check Integration
```vim
:checkhealth bootup
```

## 🖥️ Platform Support

### Linux
- **Package Managers**: apt, yum, dnf, pacman, zypper, apk
- **Clipboard**: xclip, wl-clipboard, xsel
- **Screenshots**: flameshot, gnome-screenshot, scrot, maim

### macOS
- **Package Manager**: Homebrew
- **Clipboard**: pbcopy/pbpaste (built-in)
- **Screenshots**: screencapture (built-in)
- **PDF Viewer**: skim, preview

### Windows
- **Package Managers**: chocolatey, winget, scoop
- **Clipboard**: win32yank
- **Screenshots**: snipping tool

## 📋 Supported Dependencies

<details>
<summary>Core System Tools</summary>

- git (version control)
- curl (data transfer)
- unzip (archive extraction)
- make (build automation)
- gcc/clang (C/C++ compiler)
</details>

<details>
<summary>Programming Languages</summary>

- Python 3 + pip + venv
- Node.js + npm
- Rust + cargo (optional)
</details>

<details>
<summary>File Management</summary>

- fzf (fuzzy finder)
- ripgrep (fast grep)
- fd (fast find)
- ranger (file manager)
</details>

<details>
<summary>LSP Servers (Mason-managed)</summary>

- lua_ls (Lua)
- clangd (C/C++)
- pyright (Python) 
- rust_analyzer (Rust)
- marksman (Markdown)
</details>

<details>
<summary>Optional Tools</summary>

- LaTeX distribution
- Screenshot tools
- PDF viewers
- Terminal emulators
</details>

## 🚨 Troubleshooting

### Common Issues

**Dependencies fail to install**
```bash
# Check package manager
nvim -c ":NvimEnvInfo" -c ":qa"

# Install manually with sudo
sudo ./install.sh

# Check specific dependency
nvim -c ":NvimCheckDeps" -c ":qa"
```

**Python/Node.js not found**
```bash
# Check PATH setup
echo $PATH | grep -E "(nvim-venv|nvim-node)"

# Recreate environments
rm -rf ~/.local/nvim-venv ~/.local/nvim-node
nvim -c ":NvimInstallDeps languages" -c ":qa"
```

**Clipboard not working**
```bash
# Linux: Install clipboard tools
sudo apt install xclip wl-clipboard  # Ubuntu/Debian
sudo pacman -S xclip wl-clipboard     # Arch

# Check if installed
nvim -c ":NvimCheckDeps" -c ":qa"
```

### Getting Help
```vim
" Show bootup status
:NvimEnvInfo

" Check health
:checkhealth bootup

" Debug mode (verbose output)
:lua vim.g.nvim_debug = true
```

## 🔄 Migration from Old Config

### Backup Current Config
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### Update Existing Config
If you have an existing nvim config, you can integrate the bootup system:

1. Copy the `lua/bootup/` directory to your config
2. Add `require("bootup").setup()` to the top of your `init.lua`
3. Update hardcoded paths to use environment variables
4. Run `:NvimCheckDeps` to verify everything works

### Environment Migration
```bash
# Export current paths
export NVIM_ROOT="$(pwd)"
export NVIM_PYTHON_VENV="/path/to/your/python/env"

# Copy your custom settings to ~/.nvimrc
cp .nvimrc.example ~/.nvimrc
# Edit ~/.nvimrc with your customizations
```

## 📚 Advanced Usage

### Custom Dependency Installation
```lua
-- Add custom dependencies in lua/bootup/deps.lua
M.dependencies.custom = {
    my_tool = {
        description = "My custom tool",
        required = true,
        check = function() return vim.fn.executable("my_tool") == 1 end,
        install = {
            linux = { apt = "my-tool-package" },
            macos = { brew = "my-tool" }
        }
    }
}
```

### Environment-Specific Configuration
```lua
-- In your config files
local env_config = _G.nvim_env or {}

if env_config.os == "macos" then
    -- macOS-specific settings
elseif env_config.os == "linux" then
    -- Linux-specific settings
end
```

### Plugin Integration
```lua
-- Example: Make plugin respect environment
local python_bin = _G.nvim_env and _G.nvim_env.paths.python_venv .. "/bin/python" 
    or vim.g.python3_host_prog

require("plugin").setup({
    python_executable = python_bin
})
```

## 🤝 Contributing

This bootup system is designed to be modular and extensible. To add support for new:

- **Package managers**: Edit `detect_package_manager()` in `deps.lua`
- **Dependencies**: Add entries to `M.dependencies` in `deps.lua`  
- **Platforms**: Update OS detection in `env.lua`
- **Features**: Add toggles to `features` in `env.lua`

## 📄 License

This bootup system is part of your Neovim configuration and follows the same license.