-- =======================
-- DAP Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'leoluz/nvim-dap-go',
        'nvim-neotest/nvim-nio',
        'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
        require('config.debugging')
    end,
}
