local glob = vim.api.nvim_set_var

-- Get environment config (set up by bootup system)
local env_config = _G.nvim_env or {}

-- Helper function to get binary path
local function get_binary_or_default(names, default)
    if type(names) == "string" then
        names = {names}
    end
    for _, name in ipairs(names) do
        local path = vim.fn.exepath(name)
        if path ~= "" then
            return path
        end
    end
    return default
end

-- Function to get Python path intelligently
local function get_python_path()
    -- 1. Use bootup system if already configured
    if vim.g.python3_host_prog and vim.fn.executable(vim.g.python3_host_prog) == 1 then
        return vim.g.python3_host_prog
    end
    
    -- 2. Check if old hardcoded path still exists
    local old_path = "/apdcephfs_nj7/share_1273717/yannhua/Home/.local/ml/bin/python3"
    if vim.fn.executable(old_path) == 1 then
        return old_path
    end
    
    -- 3. Fall back to system python
    return get_binary_or_default({"python3", "python"}, "python3")
end

local var = {
	-- Use intelligent Python path detection
	python3_host_prog = get_python_path(),
	
	jupyter_mapkeys = 0,
	floaterm_width = 0.95,
	floaterm_height = 0.95,
	maximizer_set_default_mapping = 0,
	maximizer_restore_on_winleave = 0,
	UltiSnipsExpandTrigger = '<NUL>',
	UltiSnipsJumpForwardTrigger = "<c-b>",
	ltiSnipsJumpBackwardTrigger = "<c-z>",
	
	-- Use environment-configured browser
	livedown_browser = (env_config.apps and env_config.apps.browser) or "firefox",
	
	rnvimr_draw_border = 1,
	rnvimr_enable_picker = 1,
	webdevicons_enable = 1,
	webdevicons_enable_airline_tabline = 1,
	webdevicons_enable_airline_statusline = 1,
	indentLine_noConcealCursor= 1,
	mapleader = ",",
	
    -- Use environment-configured browser for markdown preview
    mkdp_browser = (env_config.apps and env_config.apps.browser) or "firefox",
    
    -- Use environment-configured PDF viewer
    vimtex_view_method = (env_config.apps and env_config.apps.pdf_viewer) or "zathura",
    
	tex_flavor="latex",
	vimtex_view_skim_sync = 1,
	vimtex_view_skim_activate = 1,
}

for key, value in pairs(var) do
	glob(key,value)
end
