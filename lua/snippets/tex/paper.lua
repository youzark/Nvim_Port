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

local paper = {
    s( {
        trig="cite",
        dscr="Paper Citation", },
        fmt(
        [[
            \cite{<>}<>
        ]],{
            i(1),
            i(0)
        })
    ),
}

local M = {}

-- merge different parts together
for _, lists in ipairs({paper}) do
    for _, item in ipairs(lists) do
        table.insert(M,item)
    end
end

return M
