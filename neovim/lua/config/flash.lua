-- ========================
--  Flash Configuration
--  Author: Martin Bullman
-- ========================

require('flash').setup({
    labels = 'asdfghjklqwertyuiopzxcvbnm',
    search = {
        multi_window = true,
        forward = true,
        wrap = true,
    },
    jump = {
        jumplist = true,
        pos = 'start',
        history = false,
        register = false,
        nohlsearch = true,
        autojump = false,
    },
    modes = {
        -- flash when using f/F/t/T
        char = {
            enabled = true,
            jump_labels = true,
        },
        -- flash when using /
        search = {
            enabled = true,
        },
    },
})


-- ========================
-- Flash Keymaps
-- ========================

local map = vim.keymap.set

-- jump to any word on screen
map({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end,
    { desc = 'Flash: Jump' })

-- treesitter-aware selection
map({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end,
    { desc = 'Flash: Treesitter' })

-- remote flash (operate on distant text without moving cursor)
map('o', 'r', function() require('flash').remote() end,
    { desc = 'Flash: Remote' })

-- toggle flash in search (/)
map({ 'n', 'x', 'o' }, '<leader>/', function() require('flash').toggle() end,
    { desc = 'Flash: Toggle Search' })
