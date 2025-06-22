local glob = vim.api.nvim_set_var
local var = {
	python3_host_prog = "/apdcephfs_nj7/share_1273717/yannhua/Home/.local/ml/bin/python3",
	jupyter_mapkeys = 0,
	floaterm_width = 0.95,
	floaterm_height = 0.95,
	maximizer_set_default_mapping = 0,
	maximizer_restore_on_winleave = 0,
	UltiSnipsExpandTrigger = '<NUL>',
	UltiSnipsJumpForwardTrigger = "<c-b>",
	ltiSnipsJumpBackwardTrigger = "<c-z>",
	livedown_browser = "firefox",
	rnvimr_draw_border = 1,
	rnvimr_enable_picker = 1,
	webdevicons_enable = 1,
	webdevicons_enable_airline_tabline = 1,
	webdevicons_enable_airline_statusline = 1,
	indentLine_noConcealCursor= 1,
	mapleader = ",",
    mkdp_browser = "chrome", -- markdown preview
    vimtex_view_method = "skim",
	tex_flavor="latex",
	vimtex_view_skim_sync = 1,
	vimtex_view_skim_activate = 1,
}

for key, value in pairs(var) do
	glob(key,value)
end
