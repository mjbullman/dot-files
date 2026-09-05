-- ========================
--  Neo-tree Configuration
--  Author: Martin Bullman
-- ========================

require('neo-tree').setup({
    popup_border_style = '',
    close_if_last_window = true,
    window = {
        width = 35,
        -- mappings = {},
        position = 'left',
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
    default_component_configs = {
        indent = {
            with_expanders = true,
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
           -- deliberately minimal: JetBrains uses filename colour alone, VS
           -- Code plain letters ("!" over "⚠" — their own reasoning is it
           -- "looks really bad on Windows"), nvim-tree mostly plain unicode.
           -- modified/untracked keep neo-tree's defaults, already minimal
           -- (a dot, and "?"). ignored drops its icon entirely and relies on
           -- the NeoTreeGitIgnored highlight, which colours the text either way.
           symbols = {
               added = '+',
               deleted = '-',
               renamed = '→',
               conflict = '!',
               ignored = '',
               unstaged = '󰄱',
               staged = '󰱒',
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
