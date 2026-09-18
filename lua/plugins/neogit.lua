-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/neogit.lua
-- @brief: Git UI leveraging Neovim buffers.

return {
  "NeogitOrg/neogit",
  cmd = { "Neogit" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "echasnovski/mini.icons",
  },
  opts = {
    -- `disable_commit_confirmation` and `commit_popup` used to be set here;
    -- neither key exists in neogit's config any more and neogit's validator
    -- ignores unknown keys, so they were silently dead.
    integrations = {
      diffview = false,
      snacks = true,
    },
    signs = {
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
  },
}
