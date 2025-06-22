-- Arch Linux-specific enhancements
-- Add "require('portable.arch')" to init.lua on Arch systems

local M = {}

function M.setup()
    -- Check if we're on Arch
    if not vim.fn.filereadable("/etc/arch-release") then
        return
    end
    
    -- Clipboard for X11/Wayland
    if os.getenv("WAYLAND_DISPLAY") and vim.fn.executable("wl-copy") == 1 then
        vim.g.clipboard = {
            name = "wl-clipboard",
            copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
            paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
            cache_enabled = false,
        }
    elseif os.getenv("DISPLAY") and vim.fn.executable("xclip") == 1 then
        vim.g.clipboard = {
            name = "xclip",
            copy = { ["+"] = "xclip -i -selection clipboard", ["*"] = "xclip -i -selection clipboard" },
            paste = { ["+"] = "xclip -o -selection clipboard", ["*"] = "xclip -o -selection clipboard" },
            cache_enabled = false,
        }
    end
    
    -- PDF viewer
    if not vim.g.vimtex_view_method then
        if vim.fn.executable("zathura") == 1 then
            vim.g.vimtex_view_method = "zathura"
        elseif vim.fn.executable("evince") == 1 then
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_general_viewer = "evince"
        end
    end
    
    -- Browser
    if not vim.g.mkdp_browser then
        if vim.fn.executable("firefox") == 1 then
            vim.g.mkdp_browser = "firefox"
        elseif vim.fn.executable("chromium") == 1 then
            vim.g.mkdp_browser = "chromium"
        end
    end
    
    -- Screenshot with flameshot
    if vim.fn.executable("flameshot") == 1 then
        vim.api.nvim_create_user_command("Screenshot", function()
            local filename = vim.fn.input("Screenshot filename: ")
            if filename ~= "" then
                local dir = vim.fn.getcwd() .. "/img"
                vim.fn.mkdir(dir, "p")
                vim.fn.system("flameshot gui --path " .. vim.fn.shellescape(dir) .. " --filename " .. vim.fn.shellescape(filename))
            end
        end, { desc = "Take screenshot using flameshot" })
    end
    
    -- Pacman integration
    vim.api.nvim_create_user_command("PacInstall", function(args)
        local packages = args.args
        if packages ~= "" then
            vim.fn.system("sudo pacman -S " .. packages)
        end
    end, { nargs = "+", desc = "Install packages with pacman" })
    
    print("[PORTABLE] Arch Linux enhancements loaded")
end

M.setup()
return M