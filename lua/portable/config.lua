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
    
    -- Robust clipboard strategy detection for complex network scenarios
    local function get_clipboard_strategy()
        local is_docker = os.getenv("container") == "docker" or vim.fn.filereadable("/.dockerenv") == 1
        local is_ssh = os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_CLIENT") ~= nil
        local has_display = os.getenv("DISPLAY") ~= nil and os.getenv("DISPLAY") ~= ""
        
        -- Detect SSH hop depth by counting SSH agent forwards or analyzing DISPLAY
        local ssh_hop_depth = 0
        if is_ssh then
            local display = os.getenv("DISPLAY") or ""
            -- DISPLAY like localhost:10.0, localhost:11.0 indicates forwarding depth
            local display_num = display:match("localhost:(%d+)")
            if display_num then
                ssh_hop_depth = math.max(1, math.floor(tonumber(display_num) / 10))
            elseif is_ssh then
                ssh_hop_depth = 1
            end
        end
        
        -- Test X11 clipboard with progressive timeout based on network depth
        local function test_x11_clipboard(timeout)
            if not has_display or vim.fn.executable("xclip") == 0 then
                return false
            end
            
            -- Quick test first - if this fails immediately, X11 is broken
            local quick_test = vim.fn.system("timeout 1s xset q >/dev/null 2>&1")
            if vim.v.shell_error ~= 0 then
                return false
            end
            
            -- Test actual clipboard access
            local result = vim.fn.system(string.format("timeout %ds xclip -o -selection clipboard 2>/dev/null", timeout))
            return vim.v.shell_error == 0
        end
        
        -- Progressive timeout based on connection complexity
        local base_timeout = 2
        local timeout = base_timeout + (ssh_hop_depth * 2)  -- More time for deeper connections
        local x11_works = test_x11_clipboard(timeout)
        
        -- Strategy selection with robustness priority
        
        -- 1. Local system (most reliable)
        if not is_ssh and not is_docker and x11_works then
            return "local_x11"
        end
        
        -- 2. Direct SSH with working X11 (reliable)
        if is_ssh and ssh_hop_depth == 1 and x11_works then
            return "x11_forwarded"
        end
        
        -- 3. Multi-hop SSH with working X11 (fragile but possible)
        if is_ssh and ssh_hop_depth > 1 and x11_works then
            return "x11_forwarded_multihop"
        end
        
        -- 4. Docker with X11 access (container-specific handling)
        if is_docker and x11_works then
            return "docker_x11"
        end
        
        -- 5. Docker without X11 - try bridge
        if is_docker and has_display then
            return "docker_bridge"
        end
        
        -- 6. SSH without working X11 - network clipboard
        if is_ssh then
            return "network_clipboard"
        end
        
        -- 7. Fallback to internal clipboard
        return "internal"
    end
    
    local strategy = get_clipboard_strategy()
    
    if strategy == "x11_forwarded_multihop" then
        -- Multi-hop SSH with extra timeout and error handling
        local timeout = 8  -- Longer timeout for multi-hop
        vim.g.clipboard = {
            name = "xclip-multihop",
            copy = { 
                ["+"] = string.format("timeout %ds xclip -i -selection clipboard 2>/dev/null || true", timeout),
                ["*"] = string.format("timeout %ds xclip -i -selection clipboard 2>/dev/null || true", timeout)
            },
            paste = { 
                ["+"] = string.format("timeout %ds xclip -o -selection clipboard 2>/dev/null || echo ''", timeout),
                ["*"] = string.format("timeout %ds xclip -o -selection clipboard 2>/dev/null || echo ''", timeout)
            },
            cache_enabled = false,
        }
        return
    elseif strategy == "network_clipboard" then
        -- SSH without working X11 - use network-based clipboard via file sharing
        local network_clipboard_dir = os.getenv("HOME") .. "/.local/share/nvim"
        vim.fn.system("mkdir -p " .. network_clipboard_dir)
        local network_clipboard_file = network_clipboard_dir .. "/network_clipboard.txt"
        
        vim.g.clipboard = {
            name = "network-shared",
            copy = {
                ["+"] = function(lines)
                    local content = table.concat(lines, '\n')
                    local file = io.open(network_clipboard_file, 'w')
                    if file then
                        file:write(content)
                        file:close()
                        
                        -- Try to sync with other common clipboard locations
                        vim.fn.system("cp " .. network_clipboard_file .. " /tmp/nvim_network_clipboard 2>/dev/null || true")
                        vim.fn.system("cp " .. network_clipboard_file .. " ~/.clipboard 2>/dev/null || true")
                    end
                end,
                ["*"] = function(lines)
                    local content = table.concat(lines, '\n')
                    local file = io.open(network_clipboard_file, 'w')
                    if file then
                        file:write(content)
                        file:close()
                        vim.fn.system("cp " .. network_clipboard_file .. " /tmp/nvim_network_clipboard 2>/dev/null || true")
                        vim.fn.system("cp " .. network_clipboard_file .. " ~/.clipboard 2>/dev/null || true")
                    end
                end
            },
            paste = {
                ["+"] = function()
                    -- Try multiple clipboard locations
                    local clipboard_sources = {
                        network_clipboard_file,
                        "/tmp/nvim_network_clipboard",
                        os.getenv("HOME") .. "/.clipboard"
                    }
                    
                    for _, source in ipairs(clipboard_sources) do
                        local file = io.open(source, 'r')
                        if file then
                            local content = file:read('*all')
                            file:close()
                            if content and content ~= "" then
                                return vim.split(content, '\n', {plain = true})
                            end
                        end
                    end
                    return {}
                end,
                ["*"] = function()
                    local file = io.open(network_clipboard_file, 'r')
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
    elseif strategy == "docker_bridge" then
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