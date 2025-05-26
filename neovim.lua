vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")
vim.g.mapleader = " "

-- install lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)

-- plugins
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "nvim-telescope/telescope.nvim", tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
    { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
    { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        opts = {},
    }
}

-- options
local opts = {}


-- setup lazy.nvim
require("lazy").setup(plugins, opts)

-- set color scheme
require("catppuccin").setup(setup)
vim.cmd.colorscheme "catppuccin"

-- telescope config
local builtin = require("telescope/builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- treesitter config
local config = require("nvim-treesitter.configs")
config.setup({
    ensure_enstalled = {"lua", "javascript", "php", "java"},
    highlight = { enabled = true },
    indent = { enabled = true }
})

vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left")