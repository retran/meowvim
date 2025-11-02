-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/git-conflict.lua
-- @brief: Convenient helpers to resolve merge conflicts within Neovim.

return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPost",
  opts = {
    default_mappings = false,
    disable_diagnostics = true,
    highlights = {
      incoming = "DiffAdd",
      current = "DiffText",
    },
  },
}
