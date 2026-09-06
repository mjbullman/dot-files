-- ===============================
-- Trouble Configuration
-- Author: Martin Bullman
-- ===============================

require('trouble').setup({
    -- close the panel once its last item clears; skip the "no results"
    -- flash when toggling a mode that has nothing to show
    auto_close = true,
    warn_no_results = false,
    win = {
        type     = 'split',
        position = 'right',
        size     = { width = 0.4 },
        border   = 'rounded',
        -- global wrap is off, which truncates long diagnostics in the panel
        wo       = { wrap = true, linebreak = true, breakindent = true },
    },
    -- severity icons come from vim.diagnostic.config() signs (config/lsp.lua);
    -- trouble v3 has no error/warning/hint/info keys of its own
})

-- render every quickfix list (:grep, :make, LSP references, diffview conflicts,
-- …) in the Trouble panel instead of the plain built-in window. :cnext/:cprev
-- still work; <leader>xQ becomes redundant.
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('trouble_qf', { clear = true }),
    callback = function(ev)
        if vim.bo[ev.buf].buftype == 'quickfix' then
            vim.schedule(function()
                vim.cmd('cclose')
                require('trouble').open('qflist')
            end)
        end
    end,
})

-- =============================
-- Trouble keymaps
-- =============================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle focus=true<cr>', vim.tbl_extend('force', opts, {
    desc = 'Diagnostics (Trouble)'
}))

map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>', vim.tbl_extend('force', opts, {
    desc = 'Buffer diagnostics (Trouble)'
}))

map('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', vim.tbl_extend('force', opts, {
    desc = 'Symbols (Trouble)'
}))

map('n', '<leader>xr', '<cmd>Trouble lsp toggle focus=false<cr>', vim.tbl_extend('force', opts, {
    desc = 'LSP definitions / references (Trouble)'
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

