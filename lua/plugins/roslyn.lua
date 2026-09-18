-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/roslyn.lua
-- @brief: Roslyn language server integration for C#.

return {
  "seblyng/roslyn.nvim",
  ft = { "cs" },
  opts = {},
  config = function(_, opts)
    if vim.fn.executable("roslyn-language-server") ~= 1 then
      return
    end

    require("roslyn").setup(opts)
  end,
}
