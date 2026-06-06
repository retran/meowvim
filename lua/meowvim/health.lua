-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/health.lua
-- @brief: Health check diagnostics for Meowvim configuration and dependencies.

local M = {}

local health = vim.health or require("health")
local start = health.start or health.report_start
local ok = health.ok or health.report_ok
local warn = health.warn or health.report_warn
local error = health.error or health.report_error
local info = health.info or health.report_info

-- Check Neovim version
local function check_nvim_version()
  start("Neovim Version")

  local required_version = "0.10.0"
  local current_version = vim.version()

  if current_version.major == 0 and current_version.minor >= 10 then
    ok(
      string.format(
        "Neovim %d.%d.%d (>= %s)",
        current_version.major,
        current_version.minor,
        current_version.patch,
        required_version
      )
    )
  else
    error(
      string.format(
        "Neovim %d.%d.%d is too old. Please upgrade to >= %s",
        current_version.major,
        current_version.minor,
        current_version.patch,
        required_version
      )
    )
  end
end

-- Check configuration system
local function check_config()
  start("Configuration System")

  -- Check if config module loads
  local config_ok, config = pcall(require, "meowvim.config")
  if not config_ok then
    error("Failed to load meowvim.config module: " .. tostring(config))
    return
  end
  ok("Config module loaded successfully")

  -- Check if user config exists
  local config_path = config.get_config_path()
  if vim.fn.filereadable(config_path) == 1 then
    ok("User config file exists: " .. config_path)
  else
    warn("User config file not found: " .. config_path)
    info("Create one by running :MeowvimConfig or copying from defaults")
  end

  -- Validate config
  local valid, errors = config.validate()
  if valid then
    ok("Configuration validates successfully")
  else
    warn("Configuration has validation warnings:")
    for field, err in pairs(errors or {}) do
      info("  " .. field .. ": " .. err)
    end
  end

  -- Check critical config values
  local theme = config.get("core.theme")
  if theme then
    info("Theme: " .. theme)
  end

  local copilot = config.get("core.enable_copilot", false)
  info("Copilot: " .. (copilot and "enabled" or "disabled"))

  -- Check projects configuration
  local projects_path = config.get_projects_path()
  if vim.fn.filereadable(projects_path) == 1 then
    ok("Projects config exists: " .. projects_path)
    local projects = config.get_projects()
    local count = vim.tbl_count(projects)
    if count > 0 then
      ok(string.format("Found %d project(s)", count))
      for name, project in pairs(projects) do
        if project.path then
          local expanded = vim.fn.expand(project.path)
          if vim.fn.isdirectory(expanded) == 1 then
            info("  ✓ " .. name .. ": " .. expanded)
          else
            warn("  ✗ " .. name .. ": path not found - " .. expanded)
          end
        end
      end
    else
      info("No projects configured")
    end
  else
    info("Projects config not found (optional)")
    info("Create at: " .. projects_path)
  end
end

-- Walk up from dir looking for mise.toml or .mise.toml
local function find_nearest_mise_toml(dir)
  local candidates = { "mise.toml", ".mise.toml" }
  local seen = {}
  local current = vim.fn.resolve(dir)
  while current and not seen[current] do
    seen[current] = true
    for _, name in ipairs(candidates) do
      local path = current .. "/" .. name
      if vim.fn.filereadable(path) == 1 then
        return path
      end
    end
    local parent = vim.fn.fnamemodify(current, ":h")
    if parent == current then
      break
    end
    current = parent
  end
  return nil
end

local function check_one_mise_toml(mise_toml, label)
  if vim.fn.filereadable(mise_toml) == 0 then
    return
  end

  ok(label .. ": " .. mise_toml)

  local expected = {}
  for line in io.lines(mise_toml) do
    local full = line:match('^%s*"([^"]+)"%s*=') or line:match("^(%S+)%s*=")
    if full and full ~= "[tools]" then
      local short = full:match("([^/]+)$")
      expected[short or full] = full
    end
  end

  if vim.tbl_isempty(expected) then
    info("  No tools configured")
    return
  end

  local handle = io.popen("mise ls --current 2>/dev/null")
  if not handle then
    warn("  Could not run mise ls")
    return
  end

  local installed = {}
  for line in handle:lines() do
    local name = line:match("^(%S+)")
    if name then
      local short = name:match("([^/]+)$") or name
      installed[short] = true
    end
  end
  handle:close()

  local has_missing = false
  for short, full in pairs(expected) do
    if installed[short] then
      ok("  " .. short)
    else
      warn("  " .. short .. " — not installed")
      info("    run: mise install " .. full)
      has_missing = true
    end
  end

  if not has_missing then
    ok("  All tools installed for this config")
  end
end

-- Check mise tools from mise.toml
local function check_mise_tools()
  start("Mise Tools (mise.toml)")

  if vim.fn.executable("mise") == 0 then
    warn("mise not found — tools must be installed manually")
    info("Install from: https://mise.jdx.dev")
    return
  end
  ok("mise installed")

  local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
  if vim.fn.isdirectory(mise_shims) == 1 then
    local in_path = (vim.env.PATH or ""):find(mise_shims, 1, true) ~= nil
    if in_path then
      ok("mise shims in PATH")
    else
      warn("mise shims not in PATH — tools may not resolve")
    end
  end

  -- Project-level mise.toml (from cwd, walk up)
  local project_toml = find_nearest_mise_toml(vim.fn.getcwd())
  if project_toml then
    check_one_mise_toml(project_toml, "Project")
  else
    info("No mise.toml found in current project tree — global mise config applies")
  end
