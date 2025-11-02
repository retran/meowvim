-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot-lualine.lua
-- @brief: Copilot status indicator for lualine statusbar.

local Meow = require("config.custom")

return {
  "AndreM222/copilot-lualine",
  enabled = Meow.enable_copilot,
}
