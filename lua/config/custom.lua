-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/config/custom.lua
-- @brief: User-specific options.

return {
  theme = "catppuccin",
  enable_copilot = vim.env.MEOW_ENABLE_COPILOT == "true",
}
