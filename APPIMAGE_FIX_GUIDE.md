# 🔧 AppImage Neovim Fix Guide

## 🚨 Problem

When using Neovim AppImage, you get errors like:
```
Invalid $VIMRUNTIME: /root/squashfs-root/usr/share/nvim/runtime
Error executing lua: ... E117: Unknown function: health#report_start
```

## ✅ Automatic Fix

The portable configuration now automatically detects and fixes AppImage issues!

### **When you start nvim on the AppImage machine:**

```vim
" Enable portable features (if not already enabled)
require('portable').setup()
```

**You'll see:**
```
[APPIMAGE-FIX] 🔧 Applying AppImage compatibility fixes...
[APPIMAGE-FIX] Setting VIMRUNTIME to: /usr/share/nvim/runtime
[APPIMAGE-FIX] Adding health check compatibility
[APPIMAGE-FIX] ✅ Applied 2/2 fixes
[APPIMAGE-FIX] 🎉 AppImage compatibility enabled
[PORTABLE] Cross-platform enhancements loaded for linux (AppImage)
```

## 🛠️ Manual Commands

### **Check AppImage Status:**
```vim
:AppImageInfo
```
**Output:**
```
[APPIMAGE-FIX] AppImage Environment Info:
  Neovim path: /tmp/.mount_nvim-lVHu8L/usr/bin/nvim
  VIMRUNTIME: /tmp/.mount_nvim-lVHu8L/usr/share/nvim/runtime
  APPIMAGE env: /home/user/nvim.appimage
  Is AppImage: yes
  Health functions: available
```

### **Apply Fixes Manually:**
```vim
:AppImageFix
```

### **Test Health Check:**
```vim
:checkhealth
```

## 🔍 What Gets Fixed

### **1. VIMRUNTIME Path Issues**
- **Problem:** AppImage mounts create temporary paths like `/tmp/.mount_*/` or `/root/squashfs-root/`
- **Fix:** Detects and corrects VIMRUNTIME to proper runtime directory
- **Paths checked:**
  - `$NVIM_EXECUTABLE/../share/nvim/runtime`
  - `/usr/share/nvim/runtime`
  - `/usr/local/share/nvim/runtime`

### **2. Health Check Functions**
- **Problem:** Missing `health#report_start` and related functions
- **Fix:** Creates compatibility layer for both Lua and VimScript health functions
- **Functions added:**
  - `vim.health.report_start()`
  - `vim.health.report_ok()`
  - `vim.health.report_warn()`
  - `vim.health.report_error()`
  - `vim.health.report_info()`
  - `health#report_*()` VimScript functions

### **3. Environment Detection**
- **Automatic detection** of AppImage environments via:
  - Executable path contains `.AppImage`
  - VIMRUNTIME contains `squashfs-root` or `/tmp/.mount_`
  - `$APPIMAGE` environment variable exists

## 🚀 Features

### **Automatic Activation**
- **Detects AppImage** environment automatically
- **Applies fixes** on startup when portable system loads
- **No manual intervention** required

### **Comprehensive Compatibility**
- **VIMRUNTIME path** correction
- **Health function** restoration
- **Legacy VimScript** compatibility
- **Lua API** compatibility

### **Graceful Degradation**
- **Continues working** even if some fixes fail
- **Clear feedback** on what was fixed
- **Non-intrusive** on normal installations

## 📋 Troubleshooting

### **If health checks still fail:**
```vim
:AppImageFix
:lua vim.health.report_start("Test")
```

### **If VIMRUNTIME is still wrong:**
```vim
:echo $VIMRUNTIME
:AppImageInfo
```

### **Manual VIMRUNTIME fix:**
```vim
:let $VIMRUNTIME = "/usr/share/nvim/runtime"
```

### **If functions are missing:**
```lua
-- Test if health functions exist
:lua print(vim.health and "Health API available" or "Health API missing")
```

## 🎯 Integration

### **In your init.lua:**
```lua
-- The AppImage fixes are automatically applied when you load portable
require('portable').setup()
```

### **For AppImage-specific config:**
```lua
-- Check if running in AppImage
if _G.nvim_portable and _G.nvim_portable.is_appimage then
    -- AppImage-specific configuration
    print("Running in AppImage mode")
end
```

### **Conditional loading:**
```lua
-- Only apply fixes if needed
local appimage_fix = require('portable.appimage_fix')
if appimage_fix.is_appimage() then
    appimage_fix.apply_fixes()
end
```

## ✅ Verification

After applying fixes, these should work:

```vim
:checkhealth                    " Should run without errors
:lua vim.health.report_ok("Test") " Should print: - OK: Test
:echo $VIMRUNTIME              " Should show valid path
:AppImageInfo                  " Should show "Health functions: available"
```

## 🎉 Benefits

1. **✅ Automatic detection** and fixing of AppImage issues
2. **🔧 VIMRUNTIME correction** for proper plugin functionality  
3. **🏥 Health check restoration** for diagnostics
4. **📦 Zero configuration** - works out of the box
5. **🔄 Backwards compatible** with normal nvim installations
6. **🛡️ Safe fallbacks** when fixes aren't possible

**Your AppImage Neovim will now work seamlessly with all health checks and runtime features!** 🎉