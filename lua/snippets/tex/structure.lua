local ls = require "luasnip"

local s = ls.s
local i = ls.insert_node
local sn = ls.snippet_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node
local d = ls.dynamic_node

local csn = function (jump_index, nodes, node_opts)
    return sn(jump_index, nodes, vim.tbl_deep_extend(node_opts, {
        node_ext_opts = {
            passive = {
                virt_text = {{" More Choise"}}
            }
        }
    }))
end

local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmta

local documents = {
    -- documentclass
    s( {
        trig="doc",
        dscr="short document without chapters", },
        fmt(
        [[
        %!TEX program = xelatex
        \documentclass{<>}

        <>
        \begin{document}
        <>
        <>
        \end{document}
        <>
        ]],{
            c(1, {
                i(nil, "report"),
                i(nil, "article"),
                i(nil, "beamer"),
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            
            c(2, {
                sn(nil,
                    fmt(
                    [[
                        <>\input{preamble.tex}

                    ]], {
                        i(1)
                    })
                ),
                sn(nil,
                    fmt(
                    [[
                        <>\usepackage{amsmath,amssymb}
                        \usepackage{graphicx}
                        \usepackage{booktabs}       % professional-quality tables
                        \usepackage{algorithm}
                        \usepackage{algpseudocode}
                        \usepackage[scheme=plain]{ctex}

                    ]], {
                        i(1)
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        <>\usepackage[utf8]{inputenc}
                        \usepackage{graphicx}
                        \usepackage{xcolor}
                        \usepackage[parfill]{parskip}
                        \usepackage[width = 14cm]{geometry}

                    ]], {
                        i(1)
                    }
                    )
                ),
            }),
            c(3, {
                sn(1, fmt( [[
                \title{<>}
                \author{<>}
                \date{\today}
                \maketitle
                <>
                ]], {
                i(1),
                i(2,"Hua Yongxiang"),
                i(0)
                })
                ),
                t (" "
                )
            }),
            i(4),
            i(0)
        }
        )
    ),
    s( {
        trig="frame",
        dscr="beamer frame", },
        fmt(
        [[
            \begin{frame}<>
                <>
                <>
            \end{frame}
            <>
        ]],{
            c(1, {
                sn(nil,
                    fmt(
                    [[
                       <> 
                    ]], {
                        i(1)
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        [<>]
                    ]], {
                        i(1,"t")
                    }
                    )
                ),
                
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            c(2, {
                sn(nil,
                    fmt(
                    [[
                        \frametitle{<>}
                    ]], {
                        i(1)
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        <>
                    ]], {
                        i(1)
                    }
                    )
                ),
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            i(3),
            i(0)
        })
    ),
    
    s( {
        trig="letter",
        dscr="no sections document", },
        fmt(
        [[
        \documentclass{letter}
        \usepackage[T1]{fontenc}
        \usepackage{xcolor}
        \begin{document}

        \begin{letter}{<>}
        \opening{<>,}
        <>
        \closing{Yours, <>}
        \end{letter}

        \end{document}
        ]],{
            i(1,"Title"),
            i(2,"Sendto"),
            i(0),
            i(3,"My name"),
        }
        )
    ),
}

local section = {
    s( {
        trig="chapter",
        dscr="create a chapter", },
        fmt(
        [[
            \chapter{<>}
            <>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="section",
        dscr="create section", },
        fmt(
        [[
        \section{<>}
        <>
        ]],{
            i(1,"Title"),
            i(0)
        }
        )
    ),
    s( {
        trig="subsection",
        dscr="create subsection", },
        fmt(
        [[
        \subsection{<>}
        <>
        ]],{
            i(1,"Title"),
            i(0)
        }
        )
    ),
    s( {
        trig="subsubsection",
        dscr="create subsubsection", },
        fmt(
        [[
        \subsubsection{<>}
        <>
        ]],{
            i(1,"Title"),
            i(0)
        }
        )
    ),
}

local list = {
    s( {
        trig="lo1",
        dscr="ordered list 1", },
        fmt(
        [[
        \begin{enumerate}
            \item <>
        \end{enumerate}
        <>
        ]],{
            i(1),
            i(0),
        }
        )
    ),
    s( {
        trig="lo2",
        dscr="ordered list 2", },
        fmt(
        [[
        \begin{enumerate}
            \item <>
            \item <>
        \end{enumerate}
        <>
        ]],{
            i(1),
            i(2),
            i(0),
        }
        )
    ),
    s( {
        trig="lo3",
        dscr="ordered list 3", },
        fmt(
        [[
        \begin{enumerate}
            \item <>
            \item <>
            \item <>
        \end{enumerate}
        <>
        ]],{
            i(1),
            i(2),
            i(3),
            i(0),
        }
        )
    ),
    s( {
        trig="lo4",
        dscr="ordered list 4", },
        fmt(
        [[
        \begin{enumerate}
            \item <>
            \item <>
            \item <>
            \item <>
        \end{enumerate}
        <>
        ]],{
            i(1),
            i(2),
            i(3),
            i(4),
            i(0),
        }
        )
    ),
    s( {
        trig="lu1",
        dscr="unordered list 1", },
        fmt(
        [[
        \begin{itemize}
            \item <>
        \end{itemize}
        <>
        ]],{
            i(1),
            i(0),
        }
        )
    ),
    s( {
        trig="lu2",
        dscr="unordered list 2", },
        fmt(
        [[
        \begin{itemize}
            \item <>
            \item <>
        \end{itemize}
        <>
        ]],{
            i(1),
            i(2),
            i(0),
        }
        )
    ),
    s( {
        trig="lu3",
        dscr="unordered list 3", },
        fmt(
        [[
        \begin{itemize}
            \item <>
            \item <>
            \item <>
        \end{itemize}
        <>
        ]],{
            i(1),
            i(2),
            i(3),
            i(0),
        }
        )
    ),
    s( {
        trig="lu4",
        dscr="unordered list 4", },
        fmt(
        [[
        \begin{itemize}
            \item <>
            \item <>
            \item <>
            \item <>
        \end{itemize}
        <>
        ]],{
            i(1),
            i(2),
            i(3),
            i(4),
            i(0),
        }
        )
    ),
    s( {
        trig="preamble",
        dscr="a sample preamble", },
        fmt(
        [[
            % Document settings
            \usepackage[a4paper,margin=1in]{geometry} % Adjust page margins
            \usepackage[T1]{fontenc} % Font encoding
            \usepackage{setspace} % Line spacing
            \onehalfspacing % Adjust line spacing to 1.5

            % Chinese input
            \usepackage[UTF8]{ctex}
            \usepackage{xeCJK}

            % Additional packages
            \usepackage{graphicx} % For including images
            \usepackage{amsmath, amssymb} % Mathematical symbols and equations
            \usepackage{cite} % Bibliography management
            \usepackage{hyperref} % Hyperlinks within the document

            % Table of contents customization
            \usepackage{tocloft}
            \setcounter{tocdepth}{2} % Set the depth of the table of contents
            
            % Beautify box
            \usepackage[breakable]{tcolorbox}

            % flow Graph
            \usepackage{tikz}

            % todo list
            \usepackage{xargs}                      % Use more than one optional parameter in a new commands
            \usepackage[]{xcolor}  % Coloured text etc.
            \usepackage[colorinlistoftodos,prependcaption,textsize=tiny]{todonotes}

            \newcommandx{\unsure}[2][1=]{\todo[linecolor=red,backgroundcolor=red!25,bordercolor=red,#1]{#2}}
            \newcommandx{\change}[2][1=]{\todo[linecolor=blue,backgroundcolor=blue!25,bordercolor=blue,#1]{#2}}
            \newcommandx{\info}[2][1=]{\todo[linecolor=OliveGreen,backgroundcolor=OliveGreen!25,bordercolor=OliveGreen,#1]{#2}}
            \newcommandx{\improvement}[2][1=]{\todo[linecolor=Plum,backgroundcolor=Plum!25,bordercolor=Plum,#1]{#2}}
            \newcommandx{\thiswillnotshow}[2][1=]{\todo[disable,#1]{#2}}

            \newtcolorbox{BlueBox}[1][]{
                colback=yellow!10,
                colframe=blue!75!black,
                coltitle=red!70!black,
                fonttitle=\bfseries\large,
                fontupper=\sffamily\small,
                boxrule=2pt,
                arc=6pt,
                left=15pt,
                right=15pt,
                top=10pt,
                bottom=10pt,
                breakable, % Allow the box to break across pages
                #1 % Custom parameters passed in the []
            }
            \newtcolorbox{RedBox}[1][]{
                colback=orange!70, % Background color
                colframe=red!75!black, % Border color
                coltitle=black!70!black, % Title color
                fonttitle=\bfseries\large,
                fontupper=\sffamily\small,
                boxrule=2pt,
                arc=6pt,
                left=15pt,
                right=15pt,
                top=10pt,
                bottom=10pt,
                breakable, % Allow the box to break across pages
                #1 % Custom parameters passed in the []
            }

            \newcommand{\inlinetodo}[1]{%
            \begin{tcolorbox}[%
                colback=orange!70, % Background color
                colframe=red!75!black, % Border color
                coltitle=red!70!black,
                fonttitle=\bfseries\large,
                fontupper=\sffamily\small,
                boxrule=2pt,
                arc=6pt,
                left=15pt,
                right=15pt,
                top=10pt,
                bottom=10pt,
                hbox,
                breakable]
                \textcolor{red}{\textbf{TODO}} : #1
            \end{tcolorbox}
            }

            \usepackage{listings}

            \definecolor{codegreen}{rgb}{0,0.6,0}
            \definecolor{codegray}{rgb}{0.5,0.5,0.5}
            \definecolor{codepurple}{rgb}{0.58,0,0.82}
            \definecolor{backcolour}{rgb}{0.95,0.95,0.92}

            \lstdefinestyle{mystyle}{
                backgroundcolor=\color{backcolour},   
                commentstyle=\color{codegreen},
                keywordstyle=\color{magenta},
                numberstyle=\tiny\color{codegray},
                stringstyle=\color{codepurple},
                basicstyle=\ttfamily\footnotesize,
                breakatwhitespace=false,         
                breaklines=true,                 
                captionpos=b,                    
                keepspaces=true,                 
                numbers=left,                    
                numbersep=5pt,                  
                showspaces=false,                
                showstringspaces=false,
                showtabs=false,                  
                tabsize=2
            }

            \lstset{style=mystyle}


            <>
        ]],{
            i(0)
        }
        )
    ),
    s( {
        trig="url",
        dscr="url reference", },
        fmt(
        [[
            \url{<>}<>
        ]],{
            i(1),
            i(0)
        }
        )
    ),
    s( {
        trig="minipage",
        dscr="minipage for fixed picture", },
        fmt(
        [[
            \begin{minipage}[<>]{<>}
                <>
            \end{minipage}
            <>
        ]],{
            c(1, {
                t("c"),
                t("t"),
                t("b")
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            c(2, {
                sn(nil,
                    fmt(
                    [[
                        <>\textwidth
                    ]], {
                        i(1,"0.8")
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        <>cm
                    ]], {
                        i(1,"3")
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        <>in
                    ]], {
                        i(1,"3")
                    }
                    )
                ),
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }
            ),
            i(3),
            i(4)
        }
        )
    ),
    s( {
        trig="columns",
        dscr="columns in beamer", },
        fmt(
        [[
            \begin{columns}
                \begin{column}{<>\textwidth}
                <>
                \end{column}
                <>
            \end{columns}<>
        ]],{
            i(1),
            i(2),
            i(3),
            i(0)
        })
    ),
    
    s( {
        trig="makebox",
        dscr="a box component", },
        fmt(
        [[
            \makebox[<>][<>]{
                <>
            }
            <>
        ]],{
            c(1, {
                sn(nil,
                    fmt(
                    [[
                        <>\textwidth
                    ]], {
                        i(1,".8")
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        <>cm
                    ]], {
                        i(1,"3")
                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        <>in
                    ]], {
                        i(1,"3")
                    }
                    )
                ),
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            c(2, {
                t "t",
                t "r",
                t "c",
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }
            ),
            i(3),
            i(0)
        }
        )
    ),
    s( {
        trig="vspace",
        dscr="vspace", },
        fmt(
        [[
            \vspace{<>mm}<>
        ]],{
            i(1,"9"),
            i(0)
        })
    ),
}

local Diagram = {
    s( {
        trig="flowGraph",
        dscr="draw flow graph", },
        fmt(
        [[
            \begin{tikzpicture}[node distance=2cm, every node/.style={draw, rectangle}]
                % nodes
                \node (start) {Start};
                \node (process1) [below of=start] {Process 1};
                \node (process2) [below of=process1] {Process 2};
                \node (end) [below of=process2] {End};
                
                % Edges
                \draw [->>] (start) -- (process1);
                \draw [->>] (process1) -- (process2);
                \draw [->>] (process2) -- (end);
                <>
            \end{tikzpicture}
            <>
        ]],{
            i(1),
            i(0)
        })
    ),
}

local inline_todo = sn(nil,
    fmt(
    [[
    ]], {
        
    }
    )
)

local todo = {
    s( {
        trig="todo",
        dscr="inline todo box", },
        fmt(
        [[
            \inlinetodo{<>}<>
        ]],{
            i(1),
            i(0)
        })
    ),
    s( {
        trig="unsure",
        dscr="comment a line with unsure information", },
        fmt(
        [[
            \unsure{<>}<>
        ]],{
            i(1),
            i(0)
        })
    ),
    s( {
        trig="info",
        dscr="add infomation on margin", },
        fmt(
        [[
            \info{<>}<>
        ]],{
            i(1),
            i(0)
        })
    ),
    s( {
        trig="improvement",
        dscr="add margin comment about imporvement", },
        fmt(
        [[
            \improvement{<>}<>
        ]],{
            i(1),
            i(0)
        })
    ),
}

local box = {
    s( {
        trig="BoxBlue",
        dscr="a blue box", },
        fmt(
        [[
            \begin{BlueBox}[<><>]
            <>
            \end{BlueBox}
            <>
        ]],{
            c(1, {
                sn(nil,
                    fmt(
                    [[
                        title=<>,
                    ]], {
                        i(1),
                    })
                ),
                t ""
            }),
            c(2, {
                t("hbox,"),
                t("")
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            i(3),
            i(0)
        })
    ),
    s( {
        trig="BoxRed",
        dscr="a red box", },
        fmt(
        [[
            \begin{RedBox}[<><>]
            <>
            \end{RedBox}
            <>
        ]],{
            c(1, {
                sn(nil,
                    fmt(
                    [[
                        title=<>,
                    ]], {
                        i(1),
                    })
                ),
                t ""
            }),
            c(2, {
                t("hbox,"),
                t("")
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            i(3),
            i(0)
        })
    ),
    s( {
        trig="codeSnippet",
        dscr="code snippet", },
        fmt(
        [[
            \begin{lstlisting}[language=Python]
            <>
            \end{lstlisting}<>
        ]],{
            i(1),
            i(0)
        })
    ),
    
    s( {
        trig="box",
        dscr="colorful box with different styles", },
        fmt(
        [[
            \begin{tcolorbox}[
                <>
            ]
            <>
            \end{tcolorbox}
            <>
        ]],{
            c(1, {
                sn(nil,
                    fmt(
                    [[
                        colback=yellow!10, % Background color
                        colframe=blue!75!black, % Border color
                        coltitle=red!70!black, % Title color
                        fonttitle=\bfseries\large, % Font style for the title
                        fontupper=\sffamily\small, % Font style for the content
                        boxrule=2pt, % Border width
                        arc=6pt, % Rounded corner size
                        left=15pt, % Left margin
                        right=15pt, % Right margin
                        top=10pt, % Top margin
                        bottom=10pt, % Bottom margin
                        title=<>, % Title of the box
                        breakable % Enable breaking across pages<>
                    ]], {
                        i(1,"Title"),
                        i(0)

                    }
                    )
                ),
                sn(nil,
                    fmt(
                    [[
                        colback=orange!70, % Background color
                        colframe=red!75!black, % Border color
                        coltitle=black!70!black, % Title color
                        fonttitle=\bfseries\large, % Font style for the title
                        fontupper=\sffamily\small, % Font style for the content
                        boxrule=2pt, % Border width
                        arc=6pt, % Rounded corner size
                        left=15pt, % Left margin
                        right=15pt, % Right margin
                        top=10pt, % Top margin
                        bottom=10pt, % Bottom margin
                        title=<>, % Title of the box
                        breakable % Enable breaking across pages<>
                        
                    ]], {
                        i(1,"Title"),
                        i(0)
                    }
                    )
                ),
                    
            }, {
                node_ext_opts = { passive = { virt_text = { {"","GruvboxOrangeBold"} } } }
            }),
            i(2),
            i(0)
        })
    ),
    s( {
        trig="image",
        dscr="latex image env", },
        fmt(
        [[
            \includegraphics[width=.95\textwidth]{<>}<>
        ]],{
            i(1),
                i(0)
        })
    ),
    
    s( {
        trig="figure",
        dscr="figure floating env", },
        fmt(
        [[
            \begin{figure}[h]
                \centering
                <>
            \end{figure}<>
        ]],{
            i(1),
                i(0),
        })
    ),
    s( {
        trig="column",
        dscr="column for beamer", },
        fmt(
        [[
            \begin{column}{<>\textwidth}
                <>
            \end{column}<>
        ]],{
            i(1,"0.5"),
                i(2),
                i(3)
        })
    ),
    
    
}



local M = {}

-- merge different parts together
for _, lists in ipairs({documents,section,list,Diagram,todo,box}) do
    for _, item in ipairs(lists) do
        table.insert(M,item)
    end
end

return M
