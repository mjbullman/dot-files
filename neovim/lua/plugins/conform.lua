-- =======================
-- Conform.nvim Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
        require('config.conform')
    end,
}
