local M = {}
local Layout = require("nui.layout")
local Popup = require("nui.popup")

local top_popup = Popup({ border = "single" })
local bottom_popup = Popup({ border = "double" })


-- local layout = Layout( {
--     position = "50%",
--     size = {
--         width = 30,
--         hight = 50,
--     },
-- },
-- Layout.Box({
--     Layout.Box(top_popup, {size = "40%"}),
--     Layout.Box(bottom_popup, {size = "60%"}),
-- }, {dir = "col"}))

-- layout:mount()
M.layout = Layout( {
    position = "50%",
    size = {
        width = 30,
        height = 50,
    },
},
Layout.Box({
    Layout.Box(top_popup, { size = "40%" }),
    Layout.Box(bottom_popup, { size = "60%" }),
},
{ dir = "col" })
)

local p = require("util.display.popup")
local pop = p.get_instance(p.layouts["mini"])
pop.mount()

return M
