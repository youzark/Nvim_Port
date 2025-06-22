vim.keymap.set("n","<leader>ss",function()
    require("FTerm").scratch({cmd = {"gpustat"}})
end)
