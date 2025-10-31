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
-- @file: lua/plugins/snacks.lua
-- @brief: Collection of useful utilities and UI components.
-- @author: Andrew Vasilyev
-- @license: MIT
--
return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  lazy = false,
  priority = 1000,
  opts = {
    dashboard = {
      width = 44,
      pane_gap = 4,
      preset = {
        keys = {
          { icon = " ", key = "p", desc = "Open Project", action = ":lua Snacks.dashboard.pick('projects')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "g", desc = "Open Neogit", action = ":Neogit<CR>" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[meowvim
-------]],
      },
      sections = {
        {
          pane = 1,
          height = 17,
          width = 40,
          padding = 1,
          section = "terminal",
          cmd = "~/.config/nvim/scripts/icon.sh",
        },
        {
          pane = 2,
          {
            section = "header",
            padding = 1,
          },
          {
            section = "projects",
            padding = 1,
          },
          {
            section = "keys",
            gap = 0,
            padding = 1,
          },
          {
            section = "startup",
            padding = 1,
          },
        },
      },
    },

    bigfile = {},
    dim = {},
    explorer = {
      replace_netrw = true,
    },
    input = {},
    notifier = {},
    terminal = {},
    image = {},
    scope = {},
    scratch = {
      ft = function()
        return "markdown"
      end,
      filekey = {
        cwd = true,
        branch = false,
        count = true,
      },
    },
    styles = {},

    picker = {
      hidden = true,
      layout = { preset = "ivy" },
      sources = {
        files = {
          hidden = true,
        },
        git_files = {
          hidden = true,
        },
        recent = {
          hidden = true,
        },
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
          hidden = true,
          follow_file = true,
          auto_close = true,
          jump = {
            close = true,
          },
        },
        projects = {
          hidden = true,
        },
        lsp_workspace_symbols = {
          tree = true,
        },
      },
    },
  },
}
