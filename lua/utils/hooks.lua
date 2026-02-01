-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/utils/hooks.lua
-- @brief: Utility functions for managing Neovim hooks and events.

local M = {}

local function update_title()
  local mode = vim.api.nvim_get_mode().mode
  local mode_map = {
    n = "N",
    no = "N",
    ni = "N",
    nt = "N",
    i = "I",
    ic = "I",
    ix = "I",
    v = "V",
    V = "V-L",
    ["\22"] = "V-B",
    c = "C",
    cv = "C",
    ce = "C",
    s = "S",
    S = "S",
    t = "T",
    r = "R",
    R = "R",
  }
  local mode_indicator = mode_map[mode] or "?"

  local modified = vim.bo.modified and "+" or ""
  local readonly = vim.bo.readonly and "RO" or ""

  -- Short filename (without full path)
  local filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
  if filename == "" then
    filename = "[No Name]"
  end

  -- Detect if we're in tmux
  local in_tmux = vim.env.TMUX ~= nil

  if in_tmux then
    -- Short format for tmux: "filename+RO [N]"
    local status = table.concat({ modified, readonly }, "")
    if status ~= "" then
      status = status .. " "
    end
    vim.o.titlestring = string.format("%s%s[%s]", filename, status, mode_indicator)
  else
    -- Full format for terminal without tmux
    local user_host = string.format(" -- %s@%s", vim.env.USER or "user", vim.fn.hostname() or "host")
    local status = table.concat({
      modified ~= "" and " [+]" or "",
      readonly ~= "" and " [RO]" or "",
    }, "")
    vim.o.titlestring = string.format("meowvim | %s%s [%s]%s", filename, status, mode_indicator, user_host)
  end
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("WindowTitleUpdater", { clear = true })
  vim.api.nvim_create_autocmd({
    "ModeChanged",
    "BufEnter",
    "FileChangedRO",
    "TextChanged",
    "BufWritePost",
  }, {
    group = augroup,
    pattern = "*",
    callback = update_title,
  })
end

return M
