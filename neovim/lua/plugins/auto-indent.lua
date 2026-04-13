-- ==============================
-- Auto Indent Plugin Setup
-- Author: Martin Bullman
-- ==============================

return {
    'nmac427/guess-indent.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {}
}
