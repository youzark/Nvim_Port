local M = { }

M.win = {
    getWidth = function()
        return vim.api.nvim_win_get_width(0)
    end,
    getHeight = function ()
        return vim.api.nvim_win_get_height(0)
    end
}


M.cursor = {
    getx = function()
        return vim.api.nvim_win_get_cursor(0)[1]
    end,
    gety = function()
        return vim.api.nvim_win_get_cursor(0)[2]
    end,
}

return M















