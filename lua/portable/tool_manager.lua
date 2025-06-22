-- Tool Manager Module
-- Manages installation of luarocks, npm packages, ranger, and other tools
local M = {}

-- Tool configurations
M.tools = {
    luarocks = {
        check_cmd = "luarocks --version",
        install_cmds = {
            apt = "sudo apt install -y luarocks",
            yum = "sudo yum install -y luarocks",
            dnf = "sudo dnf install -y luarocks", 
            pacman = "sudo pacman -S --noconfirm luarocks",
            brew = "brew install luarocks"
        },
        packages = {
            "luacheck",
            "luaformatter", 
            "lanes",
            "luasocket",
            "luafilesystem"
        }
    },
    
    npm = {
        check_cmd = "npm --version",
        install_cmds = {
            apt = "sudo apt install -y nodejs npm",
            yum = "sudo yum install -y nodejs npm",
            dnf = "sudo dnf install -y nodejs npm",
            pacman = "sudo pacman -S --noconfirm nodejs npm",
            brew = "brew install node"
        },
        packages = {
            "tree-sitter-cli",
            "neovim",
            "typescript",
            "typescript-language-server",
            "bash-language-server",
            "yaml-language-server",
            "vscode-langservers-extracted",
            "prettier",
            "eslint"
        }
    },
    
    ranger = {
        check_cmd = "ranger --version",
        install_cmds = {
            apt = "sudo apt install -y ranger",
            yum = "sudo yum install -y ranger",
            dnf = "sudo dnf install -y ranger",
            pacman = "sudo pacman -S --noconfirm ranger",
            brew = "brew install ranger"
        },
        config_setup = function()
            local ranger_dir = vim.fn.expand("~/.config/ranger")
            if vim.fn.isdirectory(ranger_dir) == 0 then
                vim.fn.mkdir(ranger_dir, "p")
            end
            
            -- Create basic ranger config
            local rc_path = ranger_dir .. "/rc.conf"
            if vim.fn.filereadable(rc_path) == 0 then
                local config = [[
# Ranger configuration for nvim integration
set preview_images true
set use_preview_script true
set automatically_count_files true
set open_all_images true
set vcs_aware true
set vcs_backend_git enabled
set draw_borders both
]]
                vim.fn.writefile(vim.split(config, "\n"), rc_path)
                print("[TOOL-MANAGER] Created ranger config at: " .. rc_path)
            end
        end
    },
    
    ripgrep = {
        check_cmd = "rg --version",
        install_cmds = {
            apt = "sudo apt install -y ripgrep",
            yum = "sudo yum install -y ripgrep",
            dnf = "sudo dnf install -y ripgrep",
            pacman = "sudo pacman -S --noconfirm ripgrep",
            brew = "brew install ripgrep"
        }
    },
    
    fd = {
        check_cmd = "fd --version",
        install_cmds = {
            apt = "sudo apt install -y fd-find",
            yum = "sudo yum install -y fd-find",
            dnf = "sudo dnf install -y fd-find",
            pacman = "sudo pacman -S --noconfirm fd",
            brew = "brew install fd"
        }
    },
    
    fzf = {
        check_cmd = "fzf --version",
        install_cmds = {
            apt = "sudo apt install -y fzf",
            yum = "sudo yum install -y fzf",
            dnf = "sudo dnf install -y fzf",
            pacman = "sudo pacman -S --noconfirm fzf",
            brew = "brew install fzf"
        },
        post_install = function()
            -- Install fzf shell integration
            local fzf_script = vim.fn.expand("~/.fzf.bash")
            if vim.fn.filereadable(fzf_script) == 0 then
                vim.fn.system("$(fzf --print-completion bash) > ~/.fzf.bash")
                print("[TOOL-MANAGER] FZF shell integration installed")
            end
        end
    },
    
    latex = {
        check_cmd = "latex --version",
        install_cmds = {
            apt = "sudo apt install -y texlive-full",
            yum = "sudo yum install -y texlive",
            dnf = "sudo dnf install -y texlive",
            pacman = "sudo pacman -S --noconfirm texlive-most texlive-lang",
            brew = "brew install --cask mactex"
        }
    }
}

-- Check if a tool is installed
function M.is_installed(tool_name)
    local tool = M.tools[tool_name]
    if not tool then return false end
    
    return vim.fn.system(tool.check_cmd .. " 2>/dev/null") ~= ""
