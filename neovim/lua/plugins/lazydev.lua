-- =======================
-- LazyDev Plugin Setup
-- Better Lua completions for Neovim config
-- Author: Martin Bullman
-- =======================

return {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
        library = {
            -- load luvit types when opening files in the runtime path
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            -- load LazyVim library for LazyVim users
            { path = 'lazy.nvim', words = { 'lazy' } },
        },
        -- enable completions
        enabled = true,
    },
    dependencies = {
        { 'Bilal2453/luvit-meta', lazy = true },
    },
}
