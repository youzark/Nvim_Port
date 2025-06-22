local exist,lualine = pcall(require,'lualine')
if exist then
	lualine.setup {
		options = {
			icons_enabled = true,
			theme = 'gruvbox',
			component_separators = '|',
			section_separators = "",
		},
	}
end
