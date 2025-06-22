require('telescope').setup
{
	defaults =
	{
		prompt_prefix = "$ ",
		border = true,
		dynamic_preview_title = true,
		layout_stategy="horizontal"
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = false,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
}

pcall(require('telescope').load_extension,'fzf')
local path_util = require('util.telescope_file_navi_util')

vim.api.nvim_create_user_command('TelescopeGitFiles', path_util.custom_find_files, {})
vim.api.nvim_set_keymap('n', '<leader>fs', ':TelescopeGitFiles<CR>', { noremap = true, silent = true })

