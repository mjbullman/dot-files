-- ===============================
-- Conform.nvim Configuration
-- Author: Martin Bullman
-- ===============================

require('conform').setup({
    formatters_by_ft = {
        -- python: use ruff for import sorting and formatting
        python = {
            'ruff_format',
            'ruff_organize_imports',
        },

        -- lua: use stylua
        lua = { 'stylua' },

        -- javaScript/typeccript/vue: use prettier
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

-- =============================
-- Conform Keymaps
-- =============================

vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
    require('conform').format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    })
end, { desc = 'Format buffer or range' })
