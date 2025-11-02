-- SPDX-License-Identifier: MIT
-- Helpers for managing workspace sessions.

local M = {}

local function close_floating_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative and cfg.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

local function wipe_listed_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end
  end
end

function M.save()
  local ok, persistence = pcall(require, "persistence")
  if ok then
    pcall(persistence.save)
  end
end

function M.reset()
  close_floating_windows()
  wipe_listed_buffers()

  if #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd("silent! tabonly")
  end

  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins > 1 then
    vim.cmd("silent! only")
  end

  if #vim.api.nvim_list_bufs() == 0 or not vim.bo.buflisted then
    vim.cmd("enew")
  end
end

return M
