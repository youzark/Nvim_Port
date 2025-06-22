-- Base plugin for lsp server management
-- Plugin : mason [must before setup mason-lspconfig]
local masonExist, mason = pcall(require, "mason")
if masonExist then
    mason.setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })
end

-- lsp-server auto installation updation and setup
-- Plugin : mason-lspconfig [ if need lsp-config , must require after this plugin ]
local status, mason_lspconfig = pcall(require, "mason-lspconfig")
local cmp_nvim_lspExist, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status and cmp_nvim_lspExist then
    -- Table of severs that is automatically installed and corresponding setting
    -- :h lspconfig-all for specific configuration of certain lsp server
    local servers = {
        lua_ls = {
            Lua = {
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
                diagnostic = {
                    globals = {
                        'vim',
                        'use',
                    }
                }
            },
        },
        clangd = {
            cmd = { 'clangd' },
            filetypes = { "c", "cpp", "cuda" },
        },
        marksman = {},
        pyright = {},
        rust_analyzer = {
            cmd = {
                "rustup", "run", "stable", "rust-analyzer",
            }
        },
    }

    -- on_attach : functions get run when an Lsp connects to a particular buffer.
    -- pass a parameter to mason_lspconfig.set_handlers to set up options automatically.
    local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'Lsp: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        local telescopeExist, telescopeBuiltin = pcall(require, 'telescope.builtin')
        nmap('<leader>rn', vim.lsp.buf.rename, "[R]e[n]ame")
        nmap('<leader>ga', vim.lsp.buf.code_action, "code [A]ction")
        if telescopeExist then
            nmap('gd', telescopeBuiltin.lsp_definitions, "[G]oto [D]efinition")
            nmap('gD', telescopeBuiltin.diagnostics, "[G]oto [D]iagnostics")
            nmap('gr', telescopeBuiltin.lsp_references, "[G]oto [R]eference")
            nmap('?', telescopeBuiltin.lsp_document_symbols, "Document symble")
            nmap('gi', telescopeBuiltin.lsp_implementations, "[G]oto [I]mplementation")
        end
        nmap('<leader>k', vim.lsp.buf.hover, "Hover Document")
    end

    mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers)
    }

    mason_lspconfig.setup_handlers {
        function(server_name)
            require('lspconfig')[server_name].setup {
                capabilities = cmp_nvim_lsp.default_capabilities(),
                on_attach = on_attach,
                settings = servers[server_name],
            }
        end
    }

    local clangd_capabilities = vim.lsp.protocol.make_client_capabilities()
    clangd_capabilities.offsetEncoding = "utf-8"
    require("lspconfig").clangd.setup {
        capabilities = clangd_capabilities,
        on_attach = on_attach,
        settings = servers['clangd'],
    }
end



-- lsp status information
-- Plugin : fidget
local fidgetExist, fidget = pcall(require, "fidget")
if fidgetExist then
    fidget.setup()
end

-- lsp support for nvim builtin lua functions
-- Plugin : neodev
local neodevExist, neodev = pcall(require, "neodev")
if neodevExist then
    neodev.setup()
end

require("lsp_signature").setup({
    noice = false,
    bind = false,
    floating_window = true,
})
