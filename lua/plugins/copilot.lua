-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    local toggles_ok, toggles = pcall(require, "utils.toggles")
    local enabled = false
    
    if toggles_ok then
      enabled = toggles.get("copilot_enabled") or false
    else
      enabled = vim.g.copilot_enabled or false
    end
    
    if not enabled then
      local config_ok, config = pcall(require, "meowvim.config")
      if config_ok then
        enabled = config.get("core.enable_copilot", false)
      end
    end
    
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
          accept = "<C-y>",
          accept_word = "<C-Right>",
          accept_line = "<C-Down>",
          next = "<C-]>",
          prev = "<C-[>",
          dismiss = "<C-\\>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    })
    
    if not enabled then
      vim.cmd("Copilot disable")
    end
    
    local cmp_ok, copilot_cmp = pcall(require, "copilot_cmp")
    if cmp_ok then
      copilot_cmp.setup()
    end
  end,
}
