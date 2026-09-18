-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/lazydev.lua
-- @brief: Enhanced LuaLS workspace management and completion integration.

return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- `vim.uv` is used throughout the config (timers, fs_event, fs_stat);
      -- without the luv meta types LuaLS reports every call as unknown.
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      "lazy.nvim",
      "snacks.nvim",
    },
    integrations = {
      lspconfig = true,
      cmp = false, -- blink.cmp uses its own lazydev source (see blink-cmp.lua)
    },
  },
}
