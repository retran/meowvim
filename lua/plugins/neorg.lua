-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/neorg.lua
-- @brief: Note-taking and organization system with structured markup.

return {
  "nvim-neorg/neorg",
  lazy = false,
  version = "*",
  dependencies = {
    "vhyrro/luarocks.nvim",
    "nvim-lua/plenary.nvim",
  },
  ft = "norg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.concealer"] = {},
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
            index = "index.norg",
          },
        },
        ["core.journal"] = {
          config = {
            strategy = "nested",
            workspace = "notes",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.treesitter"] = {},
      },
    })
  end,
}
