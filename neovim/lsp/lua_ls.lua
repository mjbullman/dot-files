-- ==============================
-- Lua LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/lua-language-server'
    },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.stylua.toml',
        'stylua.toml',
        'lazy-lock.json',
        '.git'
    },
    filetypes = {
        'lua'
    },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            codeLens = { enable = true },
            -- 'missing-fields' fires on every partial plugin setup{} table
            -- (neotest, etc.) even though those merge with defaults
            diagnostics = {
                globals = { 'vim' },
                disable = { 'missing-fields' },
            },
            -- library is supplied on demand by lazydev.nvim
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}
