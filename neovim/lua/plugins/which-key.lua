-- =======================
-- Which-Key Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        require('config.which-key')
    end,
}
