-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-ts-autotag.lua
-- @brief: Auto-close and rename HTML/JSX tags using Tree-sitter.

return {
  "windwp/nvim-ts-autotag",
  ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte", "xml" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-ts-autotag").setup({
      enable_close_on_slash = false,
    })
  end,
}
