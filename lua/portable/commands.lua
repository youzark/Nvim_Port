-- Portable Commands Module
local detect = require('portable.detect')
local deps = require('portable.deps')
local M = {}

-- Setup all portable commands
function M.setup()
    -- Check dependencies
    vim.api.nvim_create_user_command("PortableCheck", function()
        deps.print_status()
    end, { desc = "Check portable dependencies" })
    
    -- Install dependencies
    vim.api.nvim_create_user_command("PortableInstall", function(args)
        local category = args.args ~= "" and args.args or "core"
        deps.install(category)
    end, {
        nargs = "?",
        complete = function() return {"core", "languages", "tools", "optional"} end,
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
end

return M