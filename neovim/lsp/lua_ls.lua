-- ==============================
-- Lua LSP Config
-- Author: Martin Bullman
-- ==============================

return {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/lua-language-server") },
    root_markers = { ".luarc.json" },
    filetypes = { "lua" },
}
