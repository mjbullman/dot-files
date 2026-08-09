-- ==============================
-- Neovim Keymaps Configuration
-- Author: Martin Bullman
-- ===============================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- -----------------------------
-- Leader keys
-- -----------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- -----------------------------
-- diagnostics
-- -----------------------------
-- open_float is line-scoped and silently does nothing when the cursor line is
-- clean, which is indistinguishable from a broken keymap. Say so instead.
map('n', '<leader>df', function()
    if vim.diagnostic.open_float() == nil then
        local total = #vim.diagnostic.get(0)
        vim.notify(
            total == 0 and 'No diagnostics in this buffer'
                or ('No diagnostics on this line (' .. total .. ' in buffer)'),
            vim.log.levels.INFO
        )
    end
end, {
    desc = 'Open diagnostic float'
})
map('n', '<leader>dd', vim.diagnostic.setloclist, {
    desc = 'Set location list with diagnostics'
})
-- show the diagnostic after jumping to it
local function on_jump(_, bufnr)
    vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
end

map('n', '[d', function()
    vim.diagnostic.jump({ count = -1, on_jump = on_jump })
end, vim.tbl_extend('force', opts, {
    desc = 'Go to previous diagnostic'
}))
map('n', ']d', function()
    vim.diagnostic.jump({ count = 1, on_jump = on_jump })
end, vim.tbl_extend('force', opts, {
    desc = 'Go to next diagnostic'
}))


-- ----------------------------- 
-- basic operations 
-- -----------------------------
map({'n', 'v'}, '<Space>', '<Nop>', {
    silent = true,
    desc = 'Disable space key default behavior'
})
map('n', '<leader>s', '<cmd>w<CR>', {
    desc = 'Save file'
})
map('n', '<leader>q', '<cmd>q<CR>', {
    desc = 'Quit window'
})
map('n', '<leader>Q', '<cmd>qa!<CR>', {
    desc = 'Quit all without saving'
})

-- -----------------------------
-- buffers
-- -----------------------------
map('n', '<S-l>', '<cmd>bnext<CR>', {
    desc = 'Go to next buffer'
})
map('n', '<S-h>', '<cmd>bprevious<CR>', {
    desc = 'Go to previous buffer'
})
map('n', '<leader>bd', function() Snacks.bufdelete() end, {
    desc = 'Close current buffer'
})
map('n', '<leader>bo', function() Snacks.bufdelete.other() end, {
    desc = 'Close all other buffers'
})
map('n', '<leader>bu', '<cmd>e#<CR>', {
    desc = 'Reopen last closed buffer'
})
map('n', '<leader>bl', '<cmd>ls<CR>', {
    desc = 'List all buffers'
})


-- -----------------------------
-- indentation
-- -----------------------------
map('v', '<', '<gv', {
    desc = 'Indent left and reselect'
})
map('v', '>', '>gv', {
    desc = 'Indent right and reselect'
})


-- -----------------------------
-- search
-- -----------------------------
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

