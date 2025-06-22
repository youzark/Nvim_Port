local M = {}
local Popup = require("nui.popup")

M.layouts = {
    mini = {
        enter = true,
        focusable = true,
        relative = "win",
        border = {
            style = "rounded",
        },
        position = "50%",
        size = {
            width = "80%",
            height = "30%"
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:GruvboxOrangeBold",
        },
        buf_options = {
            modifiable = true,
            readonly = false
        }
    },
    cursor = {
        enter = false,
        focusable = false,
        relative = "cursor",
        border = {
            style = "rounded",
        },
        size = {
            width = "50%",
            height = "10%",
        },
        position = {
            row = 0,
            col = 0
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:GruvboxOrangeBold",
        },
        -- buf_options = {
        --     modifiable = false,
        --     readonly = true
        -- }
    }
}

M.previewBuffer = function()
    local _popup = Popup(M.layouts["mini"])
    local event = require("nui.utils.autocmd").event
    _popup:on({ event.BufLeave }, function()
        _popup:unmount()
    end, { once = true })

    _popup:map("n","q", function()
        _popup:unmount()
    end, { noremap = true })

    _popup:map("n","<esc>", function()
        _popup:unmount()
    end, { noremap = true })
    return _popup
end

M.hoverBuffer = function()
    local _popup = Popup(M.layouts["cursor"])
    local event = require("nui.utils.autocmd").event
    _popup:on({ event.CursorMoved }, function()
        _popup:unmount()
    end, { once = true })
    return _popup
end

-- local buf = Popup(M.layouts["cursor"])
-- buf:mount()
return M
