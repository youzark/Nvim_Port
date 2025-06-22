-- Check if tree-sitter CLI is available
local has_tree_sitter_cli = vim.fn.executable("tree-sitter") == 1

-- Show helpful message if tree-sitter CLI is missing
if not has_tree_sitter_cli then
    vim.schedule(function()
        vim.notify(
            "tree-sitter CLI not found. Syntax highlighting will be limited.\n" ..
            "Install with: :PortableInstall tools\n" ..
            "Or manually: npm install -g tree-sitter-cli", 
            vim.log.levels.WARN
        )
    end)
end

require('nvim-treesitter.configs').setup({
    -- A list of parser names, or "all"
    ensure_installed = has_tree_sitter_cli and {
        -- Languages you specifically use
        "bash", "python", "java", "c", "cpp", "rust", "markdown", "latex",
        
        -- Common web/config languages
        "html", "css", "javascript", "typescript", "json", "yaml", "toml",
        "lua", "vim", "vimdoc", "query",
        
        -- Build tools and config files
        "cmake", "make", "dockerfile", "git_config", "git_rebase", "gitcommit", "gitignore",
        
        -- Markdown related
        "markdown_inline", "bibtex",
    } or {},

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Only enable if tree-sitter CLI is available
    auto_install = has_tree_sitter_cli,

    highlight = {
        enable = true,
        disable = {}, -- list of languages that will be disabled
        additional_vim_regex_highlighting = { "latex", "markdown" }, -- needed for some latex and markdown features
    },

    indent = {
        enable = true,
        disable = { "yaml", "python" } -- python indentation can sometimes be quirky with treesitter
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-backspace>",
        },
    },

    -- Treesitter text objects
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },

    -- Playground configuration (useful for debugging)
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
    },

    -- Better syntax aware commenting
    context_commentstring = {
        enable = true,
        enable_autocmd = false, -- Integration with Comment.nvim
    },
})

-- Git workaround for Windows
require("nvim-treesitter.install").prefer_git = true

-- Parser configurations
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
