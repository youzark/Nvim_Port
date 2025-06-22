require("noice").setup( {
    -- this plugin is not stable enough
    -- only use it to put the command line in 
    -- the middle of the screen
    -- Don't try to use it as display manager
    messages = {
        enabled = false
    },
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["vim.entry.get_documentation"] = true
        },
        signature = {
            enabled = false,
        }
    },
    views = {
        cmdline_popup = {
            position = {
                row = "50%",
                col = "50%",
            },
            size = {
                width = "80%",
                height = "auto"
            },
        },
        hover = {
            size = {
              max_height = 20,
              max_width = math.floor(vim.api.nvim_win_get_width(0)*0.8)
            },
            border = {
                style = "rounded",
            },
            win_options = {
                winhighlight = {
                    Normal = "Normal",
                    FloatBorder = "NoiceCmdlinePopupBorder"
                },
            },
        },
    }
})


-- local config = {
--     messages = {
--         enabled = false
--     },
--     routes = {
--         {
--             filter = {
--                 any = {
--                     {
--                         event = "msg_show",
--                         kind = "",
--                         find = "written"
--                     },
--                     {
--                         event = "msg_show",
--                         find = "lines >ed",
--                     },
--                     {
--                         event = "msg_show",
--                         find = "more line;",
--                     },
--                     {
--                         event = "msg_show",
--                         find = "more lines",
--                     },
--                     {
--                         event = "msg_show",
--                         find = "lines yanked",
--                     },
--                     {
--                         event = "msg_show",
--                         find = "fewer lines",
--                     },
--                     {
--                         event = "msg_show",
--                         find = "lines moved",
--                     },
--                     {
--                         event = "msg_show",
--                         find = "lines <ed",
--                     },
--                     {
--                         find = "RPC[Error] code_name = ContentModified,"
--                     }
--                 }

--             },
--             opts = {
--                 skip = true
--             }
--         },
--         -- {
--         --     view = "notify",
--         --     filter = {
--         --         any = {
--         --         },
--         --     },
--         --     opts = {
--         --         stop = true
--         --     }
--         -- },
--         {
--             view = "virtualtext",
--             filter = {
--                 event = "msg_show",
--                 kind = "search_count"
--             },
--             opts = {
--                 stop = true
--             },
--         },
--         {
--             view = "longmsg",
--             filter = {
--                 any = {
--                     {
--                         event = "msg_show",
--                         kind = "echo"
--                     },
--                     {
--                         event = "msg_show",
--                         kind = "echomsg"
--                     },
--                     {
--                         event = "msg_show",
--                         kind = ""
--                     },
--                     {
--                         event = "msg_show",
--                         kind = "return_prompt"
--                     },
--                 },
--             },
--             opts = {
--                 stop = true
--             },
--         },
--     },
--     views = {
--         cmdline_popup = {
--             position = {
--                 row = "50%",
--                 col = "50%",
--             },
--             size = {
--                 width = "80%",
--                 height = "auto"
--             },
--         },
--         hover = {
--             size = {
--               max_height = 20,
--               max_width = math.floor(vim.api.nvim_win_get_width(0)*0.8)
--             },
--             border = {
--                 style = "rounded",
--             },
--             win_options = {
--                 winhighlight = {
--                     Normal = "NormalFloat",
--                     FloatBorder = "NoiceCmdlinePopupBorder"
--                 },
--             },
--         },
--         longmsg = {
--             relative = "win",
--             backend = "popup",
--             border = {
--                 style = "rounded",
--             },
--             focusable = true,
--             enter = true,
--             position = "50%",
--             size = {
--                 height = "auto",
--                 width = "auto",
--                 max_width = math.floor(vim.api.nvim_win_get_width(0)*0.8),
--                 max_height = math.floor(vim.api.nvim_win_get_height(0)*0.4),
--             },
--             close = {
--               events = { "BufLeave" },
--               keys = { "q", "<Esc>", "<Enter>"},
--             },
--             win_options = {
--                 winhighlight = {
--                     Normal = "Normal",
--                     FloatBorder = "NoiceCmdlinePopupBorder"
--                 },
--                 linebreak = true,
--                 wrap = true,
--             }
--         }
--     },
--     lsp = {
--         override = {
--             ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--             ["vim.lsp.util.stylize_markdown"] = true,
--             ["cmp.entry.get_documentation"] = true
--         },
--         signature = {
--             enabled = false
--         }
--     },
-- }

-- local function prequire(m)
--   local ok, err = pcall(require, m)
--   if not ok then return nil, err end
--   return err
-- end

-- -- usage
-- local noice = prequire("noice")
-- if noice then
--     noice.setup(config)
-- end
