local ls = require("luasnip")

ls.config.set_config {
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
}

vim.keymap.set({"s","i"}, "<A-j>", function()
    if ls.jumpable() then
        print("jumpable")
        ls.jump(1)
    else
        print("error")
    end
end,{})
vim.keymap.set({"s","i"}, "<A-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end,{})
vim.keymap.set({"s","i"},"<A-;>",function(  )
    if ls.choice_active() then
        ls.change_choice(1)
    end
end,{})

require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets"})
