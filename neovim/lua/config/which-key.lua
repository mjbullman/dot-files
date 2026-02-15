-- ===============================
-- Which-Key Configuration
-- Author: Martin Bullman
-- ===============================

require('which-key').setup({
    delay = 1000, -- delay in ms before showing popup
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = true,
            suggestions = 20,
        },
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
        },
    },
    icons = {
        breadcrumb = '»',
        separator = '➜',
        group = '+',
    },
    win = {
        border = 'rounded',
        padding = { 1, 2 },
    },
    layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = 'left',
    },
})

-- =============================
-- Which-Key Group Labels
-- =============================
local wk = require('which-key')

wk.add({
    -- Top-level groups
    { '<leader>a', group = 'AI Tools' },
    { '<leader>b', group = 'Buffers' },
    { '<leader>c', group = 'Code Actions' },
    { '<leader>d', group = 'Debug/Diagnostics' },
    { '<leader>e', group = 'Explorer' },
    { '<leader>f', group = 'Find (Telescope)' },
    { '<leader>g', group = 'Git' },
    { '<leader>j', group = 'Java' },
    { '<leader>l', group = 'LSP' },
    { '<leader>t', group = 'Toggle' },
    { '<leader>w', group = 'Workspace' },

    -- AI Tools (ChatGPT + Copilot + Supermaven)
    { '<leader>ai', desc = 'ChatGPT interactive' },
    { '<leader>ae', desc = 'Edit with AI' },
    { '<leader>ax', desc = 'Explain code' },
    { '<leader>af', desc = 'Fix bugs' },
    { '<leader>ao', desc = 'Optimize code' },
    { '<leader>ad', desc = 'Add docstring' },
    { '<leader>at', desc = 'Add tests' },
    { '<leader>ag', desc = 'Grammar correction' },
    { '<leader>as', desc = 'Act as (prompts)' },
    { '<leader>ac', desc = 'Toggle Copilot' },
    { '<leader>am', desc = 'Toggle Supermaven' },

    -- Buffers
    { '<leader>bd', desc = 'Delete buffer' },
    { '<leader>bo', desc = 'Close other buffers' },
    { '<leader>bu', desc = 'Reopen last buffer' },
    { '<leader>bl', desc = 'List all buffers' },

    -- Code Actions (LSP buffer-local)
    { '<leader>ca', desc = 'Code action' },
    { '<leader>cf', desc = 'Quick fix (first action)' },
    { '<leader>cl', desc = 'Run CodeLens' },

    -- Debug/Diagnostics
    { '<leader>d', desc = 'Show diagnostic float' },
    { '<leader>dd', desc = 'Diagnostic location list' },
    { '<leader>dt', desc = 'Toggle breakpoint' },
    { '<leader>dc', desc = 'Continue debugging' },
    { '<leader>ds', desc = 'Step over' },
    { '<leader>di', desc = 'Step into' },
    { '<leader>do', desc = 'Step out' },
    { '<leader>dr', desc = 'Open REPL' },
    { '<leader>du', desc = 'Toggle debug UI' },

    -- Explorer
    { '<leader>e', desc = 'Toggle Neo-tree (cwd)' },
    { '<leader>E', desc = 'Toggle Neo-tree (reveal)' },

    -- Find (Telescope)
    { '<leader>ff', desc = 'Find files' },
    { '<leader>fg', desc = 'Live grep (search text)' },
    { '<leader>fh', desc = 'Help tags' },
    { '<leader>f.', desc = 'Recent files' },
    { '<leader>fd', desc = 'Diagnostics' },
    { '<leader>fk', desc = 'Keymaps' },
    { '<leader><leader>', desc = 'Switch buffers' },

    -- Git
    { '<leader>gg', desc = 'LazyGit' },
    { '<leader>gf', desc = 'LazyGit current file' },
    { '<leader>gl', desc = 'LazyGit log' },
    { '<leader>gs', desc = 'Stage hunk' },
    { '<leader>gr', desc = 'Reset hunk' },
    { '<leader>gp', desc = 'Preview hunk' },
    { '<leader>gb', desc = 'Blame line' },

    -- Java (buffer-local, set by nvim-jdtls)
    { '<leader>jo', desc = 'Organize imports' },
    { '<leader>jv', desc = 'Extract variable' },
    { '<leader>jc', desc = 'Extract constant' },
    { '<leader>jm', desc = 'Extract method' },
    { '<leader>jt', desc = 'Test nearest method' },
    { '<leader>jT', desc = 'Test class' },
    { '<leader>jp', desc = 'Pick test' },
    { '<leader>ju', desc = 'Update project config' },
    { '<leader>jr', desc = 'Run main class' },
    { '<leader>jd', desc = 'Debug main class' },

    -- LSP (buffer-local)
    { '<leader>li', desc = 'LSP info' },
    { '<leader>ll', desc = 'LSP log' },
    { '<leader>lr', desc = 'LSP restart' },
    { '<leader>ls', desc = 'Document symbols' },
    { '<leader>lS', desc = 'Workspace symbols' },
    { '<leader>lf', desc = 'Format buffer/range' },

    -- Toggle
    { '<leader>th', desc = 'Toggle inlay hints' },
    { '<leader>tb', desc = 'Toggle git blame' },
    { '<leader>td', desc = 'Toggle deleted (git)' },

    -- Workspace (LSP buffer-local)
    { '<leader>wa', desc = 'Add workspace folder' },
    { '<leader>wr', desc = 'Remove workspace folder' },
    { '<leader>wl', desc = 'List workspace folders' },

    -- File operations
    { '<leader>s', desc = 'Save file' },
    { '<leader>q', desc = 'Quit window' },
    { '<leader>Q', desc = 'Quit all (no save)' },
    { '<leader>x', desc = 'Save and quit' },

    -- LSP navigation (buffer-local)
    { 'gd', desc = 'Go to definition' },
    { 'gD', desc = 'Go to declaration' },
    { 'gi', desc = 'Go to implementation' },
    { 'gr', desc = 'Show references' },
    { 'gt', desc = 'Go to type definition' },
    { 'K', desc = 'Hover documentation' },
    { '<leader>rn', desc = 'Rename symbol' },

    -- Diagnostic navigation
    { '[d', desc = 'Previous diagnostic' },
    { ']d', desc = 'Next diagnostic' },

    -- Git hunk navigation (buffer-local)
    { '[c', desc = 'Previous git hunk' },
    { ']c', desc = 'Next git hunk' },

    -- Buffer navigation
    { '<S-l>', desc = 'Next buffer' },
    { '<S-h>', desc = 'Previous buffer' },
})
