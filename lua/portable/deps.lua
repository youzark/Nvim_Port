-- Dependency Management Module
local detect = require('portable.detect')
local M = {}

-- Dependency definitions
M.dependencies = {
    core = {"git", "curl", "unzip", "make"},
    languages = {"python3", "node", "gcc"},
    tools = {"fzf", "rg", "fd"},
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
        apt = "sudo apt install -y fzf ripgrep fd-find",
        yum = "sudo yum install -y fzf ripgrep fd-find",
        dnf = "sudo dnf install -y fzf ripgrep fd-find",
        pacman = "sudo pacman -S --noconfirm fzf ripgrep fd",
        brew = "brew install fzf ripgrep fd",
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
        print("[PORTABLE] No package manager detected. Please install dependencies manually.")
        return false
    end
    
    local cmd = M.install_commands[category] and M.install_commands[category][pkg_manager]
    if cmd then
        print("[PORTABLE] Installing " .. category .. " dependencies...")
        vim.fn.system(cmd)
        print("[PORTABLE] Installation completed")
        return true
    else
        print("[PORTABLE] No installation command for " .. category .. " on " .. pkg_manager)
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