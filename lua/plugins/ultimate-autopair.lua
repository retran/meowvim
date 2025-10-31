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
-- @file: lua/plugins/ultimate-autopair.lua
-- @brief: Advanced autopairing with Treesitter-aware behaviour and CMP integration.
---@author: Andrew Vasilyev
-- @license: MIT
--
return {
  "altermo/ultimate-autopair.nvim",
  branch = "v0.6",
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    local autopair = require("ultimate-autopair")
    local config = autopair.extend_default()

    local filetype_ext = config.extensions.filetype
    local blacklist = {
      "snacks_terminal",
      "snacks_input",
      "snacks_picker_input",
      "snacks_picker_list",
    }
    local seen = {}
    for _, ft in ipairs(filetype_ext.nft or {}) do
      seen[ft] = true
    end
    for _, ft in ipairs(blacklist) do
      if not seen[ft] then
        table.insert(filetype_ext.nft, ft)
      end
    end

    local configs = { config }
    local cmp_ok, cmpair = pcall(require, "ultimate-autopair.experimental.cmpair")
    if cmp_ok then
      table.insert(configs, { profile = cmpair.init })
    end

    autopair.init(configs)
  end,
}
