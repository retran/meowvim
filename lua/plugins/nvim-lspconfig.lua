-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-lspconfig.lua
-- @brief: Language Server Protocol (LSP) client configuration and setup.
-- @requires: Neovim >= 0.11 (uses vim.lsp.config() and vim.lsp.enable() APIs)

local mason_registry = require("config.mason")

return {
  "neovim/nvim-lspconfig",
  version = "v1.*", -- Pin to stable 1.x releases
  lazy = false,
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind.nvim",
    "b0o/SchemaStore.nvim",
    "mason-org/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local ok_lspkind, lspkind = pcall(require, "lspkind")
    if ok_lspkind then
      lspkind.init({
        mode = "symbol_text",
        preset = "codicons",
      })
    end

    -- Guard: Skip Mason setup in CI/container environments
    local is_ci = vim.env.CI or vim.env.DOCKER or vim.fn.filereadable("/.dockerenv") == 1
    if is_ci then
      vim.notify("Skipping Mason setup in CI/container environment", vim.log.levels.INFO)
      return
    end

    local mason = require("mason")
    mason.setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "󰄬",
          package_pending = "󰪠",
          package_uninstalled = "󰅘",
        },
      },
    })

    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

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

    local catppuccin_lsp_ok, catppuccin_lsp = pcall(require, "catppuccin.integrations.lsp")
    if catppuccin_lsp_ok then
      if type(catppuccin_lsp) == "table" and type(catppuccin_lsp.setup) == "function" then
        catppuccin_lsp.setup()
      elseif type(catppuccin_lsp) == "function" then
        catppuccin_lsp()
      end
    end

    local registry_ok, registry = pcall(require, "mason-registry")
    local optional_servers = {
      postgres_lsp = true,
    }

    -- Cache package_supported lookups to avoid repeated registry checks
    local package_supported_cache = {}
    local function package_supported(name)
      if package_supported_cache[name] ~= nil then
        return package_supported_cache[name]
      end

      if not registry_ok then
        package_supported_cache[name] = true
        return true
      end

      if not registry.has_package(name) then
        package_supported_cache[name] = false
        return false
      end

      local ok_pkg, pkg = pcall(registry.get_package, name)
      if not ok_pkg then
        package_supported_cache[name] = false
        return false
      end

      if pkg.is_supported then
        local ok_supported, supported = pcall(pkg.is_supported, pkg)
        if ok_supported then
          package_supported_cache[name] = supported
          return supported
        end
      end

      package_supported_cache[name] = true
      return true
    end

    local icons = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "󰋼" }
    for type, icon in pairs(icons) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
    end

    -- Configure global LSP handlers for hover and signature help
    -- These apply to all LSP clients
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, 
      { border = "rounded" }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, 
      { border = "rounded" }
    )

    -- Build capabilities from nvim-cmp defaults
    local caps = require("cmp_nvim_lsp").default_capabilities()
    -- Enable semantic tokens (supported in Neovim 0.11+)
    -- Semantic tokens provide enhanced syntax highlighting based on LSP semantic information
    -- See :h lsp-semantic-highlight for more details
    caps.textDocument.semanticTokens = vim.tbl_deep_extend("force", 
      caps.textDocument.semanticTokens or {},
      { dynamicRegistration = true }
    )

    local on_attach = function(client, bufnr)
      -- Note: Neovim 0.11+ sets omnifunc automatically as a buffer-local default
      -- Only override if you need custom behavior
      
      -- Enable inlay hints for supported servers (gopls, rust-analyzer, ts_ls, etc.)
      -- Provides inline type information and parameter names
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      -- CodeLens deliberately disabled globally for performance reasons:
      -- - Triggers excessive LSP requests on CursorHold/InsertLeave events
      -- - Causes UI lag on medium-to-large codebases
      -- - Visual clutter in the editor
      -- To re-enable per-buffer: vim.lsp.codelens.refresh({ bufnr = bufnr })
    end

    -- User command for organizing imports in TypeScript/JavaScript files
    -- Uses the ts_ls (TypeScript Language Server) custom command
    vim.api.nvim_create_user_command("LspOrganize", function()
      local clients = vim.lsp.get_clients({ bufnr = 0, name = "ts_ls" })
      if #clients == 0 then
        vim.notify("No TypeScript LSP client attached to current buffer", vim.log.levels.WARN)
        return
      end

      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "Organize Imports",
      }

      -- Use client:request() (Neovim 0.11+ API) instead of deprecated vim.lsp.buf_request()
      clients[1]:request("workspace/executeCommand", params, function(err, _)
        if err then
          vim.notify("Error organizing imports: " .. vim.inspect(err), vim.log.levels.ERROR)
        end
      end, 0)
    end, { desc = "Organize Imports (TypeScript/JavaScript)", force = true })

    local server_settings = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      },
      bashls = {
        filetypes = { "sh", "bash", "zsh" },
      },
      gopls = {
        -- Override root_dir with function that falls back to file's directory
        root_dir = function(fname)
          local root = vim.fs.root(fname, { 'go.work', 'go.mod', '.git' })
          return root or vim.fn.fnamemodify(fname, ':h')
        end,
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticTokens = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              parameterNames = true,
            },
          },
        },
      },
      pyright = {
        settings = {
          python = { analysis = { typeCheckingMode = "basic" } },
        },
      },
      ts_ls = {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.keymap.set("n", "<leader>co", "<cmd>LspOrganize<CR>", { buffer = bufnr, desc = "Organize Imports" })
        end,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      },
      html = {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      },
      cssls = {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      },
      emmet_ls = {},
      marksman = {},
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            hover = true,
            completion = true,
            format = { enable = true },
          },
        },
      },
      dockerls = {},
      docker_compose_language_service = {},
      ltex = {
        settings = {
          ltex = {
            language = "en-US",
          },
        },
      },
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = true,
            },
            forwardSearch = {
              executable = "open",
              args = { "-a", "Skim", "%p" },
            },
            chktex = {
              onOpenAndSave = true,
            },
            lint = {
              onChange = true,
            },
          },
        },
      },
      postgres_lsp = {},
    }

    local ensure_servers = {}
    for server, _ in pairs(server_settings) do
      if not optional_servers[server] or package_supported(server) then
        table.insert(ensure_servers, server)
      end
    end

    mason_registry.ensure_servers(ensure_servers)

    local extra_tools = {}
    if package_supported("roslyn") then
      table.insert(extra_tools, "roslyn")
    end
    if package_supported("rust-analyzer") then
      table.insert(extra_tools, "rust-analyzer")
    end
    if #extra_tools > 0 then
      mason_registry.ensure_servers(extra_tools)
    end

    mason_lspconfig.setup({
      ensure_installed = ensure_servers,
      -- Disable automatic_enable so that setup_server() below controls all LSP
      -- configuration (capabilities, on_attach, settings). Without this,
      -- mason-lspconfig >= 1.x would call vim.lsp.enable() for every installed
      -- server before our custom config is applied, causing ts_ls (and others)
      -- to start with no capabilities, no on_attach hooks, and no settings.
      automatic_enable = false,
    })

    local lspconfig = require("lspconfig")

    local function setup_server(server_name)
      if optional_servers[server_name] and not package_supported(server_name) then
        return
      end

      local server_opts = vim.tbl_deep_extend("force", {}, server_settings[server_name] or {})
      local custom_on_attach = server_opts.on_attach

      server_opts.capabilities = vim.tbl_deep_extend("force", {}, caps, server_opts.capabilities or {})
      
      -- Merge on_attach callbacks
      local base_on_attach = on_attach
      server_opts.on_attach = function(client, bufnr)
        base_on_attach(client, bufnr)
        if custom_on_attach then
          custom_on_attach(client, bufnr)
        end
      end

      -- Get default config from nvim-lspconfig to extract cmd, filetypes, etc.
      local server = lspconfig[server_name]
      if not server or not server.document_config then
        vim.notify(
          string.format("LSP server '%s' not found in lspconfig", server_name),
          vim.log.levels.WARN
        )
        return
      end

      local default_config = server.document_config.default_config or {}
      
      -- Build the final config by merging defaults with custom settings
      local common_root_markers = {
        'package.json',
        'tsconfig.json',
        'jsconfig.json',
        'pyproject.toml',
        'setup.py',
        'requirements.txt',
        'go.mod',
        'Cargo.toml',
        'pom.xml',
        'build.gradle',
        '.git',
      }
      
      -- Create root_dir function that falls back to file's directory if no markers found
      local root_dir_fn = server_opts.root_dir
      if not root_dir_fn then
        root_dir_fn = function(fname)
          local root = vim.fs.root(fname, common_root_markers)
          -- Fallback to file's directory if no project root found
          return root or vim.fn.fnamemodify(fname, ':h')
        end
      end
      
      local final_config = vim.tbl_deep_extend("force", {
        cmd = default_config.cmd,
        filetypes = default_config.filetypes,
        -- In Neovim 0.11+, root_dir can be a function or array of patterns
        root_dir = root_dir_fn,
      }, server_opts)
      
      -- Use Neovim 0.11+ native LSP API
      vim.lsp.config(server_name, final_config)
      vim.lsp.enable(server_name)
    end

    -- setup_handlers was removed from mason-lspconfig; iterate directly.
    for _, server_name in ipairs(ensure_servers) do
      setup_server(server_name)
    end

    -- Setup GDScript LSP (for Godot engine)
    do
      if lspconfig.gdscript and lspconfig.gdscript.document_config then
        local default_config = lspconfig.gdscript.document_config.default_config or {}
        vim.lsp.config('gdscript', {
          cmd = default_config.cmd,
          filetypes = default_config.filetypes,
          root_dir = function(fname)
            local root = vim.fs.root(fname, { 'project.godot', '.git' })
            return root or vim.fn.fnamemodify(fname, ':h')
          end,
          capabilities = caps,
          on_attach = on_attach,
        })
        vim.lsp.enable('gdscript')
      end
    end

    -- Note: Roslyn LSP is handled by the separate roslyn.nvim plugin (lua/plugins/roslyn.lua)
    -- No need to configure it here

    mason_tool_installer.setup({
      ensure_installed = mason_registry.get_all_tools(),
      auto_update = false,
      run_on_start = true,
      start_delay = 0,
      integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = true,
      },
    })
  end,
}
