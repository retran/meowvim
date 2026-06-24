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
        on_attach = function(client, _bufnr)
          -- Workaround for rust-analyzer 1.96.0 bug: panics on textDocument/didSave
          -- while VFS is still initializing (FileSourceRootInput not set for FileId).
          -- checkOnSave still works via didChange debounce.
          if client.server_capabilities.textDocumentSync then
            client.server_capabilities.textDocumentSync.save = false
          end
        end,
        default_settings = {
          ["rust-analyzer"] = {
            files = {
              excludeDirs = {
                ".agents",
                ".claude",
                ".codex",
                ".github",
                "docs",
                "target",
                "tests/.cache",
              },
            },
          },
        },
      },
      dap = {},
    }
  end,
}
