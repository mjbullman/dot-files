-- ========================
-- Snacks Configuration
-- Author: Martin Bullman
-- ========================

require('snacks').setup({

    -- =====================
    -- Dashboard
    -- =====================
    dashboard = {
        width = 60,
        preset = {
            header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            keys = {
                { icon = '󰊳', key = 'u', desc = 'Update Plugins', action = ':Lazy update' },
                { icon = '', key = 'f', desc = 'Find Files',      action = ':Telescope find_files' },
                { icon = '', key = 'd', desc = 'Dotfiles',        action = ':Telescope find_files cwd=~/.dotfiles' },
                { icon = '', key = 'q', desc = 'Quit',            action = ':qa' },
            },
        },
        sections = {
            -- Pane 1: header + keys
            { section = 'header' },
            { section = 'keys', gap = 1, padding = 1 },

            -- Pane 2: recent files + projects
            { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
            { pane = 2, icon = ' ', title = 'Projects',     section = 'projects',     indent = 2, padding = 1 },

            -- Pane 2: git status
            {
                pane = 2,
                icon = ' ',
                title = 'Git Status',
                section = 'terminal',
                enabled = function() return Snacks.git.get_root() ~= nil end,
                cmd = 'git status --short --branch --renames',
                height = 5,
                ttl = 5 * 60,
                indent = 3,
                padding = 1,
            },

            -- Full-width startup stats
            { section = 'startup' },
        },
    },

    -- =====================
    -- Module toggles
    -- =====================
    -- Only these modules read `enabled` — snacks gates them at setup time via
    -- event autocmds (bigfile, image, quickfile, indent, explorer, words,
    -- dashboard, scroll, input, scope, picker) or an explicit check
    -- (statuscolumn, notifier). Every other module (lazygit, gh, git, zen,
    -- scratch, profiler, rename, bufdelete, toggle, terminal, gitbrowse, win,
    -- layout, debug, keymap, animate, dim) is a lazy API loaded on first
    -- `Snacks.x()` call and ignores the flag entirely — listing them here would
    -- imply a switch that does not exist.
    bigfile     = { enabled = true },
    explorer    = { enabled = false },  -- neo-tree handles the file tree
    image       = {
        enabled = true,
        doc     = { enabled = true },   -- inline images in markdown, beside render-markdown
    },
    indent      = { enabled = false },
    input       = { enabled = false },
    notifier    = { enabled = false },  -- noice owns notifications
    picker      = { enabled = false },  -- telescope owns pickers
    quickfile   = { enabled = true },
    scope       = { enabled = false },
    scroll      = { enabled = true },
    words       = { enabled = true },
    statuscolumn = {
        enabled = true,
        left    = { 'mark', 'sign' },
        right   = { 'fold', 'git' },
        folds   = {
            open    = true,
            git_hl  = true,  -- use gitsigns colours on fold indicators
        },
        git     = {
            patterns = { 'GitSign' },
        },
        refresh = 50,
    },
})

-- =====================
-- Keymaps
-- =====================

vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end,          { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'LazyGit Current File' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end,      { desc = 'LazyGit Log' })

vim.keymap.set('n', '<leader>gi', function() Snacks.gh.issue() end, { desc = 'GitHub Issues' })
vim.keymap.set('n', '<leader>gP', function() Snacks.gh.pr() end,    { desc = 'GitHub PRs' })
