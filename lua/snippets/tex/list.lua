local ls = require("luasnip")
local util = require("luasnip.util.util")
local node_util = require("luasnip.nodes.util")

local find_dynamic_node = function (node)
    while not node.dynamicNode do
        node = node.parent
    end
    return node.dynamicNode
end


