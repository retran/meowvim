-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-treesitter-context.lua
-- @brief: Sticky code context from Tree-sitter scopes.
--
-- Previously disabled with the note that Neovim 0.12 removed the treesitter
-- `range` method. That is not the case: the plugin calls `TSNode:range()`,
-- which is alive and well on 0.12.5.

return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    enable = true,
    max_lines = 3,
    min_window_height = 10,
    line_numbers = true,
    mode = "topline",
    trim_scope = "outer",
    separator = nil,
    zindex = 20,
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)
  end,
}
