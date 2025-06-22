#!/usr/bin/env lua
-- required by:
-- 1. after/ftplugin/cpp

local M = {}

local local_build_options = {
    "-Wall",
    "-Wextra",
    "-Wshadow",
    "-Wconversion",
    "-Wpedantic",
    -- "-Werror",
    "-fsanitize=address",
    "-fno-omit-frame-pointer",
    "-fsanitize=undefined",
    "-fsanitize=leak",
}

M.run = function (options)
    options = options or local_build_options
    local target = "__test__"

    local compileExist, compile = pcall(require,"programming.cpp.compile")
    if compileExist then
        if compile.compile(options,target) then
            require("FTerm").scratch({cmd = "./" .. target})
            os.remove(target)
        end
    else
        vim.notify("Missing Module: programming.cpp.compile","error")
    end
end

return M
