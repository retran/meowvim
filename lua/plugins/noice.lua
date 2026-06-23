-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/noice.lua
-- @brief: Enhanced UI components for messages, cmdline, and popupmenu.

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  init = function()
    local original_handler = vim.lsp.handlers["$/progress"]
    vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
      if result and result.token == nil then
        result.token = ""
      end
      if result and result.value and result.value.token == nil then
        result.value.token = ""
      end
      if original_handler then
        return original_handler(err, result, ctx, config)
      end
    end
  end,
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 10,
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = { event = "msg_show", find = "written" },
        opts = { skip = true },
      },
    },
  },
}
