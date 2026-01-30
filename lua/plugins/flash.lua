-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/flash.lua
-- @brief: Search-based motion with contextual highlighting.

return {
  "folke/flash.nvim",
  keys = {
    { "<leader><space>", mode = { "n", "x", "o" }, desc = "Flash Jump" },
    { "<leader>jj", mode = { "n", "x", "o" }, desc = "Flash Jump to Match" },
    { "<leader>jt", mode = { "n", "x", "o" }, desc = "Flash Jump to Treesitter Node" },
    { "<leader>ja", mode = { "n", "x", "o" }, desc = "Flash Jump in All Windows" },
    { "<leader>jm", mode = { "n", "x", "o" }, desc = "Flash Jump to Remote Target" },
  },
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
