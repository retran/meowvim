-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/conform.lua

-- conform resolves availability per buffer at format time and stays quiet about
-- missing tools unless formatters are named explicitly, so no pre-filtering is
-- done here. That also matters for project-local mise toolchains: a startup
-- snapshot would go stale the moment the working directory changes.
local formatters_by_ft = {
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
  cs = { "csharpier", lsp_format = "fallback" },
  java = { "google-java-format" },
  gdscript = { "gdformat" },
  gdshader = { "clang_format" },
  tex = { "latexindent" },
  bib = { "bibtex-tidy" },
  -- Applies to filetypes without an entry above.
  ["_"] = { "codespell", "trim_whitespace" },
}

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = function()
    local config_ok, config = pcall(require, "meowvim.config")
    local timeout_ms = 3000

    if config_ok then
      timeout_ms = config.get("formatting.timeout_ms", timeout_ms)
      -- `formatting.formatters` in the user config replaces the entry for a
      -- filetype.
      local user_formatters = config.get("formatting.formatters", nil)
      if type(user_formatters) == "table" and not vim.tbl_isempty(user_formatters) then
        formatters_by_ft = vim.tbl_extend("force", formatters_by_ft, user_formatters)
      end
    end

    return {
      formatters_by_ft = formatters_by_ft,

      default_format_opts = {
        timeout_ms = timeout_ms,
        async = false,
        quiet = false,
        lsp_format = "fallback", -- Use LSP formatting if no external formatter available
      },

      -- Format on write for everything up to 800 lines; larger buffers are
      -- handled asynchronously by format_after_save so the write does not block.
      -- Anything past 5000 lines is left alone entirely.
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        if vim.api.nvim_buf_get_name(bufnr):match("/node_modules/") then
          return
        end
        if vim.api.nvim_buf_line_count(bufnr) > 800 then
          return
        end

        return { timeout_ms = 750 }
      end,

      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        if vim.api.nvim_buf_get_name(bufnr):match("/node_modules/") then
          return
        end
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if line_count <= 800 or line_count > 5000 then
          return
        end

        return { timeout_ms = line_count > 2000 and 2000 or 750 }
      end,

      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        pg_format = {
          prepend_args = { "--spaces", "2", "--comma-start", "--keyword-case", "1" },
        },
        codespell = {
          -- conform calls conditions as (self, ctx); the previous single-argument
          -- signature received `self`, so `ctx.bufnr` was always nil and codespell
          -- never ran.
          condition = function(_, ctx)
            return vim.api.nvim_buf_line_count(ctx.bufnr) <= 1000
          end,
        },
      },
    }
  end,

  init = function()
    local toggles = require("utils.toggles")
    toggles.ensure("disable_autoformat")
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
        vim.notify("Format-on-save: OFF (Buffer)", vim.log.levels.WARN)
      else
        vim.g.disable_autoformat = true
        toggles.update("disable_autoformat")
        vim.notify("Format-on-save: OFF (Global)", vim.log.levels.WARN)
      end
    end, {
      desc = "Disable Format on Save (Global or !Buffer)",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      toggles.update("disable_autoformat")
      vim.notify("Format-on-save: ON", vim.log.levels.INFO)
    end, {
      desc = "Enable Format on Save",
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
        toggles.update("disable_autoformat")
        if vim.g.disable_autoformat then
          vim.notify("Format-on-save: OFF (Global)", vim.log.levels.WARN)
        else
          vim.notify("Format-on-save: ON (Global)", vim.log.levels.INFO)
        end
      end
    end, {
      desc = "Toggle Format on Save (Global or !Buffer)",
      bang = true,
    })
  end,
}
