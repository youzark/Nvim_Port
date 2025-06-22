-- vim.cmd [[packadd packer.nvim]]

-- require('packer').startup(
-- 	function (use)
-- 	-- -- basic utilities
-- 	-- nvim development
-- 	use 'wbthomason/packer.nvim'
-- 	use 'junegunn/vim-easy-align'
--     use 'rcarriga/nvim-notify'
--     use "norcalli/nvim-colorizer.lua"

--     use {
--         -- disable = true,
--         "folke/noice.nvim",
--         requires = {
--             "MunifTanjim/nui.nvim",
--         },
--     }

-- 	-- tab line
-- 	use {
-- 		'nvim-lualine/lualine.nvim',
--  		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
-- 	}

-- 	use {
-- 		'lukas-reineke/indent-blankline.nvim'
-- 	}
--     use 'numToStr/FTerm.nvim'
-- 	use 'voldikss/vim-floaterm'
--     use 'kevinhwang91/rnvimr'
--     use 'szw/vim-maximizer'

-- 	use 'kyazdani42/nvim-web-devicons'
-- 	-- use 'jiangmiao/auto-pairs'
--     use {
--         "windwp/nvim-autopairs",
--         config = function()
--             require("nvim-autopairs").setup {}
--         end
--     }

-- 	use 'farmergreg/vim-lastplace'
-- 	use 'nvim-lua/popup.nvim'
-- 	use 'nvim-lua/plenary.nvim'
-- 	use 'python-rope/ropevim'
-- 	use 'morhetz/gruvbox'
-- 	use 'uzxmx/vim-widgets'
-- 	use 'skywind3000/asynctasks.vim'
-- 	use 'skywind3000/asyncrun.vim'
-- 	use 'powerman/vim-plugin-AnsiEsc'
-- 	use 'dstein64/vim-startuptime'

-- 	-- -- programming environment components
-- 	-- lsp server and autoCompletion
-- 	use {
-- 		'neovim/nvim-lspconfig',
-- 		requires = {
-- 			-- lsp auto installation
-- 			'williamboman/mason.nvim',

-- 			-- bridges mason and nvim-lspconfig to make lsp configuration easier
-- 			'williamboman/mason-lspconfig.nvim',

-- 			-- status updates for lsp
-- 			'j-hui/fidget.nvim',

-- 			-- nvim builtin lsp auto completion
-- 			'folke/neodev.nvim',
-- 		},
-- 	}
-- 	use {
-- 		'hrsh7th/nvim-cmp',
-- 		requires = {
-- 			'hrsh7th/cmp-nvim-lsp',
-- 			'hrsh7th/cmp-buffer',
-- 			'hrsh7th/cmp-path',
-- 			'hrsh7th/cmp-cmdline',
-- 			'L3MON4D3/LuaSnip',
-- 			'saadparwaiz1/cmp_luasnip',
-- 			'rafamadriz/friendly-snippets',

--             -- prettify the completion menu
--             'https://github.com/onsails/lspkind.nvim',
-- 		},
-- 	}
-- 	use {
-- 		"robitx/gp.nvim",
-- 	}
-- 	use {
-- 		'yetone/avante.nvim',
-- 		requires = {
-- 			'stevearc/dressing.nvim',
-- 			'nvim-lua/plenary.nvim',
-- 			'MunifTanjim/nui.nvim',
-- 			'hrsh7th/nvim-cmp',
-- 			'nvim-tree/nvim-web-devicons',
-- 			'zbirenbaum/copilot.lua',
-- 			{
-- 				'HakonHarnes/img-clip.nvim',
-- 				config = function()
-- 					require('img-clip').setup({
-- 						default = {
-- 							embed_image_as_base64 = false,
-- 							prompt_for_file_name = false,
-- 							drag_and_drop = {
-- 								insert_mode = true,
-- 							},
-- 							use_absolute_path = true,
-- 						}
-- 					})
-- 				end
-- 			},
-- 			{
-- 				'MeanderingProgrammer/render-markdown.nvim',
-- 				config = function()
-- 					require('render-markdown').setup({
-- 						file_types = { "markdown", "Avante" }
-- 					})
-- 				end,
-- 				ft = { "markdown", "Avante" }
-- 			}
-- 		},
-- 		run = 'make', -- For Windows: 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
-- 		config = function()
-- 			require('avante').setup({
-- 			})
-- 		end
-- 	}
-- 	-- use({
-- 	-- 	"jackMort/ChatGPT.nvim",
-- 	-- 	config = function()
-- 	-- 		require("chatgpt").setup()
-- 	-- 	end,
-- 	-- 	requires = {
-- 	-- 		"MunifTanjim/nui.nvim",
-- 	-- 		"nvim-lua/plenary.nvim",
-- 	-- 		"folke/trouble.nvim",
-- 	-- 		"nvim-telescope/telescope.nvim"
-- 	-- 	}
-- 	-- })
--     -- formmating and diagnostic
--     use {
--         "ray-x/lsp_signature.nvim"
--     }
--     use {
--         'jose-elias-alvarez/null-ls.nvim',
--     }
--     use {
--         "NMAC427/guess-indent.nvim",
--         config = function() require("guess-indent").setup {} end
--     }

-- 	-- project management
-- 	use 'tpope/vim-fugitive'

-- 	-- parser & search
-- 	use 'nvim-treesitter/nvim-treesitter'
--     use 'nvim-treesitter/playground'
-- 	use 'nvim-telescope/telescope.nvim'
-- 	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
--     use {"preservim/tagbar"}

-- 	-- auto commentor
-- 	use 'tpope/vim-commentary'

-- 	-- python iteractive
-- 	use 'jpalardy/vim-slime'
-- 	-- use 'hanschen/vim-ipython-cell'
-- 	use 'jupyter-vim/jupyter-vim'
--     -- use 'untitled-ai/jupyter_ascending.vim'
--     -- use "luk400/vim-jukit"


-- 	-- debugger
--     use 'mfussenegger/nvim-dap'
--     use { "rcarriga/nvim-dap-ui",
--         requires = {"mfussenegger/nvim-dap"} }
--     use 'theHamsta/nvim-dap-virtual-text'

--     -- ai
--     -- use {
--     --     "https://github.com/zbirenbaum/copilot.lua",
--     --     cmd = "Copilot",
--     --     event = "InsertEnter",
--     --     config = function()
--     --         require("copilot").setup({})
--     --     end
--     -- }
--     -- use {
--     --     "zbirenbaum/copilot-cmp",
--     --     after = { "copilot.lua" },
--     --     config = function ()
--     --         require("copilot_cmp").setup({
--     --             suggestion = { enabled = false },
--     --             panel = {enabled = false},
--     --         })
--     --     end
--     -- }
--     -- use({
--     --     "jackMort/ChatGPT.nvim",
--     --     config = function()
--     --         require("chatgpt").setup()
--     --     end,
--     --     requires = {
--     --         "MunifTanjim/nui.nvim",
--     --         "nvim-lua/plenary.nvim",
--     --         "nvim-telescope/telescope.nvim"
--     --     }
--     -- })


-- 	-- -- documenting tool
-- 	-- markdown md [ preview ]
-- 	use({
-- 		"iamcco/markdown-preview.nvim",
-- 		run = "cd app && npm install",
-- 		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
-- 		ft = { "markdown" },
-- 	})

--     -- latex
--     use({
--         'lervag/vimtex'
--     })

--     -- idea document
--     use { "nagy135/capture-nvim" }


-- 	-- plantuml [preview]
-- 	use { 'scrooloose/vim-slumlord' }

-- 	-- -- abandoned
-- 	-- test tool
-- 	use {
-- 		"klen/nvim-test",
-- 	}

-- 	-- wiki
-- 	use {
-- 		'vimwiki/vimwiki',
--         disable = true,
--     }


-- 	-- snippets
-- 	use {
-- 		'SirVer/ultisnips',
-- 		disable = true,
-- 	}
-- 	use {
-- 		"fannheyward/telescope-coc.nvim",
-- 		disable = true,
-- 	}
-- 	-- lsp support
-- 	use {
-- 		'neoclide/coc.nvim',
-- 		branch = "release",
-- 		disable = true,
-- 	}
-- end)
