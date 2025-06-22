-- Remote server-specific enhancements
-- Add "require('portable.remote')" to init.lua on remote servers

local M = {}

function M.setup()
    -- Check if we're on a remote server
    if not (os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT")) then
        return
    end
    
    -- Disable clipboard if no X11/Wayland
    if not (os.getenv("DISPLAY") or os.getenv("WAYLAND_DISPLAY")) then
        vim.opt.clipboard = ""
        print("[PORTABLE] Clipboard disabled (no display server)")
    end
    
    -- Use system python (more reliable on servers)
    if not vim.g.python3_host_prog then
        local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
        if python_path ~= "" then
            vim.g.python3_host_prog = python_path
        end
    end
    
    -- Minimal file manager if no ranger
    if vim.fn.executable("ranger") == 0 then
        vim.api.nvim_create_user_command("Files", function()
            vim.cmd("edit .")
        end, { desc = "Open file explorer (netrw fallback)" })
    end
    
    -- Simple dependency check
    vim.api.nvim_create_user_command("CheckDeps", function()
        local deps = {"git", "curl", "python3", "node"}
        print("Dependency Status:")
        for _, dep in ipairs(deps) do
            local status = vim.fn.executable(dep) == 1 and "✓" or "✗"
            print(string.format("  %s %s", status, dep))
        end
    end, { desc = "Check basic dependencies" })
    
    -- Performance optimizations for remote
    vim.opt.updatetime = 1000  -- Slower update for better performance
    vim.opt.timeoutlen = 500   -- Faster key timeout
    
    -- Disable heavy features
    vim.g.loaded_matchparen = 1  -- Disable match parentheses highlighting
    
    print("[PORTABLE] Remote server enhancements loaded")
end

M.setup()
return M