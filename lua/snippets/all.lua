local ls = require "luasnip"

local s = ls.s
local i = ls.insert_node
local sn = ls.snippet_node
local t = ls.text_node
local f = ls.function_node
local d = ls.dynamic_node

local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local M = {
    s( {
        trig="curtime",
        dscr="current time", },
        fmt(
        [[
        {}
        ]],{
            f(function()
                return os.date "%D - %H:%M"
            end)
        }
        )
    ),
    s( {
        trig="date",
        dscr="date of today", },
        fmt(
        [[
            {}
        ]],{
            f(function()
                return os.date "%x %a"
            end)
        })
    ),
    s( {
        trig="time",
        dscr="current time", },
        fmt(
        [[
            {}
        ]],{
            f(function()
                return os.date "%X"
            end)
        })
    ),
    s( {
        trig="check",
        dscr="check", },
        fmt(
        [[
            \checkmark
        ]],{
        })
    ),
    s( {
        trig="filepath",
        dscr="get current file path", },
        fmt(
        [[
            {}
        ]],{
            f(function()
                return vim.fn.expand('%:p')
            end)
        })
    ),
}


return M
