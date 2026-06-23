-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-treesitter.lua
-- @brief: Treesitter configuration for textobjects and autotag.
--
-- NOTE: nvim-treesitter was archived April 2026. Neovim 0.12 ships treesitter
-- highlighting built-in. This plugin is kept only because nvim-treesitter-textobjects
-- and nvim-ts-autotag still depend on it. The foldexpr now uses the built-in
-- vim.treesitter.foldexpr() (see lua/config/options.lua).
--
-- Parsers not bundled with Neovim 0.12 can be installed with:
--   :TSInstall <lang>  (requires tree-sitter CLI from mise.toml)

return {
  "nvim-treesitter/nvim-treesitter",
  version = "v0.10.*", -- Pin to stable 0.10.x releases (compat with Neovim 0.12+)
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        -- Languages not bundled with Neovim 0.12 built-in parsers
        "bash",
        "c",
        "c_sharp",
        "css",
        "diff",
        "dockerfile",
        "gdscript",
        "gitcommit",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "graphql",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    })

    require("nvim-ts-autotag").setup()
  end,
}
