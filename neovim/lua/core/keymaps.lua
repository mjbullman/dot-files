-- ==============================
-- Neovim Keymaps Configuration
-- Author: Martin Bullman
-- ===============================

-- -----------------------------
-- Leader keys
-- -----------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- -----------------------------
-- Diagnostics config
-- -----------------------------
vim.diagnostic.config({
  update_in_insert = false,
  float = { border = "rounded" }
})
-- Note: virtual_text handled by tiny-inline-diagnostic plugin


local map = vim.keymap.set 
local opts = { noremap = true, silent = true }


-- ----------------------------- 
-- Basic operations 
-- -----------------------------
map({"n", "v"}, "<Space>", "<Nop>", {
    silent = true,
    desc = "Disable space key default behavior"
})
map("n", "<leader>w", "<cmd>w<CR>", {
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

-- -----------------------------
-- Indentation
-- -----------------------------
map("v", "<", "<gv", opts, {
  desc = "Indent left and reselect"
})
map("v", ">", ">gv", opts, {
  desc = "Indent right and reselect"
})

-- -----------------------------
-- Diagnostics 
-- -----------------------------
map("n", "<leader>d", vim.diagnostic.open_float, opts, {
  desc = "Open diagnostic float"
})
map("n", "<leader>dd", vim.diagnostic.setloclist, opts, {
  desc = "Set location list with diagnostics"
})
map("n", "[d", vim.diagnostic.goto_prev, opts, {
  desc = "Go to previous diagnostic"
})
map("n", "]d", vim.diagnostic.goto_next, opts, {
  desc = "Go to next diagnostic"
})

