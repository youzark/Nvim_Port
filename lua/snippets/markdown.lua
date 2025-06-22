-- require
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

    -- headers 
    s( {
        trig="h1",
        dscr="level one header", },
        fmt(
        [[
        #
        ]],{
        }
        )
    ),
    s( {
        trig="h2",
        dscr="level two header", },
        fmt(
        [[
        ##
        ]],{
        }
        )
    ),
    s( {
        trig="h3",
        dscr="level three header", },
        fmt(
        [[
        ###
        ]],{
        }
        )
    ),
    s( {
        trig="h4",
        dscr="level four header", },
        fmt(
        [[
        ####
        ]],{
        }
        )
    ),

    -- table
    s( {
        trig="t2",
        dscr="tabel 1 * 2", },
        fmt(
        [[
            |{}|{}|
            |:---|:---|
            |{}|{}|
        ]],{
            i(1,"entry1"),
            i(2,"entry2"),
            i(3,"11"),
            i(4,"12"),
        }
        )
    ),
    s( {
        trig="t3",
        dscr="tabel 1 * 3", },
        fmt(
        [[
            |{}|{}|{}|
            |:---|:---|:---|
            |{}|{}|{}|
        ]],{
            i(1,"entry1"),
            i(2,"entry2"),
            i(3,"entry3"),
            i(4,"11"),
            i(5,"12"),
            i(6,"13"),
        }
        )
    ),
    s( {
        trig="t4",
        dscr="tabel 1 * 4", },
        fmt(
        [[
            |{}|{}|{}|{}|
            |:---|:---|:---|:---|
            |{}|{}|{}|{}|
        ]],{
            i(1,"entry1"),
            i(2,"entry2"),
            i(3,"entry3"),
            i(4,"entry4"),
            i(5,"11"),
            i(6,"12"),
            i(7,"13"),
            i(8,"14"),
        }
        )
    ),

    -- codeblock
    s( {
        trig="codeblock",
        dscr="code blocks", },
        fmt(
        [[
        ```{}
        {}
        ```
        ]],{
            i(1,"language"),
            i(2)
        }
        )
    ),
}


return M
