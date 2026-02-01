-- ==============================
-- Python LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = { 
        vim.fn.stdpath('data') .. '/mason/bin/basedpyright-langserver', '--stdio' 
    },
    filetypes = { 'python' },
    root_markers = {
        '.git',
        'setup.py',
        'setup.cfg',
        'pyproject.toml',
        'requirements.txt',
    },
    settings = {
        basedpyright = {
            analysis = {
                diagnosticMode = 'workspace',
                autoSearchPaths = true,
                typeCheckingMode = 'basic', -- 'off', 'basic', or 'strict'
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
            },
            disableOrganizeImports = false,
            disableLanguageServices = false,
        },
    },
    on_attach = function(client, bufnr)
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end,
}
