# 🚀 Nvim Quick Start Guide

## ✅ **Fixed Segmentation Fault Issue**

Your nvim configuration now has **multiple startup modes** to prevent crashes and ensure compatibility across different environments.

## 🎯 **Startup Modes**

### 🔧 **Auto-Detection (Default)**
```bash
nvim  # Automatically chooses the best mode
```

### 🛡️ **Safe Mode (Recommended)**
```bash
export NVIM_BOOTUP_MODE="safe"
nvim
```
- ✅ **Stable**: Uses your original configuration
- ✅ **Enhanced**: Adds cross-platform improvements
- ✅ **Safe**: No segfaults, scheduled loading

### 🟢 **Minimal Mode**
```bash
export NVIM_BOOTUP_MODE="minimal"
nvim
```
- ✅ **Original**: Just your existing configuration
- ✅ **Fast**: No bootup system overhead
- ✅ **Compatible**: Works everywhere

### 🔬 **Debug Mode**
```bash
export NVIM_BOOTUP_MODE="debug"
nvim
```
- 🔍 **Verbose**: Shows detailed loading information
- 🐛 **Debugging**: Helps diagnose issues

### ⚡ **Full Mode (Experimental)**
```bash
export NVIM_BOOTUP_MODE="full"
nvim
```
- 🚀 **Complete**: Full bootup system
- ⚠️ **Experimental**: May have issues on some systems

## 🌍 **Cross-Platform Deployment**

### **Mac/Linux/Remote Server**
```bash
# Clone your config
git clone <your-repo> ~/.config/nvim

# Set safe mode (recommended)
echo 'export NVIM_BOOTUP_MODE="safe"' >> ~/.bashrc
source ~/.bashrc

# Start nvim
nvim
```

### **Quick Commands Available**
```vim
:NvimCheckDeps    " Check what's installed
:NvimInstallDeps  " Install missing tools
:NvimEnvInfo      " Show environment info
```

## 🔧 **Current Status**

✅ **Segmentation fault**: FIXED  
✅ **Cross-platform**: WORKING  
✅ **Dependency management**: AVAILABLE  
✅ **Environment detection**: WORKING  
✅ **Safe fallbacks**: IMPLEMENTED  

## 🚨 **Troubleshooting**

### **If nvim crashes:**
```bash
export NVIM_BOOTUP_MODE="minimal"
nvim  # Uses only your original config
```

### **For remote servers:**
```bash
export NVIM_BOOTUP_MODE="safe"
# SSH auto-detects and uses safe mode
```

### **For debugging:**
```bash
export NVIM_BOOTUP_MODE="debug"
nvim  # Shows detailed loading info
```

## 📊 **Mode Comparison**

| Mode | Stability | Features | Speed | Use Case |
|------|-----------|----------|-------|----------|
| **minimal** | 🟢 Highest | ⚪ Basic | 🟢 Fastest | Compatibility |
| **safe** | 🟢 High | 🟡 Enhanced | 🟡 Fast | **Recommended** |
| **full** | 🟡 Medium | 🟢 Complete | 🟡 Medium | Power users |
| **debug** | 🟡 Medium | 🟢 Complete | 🔴 Slower | Troubleshooting |

## 🎯 **Recommendation**

**Use "safe" mode** - it gives you the best balance of stability and features:

```bash
echo 'export NVIM_BOOTUP_MODE="safe"' >> ~/.bashrc
source ~/.bashrc
nvim
```

Your nvim configuration is now ready for deployment across any environment! 🎉