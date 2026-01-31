-- ==============================
-- CSS LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.expand('~/.local/share/nvim/mason/bin/vscode-css-language-server'),
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
