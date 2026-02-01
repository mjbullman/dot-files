-- ==============================
-- HTML LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.expand('~/.local/share/nvim/mason/bin/vscode-html-language-server'),
        '--stdio'
    },
    root_markers = {
        '.git',
        'index.html'
    },
    filetypes = {
        'html'
    },
}
