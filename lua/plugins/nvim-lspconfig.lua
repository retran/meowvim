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

    local icons = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "󰋼" }
    for type, icon in pairs(icons) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    local caps = vim.lsp.protocol.make_client_capabilities()
    caps.textDocument.semanticTokens = { dynamicRegistration = true }
    caps = require("cmp_nvim_lsp").default_capabilities(caps)

    local on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,
        })
      end
    end

    if vim.fn.executable("lua-language-server") == 1 then
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = caps,
      })
    end

    if vim.fn.executable("bash-language-server") == 1 then
      lspconfig.bashls.setup({
        on_attach = on_attach,
        capabilities = caps,
        filetypes = { "sh", "bash", "zsh" },
      })
    end

    if vim.fn.executable("nc") == 1 then
      lspconfig.gdscript.setup({
        capabilities = caps,
        cmd = { "nc", "localhost", "6005" },
        filetypes = { "gd", "gdscript", "gdscript3" },
        root_dir = lspconfig.util.root_pattern("project.godot", ".git"),
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        end,
      })
    end

    if vim.fn.executable("gopls") == 1 then
      lspconfig.gopls.setup({
        capabilities = caps,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end,
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            vulncheck = "Imports",
            usePlaceholders = true,
            completeUnimported = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
            codelenses = {
              run_govulncheck = true,
              gc_details = false,
              test = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              ignoredError = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              asmdecl = true,
              assign = true,
              atomic = true,
              atomicalign = true,
              bools = true,
              buildtag = true,
              cgocall = true,
              composites = true,
              copylocks = true,
              deepequalerrors = true,
              errorsas = true,
              fieldalignment = true,
              findcall = true,
              framepointer = true,
              httpresponse = true,
              ifaceassert = true,
              infertypeargs = true,
              loopclosure = true,
              lostcancel = true,
              nilfunc = true,
              nilness = true,
              printf = true,
              shadow = true,
              sortslice = true,
              stringintconv = true,
              structtag = true,
              testinggoroutine = true,
              tests = true,
              unmarshal = true,
              unreachable = true,
              unusedparams = true,
              unusedresult = true,
              unusedwrite = true,
              useany = true,
            },
          },
        },
      })
    end

    if vim.fn.executable("rust-analyzer") == 1 then
      lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = caps,
        settings = {
          ["rust-analyzer"] = { checkOnSave = { command = "clippy" } },
        },
      })
    end

    if vim.fn.executable("pyright") == 1 then
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = caps,
        settings = {
          python = { analysis = { typeCheckingMode = "basic" } },
        },
      })
    end

    if vim.fn.executable("typescript-language-server") == 1 then
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = caps,
        settings = {
          typescript = { inlayHints = { includeInlayParameterNameHints = "literal" } },
          javascript = { inlayHints = { includeInlayParameterNameHints = "literal" } },
        },
      })
    end

    if vim.fn.executable("marksman") == 1 then
      lspconfig.marksman.setup({
        on_attach = on_attach,
        capabilities = caps,
        filetypes = { "markdown", "md" },
      })
    end

    if vim.fn.executable("vscode-json-languageserver") == 1 then
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = caps,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end
  end,
}
