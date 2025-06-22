# 🚀 Nvim Deployment Guide

## Quick Fix for Tree-sitter Error

If you see this error on a new machine:
```
tree-sitter CLI not found: `tree-sitter` is not executable!
```

### **Quick Solution:**
```bash
# Option 1: Use portable system
nvim -c ":PortableInstall tools" -c ":qa"

# Option 2: Install manually via npm
npm install -g tree-sitter-cli

# Option 3: Install via package manager
# Ubuntu/Debian:
sudo apt install tree-sitter-cli

# Arch Linux:
sudo pacman -S tree-sitter-cli

# macOS:
brew install tree-sitter
```

## 🌍 Complete Deployment Process

### **Step 1: Clone Configuration**
```bash
git clone <your-repo> ~/.config/nvim
cd ~/.config/nvim
```

### **Step 2: Enable Portable Features**
```bash
# Edit init.lua to uncomment the portable line:
sed -i 's/-- require("portable").setup()/require("portable").setup()/' init.lua
```

### **Step 3: Install Dependencies**
```bash
# Start nvim and install dependencies
nvim -c ":PortableInstall core" -c ":qa"
nvim -c ":PortableInstall languages" -c ":qa"  
nvim -c ":PortableInstall tools" -c ":qa"
```

### **Step 4: Verify Setup**
```bash
nvim -c ":PortableCheck" -c ":qa"
```

## 🔧 **Platform-Specific Instructions**

### **Ubuntu/Debian**
```bash
git clone <your-repo> ~/.config/nvim
cd ~/.config/nvim

# Install basic dependencies
sudo apt update
sudo apt install -y git curl unzip build-essential python3 python3-pip nodejs npm
npm install -g tree-sitter-cli

# Enable portable features
echo "require('portable').setup()" >> init.lua

# Start nvim
nvim
```

### **Arch Linux**
```bash
git clone <your-repo> ~/.config/nvim
cd ~/.config/nvim

# Install basic dependencies  
sudo pacman -S --noconfirm git curl unzip base-devel python python-pip nodejs npm tree-sitter-cli

# Enable portable features
echo "require('portable').setup()" >> init.lua

# Start nvim
nvim
```

### **macOS**
```bash
git clone <your-repo> ~/.config/nvim
cd ~/.config/nvim

# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install basic dependencies
brew install git curl python3 node tree-sitter

# Enable portable features
echo "require('portable').setup()" >> init.lua

# Start nvim
nvim
```

### **Remote Servers**
```bash
git clone <your-repo> ~/.config/nvim
cd ~/.config/nvim

# Use minimal setup for remote servers
cp portable_system/configs/remote.lua lua/portable/remote_config.lua
echo "require('portable.remote_config')" >> init.lua

# Install essential tools only
nvim -c ":PortableInstall core" -c ":qa"

# Start nvim
nvim
```

## 🚨 **Troubleshooting**

### **Tree-sitter Issues**
```bash
# Check if tree-sitter is installed
tree-sitter --version

# If not, install via npm (most reliable)
npm install -g tree-sitter-cli

# Add npm global bin to PATH if needed
echo 'export PATH="$PATH:$(npm config get prefix)/bin"' >> ~/.bashrc
source ~/.bashrc
```

### **Python Issues**
```bash
# Check Python configuration
nvim -c ":PortableInfo" -c ":qa"

# If Python not found, install
# Ubuntu: sudo apt install python3 python3-pip
# Arch: sudo pacman -S python python-pip
# macOS: brew install python3
```

### **Permission Issues**
```bash
# If you can't install system packages
npm install -g tree-sitter-cli  # User-level install
pip install --user jupyter      # User-level Python packages

# Or use portable mode without system installs
sed -i 's/require("portable").setup()/-- require("portable").setup()/' init.lua
```

### **Minimal Mode (Fallback)**
```bash
# If portable system causes issues, use minimal mode
cat > init.lua << 'EOF'
require("youzark")
-- Portable system disabled for compatibility
EOF
```

## ✅ **Verification Checklist**

After deployment, verify these work:
- [ ] `nvim` starts without errors
- [ ] `:PortableInfo` shows correct environment
- [ ] `:PortableCheck` shows dependency status
- [ ] Syntax highlighting works
- [ ] LSP features work
- [ ] Clipboard integration works

## 🎯 **Quick Commands Reference**

```vim
:PortableInfo          " Show environment details
:PortableCheck         " Check dependency status
:PortableInstall core  " Install core dependencies
:PortableInstall tools " Install tools (includes tree-sitter)
:PortableSetup         " Apply portable enhancements
```

## 📋 **Common Dependencies**

**Essential:**
- git, curl, unzip, make
- python3, nodejs, npm
- tree-sitter-cli

**Recommended:**
- fzf, ripgrep, fd
- gcc/clang (for LSP servers)

**Optional:**
- ranger, latex, flameshot
- PDF viewers, browsers

Your nvim configuration will now deploy smoothly across any environment! 🎉