-- ==============================
-- LSP Plugin Setup
-- Author: Martin Bullman
-- ==============================

return {
    'nvim-lsp-config',
    dir = vim.fn.stdpath('config'),
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('config.lsp')
    end,
}
