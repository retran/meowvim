-- SPDX-License-Identifier: MIT
-- Utility helpers for keeping toggle state in sync with session data.

local registry = {
  disable_autoformat = { store = "DisableAutoFormat", default = true, type = "boolean" },
  disable_autosave = { store = "DisableAutoSave", default = false, type = "boolean" },
  miniindentscope_disable = { store = "MiniIndentscopeDisable", default = true, type = "boolean" },
  snacks_dim = { store = "SnacksDim", default = false, type = "boolean" },
  lint_enabled = { store = "LintEnabled", default = true, type = "boolean" },
  diagnostics_enabled = { store = "DiagnosticsEnabled", default = true, type = "boolean" },
  inlay_hints_enabled = { store = "InlayHintsEnabled", default = false, type = "boolean" },
  copilot_enabled = { store = "CopilotEnabled", default = false, type = "boolean" },
  -- Vim option toggles
  number_mode = { store = "NumberMode", default = "relative", type = "string" }, -- "off", "number", "relative"
  wrap = { store = "Wrap", default = false, type = "boolean" },
  spell = { store = "Spell", default = false, type = "boolean" },
  cursorline = { store = "Cursorline", default = false, type = "boolean" },
  signcolumn = { store = "Signcolumn", default = "yes", type = "string" }, -- "yes", "no", "auto"
  list = { store = "List", default = false, type = "boolean" },
  hlsearch = { store = "Hlsearch", default = true, type = "boolean" },
}

local M = {}

local function decode(meta, value)
  if value == nil then
    return meta.default
  end

  if meta.type == "boolean" then
    if type(value) == "boolean" then
      return value
    end
    if type(value) == "number" then
      return value ~= 0
    end
    if type(value) == "string" then
      local lowered = value:lower()
      if lowered == "true" or lowered == "1" or lowered == "yes" then
        return true
      end
      if lowered == "false" or lowered == "0" or lowered == "no" or lowered == "" then
        return false
      end
    end
    return meta.default
  end

  if meta.type == "number" then
    if type(value) == "number" then
      return value
    end
    if type(value) == "string" then
      local parsed = tonumber(value)
      if parsed ~= nil then
        return parsed
      end
    end
    if type(value) == "boolean" then
      return value and 1 or 0
    end
    return meta.default
  end

  return value
end

local function encode(meta, value)
  if meta.type == "boolean" then
    return value and 1 or 0
  end
  return value
end

local function set(name, value)
  local meta = registry[name]
  if not meta then
    return
  end
  local decoded = decode(meta, value)
  vim.g[name] = decoded
  vim.g[meta.store] = encode(meta, decoded)
end

function M.ensure(name)
  local meta = registry[name]
  if not meta then
    return
  end

  if vim.g[meta.store] ~= nil then
    set(name, vim.g[meta.store])
    return
  end

  if vim.g[name] ~= nil then
    set(name, vim.g[name])
    return
  end

  set(name, meta.default)
end

function M.update(name)
  set(name, vim.g[name])
end

function M.apply_all()
  for name in pairs(registry) do
    M.ensure(name)
  end
end

function M.setup()
  if M._initialized then
    return
  end
  M._initialized = true

  M.apply_all()

  vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = vim.api.nvim_create_augroup("meowvim-toggle-sync", { clear = true }),
    callback = function()
      M.apply_all()
    end,
  })
end

return M
