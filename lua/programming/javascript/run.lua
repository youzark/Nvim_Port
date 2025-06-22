local M = {}
local function setShebangIfNotExist()
    if vim.bo.filetype ~= "javascript" then
        vim.notify("Not javascript File","error")
        return
    end
	local jsShebang = "#!/usr/bin/env node"
	-- check if current file has a shebang
	local function existShebang()
		local firstLine = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
		if string.sub(firstLine,1,#jsShebang) == jsShebang then
			return true
		end
		return false
	end
	if not existShebang() then
		vim.fn.append(0,jsShebang)
	end
end

M.run = function()
    setShebangIfNotExist()
    vim.cmd("wall")
    require("FTerm").scratch({cmd = "node" .. " " .. vim.api.nvim_buf_get_name(0)})
end

return M
