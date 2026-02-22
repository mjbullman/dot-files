-- ===============================
-- Notify Configuration
-- Author: Martin Bullman
-- ===============================

---@diagnostic disable-next-line: missing-fields
require('notify').setup({
    background_colour = '#1e1e2e',  -- Catppuccin Mocha background
    fps = 60,
    icons = {
        DEBUG = '󰃤',
        ERROR = '✘',
        INFO  = 'ℹ',
        TRACE = '✎',
        WARN  = '⚠',
    },
    level = 2,
    max_width = 80,
    minimum_width = 50,
    render = 'compact',
    stages = 'fade_in_slide_out',
    timeout = 3000,
    top_down = true,
})

-- Set as default notify handler
vim.notify = require('notify')
