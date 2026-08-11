-- ==========================================
-- Treesitter Textobjects Configuration
-- Author: Martin Bullman
-- ==========================================

-- On the `main` branch keymaps are set explicitly against the Lua API — the old
-- declarative `keymaps = {}` table from `master` no longer exists.

require('nvim-treesitter-textobjects').setup({
    select = {
        -- jump forward to the next textobject when the cursor is not inside one
        lookahead = true,
    },
    move = {
        -- record movements in the jumplist so <C-o> comes back
        set_jumps = true,
    },
})

local select = require('nvim-treesitter-textobjects.select')
local move = require('nvim-treesitter-textobjects.move')
local swap = require('nvim-treesitter-textobjects.swap')

-- =============================
-- Select (operator-pending + visual)
-- =============================

-- deliberately no `ab`/`ib`: those are built-in block (paren) textobjects.
local selections = {
    ['af'] = { '@function.outer', 'a function' },
    ['if'] = { '@function.inner', 'inner function' },
    ['ac'] = { '@class.outer', 'a class' },
    ['ic'] = { '@class.inner', 'inner class' },
    ['aa'] = { '@parameter.outer', 'a parameter' },
    ['ia'] = { '@parameter.inner', 'inner parameter' },
}

for lhs, spec in pairs(selections) do
    local capture, label = spec[1], spec[2]
    vim.keymap.set({ 'x', 'o' }, lhs, function()
        select.select_textobject(capture, 'textobjects')
    end, { desc = 'Select ' .. label })
end

-- =============================
-- Movement
-- =============================

-- `]c`/`[c` are NOT used here: gitsigns owns them for hunk navigation
-- (see config/gitsigns.lua). Classes use the section motions instead.
local movements = {
    { ']f', move.goto_next_start, '@function.outer', 'Next function start' },
    { '[f', move.goto_previous_start, '@function.outer', 'Previous function start' },
    { ']F', move.goto_next_end, '@function.outer', 'Next function end' },
    { '[F', move.goto_previous_end, '@function.outer', 'Previous function end' },
    { ']]', move.goto_next_start, '@class.outer', 'Next class start' },
    { '[[', move.goto_previous_start, '@class.outer', 'Previous class start' },
}

for _, spec in ipairs(movements) do
    local lhs, fn, capture, desc = spec[1], spec[2], spec[3], spec[4]
    vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
        fn(capture, 'textobjects')
    end, { desc = desc })
end

-- =============================
-- Swap
-- =============================

vim.keymap.set('n', '<leader>na', function()
    swap.swap_next('@parameter.inner')
end, { desc = 'Swap parameter with next' })

vim.keymap.set('n', '<leader>pa', function()
    swap.swap_previous('@parameter.inner')
end, { desc = 'Swap parameter with previous' })
