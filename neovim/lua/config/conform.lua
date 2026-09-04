-- ===============================
-- Conform.nvim Configuration
-- Author: Martin Bullman
-- ===============================

require('conform').setup({
    formatters_by_ft = {
        -- python: organise imports first, then format — the formatter gets the
        -- last word on the import block ruff_organize_imports rewrites
        python = {
            'ruff_organize_imports',
            'ruff_format',
        },

        -- lua: use stylua
        lua = { 'stylua' },

        -- javascript/typescript/vue: use prettier
        vue = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        yaml = { 'prettier' },
        json = { 'prettier' },
        markdown = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
    },

    -- customize formatters
    formatters = {
        ruff_organize_imports = {
            command = 'ruff',
            args = { 'check', '--select', 'I', '--fix', '--stdin-filename', '$FILENAME' },
            stdin = true,
        },
        ruff_format = {
            command = 'ruff',
            args = { 'format', '--stdin-filename', '$FILENAME' },
            stdin = true,
        },
    },
})

-- keymap (<leader>lf) lives in plugins/conform.lua so it is available before
-- the plugin loads — see the `keys` spec there.
