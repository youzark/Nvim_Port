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

local fonts = {
    s( {
        trig="ita",
        dscr="italic", },
        fmt(
        [[
            \textit{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="bold",
        dscr="bold", },
        fmt(
        [[
            \textbf{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="color",
        dscr="color text", },
        fmt(
        [[
            \textcolor{<>}{<>}<>
        ]],{
            i(1,"red"),
            i(2),
            i(0)
        }
        )
    ),
    s( {
        trig="emphasize",
        dscr="emphasize", },
        fmt(
        [[
            \emph{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="red",
        dscr="red", },
        fmt(
        [[
            \textcolor{red}{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="blue",
        dscr="blue", },
        fmt(
        [[
            \textcolor{blue}{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="green",
        dscr="green", },
        fmt(
        [[
            \textcolor{green}{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="yellow",
        dscr="yellow", },
        fmt(
        [[
            \textcolor{yellow}{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="bolditalic",
        dscr="bolditalic", },
        fmt(
        [[
            \textbf{\textit{<>}}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
}

return fonts
