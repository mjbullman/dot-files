-- ===============================
-- Notify Configuration
-- Author: Martin Bullman
-- ===============================

require('notify').setup({
    background_colour = '#1e1e2e',  -- catppuccin mocha background
    fps = 60,
    -- ERROR/INFO/WARN match the gutter signs in config/lsp.lua
    icons = {
        DEBUG = '󰃤',
        ERROR = '󰅙',
        INFO  = '󰋼',
        TRACE = '󰛿',
        WARN  = '󰀦',
    },
    level = 2,
    max_width = 80,
    minimum_width = 50,
    render = 'compact',
    stages = 'fade_in_slide_out',
    timeout = 3000,
    top_down = true,
})

