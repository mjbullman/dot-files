-- =======================
-- Tiny Inline Diagnostic - Better LSP Diagnostics Display
-- Author: Martin Bullman
-- =======================

return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function()
        require("tiny-inline-diagnostic").setup({
            preset = "modern", -- "modern", "classic", "minimal", "ghost", "simple"
            options = {
                -- Show diagnostic source (e.g., eslint, typescript)
                show_source = true,

                -- Throttle diagnostics updates (ms)
                throttle = 20,

                -- Enable on all file types
                enabled = true,

                -- Multiple diagnostics on same line behavior
                multiple_diag_under_cursor = true,

                -- Show all diagnostics or just current line
                multilines = false,
            },
        })

        -- Disable default virtual text since we're using inline diagnostics
        vim.diagnostic.config({
            virtual_text = false,
        })
    end,
}
