-- ==============================
-- Rust LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.expand('~/.local/share/nvim/mason/bin/rust-analyzer'),
    },
    root_markers = {
        'Cargo.toml',
    },
    filetypes = {
        'rust',
    },
}
