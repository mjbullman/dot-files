-- ==============================
-- Markdown Oxide LSP Config
-- Author: Martin Bullman
-- ==============================

-- Obsidian-aware markdown LSP: [[wikilink]] completion, backlinks, daily
-- notes. Vaults only -- plain markdown in code repos stays with marksman
-- (lsp/marksman.lua), which splits the filetype on the same vault test.

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/markdown-oxide',
    },
    filetypes = { 'markdown' },
    -- root_markers alone would not do: a server with no marker match still
    -- starts in single-file mode. Declining to call on_dir is how it opts out.
    root_dir = function(bufnr, on_dir)
        local vault = vim.fs.root(bufnr, { '.obsidian', '.moxide.toml' })

        if vault then
            on_dir(vault)
        end
    end,
    -- daily-note and unresolved-link completions arrive as workspace file
    -- watches; without dynamic registration the server never sends them
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}
