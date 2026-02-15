-- ===============================
-- Mason Configuration
-- Author: Martin Bullman
-- ===============================

require('mason').setup({
    ui = {
        border = 'rounded',
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },
})

require('mason-tool-installer').setup({
    ensure_installed = {
        -- lsp servers
        'jdtls',
        'vtsls',
        'clangd',
        'css-lsp',
        'html-lsp',
        'marksman',
        'json-lsp',
        'eslint-lsp',
        'basedpyright',
        'rust-analyzer',
        'lua-language-server',
        'vue-language-server',
        'bash-language-server',
        -- formatters / linters
        'ruff',
        'black',
        'stylua',
        'prettier',
        -- java debug / test
        'java-test',
        'java-debug-adapter',

    },
    auto_update = false,
    run_on_start = true,
})
