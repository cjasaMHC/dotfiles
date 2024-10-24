-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}
-- vim.cmd("colorscheme nightfox")
M.lsp = { signature = false }
M.base46 = {
  theme = "nightfox",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}


return M
