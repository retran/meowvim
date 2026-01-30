-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/bookmarks.lua
-- @brief: Bookmark management for marking and navigating important code locations

return {
  "tomasky/bookmarks.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>mm", "<cmd>lua require('bookmarks').bookmark_toggle()<cr>", desc = "Toggle Bookmark" },
    { "<leader>mi", "<cmd>lua require('bookmarks').bookmark_ann()<cr>", desc = "Add Bookmark with Annotation" },
    { "<leader>mc", "<cmd>lua require('bookmarks').bookmark_clean()<cr>", desc = "Clean Bookmarks in Buffer" },
    { "<leader>mn", "<cmd>lua require('bookmarks').bookmark_next()<cr>", desc = "Next Bookmark" },
    { "<leader>mp", "<cmd>lua require('bookmarks').bookmark_prev()<cr>", desc = "Previous Bookmark" },
    { "<leader>ml", "<cmd>lua require('bookmarks').bookmark_list()<cr>", desc = "List Bookmarks" },
    { "<leader>mx", "<cmd>lua require('bookmarks').bookmark_clear_all()<cr>", desc = "Clear All Bookmarks" },
  },
  config = function()
    require("bookmarks").setup({
      sign_priority = 8, -- Sign priority for bookmarks
      save_file = vim.fn.expand("$HOME/.local/share/nvim/bookmarks"), -- Bookmark save location
      keywords = {
        ["@t"] = "☑️ ", -- Task
        ["@w"] = "⚠️ ", -- Warning
        ["@f"] = "⛏ ", -- Fix
        ["@n"] = " ", -- Note
      },
      on_attach = function()
        local bm = require("bookmarks")
        local map = vim.keymap.set
        
        -- Buffer-local keymaps
        map("n", "mm", bm.bookmark_toggle, { desc = "Toggle Bookmark" })
        map("n", "mi", bm.bookmark_ann, { desc = "Add Bookmark Annotation" })
        map("n", "mc", bm.bookmark_clean, { desc = "Clean Bookmarks" })
        map("n", "mn", bm.bookmark_next, { desc = "Next Bookmark" })
        map("n", "mp", bm.bookmark_prev, { desc = "Previous Bookmark" })
        map("n", "ml", bm.bookmark_list, { desc = "List Bookmarks" })
      end,
    })
    
    -- Telescope integration
    local telescope_ok, telescope = pcall(require, "telescope")
    if telescope_ok then
      telescope.load_extension("bookmarks")
    end
  end,
}
