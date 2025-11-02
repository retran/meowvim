-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/persistence.lua
-- @brief: Lightweight session management that respects sessionoptions.

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    options = {
      "buffers",
      "curdir",
      "folds",
      "globals",
      "tabpages",
      "winpos",
      "winsize",
      "localoptions",
    },
  },
}
