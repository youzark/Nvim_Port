-- Dependency Management Module
local detect = require('portable.detect')
local M = {}

-- Dependency definitions
M.dependencies = {
    core = {"git", "curl", "unzip", "make"},
    languages = {"python3", "node", "gcc"},
    tools = {"fzf", "rg", "fd", "tree-sitter"},
    optional = {"ranger", "latex", "flameshot"}
}

-- Check dependencies
function M.check()
    local results = {}
    for category, tools in pairs(M.dependencies) do
        results[category] = {}
        for _, tool in ipairs(tools) do
            results[category][tool] = vim.fn.executable(tool) == 1
        end
    end
    return results
end

-- Install commands by OS and package manager
M.install_commands = {
    core = {
        apt = "sudo apt update && sudo apt install -y git curl unzip build-essential",
        yum = "sudo yum install -y git curl unzip gcc gcc-c++ make",
        dnf = "sudo dnf install -y git curl unzip gcc gcc-c++ make",
        pacman = "sudo pacman -S --noconfirm git curl unzip base-devel",
        brew = "brew install git curl",
    },
    languages = {
        apt = "sudo apt install -y python3 python3-pip nodejs npm",
        yum = "sudo yum install -y python3 python3-pip nodejs npm",
        dnf = "sudo dnf install -y python3 python3-pip nodejs npm", 
        pacman = "sudo pacman -S --noconfirm python python-pip nodejs npm",
        brew = "brew install python3 node",
    },
    tools = {
        apt = "sudo apt install -y fzf ripgrep fd-find && npm install -g tree-sitter-cli",
        yum = "sudo yum install -y fzf ripgrep fd-find && npm install -g tree-sitter-cli",
        dnf = "sudo dnf install -y fzf ripgrep fd-find && npm install -g tree-sitter-cli",
        pacman = "sudo pacman -S --noconfirm fzf ripgrep fd tree-sitter-cli",
        brew = "brew install fzf ripgrep fd tree-sitter",
    },
    optional = {
        apt = "sudo apt install -y ranger texlive-full flameshot",
        yum = "sudo yum install -y ranger texlive flameshot",
        dnf = "sudo dnf install -y ranger texlive flameshot",
        pacman = "sudo pacman -S --noconfirm ranger texlive-most flameshot",
        brew = "brew install ranger mactex flameshot",
    }
}

-- Install missing dependencies
function M.install(category)
    local pkg_manager = detect.package_manager()
    
    if pkg_manager == "manual" then
        print("[PORTABLE] ❌ No package manager detected. Please install dependencies manually.")
        return false
    end
    
    local cmd = M.install_commands[category] and M.install_commands[category][pkg_manager]
    if not cmd then
        print("[PORTABLE] ❌ No installation command for " .. category .. " on " .. pkg_manager)
        return false
    end
    
    print("[PORTABLE] Installing " .. category .. " dependencies...")
    print("═" .. string.rep("═", 50))
    print("📦 Dependency Installation Details:")
    print("   🏷️  Category: " .. category)
    print("   🔧 Package Manager: " .. pkg_manager)
    print("   📋 Dependencies: " .. table.concat(M.dependencies[category] or {}, ", "))
    print("   💻 Command: " .. cmd)
    print("")
    
    print("🔄 Installing dependencies... (this may take several minutes)")
    local start_time = os.time()
    local result = vim.fn.system(cmd)
    local elapsed = os.time() - start_time
    
    if vim.v.shell_error == 0 then
        print(string.format("✅ %s dependencies installed successfully in %d seconds", category, elapsed))
        
        -- Verify installation
        print("🔍 Verifying installation...")
        local deps_list = M.dependencies[category] or {}
        local verified = 0
        local failed = {}
        
        for _, dep in ipairs(deps_list) do
            if vim.fn.executable(dep) == 1 then
                print("  ✅ " .. dep .. " - available")
                verified = verified + 1
            else
                print("  ❌ " .. dep .. " - not found")
                table.insert(failed, dep)
            end
        end
        
        print("═" .. string.rep("═", 50))
        print("📊 Installation Verification:")
        print(string.format("  ✅ Available: %d/%d dependencies", verified, #deps_list))
        print(string.format("  ❌ Missing: %d/%d dependencies", #failed, #deps_list))
        
        if #failed > 0 then
            print("  📋 Missing dependencies:")
            for _, dep in ipairs(failed) do
                print("    • " .. dep)
            end
            print("  💡 Some dependencies may need manual installation or PATH configuration")
        end
        
        return true
    else
        print("❌ Failed to install " .. category .. " dependencies:")
        print("   Error: " .. result:gsub("\n", "\n   "))
        print("   Duration: " .. elapsed .. " seconds")
        print("═" .. string.rep("═", 50))
        return false
    end
end

-- Print dependency status
function M.print_status(results)
    print("Portable Dependency Status:")
    print("=" .. string.rep("=", 30))
    
    for category, tools in pairs(results or M.check()) do
        print("\n" .. category:upper() .. ":")
        for tool, installed in pairs(tools) do
            local status = installed and "✓" or "✗"
            print(string.format("  %s %s", status, tool))
        end
    end
end

return M