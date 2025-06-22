#!/usr/bin/env lua
local M = {}
local env_PROJECT_ROOT = "PROJECT_ROOT"
local env_CURRENT_FILE_DIR = "CURRENT_FILE_DIR"

-- default to current working dir
M.findProjectRoot = function()
    local root_dir = vim.fn.getcwd()
    for dir in vim.fs.parents(root_dir) do
        if vim.fn.isdirectory(dir .. "/.git") == 1 then
            root_dir = dir
            break
        end
    end
    return root_dir
end

M.setEnv = function()
    vim.fn.setenv(env_PROJECT_ROOT,M.findProjectRoot())
    vim.fn.setenv(env_CURRENT_FILE_DIR,vim.fn.getcwd())
end

return M
