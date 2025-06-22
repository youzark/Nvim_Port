local M = { }

M.localBuild = require("programming.python.singleBuild").run
M.tryConnect = require("programming.python.jupyter").try_connect
M.executeCell = require("programming.python.jupyter").send_cell
M.executeVisual = require("programming.python.jupyter").send_range
M.convertCurrentFile  = require("programming.python.jupyter").convertCurrentFile

return M
