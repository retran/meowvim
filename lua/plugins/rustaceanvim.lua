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
          -- rust-analyzer 1.96.0 panicked on textDocument/didSave while its VFS
          -- was still initializing. Suppressing didSave avoids the crash, but it
          -- also stops `checkOnSave`, so cargo diagnostics never appear on write.
          -- Apply it only to the version that needs it; anything else, including
          -- a server that does not report a version, keeps didSave.
          local version = client.server_info and client.server_info.version or ""
          if version:find("1.96.", 1, true) and client.server_capabilities.textDocumentSync then
            client.server_capabilities.textDocumentSync.save = false
            vim.notify(
              "rust-analyzer " .. version .. ": disabling didSave to avoid a known panic; checkOnSave is off",
              vim.log.levels.WARN,
              { title = "Meowvim" }
            )
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
