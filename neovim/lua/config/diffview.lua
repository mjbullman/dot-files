-- ===============================
-- Diffview Configuration
-- Author: Martin Bullman
-- ===============================

local actions = require('diffview.actions')

require('diffview').setup({
    enhanced_diff_hl = true,
    view = {
        -- three-way merge view for conflicts: OURS | RESULT | THEIRS
        merge_tool = {
            layout = 'diff3_mixed',
            disable_diagnostics = true,
        },
    },
    file_panel = {
        listing_style = 'tree',
        win_config = {
            position = 'left',
            width = 35,  -- match neo-tree
        },
    },
    keymaps = {
        view = {
            { 'n', 'q', actions.close, { desc = 'Close diffview' } },
        },
        file_panel = {
            { 'n', 'q', actions.close, { desc = 'Close diffview' } },
        },
        file_history_panel = {
            { 'n', 'q', actions.close, { desc = 'Close diffview' } },
        },
    },
})

