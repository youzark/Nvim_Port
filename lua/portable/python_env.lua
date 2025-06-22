-- Python Environment Management Module
-- Detects miniconda, creates nvim environment, installs dependencies
local M = {}

-- Configuration
M.config = {
    env_name = "nvim",
    conda_paths = {
        "~/miniconda3/bin/conda",
        "~/anaconda3/bin/conda", 
        "/opt/miniconda3/bin/conda",
        "/opt/anaconda3/bin/conda",
        "/usr/local/miniconda3/bin/conda",
        "/usr/local/anaconda3/bin/conda"
    },
    python_packages = {
        "pynvim",
        "black", 
        "isort",
        "flake8",
        "pylsp-mypy",
        "python-lsp-server[all]",
        "jupyterlab",
        "ipython",
        "matplotlib",
        "numpy",
        "pandas"
    }
}

-- Detect conda installation
function M.detect_conda()
    -- Check if conda is in PATH
    if vim.fn.executable("conda") == 1 then
        return vim.fn.exepath("conda")
    end
    
    -- Check common installation paths
    for _, path in ipairs(M.config.conda_paths) do
        local expanded_path = vim.fn.expand(path)
        if vim.fn.executable(expanded_path) == 1 then
            return expanded_path
        end
    end
    
    return nil
end

-- Check if nvim environment exists
function M.env_exists(conda_path)
    local cmd = conda_path .. " env list"
    local output = vim.fn.system(cmd)
    return output:match(M.config.env_name) ~= nil
end

-- Create nvim conda environment
function M.create_env(conda_path)
    print("[PYTHON-ENV] Creating nvim conda environment...")
    print("═" .. string.rep("═", 50))
    print("🏗️  Environment Details:")
    print("   📁 Name: " .. M.config.env_name)
    print("   🐍 Python Version: 3.11")
    print("   📍 Conda Path: " .. conda_path)
    print("")
    
    print("🔄 Creating environment... (this may take a few minutes)")
    local cmd = conda_path .. " create -n " .. M.config.env_name .. " python=3.11 -y"
    
    -- Show spinning indicator
    local spinner = {"|", "/", "-", "\\"}
    local start_time = os.time()
    
    -- Start environment creation in background (simplified for demo)
    local result = vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
        local elapsed = os.time() - start_time
        print(string.format("✅ Environment created successfully in %d seconds", elapsed))
        print("═" .. string.rep("═", 50))
        return true
    else
        print("❌ Failed to create environment:")
        print("   " .. result:gsub("\n", "\n   "))
        print("═" .. string.rep("═", 50))
        return false
    end
end

