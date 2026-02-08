-- ==============================
-- Markdown LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/marksman',
        'server',
    },
    filetypes = { 'markdown', 'markdown.mdx' },
    root_markers = { '.git' },
}
