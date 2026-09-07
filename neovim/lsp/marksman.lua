-- ==============================
-- Markdown LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/marksman',
        'server',
    },
    filetypes = { 'markdown' },
    -- stand down inside an Obsidian vault so markdown-oxide owns it alone;
    -- elsewhere keep the old behaviour, git root or the file's own directory
    root_dir = function(bufnr, on_dir)
        if vim.fs.root(bufnr, { '.obsidian', '.moxide.toml' }) then
            return
        end

        on_dir(vim.fs.root(bufnr, { '.git' }) or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':h'))
    end,
}
