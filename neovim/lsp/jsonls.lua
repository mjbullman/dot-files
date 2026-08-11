-- ==============================
-- JSON LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/vscode-json-language-server',
        '--stdio',
    },
    filetypes = { 'json', 'jsonc' },
    root_markers = { '.git' },

    -- schemas come from SchemaStore rather than being hand-maintained; the
    -- require() here is what pulls in the lazy-loaded plugin (plugins/schemastore.lua).
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        },
    },
}
