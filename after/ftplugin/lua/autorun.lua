#!/usr/bin/env lua
local function setShebangIfNotExist()
	local luaShebang = "#!/usr/bin/env lua"
	-- check if current file has a shebang
	local function existShebang()
		local firstLine = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
		if string.sub(firstLine,1,#luaShebang) == luaShebang then
			return true
		end
		return false
	end
	if not existShebang() then
		vim.fn.append(0,"#!/usr/bin/env lua")
	end
end

local function runLuaFile()
	setShebangIfNotExist()
	vim.cmd("w")
	vim.cmd("silent exec '!chmod +x %'")
	vim.cmd("!./%")
end

vim.keymap.set("n","<leader>t",runLuaFile,{buffer=true})
