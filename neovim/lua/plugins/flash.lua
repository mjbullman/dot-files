-- =======================
--  Flash Plugin Setup
--  Author: Martin Bullman
-- =======================

return {
    'folke/flash.nvim',
    event = 'VeryLazy',
    config = function()
        require('config.flash')
    end,
}
