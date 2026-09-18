-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/gitlinker.lua
-- @brief: Generate shareable permalinks for Git hosts.

return {
  "linrongbin16/gitlinker.nvim",
  cmd = { "GitLink" },
  -- gitlinker v5 has no `mappings` or nested `opts` keys; the keymaps live in
  -- lua/config/keymaps.lua and drive the :GitLink command.
  opts = {},
}
