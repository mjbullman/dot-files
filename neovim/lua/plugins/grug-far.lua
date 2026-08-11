-- =======================
--  Grug Far Plugin Setup
--  Project-wide find and replace
--  Author: Martin Bullman
-- =======================

return {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
        {
            '<leader>fr',
            function()
                require('grug-far').open()
            end,
            desc = 'Find & replace (grug-far)',
        },
        {
            '<leader>fr',
            function()
                require('grug-far').with_visual_selection()
            end,
            mode = 'x',
            desc = 'Find & replace selection (grug-far)',
        },
    },
    opts = {
        -- ripgrep comes from telescope-fzf-native's toolchain; keep the
        -- default engine rather than pinning a path that may move.
        headerMaxWidth = 80,
    },
}
