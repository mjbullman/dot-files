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
                { icon = '', key = 'd', desc = 'Dotfiles',        action = ':Telescope dotfiles' },
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
    -- Disabled modules
    -- =====================
    animate     = { enabled = false },
    bigfile     = { enabled = true },
    bufdelete   = { enabled = true },
    debug       = { enabled = false },
    dim         = { enabled = false },
    explorer    = { enabled = false },
    gh          = { enabled = true },
    git         = { enabled = true },
    gitbrowse   = { enabled = false },
    image       = { enabled = true },
    indent      = { enabled = false },
    input       = { enabled = false },
    keymap      = { enabled = false },
    layout      = { enabled = false },
    lazygit     = { enabled = true },
    notifier    = { enabled = false },
    picker      = { enabled = true },
    profiler    = { enabled = false },
    quickfile   = { enabled = true },
    rename      = { enabled = true },
    scope       = { enabled = false },
    scratch     = { enabled = false },
    scroll      = { enabled = true },
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
    terminal    = { enabled = false },
    toggle      = { enabled = false },
    win         = { enabled = false },
    words       = { enabled = false },
    zen         = { enabled = false },
})

-- =====================
-- Keymaps
-- =====================

vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end,          { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'LazyGit Current File' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end,      { desc = 'LazyGit Log' })

vim.keymap.set('n', '<leader>gi', function() Snacks.gh.issue() end, { desc = 'GitHub Issues' })
vim.keymap.set('n', '<leader>gp', function() Snacks.gh.pr() end,    { desc = 'GitHub PRs' })
