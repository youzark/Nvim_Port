local M = {}

local ls = require "luasnip"

local s = ls.s
local i = ls.insert_node
local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt

 local lua = {
     s( {
         trig="fnemb",
         dscr="embed function", },
         fmt(
         [[
             function({})
                 {}
             end {}
         ]],{
             i(1,"parameters"),
             i(2,"body"),
             i(0)
         }
         )
     ),
     s( {
         trig="req",
         dscr="auto require module", },
         fmt(
         [[
             local {} = require('{}')
         ]],{
             f(function(import_name)
                 local parts = vim.split(import_name[1][1],".",true)
                 return parts[#parts] or ""
             end, {1}),
             i(1)
         }
         )
     ),
     s( {
         trig="fn",
         dscr="define lua function", },
         fmt(
         [[
             local {} = function({})
                 {}
             end
         ]],
         {
             i(1,"funcname"),
             i(2,"parameters"),
             i(3,"body"),
         }
         )
     ),
     s( {
         trig="while",
         dscr="while loop", },
         fmt(
         [[
             while {} do
                 {}
             end
             {}
         ]],{
             i(1),
             i(2),
             i(0)
         }
         )
     ),
 }

return lua


