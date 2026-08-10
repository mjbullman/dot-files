-- ==============================
-- Lua LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = {
        vim.fn.expand('~/.local/share/nvim/mason/bin/lua-language-server')
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
            diagnostics = { globals = { 'vim' } },
            -- library is supplied on demand by lazydev.nvim
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}
