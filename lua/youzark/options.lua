-- set global options{{{
local global = {
	clipboard = "unnamed",
	shortmess = vim.opt.shortmess["_value"] .. "c",
	runtimepath = vim.opt.runtimepath["_value"] .. ",~/.fzf",
	updatetime = 50,
	cmdheight = 2,
	ignorecase = true,
	incsearch = true,
	hidden = true,
	termguicolors = true,
	icon = true,
	compatible = false,
	hlsearch = false,
	scrolloff = 10,
	background = "dark",
	encoding = "utf-8",
    autochdir = true,
	fillchars = { fold = " ", eob = " " },
}-- }}}

-- set window local options{{{
local window = {
	relativenumber = true,
	nu = true,
	signcolumn ="yes",
	colorcolumn = "50",
	foldlevel = 20,
	foldmethod ="marker",
}-- }}}

-- set buffer local options{{{
local buffer = {
	swapfile = false,
	undofile = true,
	tabstop =4,
	shiftwidth = 4,
	expandtab = true,
}-- }}}

-- set options{{{
for key,val in pairs(global) do
	vim.opt[key] = val
end
for key,val in pairs(buffer) do
	vim.bo[key] = val
	vim.o[key] = val
end
for key,val in pairs(window) do
	vim.wo[key] = val
end-- }}}
