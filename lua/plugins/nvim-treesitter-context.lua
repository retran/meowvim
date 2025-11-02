-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-treesitter-context.lua
-- @brief: Sticky code context from Tree-sitter scopes.

return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    enable = true,
    max_lines = 3,
    min_window_height = 10,
    line_numbers = true,
    mode = "cursor",
    trim_scope = "outer",
    separator = nil,
    zindex = 20,
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)
  end,
}
