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
    
    -- Get environment info
    local env = detect.environment()
    
    -- Store environment info globally
    _G.nvim_portable = {
        os = env.os,
        package_manager = env.package_manager,
        is_remote = env.is_remote,
        enabled = true
    }
    
    -- Setup all components
    config.setup_python()
    config.setup_clipboard()
    config.setup_applications()
    config.setup_optimizations()
    commands.setup()
    
    print("[PORTABLE] Cross-platform enhancements loaded for " .. env.os)
end

-- Export modules for direct access if needed
M.detect = detect
M.config = config
M.commands = commands

return M