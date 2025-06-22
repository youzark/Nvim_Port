local popup = require ("util.display.popup")

local diag = vim.diagnostic.get(0)

local NuiLine = require("nui.line")
local lines = {}
for _, d in ipairs(diag) do
    local line = NuiLine()
    line:append(d.message)
    lines[d.lnum + 1] = line
end


local win = popup.hoverBuffer() 

 
win:mount()
local seq = 1
for num, line in pairs(lines) do
    print(num)
    print(line)
    line:render(win.bufnr,-1,seq,seq+1)
    seq = seq + 1
end
