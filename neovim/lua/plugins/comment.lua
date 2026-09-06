-- =======================
--  Comment Plugin Setup
--  Author: Martin Bullman
-- =======================

return {
    'numToStr/Comment.nvim',
    dependencies = {
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            init = function()
                -- driven through Comment.nvim's pre_hook below, not the
                -- legacy nvim-treesitter module hook
                vim.g.skip_ts_context_commentstring_module = true
            end,
        },
    },
    keys = {
        { 'gc', mode = { 'n', 'x' } },
        { 'gb', mode = { 'n', 'x' } },
        'gcc',
        'gbc',
        'gcO',
        'gco',
        'gcA',
    },
    config = function()
        require('config.comment')
    end,
}
