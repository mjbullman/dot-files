-- =======================
-- Mason Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    {
        'mason-org/mason.nvim',
        cmd = 'Mason',
        build = ':MasonUpdate',
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        event = 'VeryLazy',
        dependencies = { 'mason-org/mason.nvim' },
        config = function()
            require('config.mason')
        end,
    },
}
