-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-ufo.lua
-- @brief: Enhanced folding UI backed by Treesitter and LSP providers.

return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  opts = {
    provider_selector = function(_, filetype, _)
      local ft_map = {
        markdown = { "treesitter", "indent" },
        help = { "treesitter", "indent" },
      }

      if ft_map[filetype] then
        return ft_map[filetype]
      end

      return { "lsp", "indent" }
    end,
  },
  config = function(_, opts)
    require("ufo").setup(opts)
  end,
}