end

-- Check external dependencies
local function check_external_deps()
  start("External Dependencies")

  -- Check git
  if vim.fn.executable("git") == 1 then
    local git_version = vim.fn.system("git --version"):gsub("\n", "")
    ok("git: " .. git_version)
  else
    error("git is not installed or not in PATH")
  end

  -- Check ripgrep (for telescope)
  if vim.fn.executable("rg") == 1 then
    local rg_version = vim.fn.system("rg --version"):match("ripgrep ([^\n]+)")
    ok("ripgrep: " .. (rg_version or "installed"))
  else
    warn("ripgrep not found - Telescope search will be slower")
    info("Install with: brew install ripgrep (macOS) or apt install ripgrep (Linux)")
  end

  -- Check fd (for telescope)
  if vim.fn.executable("fd") == 1 then
    local fd_version = vim.fn.system("fd --version"):match("fd ([^\n]+)")
    ok("fd: " .. (fd_version or "installed"))
  else
    warn("fd not found - Telescope file finding will be slower")
    info("Install with: brew install fd (macOS) or apt install fd-find (Linux)")
  end

  -- Check lazygit
  if vim.fn.executable("lazygit") == 1 then
    local lg_version = vim.fn.system("lazygit --version"):match("version=([^,]+)")
    ok("lazygit: " .. (lg_version or "installed"))
  else
    info("lazygit not found - :LazyGit command will not work")
    info("Install from: https://github.com/jesseduffield/lazygit")
  end

  -- Check node (for Copilot)
  if vim.fn.executable("node") == 1 then
    local node_version = vim.fn.system("node --version"):gsub("\n", "")
    ok("node: " .. node_version)
  else
    local config_ok, config = pcall(require, "meowvim.config")
    if config_ok and config.get("core.enable_copilot", false) then
      error("node is required for GitHub Copilot")
      info("Install from: https://nodejs.org/")
    else
      info("node not found (not needed unless using Copilot)")
    end
  end
end

-- Check LSP servers
local function check_lsp()
  start("LSP Configuration")

  local lspconfig_ok, _ = pcall(require, "lspconfig")
  if not lspconfig_ok then
    error("nvim-lspconfig not loaded")
    return
  end
  ok("nvim-lspconfig loaded")

  -- Check commonly used LSP servers
  local common_servers = {
    lua_ls = "lua-language-server",
    gopls = "gopls",
    pyright = "pyright",
    ts_ls = "typescript-language-server",
    rust_analyzer = "rust-analyzer",
  }
  for name, binary in pairs(common_servers) do
    if vim.fn.executable(binary) == 1 then
      info("  - " .. name .. " (" .. binary .. ")")
    end
  end
end

-- Check plugin manager
local function check_plugins()
  start("Plugin Manager")

  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    error("lazy.nvim not loaded")
    return
  end
  ok("lazy.nvim loaded")

  local stats = lazy.stats()
  ok(string.format("%d plugins loaded in %.2fms", stats.loaded, stats.startuptime))

  if stats.count > stats.loaded then
    info(string.format("%d plugins not yet loaded (lazy-loaded)", stats.count - stats.loaded))
  end
end

-- Check treesitter
local function check_treesitter()
  start("Tree-sitter")

  local ts_ok, _ = pcall(require, "nvim-treesitter.configs")
  if not ts_ok then
    error("nvim-treesitter not loaded")
    return
  end
  ok("nvim-treesitter loaded")

  local parser_ok, parser = pcall(require, "nvim-treesitter.parsers")
  if parser_ok then
    local installed = parser.get_parser_configs()
    local count = 0
    for _ in pairs(installed) do
      count = count + 1
    end
    if count > 0 then
      ok(string.format("%d parsers available", count))
    else
      warn("No parsers installed")
      info("Run :TSInstall <language> to install parsers")
    end
  end
end

-- Check critical files and directories
local function check_filesystem()
  start("Filesystem")

  -- Check data directory
  local data_dir = vim.fn.stdpath("data")
  if vim.fn.isdirectory(data_dir) == 1 then
    ok("Data directory: " .. data_dir)
  else
    error("Data directory missing: " .. data_dir)
  end

  -- Check config directory
  local config_dir = vim.fn.stdpath("config")
  if vim.fn.isdirectory(config_dir) == 1 then
    ok("Config directory: " .. config_dir)
  else
    error("Config directory missing: " .. config_dir)
  end

  -- Check cache directory
  local cache_dir = vim.fn.stdpath("cache")
  if vim.fn.isdirectory(cache_dir) == 1 then
    ok("Cache directory: " .. cache_dir)
  else
    warn("Cache directory missing: " .. cache_dir)
  end

  -- Check if running in container
  if vim.env.CI or vim.env.DOCKER or vim.fn.filereadable("/.dockerenv") == 1 then
    info("Running in CI/container environment")
  end
end

-- Main health check function
function M.check()
  check_nvim_version()
  check_config()
  check_filesystem()
  check_external_deps()
  check_mise_tools()
  check_plugins()
  check_treesitter()
  check_lsp()
end

return M
