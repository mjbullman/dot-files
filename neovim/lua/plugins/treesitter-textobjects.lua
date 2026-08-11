-- ===================================
--  Treesitter Textobjects Plugin Setup
--  Author: Martin Bullman
-- ===================================

return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- must track `main` to match the treesitter branch used in plugins/treesitter.lua;
    -- the `master` branch uses the old declarative API and will not load against it.
    branch = 'main',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('config.treesitter-textobjects')
    end,
}
