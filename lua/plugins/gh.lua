-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @file: lua/plugins/gh.lua
-- @brief: GitHub pull request and issue tooling backed by litee.nvim.
-- author: Andrew Vasilyev
-- @license: MIT
--
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
