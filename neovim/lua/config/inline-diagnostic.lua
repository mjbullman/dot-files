-- ===============================
-- Inline Diagnostic Configuration
--  Author: Martin Bullman
-- ===============================

require("tiny-inline-diagnostic").setup({
    preset = "modern", -- "modern", "classic", "minimal", "ghost", "simple"
    options = {
        -- show diagnostic source (e.g., eslint, typescript)
        show_source = true,

        -- throttle diagnostics updates (ms)
        throttle = 20,

        -- enable on all file types
        enabled = true,

        -- multiple diagnostics on same line behavior
        multiple_diag_under_cursor = true,

        -- show all diagnostics or just current line
        multilines = false,
    },
})

-- disable default virtual text since we're using inline diagnostics
vim.diagnostic.config({
    virtual_text = false,
})
