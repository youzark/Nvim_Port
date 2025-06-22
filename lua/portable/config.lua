-- Cross-platform Configuration Module
local detect = require('portable.detect')
local M = {}

-- Cross-platform Python setup
function M.setup_python()
    -- Don't override if already set
    if vim.g.python3_host_prog and vim.fn.executable(vim.g.python3_host_prog) == 1 then
        return
    end
    
    -- Try to find python
    local python_candidates = {"python3", "python"}
    for _, cmd in ipairs(python_candidates) do
        local path = vim.fn.exepath(cmd)
        if path ~= "" then
            vim.g.python3_host_prog = path
            break
        end
    end
end

-- Cross-platform clipboard
function M.setup_clipboard()
    -- Don't override if already configured
    if vim.g.clipboard then return end
    
    local os_type = detect.os()
    
    if os_type == "linux" then
        if vim.fn.executable("xclip") == 1 then
            vim.g.clipboard = {
                name = "xclip",
                copy = { ["+"] = "xclip -i -selection clipboard", ["*"] = "xclip -i -selection clipboard" },
                paste = { ["+"] = "xclip -o -selection clipboard", ["*"] = "xclip -o -selection clipboard" },
                cache_enabled = false,
            }
        elseif vim.fn.executable("wl-copy") == 1 then
            vim.g.clipboard = {
                name = "wl-clipboard",
                copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
                paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
                cache_enabled = false,
            }
        end
    elseif os_type == "macos" then
        if vim.fn.executable("pbcopy") == 1 then
            vim.g.clipboard = {
                name = "pbcopy",
                copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
                paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
                cache_enabled = false,
            }
        end
    elseif os_type == "windows" then
        vim.g.clipboard = {
            name = "win32yank",
            copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
            paste = { ["+"] = "win32yank.exe -o --lf", ["*"] = "win32yank.exe -o --lf" },
            cache_enabled = false,
        }
    end
end

-- Cross-platform applications
function M.setup_applications()
    local os_type = detect.os()
    
    -- PDF viewer for LaTeX
    if not vim.g.vimtex_view_method then
        if os_type == "macos" then
            if vim.fn.executable("skim") == 1 then
                vim.g.vimtex_view_method = "skim"
                vim.g.vimtex_view_skim_sync = 1
                vim.g.vimtex_view_skim_activate = 1
            end
        elseif os_type == "linux" then
            if vim.fn.executable("zathura") == 1 then
                vim.g.vimtex_view_method = "zathura"
            elseif vim.fn.executable("evince") == 1 then
                vim.g.vimtex_view_method = "general"
                vim.g.vimtex_view_general_viewer = "evince"
            end
        end
    end
    
    -- Browser for markdown preview
    if not vim.g.mkdp_browser then
        if os_type == "macos" then
            vim.g.mkdp_browser = "Safari"
        elseif os_type == "linux" then
            if vim.fn.executable("firefox") == 1 then
                vim.g.mkdp_browser = "firefox"
            elseif vim.fn.executable("chromium") == 1 then
                vim.g.mkdp_browser = "chromium"
            end
        end
    end
end

-- Environment-specific optimizations
function M.setup_optimizations()
    local env = detect.environment()
    
    -- Remote server optimizations
    if env.is_remote then
        -- Disable clipboard if no display server
        if not env.has_display then
            vim.opt.clipboard = ""
        end
        
        -- Performance optimizations for remote
        vim.opt.updatetime = 1000
        vim.opt.timeoutlen = 500
        vim.g.loaded_matchparen = 1  -- Disable match parentheses highlighting
    end
    
    -- macOS specific settings
    if env.os == "macos" then
        vim.opt.lazyredraw = true
    end
    
    -- Windows specific settings  
    if env.os == "windows" then
        if vim.fn.has('win32') == 1 then
            vim.opt.shell = 'powershell'
            vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
        end
    end
end

return M