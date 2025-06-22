local M = {}

local telescope = require('telescope')
local builtin = require('telescope.builtin')
local utils = require('telescope.utils')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function find_git_root()
    local current_dir = vim.fn.expand('%:p:h')
    local git_root = utils.get_os_command_output({ 'git', 'rev-parse', '--show-toplevel' }, current_dir)[1]
    return git_root
end

M.custom_find_files = function()
    local git_root = find_git_root()
    local opts = {
        previewer = false,
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    local file_path
                    if git_root then
                        file_path = git_root .. '/' .. selection[1]
                    else
                        file_path = selection[1]
                    end
                    vim.cmd('tabnew ' .. vim.fn.fnameescape(file_path))
                end
            end)
            return true
        end
    }
    
    if git_root then
        opts.cwd = git_root
    end
    
    builtin.find_files(opts)
end

return M
