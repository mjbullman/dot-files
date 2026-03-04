-- ===============================
-- Trouble Configuration
-- Author: Martin Bullman
-- ===============================

require('trouble').setup({
    win = {
        type     = 'split',
        position = 'right',
        size     = { width = 0.4 },
        border   = 'rounded',
    },
    icons = {
        error   = '✘',
        warning = '⚠',
        hint    = '󰞋',
        info    = 'ℹ',
    },
})

-- =============================
-- Trouble keymaps 
-- =============================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', vim.tbl_extend('force', opts, {
    desc = 'Diagnostics (Trouble)'
}))

map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', vim.tbl_extend('force', opts, {
    desc = 'Buffer diagnostics (Trouble)'
}))

map('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', vim.tbl_extend('force', opts, {
    desc = 'Symbols (Trouble)'
}))

map('n', '<leader>xr', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', vim.tbl_extend('force', opts, {
    desc = 'LSP references (Trouble)'
}))

map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', vim.tbl_extend('force', opts, {
    desc = 'Location list (Trouble)'
}))

map('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', vim.tbl_extend('force', opts, {
    desc = 'Quickfix list (Trouble)'
}))

map('n', '[x', '<cmd>Trouble prev<CR>', vim.tbl_extend('force', opts, {
    desc = 'Previous trouble item'
}))

map('n', ']x', '<cmd>Trouble next<CR>', vim.tbl_extend('force', opts, {
    desc = 'Next trouble item'
}))