end

-- Install a tool using package manager
function M.install_tool(tool_name)
    local tool = M.tools[tool_name]
    if not tool then
        print("[TOOL-MANAGER] ❌ Unknown tool: " .. tool_name)
        return false
    end
    
    local pkg_manager = require('portable.detect').package_manager()
    local install_cmd = tool.install_cmds[pkg_manager]
    
    if not install_cmd then
        print("[TOOL-MANAGER] ❌ No installation command for " .. tool_name .. " on " .. pkg_manager)
        return false
    end
    
    print("[TOOL-MANAGER] Installing " .. tool_name .. "...")
    print("═" .. string.rep("═", 50))
    print("🛠️  Tool Details:")
    print("   📦 Tool: " .. tool_name)
    print("   🔧 Package Manager: " .. pkg_manager)
    print("   💻 Command: " .. install_cmd)
    print("")
    
    print("🔄 Installing " .. tool_name .. "... (please wait)")
    local start_time = os.time()
    local result = vim.fn.system(install_cmd)
    local elapsed = os.time() - start_time
    
    if vim.v.shell_error == 0 then
        print(string.format("✅ %s installed successfully in %d seconds", tool_name, elapsed))
        
        -- Run post-install setup if available
        if tool.post_install then
            print("🔧 Running post-install setup...")
            tool.post_install()
            print("✅ Post-install setup completed")
        end
        if tool.config_setup then
            print("⚙️  Setting up configuration...")
            tool.config_setup()
            print("✅ Configuration setup completed")
        end
        
        print("═" .. string.rep("═", 50))
        return true
    else
        print("❌ Failed to install " .. tool_name .. ":")
        print("   Error: " .. result:gsub("\n", "\n   "))
        print("   Duration: " .. elapsed .. " seconds")
        print("═" .. string.rep("═", 50))
        return false
    end
end

