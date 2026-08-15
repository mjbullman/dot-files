-- ===============================
-- Kulala Configuration
-- Author: Martin Bullman
-- ===============================

-- kulala downloads its own kulala-core backend and tree-sitter parser on first
-- setup, using curl, git and the tree-sitter CLI (installed via Mason). First
-- load therefore needs network access; later loads are offline.

require('kulala').setup({
    -- Use kulala's own keymap set rather than hand-rolling one: it already binds
    -- <CR> to send the request under the cursor in .http buffers (one keystroke,
    -- no leader), and scopes the rest sensibly by filetype. plugins/kulala.lua
    -- only declares enough to trigger lazy-loading.
    global_keymaps = true,
    global_keymaps_prefix = '<leader>R',

    -- environments come from http-client.env.json next to the .http file
    default_env = 'dev',

    ui = {
        -- split keeps the request visible beside the response
        display_mode = 'split',
        split_direction = 'vertical',
        default_view = 'body',
    },

    -- kulala ships an LSP for .http files: completion for methods, headers and
    -- variables. Separate from the servers enabled in config/lsp.lua.
    lsp = {
        enable = true,
    },
})
