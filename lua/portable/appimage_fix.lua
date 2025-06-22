-- AppImage Neovim Compatibility Fixes
local M = {}

-- Fix VIMRUNTIME path for AppImage installations
function M.fix_vimruntime()
    local vimruntime = vim.env.VIMRUNTIME
    
    -- Check if VIMRUNTIME contains AppImage squashfs path issues
    if vimruntime and (vimruntime:match("squashfs%-root") or vimruntime:match("/tmp/%.mount_")) then
        print("[APPIMAGE-FIX] Detected AppImage VIMRUNTIME issues")
        
        -- Try to find the correct runtime path
        local nvim_executable = vim.v.progpath
        if nvim_executable then
            -- For AppImage, try to find the embedded runtime
            local potential_paths = {
                nvim_executable:gsub("/bin/nvim$", "/share/nvim/runtime"),
                nvim_executable:gsub("/nvim$", "/../share/nvim/runtime"),
                "/usr/share/nvim/runtime",
                "/usr/local/share/nvim/runtime"
            }
            
            for _, path in ipairs(potential_paths) do
                if vim.fn.isdirectory(path) == 1 then
                    print("[APPIMAGE-FIX] Setting VIMRUNTIME to: " .. path)
                    vim.env.VIMRUNTIME = path
                    return true
                end
            end
        end
        
        print("[APPIMAGE-FIX] ⚠️  Could not fix VIMRUNTIME, some features may not work")
        return false
    end
    
    return true
end

-- Fix VIMRUNTIME silently (for startup)
function M.fix_vimruntime_silent()
    local vimruntime = vim.env.VIMRUNTIME
    
    -- Check if VIMRUNTIME contains AppImage squashfs path issues
    if vimruntime and (vimruntime:match("squashfs%-root") or vimruntime:match("/tmp/%.mount_")) then
        -- Try to find the correct runtime path
        local nvim_executable = vim.v.progpath
        if nvim_executable then
            -- For AppImage, try to find the embedded runtime
            local potential_paths = {
                nvim_executable:gsub("/bin/nvim$", "/share/nvim/runtime"),
                nvim_executable:gsub("/nvim$", "/../share/nvim/runtime"),
                "/usr/share/nvim/runtime",
                "/usr/local/share/nvim/runtime"
            }
            
            for _, path in ipairs(potential_paths) do
                if vim.fn.isdirectory(path) == 1 then
                    vim.env.VIMRUNTIME = path
                    return true
                end
            end
        end
        return false
    end
    
    return true
end

-- Fix health check functions for older nvim versions
function M.fix_health_functions()
    -- Check if we're missing health functions
    if not pcall(function() return vim.health end) then
        print("[APPIMAGE-FIX] Adding health check compatibility")
        
        -- Create compatibility layer for health functions
        if not vim.health then
            vim.health = {}
        end
        
        -- Basic health report functions
        if not vim.health.report_start then
            vim.health.report_start = function(name)
                print("== " .. name .. " ==")
            end
        end
        
        if not vim.health.report_ok then
            vim.health.report_ok = function(msg)
                print("  - OK: " .. msg)
            end
        end
        
        if not vim.health.report_warn then
            vim.health.report_warn = function(msg)
                print("  - WARNING: " .. msg)
            end
        end
        
        if not vim.health.report_error then
            vim.health.report_error = function(msg)
                print("  - ERROR: " .. msg)
            end
        end
        
        if not vim.health.report_info then
            vim.health.report_info = function(msg)
                print("  - INFO: " .. msg)
            end
        end
    end
    
    -- Also check for legacy health functions - use safer approach
    if vim.fn.exists('*health#report_start') == 0 then
        -- Create wrapper functions instead of direct health# functions
        vim.cmd([[
            function! HealthReportStart(name)
                echo "== " . a:name . " =="
            endfunction
            
            function! HealthReportOk(msg)
                echo "  - OK: " . a:msg
            endfunction
            
            function! HealthReportWarn(msg)
                echo "  - WARNING: " . a:msg
            endfunction
            
            function! HealthReportError(msg)
                echo "  - ERROR: " . a:msg
            endfunction
            
            function! HealthReportInfo(msg)
                echo "  - INFO: " . a:msg
            endfunction
        ]])
        
        -- Create aliases that plugins might expect
        pcall(vim.cmd, 'command! -nargs=1 HealthStart call HealthReportStart(<args>)')
        pcall(vim.cmd, 'command! -nargs=1 HealthOk call HealthReportOk(<args>)')
        pcall(vim.cmd, 'command! -nargs=1 HealthWarn call HealthReportWarn(<args>)')
        pcall(vim.cmd, 'command! -nargs=1 HealthError call HealthReportError(<args>)')
        pcall(vim.cmd, 'command! -nargs=1 HealthInfo call HealthReportInfo(<args>)')
    end
end

-- Check if we're running in an AppImage environment
function M.is_appimage()
    local nvim_path = vim.v.progpath
    local vimruntime = vim.env.VIMRUNTIME
    
    return (nvim_path and nvim_path:match("%.AppImage")) or
           (vimruntime and (vimruntime:match("squashfs%-root") or vimruntime:match("/tmp/%.mount_"))) or
           (vim.env.APPIMAGE ~= nil)
end

-- Apply all AppImage fixes
function M.apply_fixes()
    if not M.is_appimage() then
        return true
    end
    
    print("[APPIMAGE-FIX] 🔧 Applying AppImage compatibility fixes...")
    
    local fixes_applied = 0
    local fixes_total = 2
    
    -- Fix VIMRUNTIME
    if M.fix_vimruntime() then
        fixes_applied = fixes_applied + 1
    end
    
    -- Fix health functions
    M.fix_health_functions()
    fixes_applied = fixes_applied + 1
    
    print(string.format("[APPIMAGE-FIX] ✅ Applied %d/%d fixes", fixes_applied, fixes_total))
    
    if fixes_applied == fixes_total then
        print("[APPIMAGE-FIX] 🎉 AppImage compatibility enabled")
    else
        print("[APPIMAGE-FIX] ⚠️  Some fixes failed, functionality may be limited")
    end
    
    return fixes_applied > 0
end

-- Apply fixes silently (for startup)
function M.apply_fixes_silent()
    if not M.is_appimage() then
        return true
    end
    
    local fixes_applied = 0
    
    -- Fix VIMRUNTIME (silent)
    if M.fix_vimruntime_silent() then
        fixes_applied = fixes_applied + 1
    end
    
    -- Fix health functions (silent)
    M.fix_health_functions()
    fixes_applied = fixes_applied + 1
    
    return fixes_applied > 0
end

-- Show AppImage environment info
function M.show_info()
    print("[APPIMAGE-FIX] AppImage Environment Info:")
    print("  Neovim path: " .. (vim.v.progpath or "unknown"))
    print("  VIMRUNTIME: " .. (vim.env.VIMRUNTIME or "unknown"))
    print("  APPIMAGE env: " .. (vim.env.APPIMAGE or "not set"))
    print("  Is AppImage: " .. (M.is_appimage() and "yes" or "no"))
    
    -- Check health function availability
    local health_available = pcall(function() return vim.health.report_start end)
    print("  Health functions: " .. (health_available and "available" or "missing"))
end

return M