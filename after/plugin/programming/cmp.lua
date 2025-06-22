-- autocompletion engine configuration
-- Plugin : nvim-cmp [ lsp compatibility part is shifted to mason-lspconfig ]
local cmp = require("cmp")
local luasnip = require("luasnip")

require("lspkind").init({
    symbol_map = {
        Copilot = "",
    }
})


local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0,line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

	-- default setup [can also set up per filetype , i.g. below]
    
local config = {

    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:GruvboxYellow,FloatBorder:GruvboxOrangeBold"
        }),
        documentation = cmp.config.window.bordered({
            winhighlight = "Normal:GruvboxYellow,FloatBorder:GruvboxOrangeBold"
        })
    },
    
    formatting = {
        fields = { "kind", "abbr", "menu"},
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol"})(entry, vim_item)

            local strings = vim.split(kind.kind, "%s", { trimempty = true })

            -- only show function name rather than full function signature in abbr
            local trim_paralist = function(input)
                return input:match("[^(]+")
            end

            -- trim long abbr to leave space for the document
            local trim = function(input)
                local max_len = math.floor(vim.api.nvim_win_get_width(0) * 0.5)
                if input and input:len() > max_len then
                    input = input:sub(1,max_len) .. "•••"
                end
                return input
            end

            -- this part remove duplicate entry
            -- local source = entry.source.name
            -- if source == "luasnip" or source == "nvim_lsp" then
            --     kind.dup = 0
            -- end

            kind.kind = (strings[1] or "") .. " "

            kind.abbr = trim(trim_paralist(kind.abbr))

            -- leave menu empty to save space for documentation
            kind.menu = ""

            return kind
        end,
    },

    view = {
        entries = "custom",
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ['<Tab>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({
                        behavior = cmp.SelectBehavior.Select,
                    })
                -- elseif luasnip.expand_or_jumpable() then
                -- 	luasnip.expand_or_jump()
                elseif has_words_before()  then
                    cmp.complete()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                -- elseif luasnip.jumable(-1) then
                --     luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
    }),

    -- sources of the completion items listed, the order of sources is the
    -- order in completion results.
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        -- { name = 'copilot' },
        { name = 'buffer' }, -- completion source of words appared in the current buffer
        { name = 'path' }
    }),
}

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)

cmp.setup(config)

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
    })
})

cmp.setup.cmdline(':lua', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'cmdline' },
    })
})




