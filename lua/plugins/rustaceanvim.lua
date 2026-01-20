-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/rustaceanvim.lua
-- @brief: Rust development environment configuration.

return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    init = function()
        vim.g.rustaceanvim = {
            tools = {},
            server = {
                on_attach = function(client, bufnr)
                    -- Intentionally left empty as a placeholder for future LSP buffer-local configuration.
                end,
                default_settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            },
            dap = {},
        }
    end,
}
