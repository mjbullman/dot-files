-- =======================
-- Notify Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
        require('config.notify')
    end,
}
