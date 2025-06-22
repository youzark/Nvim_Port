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

-- Cross-platform clipboard with unified register behavior
function M.setup_clipboard()
    local env = detect.environment()
    local os_type = env.os
    
    -- Always set clipboard to unnamed and unnamedplus for unified behavior
    -- This makes yank/delete operations automatically use system clipboard
    vim.opt.clipboard = "unnamed,unnamedplus"
    
    -- Don't override if already configured
    if vim.g.clipboard then return end
    
    -- Smart detection for clipboard strategy
    local function get_clipboard_strategy()
        local is_docker = os.getenv("container") == "docker" or vim.fn.filereadable("/.dockerenv") == 1
        local is_ssh = os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_CLIENT") ~= nil
        local has_display = os.getenv("DISPLAY") ~= nil and os.getenv("DISPLAY") ~= ""
        
        -- Test if we can actually use X11 clipboard
        local x11_works = false
        if has_display and vim.fn.executable("xclip") == 1 then
            local result = vim.fn.system("timeout 2s xclip -o -selection clipboard 2>/dev/null")
            x11_works = vim.v.shell_error == 0
        end
        
        -- Strategy 1: Docker with host X11 forwarding
        if is_docker and has_display then
            if x11_works then
                return "x11_forwarded"  -- Docker can access host X11
            else
                return "host_bridge"    -- Need to bridge to host clipboard
            end
        end
        
        -- Strategy 2: SSH with X11 forwarding (working)
        if is_ssh and x11_works then
            return "x11_forwarded"
        end
        
        -- Strategy 3: Local system with working display
        if x11_works then
            return "local_x11"
        end
        
        -- Strategy 4: Fallback to internal clipboard
        return "internal"
    end
    
    local strategy = get_clipboard_strategy()
    
    if strategy == "host_bridge" then
        -- Docker without X11 access - try to bridge to host clipboard
        local host_clipboard_file = "/tmp/nvim_clipboard_bridge.txt"
        vim.g.clipboard = {
            name = "host-bridge",
            copy = {
                ["+"] = function(lines)
                    local content = table.concat(lines, '\n')
                    -- Try to write to host-accessible location
                    local file = io.open(host_clipboard_file, 'w')
                    if file then
                        file:write(content)
                        file:close()
                        -- Try to sync with host clipboard if nsenter is available
                        vim.fn.system("timeout 3s nsenter -t 1 -m -p xclip -i -selection clipboard < " .. host_clipboard_file .. " 2>/dev/null || true")
                    end
                end,
                ["*"] = function(lines)
                    local content = table.concat(lines, '\n')
                    local file = io.open(host_clipboard_file, 'w')
                    if file then
                        file:write(content)
                        file:close()
                        vim.fn.system("timeout 3s nsenter -t 1 -m -p xclip -i -selection clipboard < " .. host_clipboard_file .. " 2>/dev/null || true")
                    end
                end
            },
            paste = {
                ["+"] = function()
                    -- Try to get from host clipboard first
                    vim.fn.system("timeout 3s nsenter -t 1 -m -p xclip -o -selection clipboard > " .. host_clipboard_file .. " 2>/dev/null || true")
                    local file = io.open(host_clipboard_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        if content and content ~= "" then
                            return vim.split(content, '\n', {plain = true})
                        end
                    end
                    return {}
                end,
                ["*"] = function()
                    vim.fn.system("timeout 3s nsenter -t 1 -m -p xclip -o -selection clipboard > " .. host_clipboard_file .. " 2>/dev/null || true")
                    local file = io.open(host_clipboard_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        if content and content ~= "" then
                            return vim.split(content, '\n', {plain = true})
                        end
                    end
                    return {}
                end
            },
            cache_enabled = false,
        }
        return
    elseif strategy == "internal" then
        -- Use internal clipboard that works across nvim sessions via temp file
        local tmp_file = vim.fn.stdpath('cache') .. '/clipboard.txt'
        vim.g.clipboard = {
            name = "internal-file",
            copy = {
                ["+"] = function(lines) 
                    local file = io.open(tmp_file, 'w')
                    if file then
                        file:write(table.concat(lines, '\n'))
                        file:close()
                    end
                end,
                ["*"] = function(lines)
                    local file = io.open(tmp_file, 'w')
                    if file then
                        file:write(table.concat(lines, '\n'))
                        file:close()
                    end
                end
            },
            paste = {
                ["+"] = function()
                    local file = io.open(tmp_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        return vim.split(content, '\n', {plain = true})
                    end
                    return {}
                end,
                ["*"] = function()
                    local file = io.open(tmp_file, 'r')
                    if file then
                        local content = file:read('*all')
                        file:close()
                        return vim.split(content, '\n', {plain = true})
                    end
                    return {}
                end
            },
            cache_enabled = false,
        }
        return
    end
    
    -- Platform-specific system clipboard integration with error handling
    if os_type == "linux" then
        if vim.fn.executable("xclip") == 1 then
            vim.g.clipboard = {
                name = "xclip-safe",
                copy = { 
                    ["+"] = "timeout 3s xclip -i -selection clipboard 2>/dev/null || true", 
                    ["*"] = "timeout 3s xclip -i -selection clipboard 2>/dev/null || true" 
                },
                paste = { 
                    ["+"] = "timeout 3s xclip -o -selection clipboard 2>/dev/null || echo ''", 
                    ["*"] = "timeout 3s xclip -o -selection clipboard 2>/dev/null || echo ''" 
                },
                cache_enabled = false,
            }
        elseif vim.fn.executable("wl-copy") == 1 then
            vim.g.clipboard = {
                name = "wl-clipboard-safe",
                copy = { 
                    ["+"] = "timeout 3s wl-copy 2>/dev/null || true", 
                    ["*"] = "timeout 3s wl-copy 2>/dev/null || true" 
                },
                paste = { 
                    ["+"] = "timeout 3s wl-paste 2>/dev/null || echo ''", 
                    ["*"] = "timeout 3s wl-paste 2>/dev/null || echo ''" 
                },
                cache_enabled = false,
            }
        elseif vim.fn.executable("xsel") == 1 then
            vim.g.clipboard = {
                name = "xsel-safe",
                copy = { 
                    ["+"] = "timeout 3s xsel -ib 2>/dev/null || true", 
                    ["*"] = "timeout 3s xsel -ib 2>/dev/null || true" 
                },
                paste = { 
                    ["+"] = "timeout 3s xsel -ob 2>/dev/null || echo ''", 
                    ["*"] = "timeout 3s xsel -ob 2>/dev/null || echo ''" 
                },
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