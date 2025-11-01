-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/neogit.lua
-- @brief: Git UI leveraging Neovim buffers with Diffview integration.

return {
  "NeogitOrg/neogit",
  cmd = { "Neogit" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    disable_commit_confirmation = true,
    integrations = {
      diffview = true,
    },
    commit_popup = {
      kind = "floating",
    },
    signs = {
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
  },
}
