-- =========================================================
-- Lualine Statusline Configuration
-- Author: Martin Bullman
-- Description: Configures Lualine with a Dracula theme for a
--              stylish and informative statusline in Neovim.
-- =========================================================

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
