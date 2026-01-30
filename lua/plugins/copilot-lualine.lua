-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot-lualine.lua
-- @brief: Lualine integration for GitHub Copilot status display.

return {
  "AndreM222/copilot-lualine",
  enabled = function()
    local ok, config = pcall(require, "meowvim.config")
    if ok then
      return config.get("core.enable_copilot", false)
    end
    return vim.env.MEOW_ENABLE_COPILOT == "true"
  end,
}
