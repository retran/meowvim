-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mcphub.lua
-- @brief: MCP Hub integration for Neovim - provides MCP server management and tool access.

local Meow = require("config.custom")

return {
  "ravitemer/mcphub.nvim",
  enabled = Meow.enable_copilot,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest",
  event = "VeryLazy",
  keys = {
    { "<leader>am", "<cmd>MCPHub<cr>", mode = "n", desc = "MCP Hub UI" },
  },
  config = function()
    require("mcphub").setup({
      auto_approve = function(params)
        if vim.g.codecompanion_auto_tool_mode == true then
          return true
        end

        if params.tool_name and params.tool_name:match("^(read|list|get)_") then
          return true
        end

        if params.is_auto_approved_in_server then
          return true
        end

        return false
      end,
    })
  end,
}
