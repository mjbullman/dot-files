-- =======================
-- Codeium Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'Exafunction/codeium.nvim',
    event = 'VeryLazy',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'saghen/blink.cmp',
    },
    config = function()
        require('config.codeium')
    end,
}
