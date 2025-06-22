local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local mini_menu = {
    layout_strategy = "vertical",
    layout_config = {
        height = 0.3,
        width = 0.5,
        prompt_position = "top"
    },
    sorting_strategy = "ascending",
}


local enter = function(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    print(vim.inspect(selected))
    actions.close(prompt_bufnr)
end

local opts = {
    finder = finders.new_table({"gruvbox", "deus", "tokyonight"}),
    sorter = sorters.get_generic_fuzzy_sorter({}),
    attach_mappings = function (prompt_bufnr, map)
        map("i", "<CR>", enter)
        return true -- so that other default mappings still remain
    end
}

-- local colors = pickers.new(themes.get_ivy(),opts)
local colors = pickers.new(mini_menu,opts)

require("telescope.builtin").man_pages(mini_menu)

-- print(colors:find())
