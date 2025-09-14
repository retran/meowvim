-- lua/plugins/nvim-cmp.lua

local dependencies = {
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "onsails/lspkind.nvim",
}

if vim.env.MEOW_ENABLE_COPILOT == "true" or false then
  table.insert(dependencies, 1, "zbirenbaum/copilot-cmp")
end

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = dependencies,
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    local sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "neorg" },
      { name = "buffer" },
      { name = "path" },
    }

    local comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    }

    if vim.env.MEOW_ENABLE_COPILOT == "true" or false then
      table.insert(sources, 1, { name = "copilot" })
      table.insert(comparators, 1, require("copilot_cmp.comparators").prioritize)
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources(sources),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 60,
          ellipsis_char = "...",
          symbol_map = { Copilot = "" },
        }),
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Esc>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.abort()
          else
            fallback()
          end
        end),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
      },
      sorting = {
        priority_weight = 2,
        comparators = comparators,
      },
      experimental = {
        ghost_text = true,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })
  end,
}
