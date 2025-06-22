local M = {}

function M.setup()
    -- Define the options you want to pass to avante.nvim's setup
    local opts = {
        behaviour = {
            use_cwd_as_project_root = true,
        },
        provider = "openrouter_sonnet",
        -- Define configurations for different providers (vendors)
        vendors = {
            ["openrouter_sonnet"] = {
                __inherited_from = 'openai',
                endpoint = 'https://openrouter.ai/api/v1',
                api_key_name = 'Router_API',
                proxy = "http://127.0.0.1:7890",
                model = 'anthropic/claude-sonnet-4',
            },
            ["openrouter_opus"] = {
                __inherited_from = 'openai',
                endpoint = 'https://openrouter.ai/api/v1',
                api_key_name = 'Router_API',
                proxy = "http://127.0.0.1:7890",
                model = 'anthropic/claude-opus-4',
            },
            ["openrouter_gemini_flash"] = {
                __inherited_from = 'openai',
                endpoint = 'https://openrouter.ai/api/v1',
                api_key_name = 'Router_API',
                proxy = "http://127.0.0.1:7890",
                model = "google/gemini-2.5-flash-preview-05-20",
            },
            ["openrouter_gemini_pro"] = {
                __inherited_from = 'openai',
                endpoint = 'https://openrouter.ai/api/v1',
                api_key_name = 'Router_API',
                proxy = "http://127.0.0.1:7890",
                model = "google/gemini-2.5-pro-preview"
            },
        },
    }
    local avante = require("avante")
    avante.setup(opts)
end

return M
