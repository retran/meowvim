-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/rustaceanvim.lua
-- @brief: Rust development environment configuration.

return {
  "mrcjkb/rustaceanvim",
  -- v9 requires Neovim 0.12; pin to v8.0.5 if you need 0.11 support
  version = "^9",
  ft = { "rust" },
  init = function()
    vim.g.rustaceanvim = {
      tools = {},
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            -- checkOnSave is boolean in v6+; clippy is configured under check.command
            checkOnSave = true,
            check = {
              command = "clippy",
            },
          },
        },
      },
      dap = {},
    }
  end,
}
