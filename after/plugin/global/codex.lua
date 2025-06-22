local M = {}

function M.setup()
    -- Define the options you want to pass to avante.nvim's setup
    local opts = {
        provider = "openrouter",

        -- Define configurations for different providers (vendors)
        vendors = {
            ["openrouter"] = {
                -- Inherit settings (like parsing functions) from the built-in 'openai' provider
                __inherited_from = 'openai',

                -- Specify the OpenRouter API endpoint
                endpoint = 'https://openrouter.ai/api/v1',

                -- Specify the *exact* name of the environment variable holding your API key
                api_key_name = 'Router_API', -- Changed from the example to match your requirement

                -- Specify the default model to use with OpenRouter
                -- Change this to any valid model on OpenRouter you prefer
                model = 'deepseek/deepseek-r1',
                -- Examples of other models: 'openai/gpt-4o', 'google/gemini-flash-1.5', 'mistralai/mistral-large'
            },
        },
    }

    -- Get the avante plugin's API (most plugins expose a setup function)
    local avante = require("avante")

    -- Call the plugin's setup function with the options
    avante.setup(opts)

    -- You could add other configuration logic here too, like keymaps specific to avante
    -- vim.keymap.set(...)
end

return M
