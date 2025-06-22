local python = require("programming.python")
vim.keymap.set("n","<leader>t",python.localBuild,{buffer = true})

-- vim.keymap.set("n","<leader>e","<Plug>JupyterExecute",{buffer=true})

-- vim.keymap.set("n","<leader>cc",python.tryConnect,{buffer = true})
vim.keymap.set('n','<leader>e',python.executeCell,{buffer = true})
vim.keymap.set('v','<leader>e',python.executeVisual,{buffer = true})
--
