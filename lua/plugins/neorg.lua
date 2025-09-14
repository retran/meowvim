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
-- @file: lua/plugins/neorg.lua
-- @brief: Note-taking and organization system with structured markup.
-- @author: Andrew Vasilyev
-- @license: MIT
--
return {
  "nvim-neorg/neorg",
  lazy = false,
  version = "*",
  dependencies = {
    "vhyrro/luarocks.nvim",
    "nvim-lua/plenary.nvim",
  },
  ft = "norg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.concealer"] = {},
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
            index = "index.norg",
          },
        },
        ["core.journal"] = {
          config = {
            strategy = "nested",
            workspace = "notes",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.treesitter"] = {},
      },
    })
  end,
}
