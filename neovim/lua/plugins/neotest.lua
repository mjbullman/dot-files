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
        'nvim-neotest/neotest-python',
        'marilari88/neotest-vitest',
    },
    ft = {
        'java',
        'python',
        'javascript',
        'typescript',
        'vue',
    },
    config = function()
        require('config.neotest')
    end,
}
