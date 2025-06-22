-- At the start of your config
vim.o.background = 'dark' -- or 'light' if you prefer

-- Set contrast
-- Options: 'hard', 'medium'(default), 'soft'
vim.g.gruvbox_contrast_dark = 'medium'

require("gruvbox").setup({
    overrides = {
        ["@variable"] = { link = "Identifier" },
        ["@module"] = { link =  "Identifier" },
    }
})
-- Load the colorscheme
vim.cmd([[colorscheme gruvbox]])
