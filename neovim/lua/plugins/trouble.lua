-- =======================
-- Trouble Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'folke/trouble.nvim',
    dependencies = { 
        'nvim-tree/nvim-web-devicons',
        'artemave/workspace-diagnostics.nvim'
    },
    config = function()
        require('config.trouble')
    end,
}
