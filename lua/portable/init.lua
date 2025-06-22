-- Portable Nvim Configuration - Main Module
-- Modular, clean cross-platform enhancements

local M = {}

-- Import modules
local detect = require('portable.detect')
local config = require('portable.config')
local commands = require('portable.commands')

-- Main setup function
function M.setup(opts)
    opts = opts or {}
    
    -- Apply AppImage fixes first if needed (silently)
    local appimage_fix = require('portable.appimage_fix')
    if appimage_fix.is_appimage() then
        appimage_fix.apply_fixes_silent()
    end
    
    -- Get environment info
    local env = detect.environment()
    
    -- Store environment info globally
    _G.nvim_portable = {
        os = env.os,
        package_manager = env.package_manager,
        is_remote = env.is_remote,
        is_appimage = appimage_fix.is_appimage(),
        enabled = true
    }
    
    -- Setup all components
    config.setup_python()
    config.setup_clipboard()
    config.setup_applications()
    config.setup_treesitter()
    config.setup_optimizations()
    commands.setup()
    
    -- Only show message if explicitly enabled in opts
    if opts.verbose then
        local appimage_note = appimage_fix.is_appimage() and " (AppImage)" or ""
        print("[PORTABLE] Cross-platform enhancements loaded for " .. env.os .. appimage_note)
    end
end

-- Export modules for direct access if needed
M.detect = detect
M.config = config
M.commands = commands

return M