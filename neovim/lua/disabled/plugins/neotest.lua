-- =======================
-- Neotest Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'rcasia/neotest-java',
    },
    ft = { 'java' },
    config = function()
        require('config.neotest')
    end,
}
