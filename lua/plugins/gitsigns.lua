-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/gitsigns.lua
-- @brief: Git decorations: signs, hunk actions and inline blame.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = function()
    local config_ok, config = pcall(require, "meowvim.config")
    local git = (config_ok and config.get("git", nil)) or {}

    return {
      signcolumn = git.enable_signs ~= false,
      -- utils.toggles seeds vim.g.git_show_deleted from git.show_deleted before
      -- lazy loads anything, and <leader>oD flips it afterwards.
      show_deleted = vim.g.git_show_deleted == true,
      current_line_blame = git.blame_line == true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
      },
    }
  end,
}
