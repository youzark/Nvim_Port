local M = { }
local monitor = require("util.i3")

M.try_connect = function()
    if not vim.b.jupyter_kernel_loaded then
        vim.fn.system("jupyter qtconsole &")
        os.execute("sleep 3")
        vim.cmd("JupyterConnect")
        vim.b.jupyter_kernel_loaded = true
        monitor.focusMonitor(monitor.outputNames[2])
    end
end

M.send_cell = function ()
    M.try_connect()
    vim.cmd("JupyterSendCell")
    monitor.focus("jupyter-qtconsole")
    monitor.focus("Alacritty")
end


M.send_range = function ()
    M.try_connect()
    vim.cmd("JupyterSendRange")
end

M.convertCurrentFile = function ()
    vim.fn.system({"p2j",vim.api.nvim_buf_get_name(0),"-o"})
end

return M
