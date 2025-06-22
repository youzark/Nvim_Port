local M = {}

M.classNames = {
    "Alacritty",
    "QQ",
    "firefox",
    "Chromium",
    "Zathura",
    "jupyter-qtconsole"
}

M.outputNames = {
    "HDMI-1",
    "eDP-1"
}

M.focus = function( className )
    local cmd = string.format('i3-msg "[class=%s] focus"',className)
    vim.fn.system(cmd)
    M.fullscreen(className)
end

M.fullscreen = function( className )
    local cmd = string.format('i3-msg "[class=%s] fullscreen enable"',className)
    vim.fn.system(cmd)
end

M.focusMonitor = function(outputName)
    local cmd = string.format('i3-msg "focus output %s"',outputName)
    vim.fn.system(cmd)
end

return M
