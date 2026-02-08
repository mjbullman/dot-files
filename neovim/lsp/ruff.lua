-- ==============================
-- Ruff LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/ruff', 'server', '--preview' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'ruff.toml',
        '.ruff.toml',
        '.git',
    },
    settings = {
        -- Ruff language server settings
        organizeImports = true,
        fixAll = true,
    },
    on_attach = function(client, bufnr)
        -- Disable hover in favor of basedpyright
        client.server_capabilities.hoverProvider = false

        -- Enable formatting via ruff LSP (optional, conform.nvim also handles this)
        vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end,
}
