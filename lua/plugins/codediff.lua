-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/codediff.lua
-- @brief: VSCode-style diff viewer with two-tier highlighting, file explorer, and history.

return {
  "esmuellert/codediff.nvim",
  build = ":CodeDiff install",
  cmd = { "CodeDiff" },
  opts = {
    diff = {
      layout = "inline",
    },
  },
}
