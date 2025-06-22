-- Portable Commands Module
local detect = require('portable.detect')
local deps = require('portable.deps')
local python_env = require('portable.python_env')
local tool_manager = require('portable.tool_manager')
local M = {}

-- Setup all portable commands
function M.setup()
    -- Check dependencies
    vim.api.nvim_create_user_command("PortableCheck", function()
        deps.print_status()
        print("\n")
        python_env.print_status()
        print("\n")
        tool_manager.print_status()
    end, { desc = "Check portable dependencies" })
    
    -- Install dependencies
    vim.api.nvim_create_user_command("PortableInstall", function(args)
        local category = args.args ~= "" and args.args or "core"
        
        if category == "python" then
            python_env.setup()
        elseif category == "essentials" then
            tool_manager.install_essentials()
        elseif tool_manager.presets[category] then
            tool_manager.install_preset(category)
        else
            deps.install(category)
        end
    end, {
        nargs = "?",
        complete = function() 
            return {"core", "languages", "tools", "optional", "python", "essentials", "web_dev", "data_science", "latex", "minimal"}
        end,
        desc = "Install portable dependencies"
    })
    
    -- Environment info
    vim.api.nvim_create_user_command("PortableInfo", function()
        local env = detect.environment()
        
        print("Portable Environment Info:")
        print("=" .. string.rep("=", 30))
        print("OS: " .. env.os .. " (" .. env.arch .. ")")
        print("Package Manager: " .. env.package_manager)
        print("Remote: " .. (env.is_remote and "Yes" or "No"))
        print("Display: " .. (env.has_display and "Yes" or "No"))
        print("WSL: " .. (env.is_wsl and "Yes" or "No"))
        print("Python: " .. (vim.g.python3_host_prog or "not configured"))
        print("Clipboard: " .. (vim.g.clipboard and vim.g.clipboard.name or "default"))
        print("PDF Viewer: " .. (vim.g.vimtex_view_method or "not configured"))
        print("Browser: " .. (vim.g.mkdp_browser or "not configured"))
    end, { desc = "Show portable environment info" })
    
    -- Setup portable enhancements
    vim.api.nvim_create_user_command("PortableSetup", function()
        require('portable').setup()
        print("[PORTABLE] Enhancements applied to current session")
    end, { desc = "Apply portable enhancements" })
    
    -- Show portable status
    vim.api.nvim_create_user_command("PortableStatus", function()
        local enabled = _G.nvim_portable ~= nil
        print("Portable Status: " .. (enabled and "ENABLED" or "DISABLED"))
        if enabled then
            print("OS: " .. _G.nvim_portable.os)
            print("Package Manager: " .. _G.nvim_portable.package_manager)
        end
    end, { desc = "Show portable system status" })
    
    -- Python environment commands
    vim.api.nvim_create_user_command('PythonEnvSetup', function()
        python_env.setup()
    end, { desc = 'Setup Python environment with miniconda' })
    
    vim.api.nvim_create_user_command('PythonEnvStatus', function()
        python_env.print_status()
    end, { desc = 'Show Python environment status' })
    
    vim.api.nvim_create_user_command('InstallMiniconda', function()
        python_env.install_miniconda()
    end, { desc = 'Install miniconda automatically' })
    
    -- Tool manager commands
    vim.api.nvim_create_user_command('ToolInstall', function(opts)
        local tool = opts.args
        if tool == "" then
            print("Usage: :ToolInstall <tool_name>")
            print("Available tools: npm, luarocks, ranger, ripgrep, fd, fzf, latex")
            return
        end
        tool_manager.install_tool(tool)
    end, {
        nargs = 1,
        complete = function() 
            local tools = {}
            for name, _ in pairs(tool_manager.tools) do
                table.insert(tools, name)
            end
            return tools
        end,
        desc = 'Install specific tool'
    })
    
    vim.api.nvim_create_user_command('ToolPackages', function(opts)
        local tool = opts.args
        if tool == "" then
            print("Usage: :ToolPackages <tool_name>")
            print("Available: npm, luarocks")
            return
        end
        tool_manager.install_packages(tool)
    end, {
        nargs = 1,
        complete = function() return {"npm", "luarocks"} end,
        desc = 'Install packages for specific tool'
    })
    
    -- Quick setup commands
    vim.api.nvim_create_user_command('QuickSetup', function(opts)
        local preset = opts.args or "essentials"
        
        print("[QUICK-SETUP] Setting up " .. preset .. " environment...")
        
        -- Install tools first
        if preset == "python" then
            python_env.setup()
        elseif preset == "full" then
            tool_manager.install_essentials()
            deps.install("core")
            deps.install("languages") 
            deps.install("tools")
            python_env.setup()
        else
            if tool_manager.presets[preset] then
                tool_manager.install_preset(preset)
            else
                tool_manager.install_essentials()
            end
        end
        
        print("[QUICK-SETUP] Setup completed for " .. preset)
    end, {
        nargs = '?',
        complete = function() 
            return {"essentials", "python", "web_dev", "data_science", "latex", "minimal", "full"}
        end,
        desc = 'Quick setup for common environments'
    })
end

return M