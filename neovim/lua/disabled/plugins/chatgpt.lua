-- =======================
-- ChatGPT Plugin Setup
-- Author: Martin Bullman
-- =======================

return {
    'jackMort/ChatGPT.nvim',
    enabled = false,  -- Disabled due to conflicts with Avante
    event = 'VeryLazy',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
        'folke/trouble.nvim',
        'nvim-telescope/telescope.nvim'
    },
    config = function()
        require('config.chatgpt')
    end,
}
