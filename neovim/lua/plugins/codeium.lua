-- =======================
-- Codeium Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'Exafunction/codeium.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    event = 'VeryLazy',
    config = function()
        require('config.codeium')
    end,
}
