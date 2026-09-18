-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/noice.lua
-- @brief: Enhanced UI components for messages, cmdline, and popupmenu.

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  -- Notifications render through snacks.notifier: noice's default
  -- `views.notify.backend` is { "snacks", "notify" } and the snacks backend is
  -- available whenever snacks.notifier is enabled, so nvim-notify is never used.
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
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
