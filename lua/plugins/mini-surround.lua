-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mini-surround.lua
-- @brief: Surround text objects with custom motions and Treesitter awareness.

return {
  "echasnovski/mini.surround",
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
      suffix_last = "N",
      suffix_next = "n",
    },
  },
  config = function(_, opts)
    require("mini.surround").setup(opts)
  end,
}
