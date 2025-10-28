-- =============================
-- Core Neovim Setup Options
-- Author: Martin Bullman
-- =============================


-- -----------------------------
-- Basic Command Settings
-- -----------------------------
vim.cmd("set number")                 -- show line numbers
vim.cmd("set expandtab")              -- use spaces instead of tabs
vim.cmd("set tabstop=4")              -- number of spaces a <Tab> in the file counts for
vim.cmd("set shiftwidth=4")           -- number of spaces used for autoindent
vim.cmd("set clipboard+=unnamedplus") -- use system clipboard


-- -----------------------------
-- Basic Options Settings
-- -----------------------------
vim.opt.splitright = true

-- -----------------------------
-- Leader keys
-- -----------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- -----------------------------
-- Diagnostics config
-- -----------------------------
vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  float = { border = "rounded" }
})


local map = vim.keymap.set 
local opts = { noremap = true, silent = true }


-- ----------------------------- 
-- Basic operations 
-- -----------------------------
map("n", "<leader>w", "<cmd>w<CR>", opts, {
    desc = "Save file"
})
map("n", "<leader>q", "<cmd>q<CR>", opts, {
    desc = "Quit window"
}) 
map("n", "<leader>Q", "<cmd>qa!<CR>", opts, {
    desc = "Quit all without saving"
})
map("n", "<leader>x", "<cmd>x<CR>", opts, {
    desc = "Save and quit"
})

-- -----------------------------
-- Buffers
-- -----------------------------
map("n", "<S-l>", "<cmd>bnext<CR>", opts, {
  desc = "Go to next buffer"
})
map("n", "<S-h>", "<cmd>bprevious<CR>", opts, {
  desc = "Go to previous buffer"
})
map("n", "<leader>bd", "<cmd>bdelete<CR>", vim.tbl_extend("force", opts, {
  desc = "Close current buffer"
}))
map("n", "<leader>bo", "<cmd>%bdelete|edit#|bdelete#<CR>", vim.tbl_extend("force", opts, {
  desc = "Close all other buffers"
}))
map("n", "<leader>bu", "<cmd>e#<CR>", vim.tbl_extend("force", opts, {
  desc = "Reopen last closed buffer"
}))
map("n", "<leader>bl", "<cmd>ls<CR>", vim.tbl_extend("force", opts, {
  desc = "List all buffers"
}))
