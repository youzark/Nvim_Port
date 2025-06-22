local M = {}

local simplify_layout = { {
        elements = { {
                id = "scopes",
                size = 0.25
            }
        },
        position = "left",
        size = 40
    }
}
local default_layout = { {

        elements = { {
                id = "scopes",
                size = 0.5
            }, {
                id = "watches",
                size = 0.5
            },
        },
        position = "left",
        size = 40
    }, {
        elements = { {
                id = "console",
                size = 1.0
            },
        },
        position = "bottom",
        size = 10
    },
}

local layouts = {
    default = default_layout,
    simplify = simplify_layout,
}

local dapui_config = {
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
        }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" }
        }
    },
    force_buffers = true,
    icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
    },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
    },
    render = {
        indent = 1,
        max_value_lines = 100
    }
}

M.get_ui = function(layoutStyle)
    layoutStyle = layoutStyle or "default"
    local dapui = require("dapui")
    dapui_config["layouts"]= layouts[layoutStyle]
    dapui.setup(dapui_config)
    return dapui
end

M.get_ui_config = function(layoutStyle)
    layoutStyle = layoutStyle or "default"
    dapui_config["layouts"]= layouts[layoutStyle]
    return dapui_config
end

return M
