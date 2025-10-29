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
require("core/options")
require("core/keymaps")
require("lazy").setup("plugins")
