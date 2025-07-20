-- ================================
-- Lualine Statusline Configuration
-- Author: Martin Bullman
-- ================================

return {
    'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup({
            options = {
                theme = 'dracula'
            }
        })
    end
}
