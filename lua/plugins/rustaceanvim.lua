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
          -- Workaround for a rust-analyzer 1.96.0 bug: it panicked on
          -- textDocument/didSave while the VFS was still initializing
          -- (FileSourceRootInput not set for FileId).
          --
          -- NOTE: the local toolchain is now 1.98.x, so this is very likely
          -- stale — and it is not free: with didSave suppressed rust-analyzer
          -- never runs `checkOnSave`, so cargo diagnostics stop appearing on
          -- write. Re-test against the current rust-analyzer and drop this if
          -- the panic is gone.
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
