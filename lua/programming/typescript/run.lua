local M = {}
local function setShebangIfNotExist()
    if vim.bo.filetype ~= "typescript" then
        vim.notify("Not typescript File","error")
        return
    end
	local tsSheBang = "#!/usr/bin/env ts-node"
	-- check if current file has a shebang
	local function existShebang()
		local firstLine = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
		if string.sub(firstLine,1,#tsSheBang) == tsSheBang then
			return true
		end
		return false
	end
	if not existShebang() then
		vim.fn.append(0,tsSheBang)
	end
end

M.run = function()
    setShebangIfNotExist()
    vim.cmd("wall")
    require("FTerm").scratch({cmd = "ts-node" .. " " .. vim.api.nvim_buf_get_name(0)})
    -- require("FTerm").scratch({cmd = "node --loader ts-node/esm" .. " " .. vim.api.nvim_buf_get_name(0)})
end

return M
