-- SPDX-License-Identifier: MIT
-- Utility helpers for keeping toggle state in sync with session data and config.

local registry = {
  disable_autoformat = {
    store = "DisableAutoFormat",
    default = true,
    type = "boolean",
    config_key = "toggles.autoformat",
    invert = true,
  },
  disable_autosave = {
    store = "DisableAutoSave",
    default = false,
    type = "boolean",
    config_key = "toggles.autosave",
    invert = true,
  },
  miniindentscope_disable = {
    store = "MiniIndentscopeDisable",
    default = true,
    type = "boolean",
    config_key = "toggles.mini_indentscope",
    invert = true,
  },
  snacks_dim = { store = "SnacksDim", default = false, type = "boolean", config_key = "toggles.snacks_dim" },
  lint_enabled = { store = "LintEnabled", default = true, type = "boolean", config_key = "toggles.lint" },
  diagnostics_enabled = {
    store = "DiagnosticsEnabled",
    default = true,
    type = "boolean",
    config_key = "toggles.diagnostics",
  },
  inlay_hints_enabled = {
    store = "InlayHintsEnabled",
    default = false,
    type = "boolean",
    config_key = "toggles.inlay_hints",
  },
  copilot_enabled = { store = "CopilotEnabled", default = false, type = "boolean", config_key = "toggles.copilot" },
  -- Vim option toggles
  number_mode = { store = "NumberMode", default = "relative", type = "string", config_key = "toggles.number_mode" }, -- "off", "number", "relative"
  wrap = { store = "Wrap", default = false, type = "boolean", config_key = "toggles.wrap" },
  spell = { store = "Spell", default = false, type = "boolean", config_key = "toggles.spell" },
  cursorline = { store = "Cursorline", default = false, type = "boolean", config_key = "toggles.cursorline" },
  signcolumn = { store = "Signcolumn", default = "yes", type = "string", config_key = "toggles.signcolumn" }, -- "yes", "no", "auto"
  list = { store = "List", default = false, type = "boolean", config_key = "toggles.list" },
  hlsearch = { store = "Hlsearch", default = true, type = "boolean", config_key = "toggles.hlsearch" },
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

local function get_default_value(name)
  local meta = registry[name]
  if not meta then
    return nil
  end

  -- Try to get from config first
  if meta.config_key then
    local ok, config = pcall(require, "meowvim.config")
    if ok then
      local value = config.get(meta.config_key, nil)
      if value ~= nil then
        -- Handle inverted toggles (disable_* -> enabled in config)
        if meta.invert then
          return not value
        end
        return value
      end
    end
  end

  return meta.default
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

  set(name, get_default_value(name))
end

function M.update(name)
  set(name, vim.g[name])
end

function M.apply_all()
  for name in pairs(registry) do
    M.ensure(name)
  end
end

-- Sync current toggle state to config (in-memory only)
function M.sync_to_config()
  local ok, config = pcall(require, "meowvim.config")
  if not ok then
    return false
  end

  for name, meta in pairs(registry) do
    if meta.config_key and vim.g[name] ~= nil then
      local value = vim.g[name]
      -- Handle inverted toggles
      if meta.invert then
        value = not value
      end
      config.set(meta.config_key, value)
    end
  end

  return true
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
