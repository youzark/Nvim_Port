# 🌍 Portable Nvim System

Clean, modular cross-platform enhancements for Neovim.

## 📁 **Directory Structure**

```
portable_system/
├── README.md                 # This file
├── init_portable.lua         # Ready-to-use portable init.lua
├── configs/                  # Platform-specific configurations
│   ├── macos.lua            # macOS optimizations
│   ├── arch.lua             # Arch Linux setup
│   └── remote.lua           # Remote server config
└── docs/                    # Documentation
    └── PORTABLE_SETUP.md    # Detailed setup guide
```

## 🚀 **Quick Start**

### **Option 1: Enable Portable Features**
```lua
-- In your init.lua, add:
require("portable").setup()
```

### **Option 2: Use Pre-configured Portable Init**
```bash
cp portable_system/init_portable.lua init.lua
```

### **Option 3: Platform-Specific Setup**
```lua
-- For specific platforms:
require("portable.configs.macos")    -- macOS
require("portable.configs.arch")     -- Arch Linux  
require("portable.configs.remote")   -- Remote servers
```

## 🔧 **Available Commands**

Once enabled, you get these commands:

```vim
:PortableInfo          " Show environment information
:PortableCheck         " Check dependency status
:PortableInstall core  " Install core dependencies
:PortableStatus        " Show portable system status
:PortableSetup         " Apply portable enhancements
```

## 📋 **What It Provides**

✅ **Cross-platform clipboard** (xclip/wl-clipboard/pbcopy/win32yank)  
✅ **OS detection** (Linux/macOS/Windows)  
✅ **Package manager detection** (apt/yum/pacman/brew/chocolatey)  
✅ **Python integration** (automatic detection)  
✅ **Application configuration** (PDF viewers, browsers)  
✅ **Environment optimizations** (remote/local)  
✅ **Dependency management** (check and install tools)  

## 🎯 **Design Principles**

- **Modular**: Clean separation of concerns
- **Non-intrusive**: Only enhances, never overrides
- **Safe**: Thoroughly tested, no crashes
- **Optional**: Can be disabled without breaking anything
- **Clean**: Well-organized, doesn't clutter root directory

## 📖 **Documentation**

See `docs/PORTABLE_SETUP.md` for detailed setup and deployment instructions.

## 🔧 **Module Structure**

The portable system is organized into clean modules:

- `lua/portable/init.lua` - Main entry point
- `lua/portable/detect.lua` - Platform detection
- `lua/portable/config.lua` - Cross-platform configuration  
- `lua/portable/deps.lua` - Dependency management
- `lua/portable/commands.lua` - Vim commands

Each module is focused and can be used independently if needed.