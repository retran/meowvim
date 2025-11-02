-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/roslyn.lua
-- @brief: Plugin for C# development using Roslyn

return {
  "seblyng/roslyn.nvim",
  init = function()
    require("config.mason").ensure_servers({ "roslyn" })
  end,
  opts = {},
  config = function(_, opts)
    require("roslyn").setup(opts)
  end,
}
