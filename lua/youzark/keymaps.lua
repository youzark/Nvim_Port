-- helper function{{{
local silent_nore = {silent = true,noremap = true}
local nmap = function(key,cmd)
	vim.api.nvim_set_keymap("n",key,cmd,{silent = true})
end-- }}}

-- store all (used by other hotkey){{{
vim.keymap.set({"n"},"<leader>w",function(  )
    vim.cmd("wall")
end,{buffer=false,silent=true})-- }}}

--  config vim in new tab{{{
-- vim.keymap.set({"n"},"<leader>cg",function(  )
--     vim.cmd("tabnew")
--     vim.cmd("lcd ~/.config/nvim")
--     vim.cmd("Telescope find_files hidden=false")
-- end,{buffer=false,silent=true})-- }}}

vim.keymap.set({"n"},"<leader>cg",function()
    -- Check for XDG_CONFIG_HOME environment variable
    local config_home = vim.env.XDG_CONFIG_HOME
    local nvim_appname = vim.env.NVIM_APPNAME or "nvim"
    local config_dir
    
    if config_home then
        -- If XDG_CONFIG_HOME is set, use that path + NVIM_APPNAME
        config_dir = config_home .. "/" .. nvim_appname
    else
        -- Fallback to the default path
        config_dir = "~/.config/nvim"
    end
    
    vim.cmd("tabnew")
    vim.cmd("lcd " .. config_dir)
    vim.cmd("Telescope find_files hidden=false")
end, {buffer=false, silent=true})-- }}}

-- 0 and ${{{
vim.api.nvim_set_keymap('n','<','0',silent_nore)
vim.api.nvim_set_keymap('n','>','$',silent_nore)-- }}}

-- folds{{{
vim.keymap.set("n","zv","zMzvzz",{silent = true})
vim.keymap.set("n","zj","zczjzOzz",{silent = true})
vim.keymap.set("n","zk","zczkzOzz",{silent = true})-- }}}

-- window movement and tab movement{{{
vim.api.nvim_set_keymap('n','K','<C-w>k',silent_nore)
vim.api.nvim_set_keymap('n','J','<C-w>j',silent_nore)
vim.api.nvim_set_keymap('n','T','<C-w>T',silent_nore)
vim.api.nvim_set_keymap('n','L','<cmd>call Win_shift_right()<cr>',silent_nore)
vim.api.nvim_set_keymap('n','H','<cmd>call Win_shift_left()<cr>',silent_nore)-- }}}

-- quick test{{{
vim.api.nvim_set_keymap('n','<leader>t','<leader>w<cmd>!sh ./test.sh<cr>',{})-- }}}

-- Jump with tag and jump back{{{
vim.api.nvim_set_keymap('n','gk','<c-]>',silent_nore)
vim.api.nvim_set_keymap('n','gj','<c-o>',silent_nore)-- }}}

-- apply new config on live{{{
vim.api.nvim_set_keymap('n','<leader>sc','<cmd>call youzark#save_and_source()<cr>',silent_nore)-- }}}

-- scroll{{{
vim.api.nvim_set_keymap('n','<c-j>','<c-e>',silent_nore)
vim.api.nvim_set_keymap('n','<c-k>','<c-y>',silent_nore)-- }}}

-- move lines{{{
vim.api.nvim_set_keymap('n','<A-J>',':m . +1<cr>==',silent_nore)
vim.api.nvim_set_keymap('n','<A-K>',':m . -2<cr>==',silent_nore)
-- vim.api.nvim_set_keymap('i','<A-k>','<esc>:m . -2<cr>==i',silent_nore)
-- vim.api.nvim_set_keymap('i','<A-j>','<esc>:m . +1<cr>==i',silent_nore)
vim.api.nvim_set_keymap('v','<A-J>',':m \'> +1<cr>gv',silent_nore)
vim.api.nvim_set_keymap('v','<A-K>',':m \'< -2<cr>gv',silent_nore)
vim.api.nvim_set_keymap('n','<A-,>',':< <cr>',silent_nore)
vim.api.nvim_set_keymap('n','<A-.>',':> <cr>',silent_nore)
vim.api.nvim_set_keymap('i','<A-,>','<esc>:< <cr>i',silent_nore)
vim.api.nvim_set_keymap('i','<A-.>','<esc>:> <cr>i',silent_nore)
vim.api.nvim_set_keymap('v','<A-,>',":'<,'> < <cr>gv",silent_nore)
vim.api.nvim_set_keymap('v','<A-.>',":'<,'> > <cr>gv",silent_nore)-- }}}

-- use to quit terminal of both ranger and floatrem{{{
vim.api.nvim_set_keymap('t','<m-p>','<c-\\><c-n>:q<cr>',silent_nore)-- }}}

-- fugitive{{{
vim.api.nvim_set_keymap('n','<leader>gs','<cmd>wall<cr><cmd>Git<cr>',silent_nore)
vim.api.nvim_set_keymap('n','<leader>gc','<cmd>Git commit<cr>',silent_nore)
vim.api.nvim_set_keymap('n','<leader>gp','<cmd>Git push<CR>',silent_nore)-- }}}

-- ranger{{{
vim.api.nvim_set_keymap('n','tt',':RnvimrToggle<cr>',silent_nore)-- }}}

-- maximizer{{{
vim.api.nvim_set_keymap('n','m','<cmd>MaximizerToggle<cr>',silent_nore)-- }}}

-- floaterm{{{
vim.api.nvim_set_keymap('n','tn','<cmd>FloatermToggle<cr>',silent_nore)
vim.api.nvim_set_keymap('t','<Esc>','<c-\\><c-n>',silent_nore)-- }}}

-- telescope{{{
vim.api.nvim_set_keymap('n','<leader>h','<cmd>lua require("telescope.builtin").help_tags()<cr>',silent_nore)
vim.api.nvim_set_keymap('n','?','<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending<cr>',silent_nore) -- press <c-/>
vim.api.nvim_set_keymap('n','gf','<cmd>lua require("telescope.builtin").find_files({hidden=true})<CR>',{})-- }}}

