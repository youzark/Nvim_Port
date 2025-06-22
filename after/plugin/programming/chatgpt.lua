#!/usr/bin/env lua
local max_tokens = 65536
local config = {
	curl_params = { "--proxy", "http://127.0.0.1:7890" },
    chat_shortcut_respond = { modes = { "n", "v", "x" }, shortcut = "<CR>" },
    chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<A-d>" },
    chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<A-s>" },
    chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<A-n>" },
    chat_free_cursor = true,
    providers = {
        deepseek = {
            endpoint = "https://api.deepseek.com/chat/completions",
            secret = os.getenv("DEEPSEEK_API"),
        },
		googleai = {
			endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
			secret = os.getenv("Gemini_API"),
            model = "gemini-2.5-pro-exp-03-25"
		},
		openai = {
			disable = true,
			endpoint = "https://api.openai.com/v1/chat/completions",
		},
        router = {
            endpoint = "https://openrouter.ai/api/v1/chat/completions",
            secret = os.getenv("Router_API"),
        }
    },
	agents = {
		{
			name = "Sonnet",
			provider = "router",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = {
				model = "anthropic/claude-sonnet-4",
				max_tokens = max_tokens,
			},
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = require("gp.defaults").chat_system_prompt,
		},
		{
			name = "Opus",
			provider = "router",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = {
				model = "anthropic/claude-opus-4",
				max_tokens = max_tokens,
			},
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = require("gp.defaults").chat_system_prompt,
		},
		{
			name = "Gemini-Flash-Thinking",
			provider = "router",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = {
				model = "google/gemini-2.5-flash-preview-05-20:thinking",
				max_tokens = max_tokens,
			},
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = require("gp.defaults").chat_system_prompt,
		},
		{
			name = "Gemini-Flash",
			provider = "router",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = {
				model = "google/gemini-2.5-flash-preview-05-20",
				max_tokens = max_tokens,
			},
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = require("gp.defaults").chat_system_prompt,
		},
		{
			name = "Gemini-Pro",
			provider = "googleai",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = {
				model = "google/gemini-2.5-pro-preview-03-25",
				temperature = 1,
				top_p = 1,
				max_tokens = max_tokens,
			},
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = require("gp.defaults").chat_system_prompt,
		},
		{
			name = "DeepSeek-General",
			chat = true,
			command = false,
            provider = "deepseek",
			-- string with model name or table with model name and parameters
			model = {
                model = "deepseek-chat",
                temperature = 0,
                top_p = 0.95,
				max_tokens = max_tokens,
            },
			system_prompt = require("gp.defaults").chat_system_prompt,
		},
	},
}

local set_keymap = function()
    local function keymapOptions(desc)
        return {
            noremap = true,
            silent = true,
            nowait = true,
            desc = "GPT prompt " .. desc,
        }
    end

    -- Chat commands
    vim.keymap.set({"n"}, "<leader>cc", "<cmd>GpChatToggle popup<cr>", keymapOptions("Toggle Chat"))

    vim.keymap.set({"n"}, "<leader>cn", "<cmd>GpChatNew popup<cr>", keymapOptions("New Chat"))
    vim.keymap.set("v", "<leader>cn", ":<C-u>'<,'>GpChatNew popup<cr>", keymapOptions("Visual Chat New"))
    vim.keymap.set({"n"}, "<leader>cf", "<cmd>GpChatFinder popup<cr>", keymapOptions("Chat Finder"))
    vim.keymap.set({"n"}, "<leader>ca", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))

    vim.keymap.set("v", "<leader>cc", ":<C-u>'<,'>GpChatPaste popup<cr>", keymapOptions("Visual Chat Paste"))
    -- vim.keymap.set("v", "<leader>cp", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))

    vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))

    vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))

    -- Prompt commands

    vim.keymap.set({"n", "i", "v", "x"}, "<A-s>", "<cmd>GpStop<cr>", keymapOptions("Stop"))

    -- optional Whisper commands with prefix <C-g>w
    vim.keymap.set({"n", "i"}, "<leader>cw", "<cmd>GpWhisper<cr>", keymapOptions("Whisper"))
end

set_keymap()
require("gp").setup(config)
