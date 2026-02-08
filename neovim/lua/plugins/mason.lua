-- =======================
-- Mason Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        build = ':MasonUpdate',
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('config.mason')
        end,
    },
}
