-- macOS-specific enhancements
-- Add "require('portable.macos')" to init.lua on macOS systems

local M = {}

function M.setup()
    -- macOS-specific settings
    if vim.loop.os_uname().sysname ~= "Darwin" then
        return
    end
    
    -- PDF viewer
    if not vim.g.vimtex_view_method and vim.fn.executable("skim") == 1 then
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1
    end
    
    -- Browser
    if not vim.g.mkdp_browser then
        vim.g.mkdp_browser = "Safari"
    end
    
    -- Clipboard (usually works by default on macOS)
    if vim.fn.executable("pbcopy") == 1 then
        vim.g.clipboard = {
            name = "pbcopy",
            copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
            paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
            cache_enabled = false,
        }
    end
    
    -- Screenshot support
    vim.api.nvim_create_user_command("Screenshot", function()
        local filename = vim.fn.input("Screenshot filename: ")
        if filename ~= "" then
            local path = vim.fn.getcwd() .. "/img/" .. filename .. ".png"
            vim.fn.mkdir(vim.fn.getcwd() .. "/img", "p")
            vim.fn.system("screencapture -i " .. vim.fn.shellescape(path))
        end
    end, { desc = "Take screenshot using screencapture" })
    
    print("[PORTABLE] macOS enhancements loaded")
end

M.setup()
return M