-- =======================
-- Supermaven Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'supermaven-inc/supermaven-nvim',
    event = 'VeryLazy',
    config = function()
        require('config.supermaven')
    end,
}
