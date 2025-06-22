# Portable Configuration Options

Your nvim is now **working normally** with your original configuration.

## 🎯 **Current Status: STABLE**

✅ No crashes  
✅ Original config working  
✅ No forced initialization  

## 🔧 **Optional Enhancements**

If you want cross-platform improvements, you have these **optional** choices:

### **Option 1: Minimal Enhancement (Recommended)**
Add this line to your `init.lua`:
```lua
require("portable.enhance")
```

This adds:
- Cross-platform clipboard detection
- Simple `:PortableInfo` command
- OS detection
- **Non-intrusive**: Only adds if not already configured

### **Option 2: Environment-Specific Configs**
Copy the appropriate config for your environment:

```bash
# For macOS
cp portable_configs/macos.lua lua/portable/macos.lua

# For Arch Linux  
cp portable_configs/arch.lua lua/portable/arch.lua

# For remote servers
cp portable_configs/remote.lua lua/portable/remote.lua
```

Then require the specific one you need.

### **Option 3: Manual Configuration**
Set environment variables for specific systems:

```bash
# macOS
export NVIM_PDF_VIEWER="skim"
export NVIM_BROWSER="safari"

# Linux
export NVIM_PDF_VIEWER="zathura"  
export NVIM_BROWSER="firefox"

# Remote server
export NVIM_SYSTEM_CLIPBOARD="false"
export NVIM_MINIMAL="true"
```

## 🚫 **What's Disabled by Default**

- ❌ Automatic dependency installation
- ❌ Complex bootup system
- ❌ Environment initialization on every start
- ❌ Forced path modifications

## ✅ **What You Get**

- ✅ Your original working configuration
- ✅ Optional cross-platform enhancements
- ✅ No crashes or errors
- ✅ Simple opt-in improvements

Your nvim works exactly as before, with optional portable features available when you want them!