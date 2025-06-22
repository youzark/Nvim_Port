local ls = require "luasnip"

local s = ls.s
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

local luaSnip = {
    s( {
        trig = "snip",
        dscr = "Define luasnip snippets",
    }, {
        c(1, {
            sn(nil,
            fmt(
            [=[
                s( {{
                    trig="{}",
                    dscr="{}", }},
                    fmt(
                    [[
                        {}
                    ]],{{
                        {}
                    }})
                ),
                {}
            ]=] ,{
                i(1,"trigger"),
                i(2,"description"),
                i(3,"format string"),
                i(4,"'nodes'"),
                i(0)
            })
            ),
            sn(nil,
                fmt(
                [[
                s( {{
                    trig="{}",
                    dscr="{}", }}, {{
                        {}
                    }}
                ),
                {}
                ]], {
                    i(1,"trigger"),
                    i(2,"description"),
                    i(3,"nodes"),
                    i(0)
                }
                )
            ),
        }, { node_ext_opts = { passive = { virt_text = {{" More Choise"}} }, } }
        ),
        }
    ),
    s( {
        trig="formatNode",
        dscr="format snippets in lua, return a list of nodes", },
        fmt(
        [=[
            fmt(
            [[
                {}
            ]], {{
                {}
            }}),
            {}
        ]=],{
            i(1),
            i(2),
            i(0)
        }
        )
    ),
    s( {
        trig="choiceNode",
        dscr="choice node", },
        fmt(
        [=[
        c({}, {{
            {}
        }}, {{
            node_ext_opts = {{ passive = {{ virt_text = {{ {{"","GruvboxOrangeBold"}} }} }} }}
        }}),
        {}
        ]=],{
            i(1,"Position"),
            i(2,"choice nodes"),
            i(0)
        }
        )
    ),

    s( {
        trig="snippetNode",
        dscr="snippet node used in choice node to formmat list of nodes into one node", },
        fmt(
        [=[
            sn({},
                fmt(
                [[
                    {}
                ]], {{
                    {}
                }}
                )
            ),
            {}
        ]=],{
            i(1,"position"),
            i(2),
            i(3),
            i(0)
        }
        )
    ),
}





return luaSnip
