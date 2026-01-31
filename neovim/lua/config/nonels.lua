-- ===============================
-- None-LS Configuration
-- Author: Martin Bullman
-- ===============================

local null_ls = require('null-ls')

-- Shortcuts for built-ins
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
    debug = false,
    sources = {
        -- ===============================
        -- FORMATTING
        -- ===============================
        formatting.stylua,       -- Lua
        formatting.prettier,     -- JS/TS/Vue/CSS/HTML/JSON/Markdown
        formatting.black,        -- Python
        formatting.isort,        -- Python imports
        formatting.clang_format, -- C/C++/Java

        -- ===============================
        -- DIAGNOSTICS
        -- ===============================
        diagnostics.pylint,       -- Python linting
        diagnostics.mypy,         -- Python type checking
        diagnostics.markdownlint, -- Markdown

        -- ===============================
        -- CODE ACTIONS
        -- ===============================
        code_actions.gitsigns, -- Git actions (stage hunks, etc)
    },
})

-- =============================
-- None-LS Keymaps
-- =============================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- manual format keymap (defined in lsp.lua but good to have backup)
map('n', '<leader>lf', vim.lsp.buf.format, vim.tbl_extend('force', opts, {
    desc = 'Format buffer',
}))
