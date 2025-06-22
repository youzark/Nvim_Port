local M = {}
local floatConfig = {
    width = 100,
    height = 25,
    enter = true,
    position = "center"
}

local dapui = require("dapui")
dapui.setup(require("programming.cpp.dapui").get_ui_config())

local prepare = function ()
    dapui.open()
    vim.keymap.set('n', 's', ":lua require('dap').step_into()<CR>", { })
    vim.keymap.set('n', 'S', ":lua require('dap').step_out()<CR>", {  })
    vim.keymap.set('n', 'n', ":lua require('dap').step_over()<CR>", { })
end

local cleanup = function (debugee)
    dapui.close()
    vim.api.nvim_del_keymap("n","n")
    vim.api.nvim_del_keymap("n","s")
    vim.api.nvim_del_keymap("n","S")
    vim.fn.system("rm " .. debugee)
end


M.startLocalDebug = function (debugee)
    debugee = debugee or "__debug__"
    local dap = require("programming.cpp.dap").get_dap(debugee)
    if not require("util.path").isFile("__debug__") then
        if require("programming.cpp.compile").compile(nil,debugee,nil) then prepare() end
    end
    dap.continue()
end

M.endLocalDebug = function (debugee)
    debugee = debugee or "__debug__"
    require("programming.cpp.dap").get_dap(debugee).terminate({},{ terminateDebuggee = true },function ()
        cleanup(debugee)
    end)
end

M.floatElement = function (elementId)
    require("dapui").float_element(elementId,floatConfig)
end
return M
