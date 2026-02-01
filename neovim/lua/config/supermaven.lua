-- ===============================
-- Supermaven Configuration
-- Author: Martin Bullman
-- ===============================

require('supermaven-nvim').setup({
    keymaps = {
        accept_suggestion = '<C-l>',  -- Ctrl+l to accept (avoids Tab conflict with Blink)
        clear_suggestion = '<C-]>',
        accept_word = '<C-Right>',    -- Accept one word at a time
    },
    ignore_filetypes = {
        'chatgpt-input',
        'chatgpt',
        'TelescopePrompt',
    },
    color = {
        suggestion_color = '#6c7086',  -- Catppuccin Mocha gray
        cterm = 244,
    },
    log_level = 'info',
    disable_inline_completion = false,
    disable_keymaps = false,
})
