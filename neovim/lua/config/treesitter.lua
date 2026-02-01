-- ===============================
-- Treesitter Plugin Configuration
-- Author: Martin Bullman
-- ===============================

local config = require('nvim-treesitter.configs')

config.setup {
    ensure_installed = {
        'lua',
        'css',
        'vue',
        'php',
        'html',
        'scss',
        'json',
        'bash',
        'rust',
        'regex',
        'javascript',
        'typescript'
    },
    ignore_install = { 'javascript' },
    sync_install = false,
    modules = {},
    auto_install = true,
    highlight = {
        enable = true
    },
    indent = {
        enable = false,
        disable = { 'vue' }
    },
}
