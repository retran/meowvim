-- lua/plugins/conform.lua

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "ruff_organize_imports" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      go = { "goimports", "gofmt" },
      rust = { "rustfmt", lsp_format = "fallback" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      java = { "google-java-format" },
      gdscript = { "gdformat" },
      gdshader = { "clang_format" },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },

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
      prettier = {
        prepend_args = { "--tab-width", "2" },
      },
      prettierd = {
        prepend_args = { "--tab-width", "2" },
      },
      black = {
        prepend_args = { "--line-length", "88" },
      },
      gdformat = {
        command = "gdformat"
      },
    },
  },

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
