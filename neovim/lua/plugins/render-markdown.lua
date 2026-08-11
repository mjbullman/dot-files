-- =============================
--  Render Markdown Plugin Setup
--  In-buffer markdown rendering
--  Author: Martin Bullman
-- =============================

return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('config.render-markdown')
    end,
}
