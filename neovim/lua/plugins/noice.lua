-- =======================
-- Noice Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
    },
    config = function()
        require('config.noice')
    end,
}
