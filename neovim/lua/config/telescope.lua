-- ===============================
-- Telescope Plugin Configuration
-- Author: Martin Bullman
-- ===============================

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

local file_ignore_patterns = {
    'node_modules',
    '%.git/',
    '%.venv',
}

require('telescope').setup({
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    },
    defaults = {
        prompt_prefix = '   ',
        selection_caret = '➤ ',
        path_display = { 'smart' },
        mappings = {
            i = {
                -- navigation in list
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-l>'] = actions.select_default,

                -- preview navigation
                ['<C-u>'] = actions.preview_scrolling_up,
                ['<C-d>'] = actions.preview_scrolling_down,

                -- additional useful mappings
                ['<Esc>'] = actions.close,
                ['<C-c>'] = actions.close,
            },
            n = {
                -- normal mode navigation
                ['j'] = actions.move_selection_next,
                ['k'] = actions.move_selection_previous,
                ['<CR>'] = actions.select_default,

                -- preview navigation in normal mode
                ['<C-u>'] = actions.preview_scrolling_up,
                ['<C-d>'] = actions.preview_scrolling_down,

                -- close with q
                ['q'] = actions.close,
            },
        },
    },
    -- scoped to file-searching pickers only: in `defaults` these also strip
    -- LSP results, so go-to-definition into node_modules returned nothing
    pickers = {
        find_files = { file_ignore_patterns = file_ignore_patterns },
        live_grep = { file_ignore_patterns = file_ignore_patterns },
        oldfiles = { file_ignore_patterns = file_ignore_patterns },
    },
})

-- fzf-native is build-gated on `make` in the plugin spec; skip it gracefully
-- on a machine without a compiler rather than erroring at startup
pcall(require('telescope').load_extension, 'fzf')
require('telescope').load_extension('ui-select')


-- =============================
-- Telescope Keymaps
-- =============================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<leader>ff', builtin.find_files, vim.tbl_extend('force', opts, {
    desc = 'Telescope: Find Files'
}))
map('n', '<leader>fg', builtin.live_grep, vim.tbl_extend('force', opts, {
    desc = 'Telescope: Live Grep'
}))
map('n', '<leader>fh', builtin.help_tags, vim.tbl_extend('force', opts, {
    desc = 'Telescope: Help Tags'
}))
map('n', '<leader><leader>', builtin.buffers, vim.tbl_extend('force', opts, {
    desc = 'Telescope: Buffers'
}))
map('n', '<leader>f.', builtin.oldfiles, vim.tbl_extend('force', opts, {
    desc = 'Telescope: Recent Files'
}))
map('n', '<leader>fd', builtin.diagnostics, vim.tbl_extend('force', opts, {
    desc = 'Telescope: Diagnostics'
}))
map('n', '<leader>fk', builtin.keymaps, vim.tbl_extend('force', opts, {
    desc = 'Telescope: Keymaps'
}))
