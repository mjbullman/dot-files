-- =======================
-- Mason Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    config = function()
        require('config.mason')
    end,
}