-- Install Python packages in nvim environment
function M.install_packages(conda_path)
    print("[PYTHON-ENV] Installing Python packages...")
    print("═" .. string.rep("═", 50))
    
    -- Show package list
    print("📦 Packages to install:")
    for i, pkg in ipairs(M.config.python_packages) do
        print(string.format("  %d. %s", i, pkg))
    end
    print("")
    
    -- Install packages one by one for better progress tracking
    local total = #M.config.python_packages
    local success_count = 0
    local failed_packages = {}
    
    for i, package in ipairs(M.config.python_packages) do
        -- Progress indicator
        local progress = math.floor((i - 1) / total * 20)
        local bar = "█" .. string.rep("█", progress) .. string.rep("░", 20 - progress)
        local percent = math.floor((i - 1) / total * 100)
        
        print(string.format("🔄 [%s] %d%% Installing %s...", bar, percent, package))
        
        local cmd = conda_path .. " run -n " .. M.config.env_name .. " pip install " .. package .. " --quiet"
        local result = vim.fn.system(cmd)
        
        if vim.v.shell_error == 0 then
            print(string.format("✅ %s installed successfully", package))
            success_count = success_count + 1
        else
            print(string.format("❌ Failed to install %s: %s", package, result:gsub("\n", " ")))
            table.insert(failed_packages, package)
        end
        
        -- Small delay for visual feedback
        vim.cmd("redraw")
        os.execute("sleep 0.5")
    end
    
    -- Final progress bar
    local final_progress = "█" .. string.rep("█", 20)
    print(string.format("🎯 [%s] 100%% Installation completed!", final_progress))
    print("═" .. string.rep("═", 50))
    
    -- Summary
    print(string.format("📊 Installation Summary:"))
    print(string.format("  ✅ Successful: %d/%d packages", success_count, total))
    print(string.format("  ❌ Failed: %d/%d packages", #failed_packages, total))
    
    if #failed_packages > 0 then
        print("  📋 Failed packages:")
        for _, pkg in ipairs(failed_packages) do
            print("    • " .. pkg)
        end
        print("  💡 Try installing failed packages manually with:")
        print("     conda activate nvim && pip install " .. table.concat(failed_packages, " "))
    end
    
    return success_count == total
end

-- Get Python path from nvim environment
function M.get_python_path(conda_path)
    local cmd = conda_path .. " run -n " .. M.config.env_name .. " which python"
    local python_path = vim.fn.system(cmd):gsub("%s+$", "") -- trim whitespace
    
    if vim.v.shell_error == 0 and vim.fn.executable(python_path) == 1 then
        return python_path
    end
    return nil
end

-- Setup Python environment for nvim
function M.setup()
    print("[PYTHON-ENV] Setting up Python environment...")
    print("═" .. string.rep("═", 60))
    
    local conda_path = M.detect_conda()
    
    if not conda_path then
        print("❌ CONDA NOT FOUND")
        print("═" .. string.rep("═", 60))
        print("🔍 Conda Detection Results:")
        print("   ❌ conda command not found in PATH")
        print("   ❌ No conda installation detected in common locations:")
        for _, path in ipairs(M.config.conda_paths) do
            print("      • " .. path)
        end
        print("")
        
        print("📋 INSTALLATION OPTIONS:")
        print("═" .. string.rep("═", 60))
        print("1️⃣  AUTOMATIC INSTALLATION (Recommended)")
        print("   🚀 Run: :InstallMiniconda")
        print("   ⏱️  Takes: ~5-10 minutes")
        print("   📁 Installs to: ~/miniconda3")
        print("")
        
        print("2️⃣  MANUAL INSTALLATION")
        local os_type = require('portable.detect').os()
        if os_type == "linux" then
            print("   💻 Linux Commands:")
            print("      curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh")
            print("      bash ~/miniconda.sh -b -p ~/miniconda3")
            print("      ~/miniconda3/bin/conda init")
        elseif os_type == "macos" then
            print("   🍎 macOS Commands:")
            print("      curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/miniconda.sh")
            print("      bash ~/miniconda.sh -b -p ~/miniconda3") 
            print("      ~/miniconda3/bin/conda init")
        else
            print("   🪟 Windows: Download installer from https://docs.conda.io/en/latest/miniconda.html")
        end
        print("")
        
        print("3️⃣  PACKAGE MANAGER INSTALLATION")
        if os_type == "linux" then
            print("   🐧 Ubuntu/Debian: sudo apt install conda")
            print("   🔴 RHEL/CentOS: sudo yum install conda")
            print("   🔷 Arch Linux: sudo pacman -S miniconda3")
        elseif os_type == "macos" then
            print("   🍺 Homebrew: brew install miniconda")
        end
        print("")
        
        print("4️⃣  ALTERNATIVE: Use system Python")
        print("   ⚠️  Limited functionality, but will work")
        print("   🐍 Uses system Python instead of isolated environment")
        print("")
        
        print("💡 NEXT STEPS:")
        print("═" .. string.rep("═", 60))
        print("After installing conda:")
        print("  1. Restart your terminal or run: source ~/.bashrc")
        print("  2. Run: :PythonEnvSetup")
        print("  3. Verify with: :PythonEnvStatus")
        print("")
        
        -- Ask if user wants automatic installation
        print("🤖 Would you like to install miniconda automatically?")
        print("   Type 'y' or 'yes' to proceed with automatic installation")
        print("   Or install manually using the commands above")
        
        return false
    end
    
    print("✅ CONDA FOUND")
    print("═" .. string.rep("═", 60))
    print("📍 Conda Details:")
    print("   📁 Path: " .. conda_path)
    print("   🔧 Version: " .. (vim.fn.system(conda_path .. " --version 2>/dev/null"):gsub("\n", "") or "Unknown"))
    print("   🏠 Base Environment: " .. (vim.fn.system("dirname " .. conda_path .. "/../"):gsub("\n", "") or "Unknown"))
    print("")
    
    -- Check if environment exists
    print("🔍 Checking nvim environment...")
    if not M.env_exists(conda_path) then
        print("📥 Creating new nvim environment...")
        if not M.create_env(conda_path) then
            return false
        end
    else
        print("✅ Environment 'nvim' already exists")
    end
    
    -- Install packages
    print("📦 Installing Python packages...")
    if not M.install_packages(conda_path) then
        return false
    end
    
    -- Set Python path
    print("⚙️  Configuring nvim Python host...")
    local python_path = M.get_python_path(conda_path)
    if python_path then
        vim.g.python3_host_prog = python_path
        print("✅ Python host configured: " .. python_path)
        print("═" .. string.rep("═", 60))
        print("🎉 PYTHON ENVIRONMENT SETUP COMPLETE!")
        print("   🐍 Environment: nvim")
        print("   📦 Packages: " .. #M.config.python_packages .. " installed")
        print("   🔗 Nvim integration: Ready")
        return true
    else
        print("❌ Failed to configure Python path")
        return false
    end
end

-- Check current Python environment status
function M.status()
    local conda_path = M.detect_conda()
    local status = {
        conda_installed = conda_path ~= nil,
        conda_path = conda_path,
        env_exists = false,
        python_path = vim.g.python3_host_prog,
        packages_status = {}
    }
    
    if conda_path then
        status.env_exists = M.env_exists(conda_path)
        
        if status.env_exists then
            -- Check package installations
            for _, pkg in ipairs(M.config.python_packages) do
                local cmd = conda_path .. " run -n " .. M.config.env_name .. " pip show " .. pkg
                local result = vim.fn.system(cmd)
                status.packages_status[pkg] = vim.v.shell_error == 0
            end
        end
    end
    
    return status
end

-- Print status information
function M.print_status()
    local status = M.status()
    
    print("Python Environment Status:")
    print("=" .. string.rep("=", 30))
    print("Conda installed: " .. (status.conda_installed and "✓" or "✗"))
    if status.conda_path then
        print("Conda path: " .. status.conda_path)
    end
    print("Nvim env exists: " .. (status.env_exists and "✓" or "✗"))
    print("Python host: " .. (status.python_path or "Not set"))
    
    if status.env_exists then
        print("\nPackage Status:")
        for pkg, installed in pairs(status.packages_status) do
            local mark = installed and "✓" or "✗"
            print("  " .. mark .. " " .. pkg)
        end
    end
end

-- Install miniconda if not present
function M.install_miniconda()
    print("[PYTHON-ENV] 🚀 AUTOMATIC MINICONDA INSTALLATION")
    print("═" .. string.rep("═", 60))
    
    local os_type = require('portable.detect').os()
    local install_script = ""
    local arch = vim.fn.system("uname -m"):gsub("\n", "")
    
    print("🖥️  System Information:")
    print("   💻 Operating System: " .. os_type)
    print("   🏗️  Architecture: " .. arch)
    print("")
    
    if os_type == "linux" then
        if arch:match("aarch64") or arch:match("arm64") then
            install_script = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
        else
            install_script = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
        end
    elseif os_type == "macos" then
        if arch:match("arm64") then
            install_script = "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
        else
            install_script = "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
        end
    else
        print("❌ UNSUPPORTED PLATFORM")
        print("   🚫 Automatic installation not supported on " .. os_type)
        print("   💡 Manual installation required")
        print("   🔗 Download from: https://docs.conda.io/en/latest/miniconda.html")
        return false
    end
    
    local install_path = vim.fn.expand("~/miniconda3")
    local script_path = "/tmp/miniconda_installer.sh"
    
    print("📦 Installation Details:")
    print("   🔗 Download URL: " .. install_script)
    print("   📁 Install Path: " .. install_path)
    print("   📄 Script Path: " .. script_path)
    print("")
    
    -- Check if already exists
    if vim.fn.isdirectory(install_path) == 1 then
        print("⚠️  EXISTING INSTALLATION DETECTED")
        print("   📁 Directory exists: " .. install_path)
        print("   🤔 Would you like to:")
        print("      1. Remove existing and reinstall")
        print("      2. Skip installation and use existing")
        print("   💡 Proceeding with existing installation...")
        return true
    end
    
    print("🔄 INSTALLATION PROCESS")
    print("═" .. string.rep("═", 60))
    
    -- Step 1: Download
    print("📥 Step 1/3: Downloading miniconda installer...")
    local download_cmd = string.format("curl -L -# %s -o %s", install_script, script_path)
    local start_time = os.time()
    
    print("   💻 Command: " .. download_cmd)
    print("   ⏳ Downloading... (this may take 2-5 minutes)")
    
    local download_result = vim.fn.system(download_cmd)
    local download_time = os.time() - start_time
    
    if vim.v.shell_error ~= 0 then
        print("❌ Download failed:")
        print("   " .. download_result:gsub("\n", "\n   "))
        print("   ⏱️  Duration: " .. download_time .. " seconds")
        return false
    end
    
    print("✅ Download completed in " .. download_time .. " seconds")
    
    -- Verify download
    local file_size = vim.fn.system("stat -c%s " .. script_path .. " 2>/dev/null"):gsub("\n", "")
    if file_size and tonumber(file_size) and tonumber(file_size) > 1000000 then
        print("   📊 Downloaded: " .. math.floor(tonumber(file_size) / 1024 / 1024) .. " MB")
    end
    
    -- Step 2: Install
    print("\n🔧 Step 2/3: Installing miniconda...")
    local install_cmd = string.format("bash %s -b -p %s", script_path, install_path)
    start_time = os.time()
    
    print("   💻 Command: " .. install_cmd)
    print("   ⏳ Installing... (this may take 3-8 minutes)")
    
    local install_result = vim.fn.system(install_cmd)
    local install_time = os.time() - start_time
    
    if vim.v.shell_error ~= 0 then
        print("❌ Installation failed:")
        print("   " .. install_result:gsub("\n", "\n   "))
        print("   ⏱️  Duration: " .. install_time .. " seconds")
        return false
    end
    
    print("✅ Installation completed in " .. install_time .. " seconds")
    
    -- Step 3: Initialize
    print("\n⚙️  Step 3/3: Initializing conda...")
    local init_cmd = install_path .. "/bin/conda init"
    start_time = os.time()
    
    print("   💻 Command: " .. init_cmd)
    print("   ⏳ Initializing shell integration...")
    
    local init_result = vim.fn.system(init_cmd)
    local init_time = os.time() - start_time
    
    if vim.v.shell_error ~= 0 then
        print("⚠️  Initialization warning (installation still successful):")
        print("   " .. init_result:gsub("\n", "\n   "))
    else
        print("✅ Initialization completed in " .. init_time .. " seconds")
    end
    
    -- Cleanup
    print("\n🧹 Cleaning up...")
    vim.fn.system("rm -f " .. script_path)
    print("✅ Installer script removed")
    
    -- Final summary
    local total_time = download_time + install_time + init_time
    print("\n" .. "═" .. string.rep("═", 60))
    print("🎉 MINICONDA INSTALLATION COMPLETE!")
    print("═" .. string.rep("═", 60))
    print("📊 Installation Summary:")
    print("   ✅ Status: Successful")
    print("   📁 Location: " .. install_path)
    print("   ⏱️  Total Time: " .. M.format_time(total_time))
    print("   📦 Ready for: Python environment creation")
    print("")
    
    print("🔄 NEXT STEPS:")
    print("   1. Restart your terminal or run: source ~/.bashrc")
    print("   2. Run: :PythonEnvSetup")
    print("   3. Verify with: conda --version")
    print("")
    
    print("💡 Alternative: Reload nvim and run :PortableInstall python")
    
    return true
end

-- Helper function to format time
function M.format_time(seconds)
    if seconds < 60 then
        return string.format("%ds", seconds)
    elseif seconds < 3600 then
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%dm %ds", mins, secs)
    else
        local hours = math.floor(seconds / 3600)
        local mins = math.floor((seconds % 3600) / 60)
        return string.format("%dh %dm", hours, mins)
    end
end

return M