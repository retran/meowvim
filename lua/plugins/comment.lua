-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/comment.lua
-- @brief: Treesitter-aware commenting powered by ts-comments.nvim.

return {
  "folke/ts-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
