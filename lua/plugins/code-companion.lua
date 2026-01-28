-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/code-companion.lua
-- @brief: AI-powered coding assistant with chat and inline capabilities via ACP.

local Meow = require("config.custom")

return {
  "olimorris/codecompanion.nvim",
  enabled = Meow.enable_copilot,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
  },
  event = "VeryLazy",
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat Toggle" },
    { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI Chat Add" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI Inline Assistant" },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        acp = {
          copilot_cli = function()
            return require("codecompanion.adapters").extend("goose", {
              name = "copilot_cli",
              formatted_name = "Copilot CLI",
              commands = {
                default = {
                  "/Users/retran/Library/Application Support/Code/User/globalStorage/github.copilot-chat/copilotCli/copilot",
                  "--acp",
                },
              },
              env = {
                NODE_NO_WARNINGS = "1",
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "copilot_cli",
        },
      },
      display = {
        action_palette = {
          provider = "snacks",
        },
        chat = {
          show_settings = true,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_tools = true,
            show_server_tools_in_chat = true,
            add_mcp_prefix_to_tool_names = false,
            show_result_in_chat = true,
            make_vars = true, -- Convert MCP resources to #variables
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
    })
  end,
}
