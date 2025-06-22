local ls = require "luasnip"

local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmta
local c = ls.choice_node
local sn = ls.snippet_node

    

local math = {
    -- math
    -- functions
    s( {
        trig="formular",
        dscr="formular or equation", },
        fmt(
        [[
            \begin{equation*}
                <>
            \end{equation*}
            <>
        ]],{
            i(1),
            i(0)
        })
    ),
    s( {
        trig="partial",
        dscr="partial derivative", },
        fmt(
        [[
            \partial<>
        ]],{
            i(0),
        })
    ),
    s( {
        trig="equationSystemParathesis",
        dscr="equation System Large left Parathesis", },
        fmt(
        [[
            \begin{cases}
                <>
            \end{cases}
            <>
        ]],{
            i(1),
                i(0)
        })
    ),
    
    
    s( {
        trig="combinatorics",
        dscr="combinatorics", },
        fmt(
        [[
            \binom{<>}{<>}<>
        ]],{
            i(1),
                i(2),
                i(0)
        })
    ),
    s( {
        trig="suchthat",
        dscr="such that , implies", },
        fmt(
        [[
            \implies<>
        ]],{
            i(0)
        })
    ),
    s( {
        trig="backslash",
        dscr="backslash set minus", },
        fmt(
        [[
            \setminus<>
        ]],{
            i(0)
        })
    ),
    s( {
        trig="equivalent",
        dscr="left right arrow", },
        fmt(
        [[
            \Leftrightarrow<>
        ]],{
            i(0)
        })
    ),
    
    s( {
        trig="setminus",
        dscr="backslash set minus", },
        fmt(
        [[
            \setminus<>
        ]],{
            i(0)
        })
    ),
    
    s( {
        trig="implies",
        dscr="such that , implies", },
        fmt(
        [[
            \implies<>
        ]],{
            i(0)
        })
    ),
    
    s( {
        trig="formulars",
        dscr="formulars or equations", },
        fmt(
        [[
            \begin{align*}
                <>
            \end{align*}
            <>
        ]],{
            i(1),
            i(0)
        })
    ),

    s( {
        trig="parenthesis",
        dscr="parenthesis", }, {
        c(1, {
            sn(nil,
                fmt(
                [[
                    \left(<>\right)<>
                ]], {
                    i(1),
                        i(0)
                }
                )
            ),
            sn(nil,
                fmt(
                [[
                    \left[<>\right]<>
                ]], {
                    i(1),
                        i(0)
                }
                )
            ),
            sn(nil,
                fmt(
                [[
                    \left{<>\right}<>
                ]], {
                    i(1),
                        i(0)
                }
                )
            ),
        }, {
            node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
        }),
        }
    ),
    s( {
        trig="matrix",
        dscr="matrix", },
        fmt(
        [[
            \begin{matrix}
                <>\\
                <>
            \end{matrix}<>
        ]],{
            i(1),
                i(2),
                i(0)
        })
    ),
    
    s( {
        trig="mathinline",
        dscr="inline math expression", },
        fmt(
        [[
            $<>$ <>
        ]],{
            i(1,"equation"),
            i(0)
        }
        )
    ),
    s( {
        trig="mathdisplay",
        dscr="math expression in seperate env", },
        fmt(
        [[
            \[
            <>
            \]
            <>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="sin",
        dscr="sin", },
        fmt(
        [[
            \sin<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="cos",
        dscr="cos", },
        fmt(
        [[
            \cos<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="tan",
        dscr="tan", },
        fmt(
        [[
            \tan<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="cot",
        dscr="cot", },
        fmt(
        [[
            \cot<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="log",
        dscr="log function", },
        fmt(
        [[
            \log{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="sqrt",
        dscr="square root", },
        fmt(
        [[
            \sqrt{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="ssqrt",
        dscr="subscription sqrt", },
        fmt(
        [[
            \sqrt[<>]{<>}<>
        ]],{
            i(1,"pow"),
            i(2,"base"),
            i(0)
        }
        )
    ),
    s( {
        trig="frac",
        dscr="fraction", },
        fmt(
        [[
            \frac{<>}{<>}<>
        ]],{
            i(1),
            i(2),
            i(0)
        }
        )
    ),

    -- latters
    -- greek
    s( {
        trig="alpha",
        dscr="α", },
        fmt(
        [[
            \alpha<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="beta",
        dscr="β", },
        fmt(
        [[
            \beta<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="gamma",
        dscr="γ", },
        fmt(
        [[
            \gamma<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="lambda",
        dscr="γ", },
        fmt(
        [[
            \lambda<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="theta",
        dscr="θ", },
        fmt(
        [[
            \theta<>
        ]],{
            i(0)
        }
        )
    ),
    -- operator
    s( {
        trig="sum",
        dscr="summation notation", }, {
            c(1, {
                sn(nil,
                    fmt(
                    [[
                        \sum_{<>}^{<>}<>
                    ]], {
                        i(1),
                            i(2),
                            i(0),
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        \sum_{<>}<>
                    ]], {
                        i(1),
                            i(0),
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        \sum^{<>}<>
                    ]], {
                        i(1),
                            i(0)
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        \sum<><>
                    ]], {
                        i(1),
                            i(0)
                    }
                    )
                ),
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
        }
    ),
    s( {
        trig="neg",
        dscr="negation logical", },
        fmt(
        [[
            \neg<>
        ]],{
            i(0),
        })
    ),
    s( {
        trig="not",
        dscr="logical negation", },
        fmt(
        [[
            \neg<>
        ]],{
            i(0)
        })
    ),
    s( {
        trig="prod",
        dscr="product", },
        fmt(
        [[
            \prod<>
        ]],{
            i(0),
        }
        )
    ),
    s( {
        trig="integrate",
        dscr="integration", },
        fmt(
        [[
            \int<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="times",
        dscr="×", },
        fmt(
        [[
            \times<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="div",
        dscr="÷", },
        fmt(
        [[
            \div<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="oplus",
        dscr="⊕", },
        fmt(
        [[
            \oplus<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="otimes",
        dscr="⊗", },
        fmt(
        [[
            \otimes<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="cap",
        dscr="∩", },
        fmt(
        [[
            \cap<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="cup",
        dscr="∪", },
        fmt(
        [[
            \cup<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="infinity",
        dscr="∞", },
        fmt(
        [[
            \infty<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="exist",
        dscr="∃", },
        fmt(
        [[
            \exists<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="any",
        dscr="∀", },
        fmt(
        [[
            \forall<>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="include",
        dscr="in", },
        fmt(
        [[
            \in<>
        ]],{
            i(0)
        }
        )
    ),
}

return math
