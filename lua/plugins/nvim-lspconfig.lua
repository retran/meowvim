-- lua/plugins/nvim-lspconfig.lua

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind.nvim",
    "folke/neodev.nvim",
    "b0o/SchemaStore.nvim",
  },
  config = function()
    vim.deprecate = function(...) end

    require("neodev").setup()

    local ok, lspkind = pcall(require, "lspkind")
    if ok then
      lspkind.init({
        mode = "symbol_text",
        preset = "codicons",
      })
    end

    local lspconfig = require("lspconfig")

    vim.diagnostic.config({
      virtual_text = { prefix = "", spacing = 2 },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
    })

    local icons = {
      Error = "󰅚",
      Warn = "󰀪",
      Hint = "󰌶",
      Info = "󰋼",
    }
    for type, icon in pairs(icons) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    local caps = vim.lsp.protocol.make_client_capabilities()
    caps = require("cmp_nvim_lsp").default_capabilities(caps)

    local on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end

    local servers = {
      lua_ls = {},
      bashls = { filetypes = { "sh", "bash", "zsh" } },
      gdscript = {
        cmd = { "nc", "localhost", "6005" },
        filetypes = { "gd", "gdscript", "gdscript3" },
        root_dir = lspconfig.util.root_pattern("project.godot", ".git"),
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        end,
      },
      gopls = {
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
            ui = {
              inlayhints = {
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = { checkOnSave = { command = "clippy" } },
        },
      },
      pyright = {
        settings = {
          python = { analysis = { typeCheckingMode = "basic" } },
        },
      },
      ts_ls = {
        settings = {
          typescript = { inlayHints = { includeInlayParameterNameHints = "literal" } },
          javascript = { inlayHints = { includeInlayParameterNameHints = "literal" } },
        },
      },
      marksman = { filetypes = { "markdown", "md" } },
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
    }

    local server_executables = {
      lua_ls = "lua-language-server",
      ts_ls = "typescript-language-server",
      jsonls = "vscode-json-languageserver",
    }

    for name, cfg in pairs(servers) do
      local exec_name = server_executables[name] or name
      if name == "gdscript" or vim.fn.executable(exec_name) == 1 then
        lspconfig[name].setup(vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = caps,
        }, cfg))
      end
    end
  end,
}
