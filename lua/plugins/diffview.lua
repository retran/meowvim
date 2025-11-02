-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/diffview.lua
-- @brief: Git diff viewer with history timelines and enhanced comparisons.

return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = {
        layout = "diff2_horizontal",
      },
    },
    file_history_panel = {
      log_options = {
        git = {
          single_file = {
            max_count = 256,
          },
        },
      },
    },
  },
}
