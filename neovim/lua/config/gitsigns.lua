-- ===============================
-- Gitsigns Configuration
-- Author: Martin Bullman
-- ===============================

require('gitsigns').setup({
    signs = {
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '▾' },
        topdelete    = { text = '▴' },
        changedelete = { text = '▎' },
        untracked    = { text = '┆' },
    },
    signcolumn = true,  -- toggle with `:Gitsigns toggle_signs`
    numhl = false,      -- toggle with `:Gitsigns toggle_numhl`
    linehl = false,     -- toggle with `:Gitsigns toggle_linehl`
    word_diff = false,  -- toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
        -- options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- navigation
        map('n', ']c', function()
            if vim.wo.diff then
                return ']c'
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return '<Ignore>'
        end, { expr = true, desc = 'Next hunk' })

        map('n', '[c', function()
            if vim.wo.diff then
                return '[c'
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return '<Ignore>'
        end, { expr = true, desc = 'Previous hunk' })

        -- actions (essential only)
        map('n', '<leader>gs', gs.stage_hunk, { desc = 'Git: Stage hunk' })
        map('v', '<leader>gs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Git: Stage hunk' })
        map('n', '<leader>gr', gs.reset_hunk, { desc = 'Git: Reset hunk' })
        map('v', '<leader>gr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Git: Reset hunk' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Git: Preview hunk' })
        map('n', '<leader>gb', function()
            gs.blame_line({ full = true })
        end, { desc = 'Git: Blame line' })

        -- toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })
    end,
})
