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
vim.lsp.enable({ "clangd", "lua_ls", "vtsls", "vue_ls", "basedpyright", "html_ls", "css_ls", "eslint_ls", "jdtls" })

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
