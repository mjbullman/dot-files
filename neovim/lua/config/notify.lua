-- ===============================
-- Notify Configuration
-- Author: Martin Bullman
-- ===============================

require('notify').setup({
    background_colour = '#1e1e2e',  -- Catppuccin Mocha background
    fps = 60,
    icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
    },
    level = 2,
    minimum_width = 50,
    render = 'compact',
    stages = 'fade_in_slide_out',
    timeout = 3000,
    top_down = true,
})

-- Set as default notify handler
vim.notify = require('notify')
