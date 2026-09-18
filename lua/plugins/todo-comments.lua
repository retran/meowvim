-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/todo-comments.lua
-- @brief: Highlight and navigate TODO/FIXME/HACK annotations.

return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TodoLocList", "TodoQuickFix" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- The `search` block that used to be here repeated todo-comments' own
    -- defaults (rg with the same five flags) verbatim.
    highlight = {
      keyword = "bg",
    },
  },
}
