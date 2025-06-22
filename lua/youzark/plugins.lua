#!/usr/bin/env lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
    -- Basic utilities
    "junegunn/vim-easy-align",
    "rcarriga/nvim-notify",
    {
       "amitds1997/remote-nvim.nvim",
       version = "*", -- Pin to GitHub releases
       dependencies = {
           "nvim-lua/plenary.nvim", -- For standard functions
           "MunifTanjim/nui.nvim", -- To build the plugin UI
           "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
       },
       config = true,
    },
    { "norcalli/nvim-colorizer.lua" },
    -- {
    --     'chipsenkbeil/distant.nvim', 
    --     branch = 'v0.3',
    --     config = function()
    --         require('distant'):setup()
    --     end
    -- },
    
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    'lukas-reineke/indent-blankline.nvim',
    'numToStr/FTerm.nvim',
    'voldikss/vim-floaterm',
    'kevinhwang91/rnvimr',
    'szw/vim-maximizer',
    'kyazdani42/nvim-web-devicons',

    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end
    },

    'farmergreg/vim-lastplace',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'python-rope/ropevim',
    -- 'morhetz/gruvbox',
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
    'uzxmx/vim-widgets',
    'skywind3000/asynctasks.vim',
    'skywind3000/asyncrun.vim',
    'powerman/vim-plugin-AnsiEsc',
    'dstein64/vim-startuptime',

    -- LSP and Completion
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'j-hui/fidget.nvim',
            'folke/neodev.nvim',
        },
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim',
        },
    },

    "robitx/gp.nvim",

    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        config= function()
            require("config.avante").setup()
        end,
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },

    -- Formatting and Diagnostics
    "ray-x/lsp_signature.nvim",
    'jose-elias-alvarez/null-ls.nvim',
    {
        "NMAC427/guess-indent.nvim",
        config = function() require("guess-indent").setup {} end
    },

    -- Git
    'tpope/vim-fugitive',
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration

            -- Only one of these is needed.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
            "echasnovski/mini.pick",         -- optional
            "folke/snacks.nvim",             -- optional
        },
    },

    "sindrets/diffview.nvim",

    -- Treesitter and Telescope
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/playground',
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
        }
    },
    "preservim/tagbar",

    -- Comments
    'tpope/vim-commentary',

    -- Python/Jupyter
    'jpalardy/vim-slime',
    'jupyter-vim/jupyter-vim',

    -- Debugging
    'mfussenegger/nvim-dap',
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap"}
    },
    'theHamsta/nvim-dap-virtual-text',

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        init = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    },

    -- LaTeX
    'lervag/vimtex',

    -- Capture
    "nagy135/capture-nvim",

    -- PlantUML
    'scrooloose/vim-slumlord',

    -- Testing
    "klen/nvim-test",

    -- Disabled plugins
    { 'vimwiki/vimwiki', enabled = false },
    { 'SirVer/ultisnips', enabled = false },
    { "fannheyward/telescope-coc.nvim", enabled = false },
    { 'neoclide/coc.nvim', branch = "release", enabled = false },
})
