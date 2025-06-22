local capture = require("capture")

capture.setup({
    location = "~/todo.md",
    project_root_todo = true
})


vim.keymap.del("n","<leader>J",{})
vim.keymap.del("n","<leader>X",{})

-- vim.keymap.set("n","<leader>n",capture.create_todo,{})
-- vim.keymap.set("n","<leader>j",capture.jump_to_file_with_column,{})
