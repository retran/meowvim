-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-treesitter.lua
-- @brief: Treesitter parser management and textobject/autotag integration.
--
-- nvim-treesitter was rewritten for Neovim 0.12+:
--   - lazy = false is required (plugin does not support lazy-loading)
--   - ensure_installed is gone; use require('nvim-treesitter').install({...})
--   - setup() only accepts install_dir
--   - Parsers bundled with Neovim 0.12.3: c, lua, markdown, markdown_inline,
--     query, vim, vimdoc — do not reinstall them to avoid ABI conflicts

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Install parsers not bundled with Neovim 0.12.3.
    -- Runs async in the background; safe to call on every startup
    -- (no-op for already-installed parsers).
    require("nvim-treesitter").install({
      "bash",
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
      "luadoc",
      "python",
      "regex",
      "rust",
      "scss",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "yaml",
    })

    -- Register compound filetypes that use an existing parser
    vim.treesitter.language.register("yaml", "yaml.docker-compose")
    vim.treesitter.language.register("yaml", "yaml.gitlab")
    vim.treesitter.language.register("yaml", "yaml.helm-values")

    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })
  end,
}
