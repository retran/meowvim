-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/glance.lua
-- @brief: VSCode-like LSP peek windows.

return {
  "dnlhc/glance.nvim",
  cmd = "Glance",
  module = "glance",
  opts = {
    detached = function(winid)
      return winid > -1
    end,
    preview = {
      type = "float",
      win = {
        border = "rounded",
      },
    },
  },
  config = function(_, opts)
    require("glance").setup(opts)
  end,
}
