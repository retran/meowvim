-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/lazydev.lua
-- @brief: Enhanced LuaLS workspace management and completion integration.

return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      "lazy.nvim",
    },
    integrations = {
      lspconfig = true,
      cmp = true,
    },
  },
}
