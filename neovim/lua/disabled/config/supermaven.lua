-- ===============================
-- Supermaven Configuration
-- Author: Martin Bullman
-- ===============================

require('supermaven-nvim').setup({
    keymaps = {
        accept_suggestion = '<C-l>',  -- Ctrl+l to accept (avoids Tab conflict with Blink)
        clear_suggestion = '<C-]>',
        accept_word = '<C-Right>',
    },
    ignore_filetypes = {
        'chatgpt-input',
        'chatgpt',
        'TelescopePrompt',
    },
    color = {
        suggestion_color = '#6c7086', -- catppuccin mocha gray
        cterm = 244,
    },
    log_level = 'info',
    disable_inline_completion = false,
    disable_keymaps = false,
})

-- =============================
-- Supermaven Keymaps
-- =============================
local api = require('supermaven-nvim.api')

vim.keymap.set('n', '<leader>am', function()
    if api.is_running() then
        api.stop()
        vim.notify('Supermaven stopped', vim.log.levels.INFO)
    else
        api.start()
        vim.notify('Supermaven started', vim.log.levels.INFO)
    end
end, { desc = 'Toggle Supermaven' })
