-- ==============================
-- Auto Pairs Plugin Setup
-- Author: Martin Bullman
-- ==============================

return {
    'nvim-mini/mini.nvim',
    event = 'VeryLazy',
    version = false,
    config = function()
        require('mini.pairs').setup()
    end
}
