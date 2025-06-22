local M = {}

local diag = vim.diagnostic.get(622)

for _, d in ipairs(diag) do
    print(d.message)
end

return M
