-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/flash.lua
-- @brief: Search-based motion with contextual highlighting.

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      search = {
        multi_window = true,
        highlight = { backdrop = true },
      },
      char = {
        enabled = true,
        multi_line = false,
      },
    },
  },
  config = function(_, opts)
    local flash = require("flash")
    flash.setup(opts)
  end,
}
