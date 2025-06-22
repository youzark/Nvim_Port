local M = {}
local function setShebangIfNotExist()
    if vim.bo.filetype ~= "python" then
        vim.notify("Not Python File","error")
        return
    end
	local pythonShebang = "#!/usr/bin/env python3"
	-- check if current file has a shebang
	local function existShebang()
		local firstLine = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
		if string.sub(firstLine,1,#pythonShebang) == pythonShebang then
			return true
		end
		return false
	end
	if not existShebang() then
		vim.fn.append(0,pythonShebang)
	end
end

M.run = function()
    setShebangIfNotExist()
    vim.cmd("wall")
    require("FTerm").scratch({cmd = "python3" .. " " .. vim.api.nvim_buf_get_name(0)})
end

return M
