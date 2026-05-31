-- ====================================
-- nvim-highlight-colors Plugin Setup
-- Author: Martin Bullman
-- ====================================
--
-- Live preview of color values (#hex, rgb(), hsl(), tailwind classes)
-- shown as a small color swatch alongside the value.

return {
    'brenoprata10/nvim-highlight-colors',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        render = 'virtual',  -- 'background' | 'foreground' | 'virtual'
        virtual_symbol = '●',
        enable_named_colors = true,
        enable_tailwind = false,
    },
}
