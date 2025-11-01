-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/conform.lua

local mason_registry = require("config.mason")

local desired_formatters_by_ft = {
  lua = { "stylua" },
  python = { "ruff_format", "ruff_organize_imports" },
  javascript = { "prettierd", "prettier", stop_after_first = true },
  typescript = { "prettierd", "prettier", stop_after_first = true },
  javascriptreact = { "prettierd", "prettier", stop_after_first = true },
  typescriptreact = { "prettierd", "prettier", stop_after_first = true },
  json = { "prettierd", "prettier", stop_after_first = true },
  jsonc = { "prettierd", "prettier", stop_after_first = true },
  yaml = { "prettierd", "prettier", stop_after_first = true },
  markdown = { "prettierd", "prettier", "mdformat", stop_after_first = true },
  html = { "prettierd", "prettier", stop_after_first = true },
  css = { "prettierd", "prettier", stop_after_first = true },
  scss = { "prettierd", "prettier", stop_after_first = true },
  go = { "goimports", "gofmt" },
  sql = { "pg_format" },
  plpgsql = { "pg_format" },
  rust = { "rustfmt", lsp_format = "fallback" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  zsh = { "shfmt" },
  c = { "clang_format" },
  cpp = { "clang_format" },
  cs = { "csharpier", "dotnet_format", lsp_format = "fallback" },
  java = { "google-java-format" },
  gdscript = { "gdformat" },
  gdshader = { "clang_format" },
  ["*"] = { "codespell" },
}

local function collect_formatters()
  local alias_map = {
    clang_format = "clang-format",
    dotnet_format = false,
    gdformat = "gdtoolkit",
    gofmt = false,
    pg_format = "pgformatter",
    ruff_format = "ruff",
    ruff_organize_imports = "ruff",
    rustfmt = false,
  }

  local seen = {}
  local result = {}

  local function add(item)
    if type(item) ~= "string" or seen[item] then
      return
    end

    local package = alias_map[item]
    if package == false then
      seen[item] = true
      return
    end

    package = package or item
    if not seen[package] then
      table.insert(result, package)
      seen[package] = true
    end
    seen[item] = true
  end

  -- Collect from formatters_by_ft
  for _, formatters in pairs(desired_formatters_by_ft) do
    for _, formatter in ipairs(formatters) do
      add(formatter)
    end
  end

  -- Add explicit formatters
  for _, formatter in ipairs({ "shfmt", "stylua", "black", "gdformat" }) do
    add(formatter)
  end

  return result
end

mason_registry.ensure_formatters(collect_formatters())

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = function()
    local formatters_by_ft = {}

    for ft, formatters in pairs(desired_formatters_by_ft) do
      local available_formatters = {}
      for key, value in pairs(formatters) do
        if type(key) == "string" then
          available_formatters[key] = value
        end
      end

      for _, formatter in ipairs(formatters) do
        if type(formatter) == "string" and vim.fn.executable(formatter) == 1 then
          table.insert(available_formatters, formatter)
        end
      end

      if #available_formatters > 0 then
        formatters_by_ft[ft] = available_formatters
      end
    end

    formatters_by_ft["_"] = { "trim_whitespace" }

    return {
      formatters_by_ft = formatters_by_ft,

      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },

      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        return { timeout_ms = 500 }
      end,

      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        black = {
          prepend_args = { "--line-length", "88" },
        },
        gdformat = {
          command = "gdformat",
        },
        pg_format = {
          prepend_args = { "--spaces", "2", "--comma-start", "--keyword-case", "1" },
        },
      },
    }
  end,

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
        vim.notify("Format-on-save: OFF (Buffer)", vim.log.levels.WARN)
      else
        vim.g.disable_autoformat = true
        vim.notify("Format-on-save: OFF (Global)", vim.log.levels.WARN)
      end
    end, {
      desc = "Disable format-on-save (Global or !Buffer)",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify("Format-on-save: ON", vim.log.levels.INFO)
    end, {
      desc = "Enable format-on-save",
    })

    vim.api.nvim_create_user_command("FormatToggle", function(args)
      if args.bang then
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        if vim.b.disable_autoformat then
          vim.notify("Format-on-save: OFF (Buffer)", vim.log.levels.WARN)
        else
          vim.notify("Format-on-save: ON (Buffer)", vim.log.levels.INFO)
        end
      else
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          vim.notify("Format-on-save: OFF (Global)", vim.log.levels.WARN)
        else
          vim.notify("Format-on-save: ON (Global)", vim.log.levels.INFO)
        end
      end
    end, {
      desc = "Toggle format-on-save (Global or !Buffer)",
      bang = true,
    })
  end,
}
