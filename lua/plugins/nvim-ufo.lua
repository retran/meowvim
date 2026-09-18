-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-ufo.lua
-- @brief: Enhanced folding UI backed by Treesitter and LSP providers.

return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  opts = {
    -- A returned table only chains two providers, so use the documented
    -- promise form to degrade lsp -> treesitter -> indent. This matters here:
    -- language servers are installed per project, while treesitter parsers are
    -- always available, so the previous { "lsp", "indent" } fell straight
    -- through to indent folding in every buffer without an attached server.
    provider_selector = function()
      -- ufo accepts a function as the provider; returning one lets us chain
      -- three providers, while the {main, fallback} table form allows only two.
      return function(bufnr)
        local ufo = require("ufo")
        local promise = require("promise")

        local function fallback(err, provider)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return ufo.getFolds(bufnr, provider)
          end
          return promise.reject(err)
        end

        return ufo
          .getFolds(bufnr, "lsp")
          :catch(function(err)
            return fallback(err, "treesitter")
          end)
          :catch(function(err)
            return fallback(err, "indent")
          end)
      end
    end,
  },
  config = function(_, opts)
    require("ufo").setup(opts)
  end,
}
