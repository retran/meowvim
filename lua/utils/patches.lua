-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/utils/patches.lua
-- @brief: Utility functions for applying Neovim patches and fixes.

local M = {}
local snacks_picker_patched = false

-- Neovim 0.12.3 bug: vim.treesitter.get_range() can receive a nil node
-- from injection query captures, causing a crash in the highlighter.
-- Guard against it by returning a zero-range instead of crashing.
local _orig_ts_get_range = vim.treesitter.get_range
vim.treesitter.get_range = function(node, source, metadata)
  if node == nil then
    return { 0, 0, 0, 0, 0, 0 }
  end
  return _orig_ts_get_range(node, source, metadata)
end

local function patch_snacks_picker()
  if snacks_picker_patched then
    return true
  end

  local ok_picker, picker = pcall(require, "snacks.picker.core.picker")
  if not ok_picker or not picker or type(picker.set_layout) ~= "function" then
    return false
  end

  local original_set_layout = picker.set_layout
  picker.set_layout = function(self, layout)
    if not self or self.closed or not self.layout or not self.layout.opts then
      return
    end
    return original_set_layout(self, layout)
  end
  snacks_picker_patched = true
  return true
end

function M.setup()
  local snacks = require("snacks")

  snacks.dashboard.sections.session = function(item)
    return setmetatable({
      action = function()
        local ok, persistence = pcall(require, "persistence")
        if ok then
          persistence.load()
        end
      end,
      section = false,
    }, { __index = item })
  end
  patch_snacks_picker()
end

M.patch_snacks_picker = patch_snacks_picker

return M
