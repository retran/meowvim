-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/luasnip.lua
-- @brief: Snippet engine with expansion and template support.

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*", -- Pin to stable 2.x releases, like the other pinned plugins
  -- Loaded as a dependency of blink.cmp; without this the spec has no trigger
  -- and lazy.nvim would pull it in at startup on its own.
  lazy = true,
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
