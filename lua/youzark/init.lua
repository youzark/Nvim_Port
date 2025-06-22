-- AutoInstallation of Packer on New environment [also auto sync]
-- local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
-- local is_bootstrap = false

-- if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
--     is_bootstrap = true
--     vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
--     vim.cmd [[packadd packer.nvim]]
-- end

-- if is_bootstrap then
-- 	require('packer').sync()
-- end

require("youzark.options")
require("youzark.var")
require("youzark.plugins")
require("youzark.cmd")
require("youzark.autocmd")
require("youzark.keymaps")
