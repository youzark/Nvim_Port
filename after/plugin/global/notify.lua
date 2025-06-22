local notify = require("notify")
local config = {
    background_colour = "NotifyBackground",
    fps = 30,
    icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = ""
    },
    level = 2,
    minimum_width = 50,
    render = "default",
    stages = "fade_in_slide_out",
    timeout = 100,
    top_down = true
}
notify.setup(config)
vim.notify = function (msg, ...)
    if msg:match("different client offset_encodings") then
        return
    end
    notify(msg,...)
end
-- vim.notify = notify
