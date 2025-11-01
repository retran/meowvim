-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/comment.lua
-- @brief: Treesitter-aware commenting powered by ts-comments and mini.comment.

return {
  {
    "folke/ts-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "echasnovski/mini.comment",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "folke/ts-comments.nvim" },
    config = function()
      local function commentstring()
        local ok, comments = pcall(require, "ts-comments.comments")
        if ok then
          local cs = comments.get(vim.bo.filetype)
          if cs and cs ~= "" then
            return cs
          end
        end
        return vim.bo.commentstring
      end

      require("mini.comment").setup({
        options = {
          custom_commentstring = commentstring,
        },
      })
    end,
  },
}
