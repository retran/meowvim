-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

local function get_dependencies()
  local deps = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-cmdline",
    "f3fora/cmp-spell",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
    "saecki/crates.nvim",
  }
  return deps
end

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = get_dependencies(),
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    local format_kinds = function(entry, vim_item)
      vim_item = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...",
        symbol_map = { Copilot = "" },
      })(entry, vim_item)

      local kind = vim_item.kind
      local source_name = entry.source.name
      local source_icons = {
        nvim_lsp = " LSP",
        luasnip = " Snip",
        buffer = " Buffer",
        path = " Path",
        lazydev = " LazyDev",
        spell = " Spell",
        nvim_lua = "NVIM API",
        cmdline = " Command",
      }

      if source_icons[source_name] then
        vim_item.kind = string.format("%s %s", source_icons[source_name], kind)
      end

      return vim_item
    end

    local comparators = {
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.order,
    }

    local global_sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "spell" },
      { name = "buffer", keyword_length = 3 },
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources(global_sources),
      formatting = {
        format = format_kinds,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() then
            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Esc>"] = cmp.mapping.abort(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sorting = {
        priority_weight = 2,
        comparators = comparators,
      },
      experimental = {
        ghost_text = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })

    cmp.setup.filetype("lua", {
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },
      }),
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "Cargo.toml",
      callback = function(_event)
        cmp.setup.buffer({
          sources = cmp.config.sources({
            { name = "crates" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer", keyword_length = 3 },
          }),
        })
      end,
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = "path" }, { name = "cmdline" } }),
    })
  end,
}
