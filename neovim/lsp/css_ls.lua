-- ==============================
-- CSS LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/vscode-css-language-server',
        '--stdio',
    },
    root_markers = {
        '.git',
        'package.json',
    },
    filetypes = {
        'css',
        'scss',
        'less',
    },
}
