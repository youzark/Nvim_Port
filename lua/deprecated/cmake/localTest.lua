#!/usr/bin/env lua
local M = {}

M.createLocalTestFile = function ()
    M._filePath = vim.fn.getcwd()
    M._fileName = vim.api.nvim_buf_get_name(0)
    M._testFilePath = M._filePath .. "/test.sh"
    M._flag = " -Wall -Wextra -Wshadow -Wconversion -Wpedantic -Werror -g " ..
    " -fsanitize=address -fno-omit-frame-pointer -fsanitize=undefined -fsanitize=leak "
    M._commands = {
        "#/bin/bash",
        "g++ " .. M._flag .. M._fileName .. " -o test__" ,
        "[ -e " .. M._filePath .. "/test__" .. " ]" .. " && " .. M._filePath .. "/test__",
        "[ -e " .. M._filePath .. "/test__" .. " ]" .. " && " .. "rm " .. M._filePath .. "/test__",
    }
    local testfile = io.open(M._testFilePath,"w")
    if testfile then
        for _,command in ipairs(M._commands) do
            testfile:write(command,"\n")
        end
        testfile:close()
    end
end

return M
