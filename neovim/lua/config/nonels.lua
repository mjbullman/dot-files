-- ===============================
-- None-LS Configuration
-- Author: Martin Bullman
-- ===============================

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.completion.spell,
    },
})

-- =============================
-- None-LS Keymaps
-- =============================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>lf", vim.lsp.buf.format, vim.tbl_extend("force", opts, {
    desc = "Format buffer"
}))
