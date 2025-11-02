-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/gitlinker.lua
-- @brief: Generate shareable permalinks for Git hosts.

return {
  "linrongbin16/gitlinker.nvim",
  cmd = { "GitLink" },
  opts = {
    mappings = nil,
    opts = {
      add_current_line_on_normal_mode = true,
    },
  },
  config = function(_, opts)
    require("gitlinker").setup(opts)
  end,
}
