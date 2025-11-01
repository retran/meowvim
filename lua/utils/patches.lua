-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/utils/patches.lua
-- @brief: Utility functions for applying Neovim patches and fixes.

local M = {}

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
end

return M
