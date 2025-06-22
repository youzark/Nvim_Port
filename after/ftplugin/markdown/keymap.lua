local screenshot = require("screenshot.screenshot")
vim.keymap.set("n","<leader>i",screenshot.markdownTakeShotAndSave,{silent = true})
vim.keymap.set("n","<leader>t",function ()
    vim.cmd("MarkdownPreviewToggle")
end,{silent = true})

