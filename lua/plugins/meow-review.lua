-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/meow-review.lua
-- @brief: lazy.nvim spec for meow.review.nvim — AI code review annotations.
--
-- Keymaps (all managed in keymaps.lua under <leader>r):
--   <leader>ra  Add Comment              [n, v] — modal: Tab cycles type, <C-s> confirms
--   <leader>rd  Delete Comment           [n, v]
--   <leader>rE  Edit Comment             [n]    — pre-filled modal
--   <leader>rv  View Comment             [n]
--   <leader>re  Export Review            [n]    — exports to clipboard (default)
--   <leader>rf  Export to File           [n]    — prompts for filename
--   <leader>rF  Export Current File      [n]    — export annotations for current buffer only
--   <leader>rC  Export and Clear         [n]    — export then wipe all annotations
--   <leader>rc  Clear All                [n]
--   <leader>rg  Go to Comment            [n]    — picker; jump to any annotation
--   <leader>rG  Go to Comment in File    [n]    — picker filtered to current file
--   <leader>rt  Go to Comment by Type    [n]    — type-selection picker then annotation picker
--   <leader>rx  Resolve Comment          [n]    — mark annotation at cursor as resolved
--   <leader>rX  Resolve All              [n]    — mark all annotations as resolved
--   <leader>rV  Validate Annotations     [n]    — detect stale annotations
--   <leader>rr  Reload                   [n]    — reload from store file
--   ]r          Next Review Comment      [n]
--   [r          Previous Review Comment  [n]

return {
    dir = "/Users/retran/workspace/meow.review.nvim", -- local dev override
    -- "retran/meow.review.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    config = function()
        require("meow.review").setup({
            -- Number of source lines to show before and after each annotated range
            -- in the exported markdown. Set to 0 to disable snippet capture.
            context_lines = 3,

            -- Exporter used by <Plug>(MeowReviewExport) / :MeowReview export.
            default_exporter = "clipboard",

            -- Formatter used when rendering annotations ("markdown" or "json").
            default_formatter = "markdown",

            -- Filename written by :MeowReview export file (and file_prompt).
            -- Relative to project root; parent dirs are auto-created.
            export_filename = ".cache/meow-review/review.md",

            -- Path to the annotation store JSON file.
            store_path = ".cache/meow-review/annotations.json",

            -- Inject a ## Summary block (file count, annotation count, type breakdown)
            -- after the preamble in exported Markdown.
            export_summary = true,

            -- Add store file to .gitignore after first write.
            -- "always" = silent, "prompt" = vim.ui.select once, false = disabled.
            auto_gitignore = "prompt",
        })
    end,
}
