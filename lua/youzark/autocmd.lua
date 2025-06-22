-- Used for unstandard input method: when Esc is pressed to exit Insert Mode, automatically
-- turn back to Ascii keyboard layout
-- vim.api.nvim_create_autocmd("InsertLeave",{
-- 	pattern = {"*.md","*.txt","*.cpp","*.tex"},
-- 	callback = function() os.execute("fcitx-remote -s fcitx-keyboard-us") end,
-- })

-- vim.api.nvim_create_autocmd("FileType",{
-- 	pattern = "yaml",
-- 	command = [[setlocal ts=4 sts=4 sw=4 expandtab indentkeys-=0# indentkeys-=<:>]]
-- })

-- reserve fold
-- local filetype = {"*.lua","*.cpp","*.md","*.tex","*.json","*.py"}
-- local reserveFold = vim.api.nvim_create_augroup("reserveFold", { clear = true })
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--     pattern = filetype,
--     callback = function()
--         vim.cmd("silent! loadview")
--     end,
--     group = reserveFold,
-- })
-- vim.api.nvim_create_autocmd("BufWinLeave", {
--     pattern = filetype,
--     callback = function()
--         vim.cmd("mkview")
--     end,
--     group = reserveFold,
-- })

