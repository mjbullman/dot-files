-- ========================
-- Snacks Plugin Setup
-- Author: Martin Bullman
-- ========================

return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    config = function()
        require('config.snacks')
    end,
}
