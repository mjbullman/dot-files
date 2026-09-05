-- ===============================
-- Mason Configuration
-- Author: Martin Bullman
-- ===============================

require('mason').setup({
    ui = {
        border = 'rounded',
        icons = {
            -- same family and concept-mapping as neotest's status icons in
            -- config/neotest.lua: installed~passed, pending~running, uninstalled~failed
            package_installed = '󰗠',
            package_pending = '󰦖',
            package_uninstalled = '󱎘',
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
        'docker-language-server',
        'lua-language-server',
        'vue-language-server',
        'bash-language-server',
        -- required by nvim-treesitter (main) to compile parsers
        'tree-sitter-cli',
        -- formatters / linters
        'ruff',
        'stylua',
        'prettier',
        -- debug adapters
        'java-test',
        'java-debug-adapter',
        'js-debug-adapter',
        'debugpy',

    },
    auto_update = false,
    run_on_start = true,
})
