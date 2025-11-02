-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/gh.lua
-- @brief: GitHub pull request and issue tooling backed by litee.nvim.

return {
  {
    "ldelossa/litee.nvim",
    lazy = true,
    config = function()
      require("litee.lib").setup({
        panel = {
          orientation = "left",
          panel_size = 35,
        },
      })
    end,
  },
  {
    "ldelossa/gh.nvim",
    cmd = {
      "GHOpenPR",
      "GHOpenIssue",
      "GHViewThreads",
      "GHSearchPRs",
      "GHSearchIssues",
      "GHClosePR",
      "GHCloseIssue",
      "GHRefreshComments",
    },
    dependencies = { "ldelossa/litee.nvim" },
    config = function()
      require("litee.gh").setup({
        icon_set = "nerd",
        map_resize_keys = false,
        jump_mode = "invoking",
      })
    end,
  },
}