-- Install packages for a tool (like npm packages or luarocks)
function M.install_packages(tool_name)
    local tool = M.tools[tool_name]
    if not tool or not tool.packages then
        print("[TOOL-MANAGER] ❌ No packages defined for " .. tool_name)
        return false
    end
    
    if not M.is_installed(tool_name) then
        print("[TOOL-MANAGER] " .. tool_name .. " not installed. Installing first...")
        if not M.install_tool(tool_name) then
            return false
        end
    end
    
    print("[TOOL-MANAGER] Installing " .. tool_name .. " packages...")
    print("═" .. string.rep("═", 50))
    
    -- Show package list
    print("📦 Packages to install for " .. tool_name .. ":")
    for i, pkg in ipairs(tool.packages) do
        print(string.format("  %d. %s", i, pkg))
    end
    print("")
    
    local total = #tool.packages
    local success_count = 0
    local failed_packages = {}
    
    for i, package in ipairs(tool.packages) do
        -- Progress indicator
        local progress = math.floor((i - 1) / total * 20)
        local bar = "█" .. string.rep("█", progress) .. string.rep("░", 20 - progress)
        local percent = math.floor((i - 1) / total * 100)
        
        local cmd = ""
        if tool_name == "npm" then
            cmd = "npm install -g " .. package
        elseif tool_name == "luarocks" then
            cmd = "luarocks install " .. package
        end
        
        if cmd ~= "" then
            print(string.format("🔄 [%s] %d%% Installing %s...", bar, percent, package))
            
            local start_time = os.time()
            local result = vim.fn.system(cmd)
            local elapsed = os.time() - start_time
            
            if vim.v.shell_error == 0 then
                print(string.format("✅ %s installed successfully (%ds)", package, elapsed))
                success_count = success_count + 1
            else
                print(string.format("❌ Failed to install %s (%ds): %s", package, elapsed, result:gsub("\n", " ")))
                table.insert(failed_packages, package)
            end
            
            -- Visual feedback
            vim.cmd("redraw")
            os.execute("sleep 0.3")
        end
    end
    
    -- Final progress bar
    local final_progress = "█" .. string.rep("█", 20)
    print(string.format("🎯 [%s] 100%% Package installation completed!", final_progress))
    print("═" .. string.rep("═", 50))
    
    -- Summary
    print(string.format("📊 Package Installation Summary for %s:", tool_name))
    print(string.format("  ✅ Successful: %d/%d packages", success_count, total))
    print(string.format("  ❌ Failed: %d/%d packages", #failed_packages, total))
    
    if #failed_packages > 0 then
        print("  📋 Failed packages:")
        for _, pkg in ipairs(failed_packages) do
            print("    • " .. pkg)
        end
        print("  💡 Try installing failed packages manually with:")
        if tool_name == "npm" then
            print("     npm install -g " .. table.concat(failed_packages, " "))
        elseif tool_name == "luarocks" then
            print("     luarocks install " .. table.concat(failed_packages, " "))
        end
    end
    
    return success_count == total
end

-- Check status of all tools
function M.check_all()
    local status = {}
    for tool_name, _ in pairs(M.tools) do
        status[tool_name] = M.is_installed(tool_name)
    end
    return status
end

-- Print status of all tools
function M.print_status()
    print("Tool Manager Status:")
    print("=" .. string.rep("=", 30))
    
    local status = M.check_all()
    for tool_name, installed in pairs(status) do
        local mark = installed and "✓" or "✗"
        print("  " .. mark .. " " .. tool_name)
    end
end

-- Install all essential tools
function M.install_essentials()
    local essential_tools = {"npm", "luarocks", "ripgrep", "fd", "fzf", "ranger"}
    
    print("[TOOL-MANAGER] Installing essential tools...")
    print("═" .. string.rep("═", 60))
    print("🎯 Essential Tools Installation Plan:")
    for i, tool in ipairs(essential_tools) do
        local status = M.is_installed(tool) and "✅ Already installed" or "📥 Will install"
        print(string.format("  %d. %s - %s", i, tool, status))
    end
    print("")
    
    local total_tools = #essential_tools
    local installed_count = 0
    local failed_tools = {}
    
    -- Install each tool
    for i, tool in ipairs(essential_tools) do
        local progress = math.floor((i - 1) / total_tools * 20)
        local bar = "█" .. string.rep("█", progress) .. string.rep("░", 20 - progress)
        local percent = math.floor((i - 1) / total_tools * 100)
        
        print(string.format("🔄 [%s] %d%% Processing %s...", bar, percent, tool))
        
        if not M.is_installed(tool) then
            if M.install_tool(tool) then
                installed_count = installed_count + 1
            else
                table.insert(failed_tools, tool)
            end
        else
            print("✅ " .. tool .. " already installed")
            installed_count = installed_count + 1
        end
        
        vim.cmd("redraw")
        os.execute("sleep 0.5")
    end
    
    -- Final progress
    local final_progress = "█" .. string.rep("█", 20)
    print(string.format("🎯 [%s] 100%% Tool installation phase completed!", final_progress))
    print("")
    
    -- Install packages for npm and luarocks if they're available
    if M.is_installed("npm") then
        print("📦 Installing NPM packages...")
        M.install_packages("npm")
    end
    
    if M.is_installed("luarocks") then
        print("📦 Installing Luarocks packages...")
        M.install_packages("luarocks")
    end
    
    -- Final summary
    print("═" .. string.rep("═", 60))
    print("📊 Essential Tools Installation Summary:")
    print(string.format("  ✅ Successfully installed: %d/%d tools", installed_count, total_tools))
    print(string.format("  ❌ Failed: %d/%d tools", #failed_tools, total_tools))
    
    if #failed_tools > 0 then
        print("  📋 Failed tools:")
        for _, tool in ipairs(failed_tools) do
            print("    • " .. tool)
        end
    end
    
    return #failed_tools == 0
end

-- Quick setup for specific use cases
M.presets = {
    web_dev = {"npm", "fzf", "ripgrep", "fd"},
    data_science = {"ranger", "fzf", "ripgrep"},
    latex = {"latex", "fzf", "ripgrep", "fd"},
    minimal = {"fzf", "ripgrep"}
}

function M.install_preset(preset_name)
    local tools = M.presets[preset_name]
    if not tools then
        print("[TOOL-MANAGER] Unknown preset: " .. preset_name)
        return false
    end
    
    print("[TOOL-MANAGER] Installing " .. preset_name .. " preset...")
    local success = true
    
    for _, tool in ipairs(tools) do
        if not M.is_installed(tool) then
            if not M.install_tool(tool) then
                success = false
            end
        end
    end
    
    return success
end

return M