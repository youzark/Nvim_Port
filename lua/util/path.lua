#!/usr/bin/env lua
local M = {}

M.isFile = function (name)
    local file = io.open(name,"r")
    if file ~= nil then io.close(file) return true else return false end
end

return M
