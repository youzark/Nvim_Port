local ls = require "luasnip"

local s = ls.s
local i = ls.insert_node
local sn = ls.snippet_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node
local d = ls.dynamic_node

local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmta

local grammar = {
    s( {
        trig="isin",
        dscr="judge is instance of", },
        fmt(
        [[
            if isinstance(<>,<>):
                <>
            else:
                <>
            <>
        ]],{
            i(1),
            i(2),
            i(3),
            i(4),
            i(0)
        })
    ),
}

return grammar
