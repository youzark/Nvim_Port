local M = { }

local defaultTarget = "__test__"
local default_options = {
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
    "-g"
}

M.compile = function (options, target, source)
    -- only compile cpp files
    if vim.bo.filetype ~= "cpp" then
        vim.notify("Not C++ File","error")
        return false
    end

    options = options or default_options
    target = target or defaultTarget
    source = source or vim.api.nvim_buf_get_name(0)
    local compile_flag = table.concat(options," ")
    local compile_command = "g++ " .. compile_flag .. " " .. source .. " -o " .. target

    if vim.fn.system(compile_command) ~= "" then
        require("FTerm").scratch({cmd = compile_command}) -- run the command (in terminal so that output is documented)
        vim.notify("Compile Failed!","error")
        return false
    else
        vim.notify("Compile Succeed!","info")
        return true
    end
end

return M
