-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/meow-yarn.lua
-- @brief: Visualizer of LSP hierarchies.

return {
  -- dir = "/Users/retran/workspace/meow.yarn.nvim", -- local dev override
  "retran/meow.yarn.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("meow.yarn").setup({})
  end,
}
