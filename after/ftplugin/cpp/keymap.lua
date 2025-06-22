-- compile local file and run in floating terminal
vim.keymap.set("n","<leader>t",require("programming.cpp.singleBuild").run,{buffer = true})

vim.keymap.set("n","<leader>m",":wa<cr>:!make<cr>:!./test<cr>")


-- Debug local file keymap
vim.keymap.set('n', 'C',
    function ()
        vim.cmd("wall")
        require("programming.cpp").startLocalDebug()
    end,
    { buffer = true }
)

vim.keymap.set('n', '<leader>cc',
    function ()
        require("programming.cpp").endLocalDebug()
    end,
    {buffer = true}
)

vim.keymap.set('n','b', require('dap').toggle_breakpoint, {buffer = true})

vim.keymap.set('n','R', require('dap').run_last, {buffer = true})

vim.keymap.set('n','<space>w', function()
        require("programming.cpp").floatElement("watches")
    end ,
    {buffer = true}
)

vim.keymap.set('n','<space>t', function()
        require("programming.cpp").floatElement("console")
    end ,
    {buffer = true}
)

vim.keymap.set('n','<space>s', function()
        require("programming.cpp").floatElement("stacks")
    end ,
    {buffer = true}
)
