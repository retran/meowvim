-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/rustaceanvim.lua
-- @brief: Rust development environment configuration.

return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  ft = { "rust" },
  init = function()
    vim.g.rustaceanvim = {
      tools = {},
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      dap = {},
    }
  end,
}
