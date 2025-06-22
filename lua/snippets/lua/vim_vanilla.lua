local ls = require "luasnip"
local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local  M= {
    -- vim related
    s( {
        trig="keymap",
        dscr="set key map", },
        fmt(
        [[
            vim.keymap.set({{{}}},"{}",function({})
                {}
            end,{{buffer={},silent={}}})
            {}
        ]],{
            i(1,[["n"]]),
            i(2),
            i(3,[["parameters"]]),
            i(4,[["body"]]),
            i(5,"false"),
            i(6,"true"),
            i(0),
        }
        )
    ),
}

return M
