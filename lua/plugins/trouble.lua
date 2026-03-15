-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/trouble.lua
-- @brief: Diagnostics/status list UI built on Trouble.nvim.

return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = false,
    auto_preview = true,
    auto_jump = false,
    warn_no_results = true,
    open_no_results = false,
    icons = {
      indent = {
        top = "│",
        bottom = "│",
        middle = "│",
        last = "└",
        fold_open = "",
        fold_closed = "",
      },
    },
  },
}
