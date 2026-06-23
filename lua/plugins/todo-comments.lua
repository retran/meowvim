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
    highlight = {
      keyword = "bg",
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
    },
  },
}
