-- Cross-platform Configuration Module
local detect = require('portable.detect')
local M = {}

-- Cross-platform Python setup
function M.setup_python()
    -- First try to load persistent Python host configuration
    local config_dir = vim.fn.stdpath('config')
    local python_config_file = config_dir .. '/lua/portable/python_host.lua'
    
    if vim.fn.filereadable(python_config_file) == 1 then
        local success, err = pcall(dofile, python_config_file)
        if success and vim.g.python3_host_prog and vim.fn.executable(vim.g.python3_host_prog) == 1 then
            return  -- Successfully loaded persistent configuration
        end
    end
    
    -- Don't override if already set and working
    if vim.g.python3_host_prog and vim.fn.executable(vim.g.python3_host_prog) == 1 then
        return
    end
    
    -- Try miniconda nvim environment first
    local python_env = require('portable.python_env')
    local conda_path = python_env.detect_conda()
    if conda_path and python_env.env_exists(conda_path) then
        local nvim_python = python_env.get_python_path(conda_path)
        if nvim_python then
            vim.g.python3_host_prog = nvim_python
            return
        end
    end
    
    -- Fallback to system python
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

-- Check and install tree-sitter if missing
function M.setup_treesitter()
    if vim.fn.executable("tree-sitter") == 0 then
        -- Try to install via npm if available
        if vim.fn.executable("npm") == 1 then
            vim.schedule(function()
                vim.notify("Installing tree-sitter CLI via npm...", vim.log.levels.INFO)
                vim.fn.system("npm install -g tree-sitter-cli")
                if vim.fn.executable("tree-sitter") == 1 then
                    vim.notify("tree-sitter CLI installed successfully!", vim.log.levels.INFO)
                else
                    vim.notify("tree-sitter CLI installation failed. Run :PortableInstall tools", vim.log.levels.WARN)
                end
            end)
        else
            vim.schedule(function()
                vim.notify("tree-sitter CLI missing. Install nodejs/npm first, then run :PortableInstall tools", vim.log.levels.WARN)
            end)
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