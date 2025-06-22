-- Portable Nvim Configuration
-- Safe cross-platform setup that works everywhere

-- Load original configuration first (ensures stability)
require("youzark")

-- Add portable enhancements (safe, tested approach)
require("portable").setup()

-- Environment-specific optimizations
local os_type = _G.nvim_portable and _G.nvim_portable.os or "unknown"

-- Remote server optimizations
if os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") then
    -- Disable clipboard if no display server
    if not (os.getenv("DISPLAY") or os.getenv("WAYLAND_DISPLAY")) then
        vim.opt.clipboard = ""
    end
    
    -- Performance optimizations for remote
    vim.opt.updatetime = 1000
    vim.opt.timeoutlen = 500
    vim.g.loaded_matchparen = 1  -- Disable match parentheses highlighting
end

-- macOS specific settings
if os_type == "macos" then
    -- Better performance on macOS
    vim.opt.lazyredraw = true
end

-- Windows specific settings  
if os_type == "windows" then
    -- Windows path handling
    if vim.fn.has('win32') == 1 then
        vim.opt.shell = 'powershell'
        vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
    end
end