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
        "ropevim",
        "rope",
        "black", 
        "isort",
        "flake8",
        "pylsp-mypy",
        "python-lsp-server[all]",
        "jupyterlab",
        "ipython",
        "matplotlib",
        "numpy",
        "pandas",
        "jedi",
        "autopep8",
        "yapf"
    }
}

-- Detect conda installation
function M.detect_conda()
    -- Check if conda is in PATH first
    if vim.fn.executable("conda") == 1 then
        return vim.fn.exepath("conda")
    end
    
    -- Check common installation paths
    local all_paths = vim.list_extend({}, M.config.conda_paths)
    
    -- Add more paths including newly installed location
    local extra_paths = {
        "~/miniconda3/condabin/conda",  -- New conda installations use condabin
        "~/miniconda3/bin/conda",
        "~/anaconda3/condabin/conda",
        "~/anaconda3/bin/conda",
        "/usr/local/miniconda3/condabin/conda",
        "/opt/conda/condabin/conda",
        "/opt/conda/bin/conda"
    }
    
    vim.list_extend(all_paths, extra_paths)
    
    for _, path in ipairs(all_paths) do
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

-- Check which packages are missing
function M.check_missing_packages(conda_path)
    local missing = {}
    for _, package in ipairs(M.config.python_packages) do
        local cmd = conda_path .. " run -n " .. M.config.env_name .. " pip show " .. package .. " >/dev/null 2>&1"
        if vim.fn.system(cmd) ~= 0 then
            table.insert(missing, package)
        end
    end
    return missing
end

-- Create nvim conda environment
function M.create_env(conda_path)
    local cmd = conda_path .. " create -n " .. M.config.env_name .. " python=3.11 -y"
    local start_time = os.time()
    
    local result = vim.fn.system(cmd)
    local elapsed = os.time() - start_time
    
    if vim.v.shell_error == 0 then
        print(string.format("✅ Environment created (%ds)", elapsed))
        return true
    else
        print(string.format("❌ Environment creation failed (%ds): %s", elapsed, result:gsub("\n", " ")))
        return false
    end
end

