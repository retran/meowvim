-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot-lualine.lua
-- @brief: Lualine integration for GitHub Copilot status display.

return {
  "AndreM222/copilot-lualine",
  enabled = function()
    -- Check if Copilot is enabled via toggle
    if vim.g.copilot_enabled ~= nil then
      return vim.g.copilot_enabled
    end
    
    -- Check config system
    local ok, config = pcall(require, "meowvim.config")
    if ok then
      return config.get("core.enable_copilot", false)
    end
    
    -- Disabled by default
    return false
  end,
}
