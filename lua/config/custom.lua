-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/config/custom.lua
-- @brief: User-specific options.

local theme = "catppuccin"
if vim.env.MEOW_THEME == "tokyonight" then
  theme = "tokyonight"
end

return {
  theme = theme,
  enable_copilot = vim.env.MEOW_ENABLE_COPILOT == "true"
}
