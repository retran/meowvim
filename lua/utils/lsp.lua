-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/utils/lsp.lua
-- @brief: Capability checks used to pick between an LSP path and a fallback.
--
-- Language servers are installed per project here, so a buffer may have no
-- server, or one that answers only part of the protocol. Rather than let a
-- command open an empty window, callers ask whether the capability is there and
-- take the treesitter or grep path when it is not.

local M = {}

--- Whether a server attached to `bufnr` answers `method`.
--- @param method string LSP request name, for example "textDocument/documentSymbol"
--- @param bufnr integer? defaults to the current buffer
--- @return boolean
function M.supports(method, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client:supports_method(method, bufnr) then
      return true
    end
  end

  return false
end

--- Run `lsp_fn` when `method` is available, otherwise `fallback_fn`.
--- `reason` names what the fallback gives up, and is shown once per call.
--- @param method string
--- @param lsp_fn fun()
--- @param fallback_fn fun()
--- @param reason string
function M.with_fallback(method, lsp_fn, fallback_fn, reason)
  if M.supports(method) then
    lsp_fn()
    return
  end

  vim.notify(reason, vim.log.levels.WARN, { title = "Meowvim" })
  fallback_fn()
end

--- Run `fn` when `method` is available, otherwise say what is missing.
--- @param method string
--- @param fn fun()
--- @param what string the feature name, for the message
function M.require_capability(method, fn, what)
  if not M.supports(method) then
    vim.notify(
      ("No language server in this buffer provides %s"):format(what),
      vim.log.levels.WARN,
      { title = "Meowvim" }
    )
    return
  end

  fn()
end

return M
