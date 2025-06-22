local M = {}
M.localBuild = require("programming.cpp.singleBuild").run
M.startLocalDebug = require("programming.cpp.debugger").startLocalDebug
M.endLocalDebug = require("programming.cpp.debugger").endLocalDebug
M.floatElement = require("programming.cpp.debugger").floatElement
return M