-- Install Python packages in nvim environment
function M.install_packages(conda_path)
    local total = #M.config.python_packages
    local success_count = 0
    local failed_packages = {}
    local start_time = os.time()
    
    -- Install all packages in one command for speed
    local packages_str = table.concat(M.config.python_packages, " ")
    local cmd = conda_path .. " run -n " .. M.config.env_name .. " pip install " .. packages_str .. " --quiet"
    
    print(string.format("📦 Installing %d packages...", total))
    local result = vim.fn.system(cmd)
    local elapsed = os.time() - start_time
    
    if vim.v.shell_error == 0 then
        print(string.format("✅ All packages installed (%ds)", elapsed))
        return true
    else
        print(string.format("⚠️  Batch install failed (%ds), trying individual packages...", elapsed))
        
        -- Fall back to individual installation
        for i, package in ipairs(M.config.python_packages) do
            local percent = math.floor(i / total * 100)
            io.write(string.format("\r📥 [%d%%] %s", percent, package))
            
            local single_cmd = conda_path .. " run -n " .. M.config.env_name .. " pip install " .. package .. " --quiet"
            local single_result = vim.fn.system(single_cmd)
            
            if vim.v.shell_error == 0 then
                success_count = success_count + 1
            else
                table.insert(failed_packages, package)
            end
        end
        
        -- Clear progress line and show summary
        print(string.format("\r✅ Installed %d/%d packages", success_count, total))
        
        if #failed_packages > 0 then
            print("❌ Failed: " .. table.concat(failed_packages, ", "))
        end
        
        return success_count > 0
    end
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
    print("[PYTHON-ENV] 🔍 Checking Python environment... (streamlined v2)")
    
    local conda_path = M.detect_conda()
    
    -- Step 1: Check/Install conda
    if not conda_path then
        print("❌ Conda not found, installing miniconda...")
        if not M.install_miniconda() then
            print("❌ Miniconda installation failed")
            return false
        end
        -- Re-detect after installation
        conda_path = M.detect_conda()
        if not conda_path then
            print("❌ Conda still not found after installation")
            return false
        end
    end
    print("✅ Conda found: " .. conda_path)
    
    -- Step 2: Check/Create environment
    if not M.env_exists(conda_path) then
        print("📦 Creating 'nvim' environment...")
        if not M.create_env(conda_path) then
            print("❌ Environment creation failed")
            return false
        end
    end
    print("✅ Environment 'nvim' ready")
    
    -- Step 3: Check/Install packages
    local missing_packages = M.check_missing_packages(conda_path)
    if #missing_packages > 0 then
        print("📥 Installing " .. #missing_packages .. " missing packages...")
        if not M.install_packages(conda_path) then
            print("⚠️  Some packages failed to install")
        end
    end
    print("✅ Python packages ready")
    
    -- Step 4: Configure Python host
    local python_path = M.get_python_path(conda_path)
    if python_path then
        -- Set Python host for current session
        vim.g.python3_host_prog = python_path
        
        -- Also ensure it's set early in init for persistence
        local config_dir = vim.fn.stdpath('config')
        local python_config_file = config_dir .. '/lua/portable/python_host.lua'
        
        -- Create persistent configuration
        local python_config_content = string.format([[-- Auto-generated Python host configuration
-- This file is managed by portable/python_env.lua
vim.g.python3_host_prog = %q
]], python_path)
        
        -- Write the file
        local file = io.open(python_config_file, 'w')
        if file then
            file:write(python_config_content)
            file:close()
            print("✅ Python host configured: " .. python_path)
            print("💾 Configuration saved for persistence")
        else
            print("✅ Python host configured: " .. python_path)
            print("⚠️  Could not save persistent configuration")
        end
    else
        print("❌ Failed to get Python path from conda environment")
        return false
    end
    
    print("🎉 Python environment setup complete!")
    return true
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
    local arch = vim.fn.system("uname -m"):gsub("\n", "")
    local install_script = ""
    
    -- Determine download URL
    if os_type == "linux" then
        install_script = arch:match("aarch64") and 
            "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh" or
            "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    elseif os_type == "macos" then
        install_script = arch:match("arm64") and
            "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh" or
            "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    else
        print("❌ Automatic installation not supported on " .. os_type)
        print("💡 Manual install: https://docs.conda.io/en/latest/miniconda.html")
        return false
    end
    
    local install_path = vim.fn.expand("~/miniconda3")
    local script_path = "/tmp/miniconda_installer.sh"
    
    -- Check if already exists
    if vim.fn.isdirectory(install_path) == 1 then
        print("✅ Miniconda already exists at " .. install_path)
        return true
    end
    
    print("📥 Downloading miniconda (" .. os_type .. "/" .. arch .. ")...")
    local download_cmd = string.format("curl -L -s %s -o %s", install_script, script_path)
    local start_time = os.time()
    
    local download_result = vim.fn.system(download_cmd)
    local download_time = os.time() - start_time
    
    if vim.v.shell_error ~= 0 then
        print(string.format("❌ Download failed (%ds): %s", download_time, download_result:gsub("\n", " ")))
        return false
    end
    
    print(string.format("✅ Downloaded (%ds)", download_time))
    
    -- Install
    print("🔧 Installing miniconda...")
    local install_cmd = string.format("bash %s -b -p %s", script_path, install_path)
    start_time = os.time()
    
    local install_result = vim.fn.system(install_cmd)
    local install_time = os.time() - start_time
    
    if vim.v.shell_error ~= 0 then
        print(string.format("❌ Installation failed (%ds): %s", install_time, install_result:gsub("\n", " ")))
        return false
    end
    
    print(string.format("✅ Installed (%ds)", install_time))
    
    -- Initialize conda
    print("⚙️  Initializing conda...")
    local init_cmd = install_path .. "/bin/conda init"
    vim.fn.system(init_cmd .. " 2>/dev/null")
    
    -- Also try to add to current session PATH
    local conda_bin = install_path .. "/bin"
    local conda_condabin = install_path .. "/condabin"
    local current_path = vim.env.PATH or ""
    
    -- Update PATH for current session
    if not current_path:match(conda_bin) then
        vim.env.PATH = conda_condabin .. ":" .. conda_bin .. ":" .. current_path
    end
    
    -- Cleanup
    vim.fn.system("rm -f " .. script_path)
    
    local total_time = download_time + install_time
    print(string.format("✅ Miniconda installed successfully (%ds total)", total_time))
    
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