-- ========================
--  Neo-tree Configuration
--  Author: Martin Bullman
-- ========================

local default_icon = require('neo-tree.defaults').default_component_configs.icon

require('neo-tree').setup({
    popup_border_style = '',
    close_if_last_window = true,
    window = {
        width = 35,
        -- mappings = {},
        position = 'left',
    },
    filesystem = {
        use_libuv_file_watcher = true,
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
    default_component_configs = {
        icon = vim.tbl_extend('force', default_icon, {
            folder_closed = '󰉋',
            folder_open = '󰝰',
        }),
        indent = {
            with_expanders = true,
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
            -- plain marks, differentiated by the NeoTreeGit* highlight colour.
            -- unstaged has no mark (that is the default state); staged gets a
            -- tick. modified is '~' so a doubled index+worktree change reads
            -- '~~' rather than two identical glyphs.
            symbols = {
                added = '+',
                deleted = '-',
                modified = '~',
                untracked = '?',
                renamed = '→',
                conflict = '!',
                ignored = '',
                unstaged = '',
                staged = '✓',
            },
        },
    },
})


-- =========================================================
-- Neo-tree Keymaps
-- =========================================================

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- toggle Neo-tree at project root (cwd).
map('n', '<leader>e', function()
    require('neo-tree.command').execute({
        dir = vim.fn.getcwd(),
        toggle = true,
        source = 'filesystem',
        position = 'left',
    })
end, vim.tbl_extend('force', opts, { desc = 'Toggle Neo-tree (cwd)' }))

-- reveal the current buffer's file in the tree. No `toggle` — with it, an
-- already-open tree is closed and the reveal never runs (command/init.lua).
map('n', '<leader>E', function()
    require('neo-tree.command').execute({
        dir = vim.fn.getcwd(),
        reveal = true,
        source = 'filesystem',
        position = 'left',
    })
end, vim.tbl_extend('force', opts, { desc = 'Reveal current file in Neo-tree' }))
