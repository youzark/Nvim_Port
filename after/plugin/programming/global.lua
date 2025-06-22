vim.keymap.set({"n"},"<leader>nb",function(  )
    require("programming.python").convertCurrentFile()
end,{buffer=false,silent=true})

