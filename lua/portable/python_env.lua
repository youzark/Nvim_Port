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
    local conda_path = M.detect_conda()
    
    if not conda_path then
        print("[PYTHON-ENV] Conda not found. Install miniconda/anaconda first")
        print("[PYTHON-ENV] Download from: https://docs.conda.io/en/latest/miniconda.html")
        return false
    end
    
    print("[PYTHON-ENV] Found conda at: " .. conda_path)
    
    -- Check if environment exists
    if not M.env_exists(conda_path) then
        if not M.create_env(conda_path) then
            return false
        end
    else
        print("[PYTHON-ENV] Environment 'nvim' already exists")
    end
    
    -- Install packages
    if not M.install_packages(conda_path) then
        return false
    end
    
    -- Set Python path
    local python_path = M.get_python_path(conda_path)
    if python_path then
        vim.g.python3_host_prog = python_path
        print("[PYTHON-ENV] Python host set to: " .. python_path)
        return true
    else
        print("[PYTHON-ENV] Failed to get Python path")
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
    local os_type = require('portable.detect').os()
    local install_script = ""
    
    if os_type == "linux" then
        install_script = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    elseif os_type == "macos" then
        install_script = "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    else
        print("[PYTHON-ENV] Automatic miniconda installation not supported on " .. os_type)
        print("[PYTHON-ENV] Please install manually from: https://docs.conda.io/en/latest/miniconda.html")
        return false
    end
    
    print("[PYTHON-ENV] Downloading and installing miniconda...")
    local install_path = vim.fn.expand("~/miniconda3")
    local cmd = string.format("curl -L %s -o /tmp/miniconda.sh && bash /tmp/miniconda.sh -b -p %s", 
                             install_script, install_path)
    
    local result = vim.fn.system(cmd)
    if vim.v.shell_error == 0 then
        print("[PYTHON-ENV] Miniconda installed to: " .. install_path)
        print("[PYTHON-ENV] Restart your shell or run: source " .. install_path .. "/bin/activate")
        return true
    else
        print("[PYTHON-ENV] Failed to install miniconda: " .. result)
        return false
    end
end

return M