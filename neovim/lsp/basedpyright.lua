-- ==============================
-- Python LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },

    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "basic", -- "off", "basic", or "strict"
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
            disableLanguageServices = false,
            disableOrganizeImports = false,
        },
    },

    on_attach = function(client, bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
}
