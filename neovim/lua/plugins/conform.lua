-- =======================
-- Conform.nvim Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>lf',
            function()
                require('conform').format({
                    lsp_format = 'fallback',
                    async = false,
                    timeout_ms = 500,
                })
            end,
            mode = { 'n', 'v' },
            desc = 'Format buffer or range',
        },
    },
    config = function()
        require('config.conform')
    end,
}
