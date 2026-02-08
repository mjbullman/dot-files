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
}
