-- =============================
-- Core Neovim Setup Options
-- Author: Martin Bullman
-- =============================

vim.wo.number = true             -- show line numbers
vim.o.expandtab = true           -- use spaces instead of tabs
vim.o.tabstop = 4                -- number of spaces a <Tab> counts for
vim.o.shiftwidth = 4             -- number of spaces used for autoindent
vim.o.smartindent = true         -- autoindent new lines
vim.o.ignorecase = true          -- ignore case in search patterns
vim.o.smartcase = true           -- override 'ignorecase' if search contains uppercase
vim.o.clipboard = "unnamedplus"  -- use system clipboard
vim.o.mouse = "a"                -- enable mouse support
vim.opt.splitright = true        -- new vertical splits to the right
vim.opt.splitbelow = true        -- new horizontal splits to the bottom
vim.o.termguicolors = true       -- enable 24-bit RGB colors
vim.o.scrolloff = 4              -- minimum number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 8          -- minimum number of screen columns to

