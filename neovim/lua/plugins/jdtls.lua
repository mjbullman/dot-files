-- =======================
-- nvim-jdtls Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = {
        'mfussenegger/nvim-dap',
    },
    config = function()
        require('config.jdtls')
    end,
}
