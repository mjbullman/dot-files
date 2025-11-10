-- =================================
--  Neovim Configuration Entry Point
--  Author: Martin Bullman
-- =================================

-- install lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)

-- setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        enabled = false,
    },
})

-- Configure LSP with Blink.cmp capabilities (after lazy loads plugins)
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    root_markers = { '.git' },
})

-- Configure lua_ls for Neovim development
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- Enable all LSP servers
vim.lsp.enable({ "clangd", "lua_ls", "vtsls", "vue_ls", "basedpyright", "html_ls", "css_ls", "eslint_ls", "jdtls" })
