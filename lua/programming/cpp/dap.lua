local M = {}
M.get_dap = function (debugee)
    local dap = require("dap")
    local dapConfig = {
        {
            name = "Debug current C++ file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return debugee
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
            setupCommands = {
                {
                    text = '-enable-pretty-printing',
                    description = 'enable pretty printing',
                    ignoreFailures = false
                },
            },
        },
    }
    dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = os.getenv("HOME") .. '/bin/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
    }
    dap.configurations.cpp = dapConfig
    return dap
end

M.get_ui = function()

end

return M
