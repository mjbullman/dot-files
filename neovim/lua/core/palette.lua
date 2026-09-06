-- =========================================================
--  Shared accent palette
--  Author: Martin Bullman
-- =========================================================
--
-- Single source of truth for the git and diagnostic accent hues used across
-- the UI: the gitsigns gutter, the neo-tree tree, the bufferline tabs, the
-- lualine statusline and the diagnostic signs.
--
-- Catppuccin's Latte (light) accents are deeper, more saturated versions of
-- the same hues and read more clearly on the Mocha background than the Mocha
-- pastels do. Everything that needs these colours requires this module so the
-- table is defined once and cannot drift.

local latte = require('catppuccin.palettes').get_palette('latte')

local M = {}

M.git = {
    add     = latte.green,  -- #40a02b
    change  = latte.peach,  -- #fe640b  also the buffer-unsaved dot
    delete  = latte.red,    -- #d20f39
    rename  = latte.blue,   -- #1e66f5
    special = latte.maroon, -- #e64553  untracked / changedelete
}

M.diag = {
    error = latte.red,   -- #d20f39  (= git conflict/delete)
    warn  = latte.peach, -- #fe640b  (= git modified)
    info  = latte.blue,  -- #1e66f5  (= git renamed)
    hint  = latte.teal,  -- #179299  diagnostic-only hue
}

return M
